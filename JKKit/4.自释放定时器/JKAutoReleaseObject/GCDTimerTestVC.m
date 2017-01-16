//
//  JKViewController.m
//  JKAutoReleaseObject
//
//  Created by 蒋鹏 on 17/1/10.
//  Copyright © 2017年 溪枫狼. All rights reserved.
//

#import "GCDTimerTestVC.h"
#import "JKGCDTimerHolder.h"

@interface GCDTimerTestVC ()

@property (nonatomic, weak) JKGCDTimerHolder * gcdTimerHolder;


@end

@implementation GCDTimerTestVC



- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (IBAction)startTimerJK:(id)sender {
    JKGCDTimerHolder * gcdTimerHolder = [[JKGCDTimerHolder alloc] init];
    self.gcdTimerHolder = gcdTimerHolder;
//    [self.gcdTimerHolder startGCDTimerWithTimeInterval:0.5 repeatCount:8 actionHandler:self callBackAction:@selector(gcdTimerAction)];
    [self.gcdTimerHolder startBlockTimerWithTimeInterval:0.5 repeatCount:8 actionHandler:self callBack:^(JKGCDTimerHolder * _Nonnull gcdTimer, id  _Nonnull actionHandler, NSUInteger currentCount) {
        [(GCDTimerTestVC *)actionHandler gcdTimerAction];
    }];
}

- (void)gcdTimerAction {
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    NSLog(@"GCD定时器正在运行");
}


- (IBAction)cancelTimerJK:(id)sender {
    [self.gcdTimerHolder cancelGCDTimer];
}



- (void)dealloc {
    NSLog(@"%@ 已释放",self.class);
}

@end
