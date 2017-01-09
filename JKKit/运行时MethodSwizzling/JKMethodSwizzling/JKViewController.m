//
//  JKViewController.m
//  JKMethodSwizzling
//
//  Created by 蒋鹏 on 17/1/5.
//  Copyright © 2017年 溪枫狼. All rights reserved.
//

#import "JKViewController.h"
#import "NSObject+Swizzling.h"

@interface JKViewController ()

@end

@implementation JKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (IBAction)didClickedPopItem:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)jk_navigationControllerShouldPopOnBackButton {
    return YES;
}

@end
