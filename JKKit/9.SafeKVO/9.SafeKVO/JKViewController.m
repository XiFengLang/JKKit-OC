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

@implementation JKViewController {
    WKWebView * webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    webView = [[WKWebView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:webView];
    
    [webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://www.baidu.com"]]];
    
    weak(self);
    [webView jk_addKVOWithKeyPath:@"estimatedProgress" handle:^(id  _Nonnull newValue, id  _Nonnull oldValue) {
        strong(self);
        self.view.backgroundColor = [UIColor redColor];
        NSLog(@"%@   %@",newValue,oldValue);
    }];
}


- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
//    [webView jk_removeObserverWithKeyPath:@"estimatedProgress"];
//    [webView jk_removeAllObservers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)dealloc {
    NSLog(@"************dealloc");
}

@end
