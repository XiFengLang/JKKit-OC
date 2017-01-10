//
//  ViewController.m
//  JKAutoReleaseObject
//
//  Created by 蒋鹏 on 17/1/6.
//  Copyright © 2017年 溪枫狼. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()


@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    /*
     dispatch_block_t TestBlock = nil;
     
     
     /// 下面4种Block都没有捕获外部变量，且不管有没有赋值，都是全局类型__NSGlobalBlock__
     TestBlock = ^(){};
     NSLog(@"1：%@",TestBlock);
     NSLog(@"2：%@",^(){});
     NSLog(@"3：%@",^(int a, int b){ a = a + b;});
     void (^MyBlock) (int , int ) = ^(int a, int b) {
     a = a + b;
     };
     NSLog(@"4：%@",MyBlock);
     
     
     
     
     /// 创建的block有捕获外部变量，存放在栈区（Block的实现IMP在栈中吗？），也就是__NSStackBlock__。
     NSLog(@"5：%@",^(){
     self.view.backgroundColor = [UIColor redColor];
     });
     
     
     
     /// 将上面有捕获外部变量的栈区NSStackBlock赋值给TestBlock时，ARC模式下会自动对NSStackBlock进行 Copy操作，栈区NSStackBlock会被Copy到堆区，NSMallocBlock会强引用NSStackBlock（实际是增加外部变量的引用计数），堆区类型__NSMallocBlock__
     TestBlock = ^(){
     self.view.backgroundColor = [UIColor redColor];
     };
     NSLog(@"6：%@",TestBlock);
     
     
     
     dispatch_block_t TestBlock_Copy = [TestBlock copy];
     /// 对堆区Block(NSMallocBlock) 进行copy，会增加外部变量的引用计数，应该等同增加了NSStackBlock的引用计数
     NSLog(@"7：%@",TestBlock_Copy);
     
     
     
     /// 再copy,不会增加TestBlock引用计数，也不会增加外部变量的引用计数.那有啥意义？
     dispatch_block_t TestBlock_Copy_Copy = [TestBlock_Copy copy];
     NSLog(@"8：%@",TestBlock_Copy_Copy);
     
     
     
     /// 内部打印Block，__NSGlobalBlock__
     [self voidBlockTest:^{
     
     }];
     
     
     
     /// 内部打印Block，__NSStackBlock__
     [self voidBlockTest:^{
     self.view.backgroundColor = [UIColor redColor];
     }];
     
     
     
     /// 内部打印Block，__NSMallocBlock__
     [self voidBlockTest:TestBlock];
     
     */
}

//- (void)voidBlockTest:(void(^)(void))block {
//    NSLog(@"8：%@",block);
//}


@end
