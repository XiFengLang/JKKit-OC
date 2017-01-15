//
//  ViewController.m
//  JKMethodSwizzling
//
//  Created by 蒋鹏 on 17/1/3.
//  Copyright © 2017年 溪枫狼. All rights reserved.
//

#import "ViewController.h"
#import "NSObject+Swizzling.h"
#import "Test.h"





@interface ViewController ()



@end

@implementation ViewController
+ (void)load {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        JK_ExchangeInstanceMethod(@selector(viewWillAppear:), @selector(edf_viewWillAppear:), self);
//    });
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIImage * image = [UIImage imageNamed:@"TTTTT"];
    image = [UIImage imageNamed:@"test.jpg"];
    
    
    NSArray * array = @[@"1",@"2",@"3"];
    NSLog(@"%@",[array objectAtIndex:3]);
    NSLog(@"%@",[[NSMutableArray arrayWithArray:array] objectAtIndex:3]);
    
    
    
    
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        JK_ExchangeInstanceMethod(@selector(viewWillAppear:), @selector(edf_viewWillAppear:), [self class]);
//    });


//    NSLog(@"%@",image);
}


//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    NSLog(@"本类  原始  方法");
//}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)edf_viewWillAppear:(BOOL)animated{
    [self edf_viewWillAppear:animated];
    NSLog(@"   JJJ       JJJ   %@",[self class]);
}

@end
