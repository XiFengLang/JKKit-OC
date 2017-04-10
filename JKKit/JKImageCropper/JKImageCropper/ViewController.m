//
//  ViewController.m
//  JKImageCropper
//
//  Created by 蒋鹏 on 17/2/23.
//  Copyright © 2017年 溪枫狼. All rights reserved.
//

#import "ViewController.h"
#import "JKImageCropperViewController.h"

@interface ViewController ()

@property (nonatomic, weak) UIView * contentView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView * contentView = [[UIView alloc] init];
    [self.view addSubview:contentView];
    contentView.backgroundColor = [UIColor redColor];
    self.contentView = contentView;
    
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:<#(nonnull id)#> attribute:<#(NSLayoutAttribute)#> relatedBy:<#(NSLayoutRelation)#> toItem:<#(nullable id)#> attribute:<#(NSLayoutAttribute)#> multiplier:<#(CGFloat)#> constant:<#(CGFloat)#>]]
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
