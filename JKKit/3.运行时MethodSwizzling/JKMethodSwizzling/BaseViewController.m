//
//  BaseViewController.m
//  JKMethodSwizzling
//
//  Created by 蒋鹏 on 17/1/5.
//  Copyright © 2017年 溪枫狼. All rights reserved.
//

#import "BaseViewController.h"
#import "NSObject+Swizzling.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

+ (void)load {
    [super load];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    NSLog(@"父类  原始  方法");
//}


- (void)edf_viewWillAppear:(BOOL)animated{
    [self edf_viewWillAppear:animated];
    NSLog(@"   KKK       KKK   %@",[self class]);
}

@end
