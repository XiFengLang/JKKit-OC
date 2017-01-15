//
//  DelayTaskTestVC.m
//  JKAutoReleaseObject
//
//  Created by 蒋鹏 on 17/1/10.
//  Copyright © 2017年 溪枫狼. All rights reserved.
//

#import "DelayTaskTestVC.h"
#import "NSObject+GCDDelayTask.h"
#import "JKTestObj.h"



@interface DelayTaskTestVC ()
@property (nonatomic, copy) JKGCDDelayTaskBlock delayTaskBlock;

@property (nonatomic, assign) BOOL autoCancelDelayTask;


@end

@implementation DelayTaskTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}
- (IBAction)swicthValueChange:(UISwitch *)sender {
    self.autoCancelDelayTask = sender.isOn;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    
    if (self.autoCancelDelayTask) {
        JK_CancelGCDDelayedTask(self.delayTaskBlock);
        [self jk_cancelGCDDelayTask];
        [self jk_cancelGCDDelayTaskForKey:"key"];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(jk_testSEL) object:nil];
    }
    
    
    //    JKGCDDelayTaskBlock taskBlockCopy = objc_getAssociatedObject(self, "key");
    //    NSLog(@"%@",taskBlockCopy);
}

- (IBAction)startDelayPerform:(id)sender {
    [self performSelector:@selector(jk_testSEL) withObject:nil afterDelay:2];
}


- (void)jk_testSEL {
    NSLog(@"JKViewController 执行延时任务");
    self.view.backgroundColor = [UIColor redColor];
}


- (IBAction)cancelDelayPerform:(id)sender {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(jk_testSEL) object:nil];
    // [NSObject cancelPreviousPerformRequestsWithTarget:self];
}




- (IBAction)startDelayFunc:(id)sender {
    JKTestObj * obj = [[JKTestObj alloc] init];
    
    self.delayTaskBlock = JK_GCDDelayTaskBlock(5.0, ^{
        [obj testSEL];
        self.view.backgroundColor = [UIColor redColor];
    });
}
- (IBAction)cancelDelayFunc:(id)sender {
    JK_CancelGCDDelayedTask(self.delayTaskBlock);
}


- (IBAction)startDelayObj:(id)sender {
    JKTestObj * obj = [[JKTestObj alloc] init];
    
    [self jk_excuteDelayTask:5 inMainQueue:^{
        [obj testSEL];
        self.view.backgroundColor = [UIColor darkGrayColor];
    }];
}

- (IBAction)cancelDelayObj:(id)sender {
    [self jk_cancelGCDDelayTask];
}


- (IBAction)startDelayWithKey:(id)sender {
    JKTestObj * obj = [[JKTestObj alloc] init];
    [self jk_excuteDelayTaskWithKey:"key" delayInSeconds:5 inMainQueue:^{
        [obj testSEL];
        self.view.backgroundColor = [UIColor blueColor];
    }];
}
- (IBAction)cancelDelayWithKey:(id)sender {
    [self jk_cancelGCDDelayTaskForKey:"key"];
}


- (void)dealloc {
    NSLog(@"%@ 已释放",self.class);
}

@end
