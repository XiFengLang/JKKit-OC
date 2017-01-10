//
//  JKGCDTimerHolder.h
//  JKAutoReleaseObject
//
//  Created by 蒋鹏 on 17/1/10.
//  Copyright © 2017年 溪枫狼. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#pragma clang assume_nonnull begin
@interface JKGCDTimerHolder : NSObject



/**
 开始GCD定时器，定时事件在主线程回调。repeatCount = 0时不重复，JKGCDTimerTaskBlock(YES)，即可取消定时。

 @param seconds 周期
 @param repeatCount 重复次数，repeatCount = 总数 -1
 @param handler 回调响应者
 @param callBack 回调SEL
 */
- (void)startGCDTimerWithTimeInterval:(NSTimeInterval)seconds
                          repeatCount:(NSUInteger)repeatCount
                        actionHandler:(id __nonnull)handler
                       callBackAction:(SEL __nonnull)callBack;




/**
 取消GCD定时器任务
 */
- (void)cancelGCDTimer;

@end
#pragma clang assume_nonnull end
