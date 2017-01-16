//
//  ViewController.m
//  7.Runtime-Json-Model
//
//  Created by 蒋鹏 on 17/1/13.
//  Copyright © 2017年 溪枫狼. All rights reserved.
//

#import "ViewController.h"
#import "JKModel.h"
#import "JKModelExtension.h"



@interface ViewController ()



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString * path = [[NSBundle mainBundle] pathForResource:@"runtime.json" ofType:nil];
    NSData * data = [NSData dataWithContentsOfFile:path];
    NSDictionary * dict = [data jk_JSONObject];
    NSArray <JKModel *> * models = [JKModel jk_objectArrayWithDictionaryArray:dict[@"data"]];
    NSLog(@"%@",models);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
