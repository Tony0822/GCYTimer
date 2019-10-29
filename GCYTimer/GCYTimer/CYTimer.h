//
//  CYTimer.h
//  GCYTimer
//
//  Created by gao on 2019/10/30.
//  Copyright © 2019 Yang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


/// 自定义定时器
@interface CYTimer : NSObject


/// Block方法执行定时器
/// @param task 任务
/// @param start 开始时间
/// @param interval 时间间隔
/// @param repeats 是否重复
/// @param async 是否异步
+ (NSString *)execTask:(void(^)(void))task
           start:(NSTimeInterval)start
        interval:(NSTimeInterval)interval
         repeats:(BOOL)repeats
           async:(BOOL)async;

/// SEL方法执行定时器
/// @param target 任务
/// @param selector 选择器
/// @param start 开始时间
/// @param interval 结束时间
/// @param repeats 是否重复
/// @param async 是否异步
+ (NSString *)execTask:(id)target
              selector:(SEL)selector
                 start:(NSTimeInterval)start
              interval:(NSTimeInterval)interval
               repeats:(BOOL)repeats
                 async:(BOOL)async;

/// 取消定时器
+ (void)cancelTask:(NSString *)name;


@end

NS_ASSUME_NONNULL_END
