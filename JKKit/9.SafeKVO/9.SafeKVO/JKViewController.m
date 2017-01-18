//
//  JKViewController.m
//  9.SafeKVO
//
//  Created by 蒋鹏 on 17/1/18.
//  Copyright © 2017年 溪枫狼. All rights reserved.
//

#import "JKViewController.h"
#import <WebKit/WebKit.h>
#import "NSObject+KVO.h"

@interface JKViewController ()

@end

@implementation JKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WKWebView * webView = [[WKWebView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:webView];
    
    [webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://www.baidu.com"]]];
    
    [webView jk_addKVOWithKeyPath:@"estimatedProgress" handle:^(id  _Nonnull newValue, id  _Nonnull oldValue) {
        NSLog(@"%@   %@",newValue,oldValue);
    }];
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
}


@end
