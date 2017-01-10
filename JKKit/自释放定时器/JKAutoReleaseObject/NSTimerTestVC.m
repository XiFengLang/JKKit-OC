//
//  NSTimerTestVC.m
//  JKAutoReleaseObject
//
//  Created by 蒋鹏 on 17/1/10.
//  Copyright © 2017年 溪枫狼. All rights reserved.
//

#import "NSTimerTestVC.h"
#import "JKNSTimerHolder.h"

@interface NSTimerTestVC ()
@property (nonatomic, strong)JKNSTimerHolder * timerHolder;
//@property (nonatomic, weak)JKNSTimerHolder * timerHolder;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) NSUInteger repeatCount;


@end

@implementation NSTimerTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /// 定时器
    self.repeatCount = 9;
    JKNSTimerHolder * timerHolder = [[JKNSTimerHolder alloc] init];
    self.timerHolder = timerHolder;
    [timerHolder startNSTimerWithTimeInterval:0.5 repeatCount:self.repeatCount actionHandler:self callBackAction:@selector(jk_sel:)];
}


- (void)jk_sel:(NSTimer *)timer {
    self.index += 1;
    NSLog(@"执行第%zd次,并将在第%zd次后取消",self.index, self.repeatCount + 1);
    
    if (self.index == self.repeatCount + 1) {
        [self.timerHolder cancelNSTimer];
    }
}


- (void)dealloc {
    NSLog(@"%@ 已释放",self.class);
}

@end
