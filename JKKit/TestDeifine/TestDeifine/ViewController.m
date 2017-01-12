//
//  ViewController.m
//  TestDeifine
//
//  Created by 蒋鹏 on 17/1/11.
//  Copyright © 2017年 溪枫狼. All rights reserved.
//

#import "ViewController.h"

#define JKConstDefineForString(myKey,myValue)  static NSString * const myKey = myValue;
#define JKConstDefineForFloat(myKey,myValue)   static const CGFloat myKey = myValue;
#define JKConstDefineForInteger(myKey,myValue) static const NSInteger myKey = myValue;
#define JKConstDefineForChar(myKey,myValue)    static const char * myKey = myValue;




@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
