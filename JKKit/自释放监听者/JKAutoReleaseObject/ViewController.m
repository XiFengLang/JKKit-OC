//
//  ViewController.m
//  JKAutoReleaseObject
//
//  Created by 蒋鹏 on 17/1/6.
//  Copyright © 2017年 溪枫狼. All rights reserved.
//

#import "ViewController.h"
#import "JKTimerHolder.h"
#import "JKTestObj.h"
#import "NSObject+Swizzling.h"

#import "NSObject+GCDDelayTask.h"

#import <objc/runtime.h>

@interface ViewController ()

@property (nonatomic, weak)JKTimerHolder * timerHolder;

@property (nonatomic, assign)NSInteger index;


@property (nonatomic, copy) JKGCDDelayTaskBlock delayTaskBlock;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    /// 定时器
    JKTimerHolder * timerHolder = [[JKTimerHolder alloc] init];
    self.timerHolder = timerHolder;
    [timerHolder startTimerWithTimeInterval:0.5 actionHandler:self callBackAction:@selector(jk_sel:) repeatCount:10];
}


- (IBAction)startTest:(id)sender {
    JKTestObj * obj = [[JKTestObj alloc] init];

    self.delayTaskBlock = JK_GCDDelayTaskBlock(5.0, ^{
        [obj testSEL];
    });
    
    
//    [self jk_excuteDelayTaskWithKey:"key" delayInSeconds:5 inMainQueue:^{
//        [obj testSEL];
//    }];
    
    
    
//    [self jk_excuteDelayTask:5 inMainQueue:^{
//        [obj testSEL];
//    }];
    
}


- (IBAction)endTest:(id)sender {
    JK_CancelGCDDelayedTask(self.delayTaskBlock);
    
//    [self jk_cancelGCDDelayTaskForKey:nil];
//    JKGCDDelayTaskBlock taskBlockCopy = objc_getAssociatedObject(self, "key");
//    NSLog(@"%@",taskBlockCopy);
}

- (void)jk_sel:(NSTimer *)timer {
    self.index += 1;
    NSLog(@"%zd",self.index);
    
    if (self.index == 10) {
        [self.timerHolder invalidateTimer];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
