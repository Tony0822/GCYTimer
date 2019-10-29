//
//  CYTimer.m
//  GCYTimer
//
//  Created by gao on 2019/10/30.
//  Copyright © 2019 Yang. All rights reserved.
//

#import "CYTimer.h"

@implementation CYTimer

static NSMutableDictionary *times_;
dispatch_semaphore_t semaphoer_;
+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        times_ = [NSMutableDictionary dictionary];
        semaphoer_ = dispatch_semaphore_create(1);
    });
   
}

+ (NSString *)execTask:(void (^)(void))task start:(NSTimeInterval)start interval:(NSTimeInterval)interval repeats:(BOOL)repeats async:(BOOL)async {
   
    if (!task || start < 0 || (interval <= 0 && repeats))  return nil;
    
    //    队列
    dispatch_queue_t queue = async ? dispatch_get_global_queue(0, 0) : dispatch_get_main_queue();
    
    //    创建定时器
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    //    设置时间
    dispatch_source_set_timer(timer,
                              dispatch_time(DISPATCH_TIME_NOW, start * NSEC_PER_SEC),
                              interval * NSEC_PER_SEC,
                              0);
    
    // 加锁
    dispatch_semaphore_wait(semaphoer_, DISPATCH_TIME_FOREVER);
    
    //   定时器的唯一标识
    NSString *name = [NSString stringWithFormat:@"%zd", times_.count];
    //    存放到字典中
    times_[name] = timer;
    
    // 解锁
    dispatch_semaphore_signal(semaphoer_);
    
    //    设置回调
    dispatch_source_set_event_handler(timer, ^{
        task();
        if (!repeats) {
            [self cancelTask:name];
        }
    });

    //    启动定时器
    dispatch_resume(timer);


    return name;
}

+ (NSString *)execTask:(id)target selector:(SEL)selector start:(NSTimeInterval)start interval:(NSTimeInterval)interval repeats:(BOOL)repeats async:(BOOL)async {
    
    if (!target || !selector) {
        return nil;
    }
    
    return [self execTask:^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [target performSelector:selector];
#pragma clang diagnostic pop
    } start:start interval:interval repeats:repeats async:async];
}

+ (void)cancelTask:(NSString *)name {
    if (name.length == 0) {
        return;
    }
    // 加锁
    dispatch_semaphore_wait(semaphoer_, DISPATCH_TIME_FOREVER);
    
    dispatch_source_t timer = times_[name];
    if (timer) {
        dispatch_source_cancel(timer);
        [times_ removeObjectForKey:name];
    }
    // 解锁
    dispatch_semaphore_signal(semaphoer_);
    
}

@end
