//
//  ViewController.m
//  GCYTimer
//
//  Created by gao on 2019/10/29.
//  Copyright © 2019 Yang. All rights reserved.
//

#import "ViewController.h"
#import "CYTimer.h"

@interface ViewController ()
@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, strong) NSString *task;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.task = [CYTimer execTask:^{
//        NSLog(@"====%@====", [NSThread currentThread]);
//    } start:2 interval:1 repeats:YES async:NO];
self.task = [CYTimer execTask:self
                     selector:@selector(dosome) start:2 interval:1 repeats:YES async:YES];
}

- (void)dosome {
    NSLog(@"====%@====", [NSThread currentThread]);
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [CYTimer cancelTask:self.task];
}

- (void)test {
    
    //    队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    //    创建定时器
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    //    设置时间
    uint64_t start = 10.0;
    uint64_t interval = 1.0;
    dispatch_source_set_timer(timer,
                              dispatch_time(DISPATCH_TIME_NOW, start * NSEC_PER_SEC),
                              interval * NSEC_PER_SEC,
                              0);
    
    //    设置回调
    dispatch_source_set_event_handler(timer, ^{
        NSLog(@"123");
    });
    
    //    启动定时器
    dispatch_resume(timer);
    
    
    
    //    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 2.0 * NSEC_PER_SEC, 0);
    //    dispatch_source_set_event_handler(timer, ^{
    //        NSLog(@"00000");
    //    });
    //    dispatch_resume(timer);
    
    
    self.timer = timer;
    
}

@end
