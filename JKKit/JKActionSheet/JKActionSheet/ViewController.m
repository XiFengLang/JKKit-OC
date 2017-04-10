//
//  ViewController.m
//  JKActionSheet
//
//  Created by 蒋鹏 on 17/2/14.
//  Copyright © 2017年 溪枫狼. All rights reserved.
//

#import "ViewController.h"
#import "JKActionSheet.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    
    self.view.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"img1.jpg"].CGImage);
    
//    UIActionSheet
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    JKActionSheet * actionSheet = [[JKActionSheet alloc] initWithTitle:@"标题" cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:@[@"其他"]];
    [actionSheet showInView:[actionSheet statusBarContentView] actionHandle:^(JKActionSheet * _Nonnull tempActionSheet, NSInteger index, NSString * _Nonnull buttonTitle) {
        
        NSLog(@"%zd  %@",index,buttonTitle);
        
    }];
    
    [self performSelector:@selector(excuteDelayTask:) withObject:actionSheet afterDelay:1.0];
}

- (void)excuteDelayTask:(JKActionSheet *)sheet {
    [sheet reloadWithOtherButtonTitles:@[@"识别二维码",@"保存图片"]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
