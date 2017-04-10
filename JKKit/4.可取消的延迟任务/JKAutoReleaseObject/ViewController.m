//
//  ViewController.m
//  JKAutoReleaseObject
//
//  Created by 蒋鹏 on 17/1/6.
//  Copyright © 2017年 溪枫狼. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()


@end

@implementation ViewController




- (void)viewDidLoad {
    [super viewDidLoad];

}


- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    NSLog(@"%@",self.navigationController);
    NSLog(@"%@",self.navigationController.topViewController);
    NSLog(@"%@",self.navigationController.viewControllers);
}



@end
