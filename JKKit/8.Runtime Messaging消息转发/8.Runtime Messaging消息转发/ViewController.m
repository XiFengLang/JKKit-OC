//
//  ViewController.m
//  8.Runtime Messaging消息转发
//
//  Created by 蒋鹏 on 17/1/17.
//  Copyright © 2017年 溪枫狼. All rights reserved.
//  http://cc.cocimg.com/api/uploads/20151014/1444814548720164.png

#import "ViewController.h"
#import "Bird.h"
#import "Cat.h"
#import "Dog.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    
    
    [[Dog new] jump];
    [[Cat new] jump];
    [[Bird new] jump];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
