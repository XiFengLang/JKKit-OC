//
//  ViewController.m
//  Block
//
//  Created by 蒋鹏 on 17/1/11.
//  Copyright © 2017年 溪枫狼. All rights reserved.
//

#import "ViewController.h"

static inline void JKLogRetainCount(NSString * des ,id obj) {
    if (nil != obj) {
        /// 实际的RetainCount 比 CFGetRetainCount 小 1
        NSLog(@"%@  RetainCount = %zd", des,CFGetRetainCount((__bridge CFTypeRef)obj) - 1);
    } else {
        NSLog(@"%@  RetainCount = 0, obj == nil",des);
    }
}


@interface ViewController ()


@property (nonatomic, weak) void(^weakBlock)();
@property (nonatomic, copy) void(^copyBlock)();
@property (nonatomic, strong) void(^strongBlock)();




@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIView * testView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 50, 50)];
    testView.backgroundColor = [UIColor orangeColor];
    JKLogRetainCount(@"alloc testView",testView);
    
    [self.view addSubview:testView];
    JKLogRetainCount(@"add testView",testView);
    
     dispatch_block_t globalBlock = nil;
    
    NSLog(@"\n************************************************************__NSGlobalBlock__********************\n.");
    
    
     /// 下面4种Block都没有捕获外部变量，且不管有没有赋值，都是全局类型__NSGlobalBlock__
     globalBlock = ^(){};
     NSLog(@"1:%@",globalBlock);
     NSLog(@"2:%@",^(int a, int b){ a = a + b;});
    
    /// 在执行GlobalBlock时，GlobalBlock会强引用参数变量(RetainCount+1)，GlobalBlock执行结束就会解除强引用(RetainCount-1)
     void (^globalBlock_Temp) (UIView * , int ) = ^(UIView * a, int b) {
         a.backgroundColor = [UIColor redColor];
         JKLogRetainCount(@"作为GlobalBlock内部的参数 testView",a);
     };
    int a = 1, b = 2;
    JKLogRetainCount(@"GlobalBlock外部的testView",testView);
    globalBlock_Temp(testView,b+a);
    JKLogRetainCount(@"已执行完GlobalBlock，外部testView",testView);
    NSLog(@"3:%@",globalBlock_Temp);
    
    /// 可以重复调用
    globalBlock_Temp(testView,b+a);
    
    /// __NSGlobalBlock__ 可以释放
    globalBlock = nil;
    globalBlock_Temp = nil;
    NSLog(@"4:%@",globalBlock);
    NSLog(@"5:%@",globalBlock_Temp);
    
    
    /// 内部打印Block，__NSGlobalBlock__
    [self globalBlockTest:^{
        NSLog(@"没有强引用外部变量");
    }];
    
    
    
    /**<  
     
     [控制台打印] alloc testView  RetainCount = 1
     [控制台打印] add testView  RetainCount = 2
     [控制台打印] 1:<__NSGlobalBlock__: 0x10fa44100>
     [控制台打印] 2:<__NSGlobalBlock__: 0x10fa44140>
     [控制台打印] GlobalBlock外部的testView  RetainCount = 2
     [控制台打印] 作为GlobalBlock内部的参数 testView  RetainCount = 3
     [控制台打印] 已执行完GlobalBlock，外部testView  RetainCount = 2
     [控制台打印] 3:<__NSGlobalBlock__: 0x10fa44180>
     [控制台打印] 作为GlobalBlock内部的参数 testView  RetainCount = 3
     [控制台打印] 4:(null)
     [控制台打印] 5:(null)
     [控制台打印] globalBlock Func Log：<__NSGlobalBlock__: 0x10fa441c0>
     [控制台打印] 没有强引用外部变量
     */
    
    
    NSLog(@"\n\n************************************************************__NSStackBlock__********************\n.");
    
    
    testView = [[UIView alloc] initWithFrame:CGRectMake(100, 200, 50, 50)];
    testView.backgroundColor = [UIColor orangeColor];
    JKLogRetainCount(@"alloc testView",testView);
    
    [self.view addSubview:testView];
    JKLogRetainCount(@"add testView",testView);
    
    
    
    /// 外部变量会被stackBlock强引用一次,直到stackBlock销毁才会解除强引用。
    
    NSLog(@"1:%@",^(){
        testView.backgroundColor = [UIColor darkGrayColor];
        JKLogRetainCount(@"stackBlock内部强引用的 testView",testView);
    });
    JKLogRetainCount(@"外部的TestView已被stackBlock引用，但是未调用stackBlock", testView);
    
    
    ///\
    在执行GlobalBlock时，GlobalBlock会强引用参数变量(RetainCount+1)，GlobalBlock执行结束就会解除强引用(RetainCount-1)\
    效果跟GlobalBlock一样
    
    /// 用__weak修饰的weakBlock接收stackBlock，weakBlock还是__NSStackBlock__类型
    
    __weak void (^stackBlock)(UIView *) = ^(UIView * view){
        testView.backgroundColor = [UIColor darkGrayColor];
        view.backgroundColor = [UIColor darkGrayColor];
        JKLogRetainCount(@"stackBlock内部强引用的 testView",testView);
    };
    NSLog(@"2:%@",stackBlock);
    stackBlock(testView);
    JKLogRetainCount(@"stackBlock已执行完，外部的testView",testView);
    NSLog(@"3:%@",stackBlock);
    
    
    /// (__weak)stackBlock作为方法的参数传入,tempStackBlock接收参数中的(__weak)stackBlock,tempStackBlock会是__NSMallocBlock__，应该是调用了copy\
        如果用tempStackBlock直接接收(__weak)stackBlock,还是__NSStackBlock__类型，奇葩
    
    [self stackBlockTest:stackBlock];
    void(^tempStackBlock)(UIView *) = stackBlock;
    NSLog(@"tempStackBlock = stackBlock   2: %@",tempStackBlock);

    
    /**<  
     [控制台打印] alloc testView  RetainCount = 1
     [控制台打印] add testView  RetainCount = 2
     [控制台打印] 1:<__NSStackBlock__: 0x7fff501be818>
     [控制台打印] 外部的TestView已被stackBlock引用，但是未调用stackBlock  RetainCount = 3
     [控制台打印] 2:<__NSStackBlock__: 0x7fff501be7e8>
     [控制台打印] stackBlock内部强引用的 testView  RetainCount = 5
     [控制台打印] stackBlock已执行完，外部的testView  RetainCount = 4
     [控制台打印] 3:<__NSStackBlock__: 0x7fff501be7e8>
     [控制台打印] stackBlock Func Log：<__NSStackBlock__: 0x7fff501be7e8>
     [控制台打印] stackBlock内部强引用的 testView  RetainCount = 4
     [控制台打印] tempStackBlock = stackBlock   1: <__NSMallocBlock__: 0x60000005b960>
     [控制台打印] tempStackBlock = stackBlock   2: <__NSStackBlock__: 0x7fff501be7e8>
     */
    
    
    NSLog(@"\n\n************************************************************__NSMallocBlock__********************\n.");
    
    testView = [[UIView alloc] initWithFrame:CGRectMake(100, 300, 50, 50)];
    testView.backgroundColor = [UIColor orangeColor];
    JKLogRetainCount(@"alloc testView",testView);
    
    [self.view addSubview:testView];
    JKLogRetainCount(@"add testView",testView);
    
    
    
    void (^mallocBlock_temp) (UIView *) = [stackBlock copy];
    NSLog(@"1:%@",mallocBlock_temp);
    
    
    /// 外部变量作为参数传入mallocBlock,效果跟传入stackBlock、globalBlock一样，即只在执行的过程中强引用，执行完就解除强引用\
        在ARC模式下，将stackBlockw赋值给一个strong类型的mallocBlock，会自动执行[stackBlockw copy]\
        mallocBlock 也会强引用外部变量一次。所以这个过程，外部变量会被强引用2次。
    
    void (^mallocBlock) (UIView *) = ^(UIView * view) {
        testView.backgroundColor = [UIColor redColor];
        view.backgroundColor = [UIColor blueColor];
        JKLogRetainCount(@"mallocBlock内部的testView", testView);
    };
    NSLog(@"2:%@",mallocBlock);
    mallocBlock(testView);
    JKLogRetainCount(@"已调用mallocBlock，testView被强引用，也作为参数传入mallocBlock", testView);
    
    [self mallocBlockTest:mallocBlock];
    
    
    /// 很多博客说mallocBlock_Copy = [mallocBlock copy]的效果等同强引用retain了(mallocBlock或外部变量)一次\
        但在[MRC和ARC]环境下测试的结果都是引用计数不变，mallocBlock_Copy和mallocBlock内存一直，但是外部变量的引用计数不变，why❓\
        即使用__strong 修饰，也一样
    
    void (^mallocBlock_Copy)(UIView *) = [mallocBlock copy];
    NSLog(@"mallocBlock_Copy %@",mallocBlock_Copy);
    JKLogRetainCount(@"copy mallocBlock之后", testView);
    
    
    __strong void (^mallocBlock_Copy_Copy)(UIView *) = [mallocBlock_Copy copy];
    NSLog(@"mallocBlock_Copy_Copy %@",mallocBlock_Copy_Copy);
    JKLogRetainCount(@"copy mallocBlock_Copy_Copy之后", testView);
    
    
    /**<  
     [控制台打印] alloc testView  RetainCount = 1
     [控制台打印] add testView  RetainCount = 2
     [控制台打印] 1:<__NSMallocBlock__: 0x6000002409f0>
     [控制台打印] 2:<__NSMallocBlock__: 0x600000240b70>
     [控制台打印] mallocBlock内部的testView  RetainCount = 5
     [控制台打印] 已调用mallocBlock，testView被强引用，也作为参数传入mallocBlock  RetainCount = 4
     [控制台打印] stackBlock Func Log：<__NSMallocBlock__: 0x600000240b70>
     [控制台打印] mallocBlock内部的testView  RetainCount = 4
     [控制台打印] mallocBlock_Copy <__NSMallocBlock__: 0x600000240b70>
     [控制台打印] copy mallocBlock之后  RetainCount = 4
     [控制台打印] mallocBlock_Copy_Copy <__NSMallocBlock__: 0x600000240b70>
     [控制台打印] copy mallocBlock_Copy_Copy之后  RetainCount = 4
     
     */
    
    
    
    NSLog(@"\n\n************************************************************__不推荐 weak__********************\n.");
    
    /*
    
    testView = [[UIView alloc] initWithFrame:CGRectMake(100, 400, 50, 50)];
    testView.backgroundColor = [UIColor orangeColor];
    JKLogRetainCount(@"alloc testView",testView);
    
    [self.view addSubview:testView];
    JKLogRetainCount(@"add testView",testView);
    
    
    /// weak类型的block属性对象，__NSStackBlock__，只会强引用外部变量一次
    /// 不推荐，在viewDidAppear调用lf.weakBlock就会崩溃，viewDidLoad结束就会释放
    
    self.weakBlock = ^(){
        testView.backgroundColor = [UIColor redColor];
        JKLogRetainCount(@"self.weakBlock 内部testView", testView);
    };
    NSLog(@"1:%@",self.weakBlock);
    self.weakBlock();
    JKLogRetainCount(@"self.weakBlock 外部testView", testView);
     
     
    */
    
    NSLog(@"\n\n************************************************************__copy__********************\n.");
    
    
    testView = [[UIView alloc] initWithFrame:CGRectMake(100, 400, 50, 50)];
    testView.backgroundColor = [UIColor orangeColor];
    JKLogRetainCount(@"alloc testView",testView);
    
    [self.view addSubview:testView];
    JKLogRetainCount(@"add testView",testView);
    
    /// copy类型的block属性对象，__NSMallocBlock__，只会强引用外部变量2次，因为ARC会自动copy stackBlock
    self.copyBlock = ^(){
        testView.backgroundColor = [UIColor blueColor];
        JKLogRetainCount(@"self.copyBlock 内部testView", testView);
    };
    NSLog(@"2:%@",self.copyBlock);
    self.copyBlock();
    JKLogRetainCount(@"self.copyBlock 外部testView", testView);
    

    
    /**<  
     [控制台打印] alloc testView  RetainCount = 1
     [控制台打印] add testView  RetainCount = 2
     [控制台打印] 2:<__NSMallocBlock__: 0x60800044d080>
     [控制台打印] self.copyBlock 内部testView  RetainCount = 4
     [控制台打印] self.copyBlock 外部testView  RetainCount = 4
     
     */
     
     
    NSLog(@"\n\n************************************************************__strong__********************\n.");
    
    
    testView = [[UIView alloc] initWithFrame:CGRectMake(100, 400, 50, 50)];
    testView.backgroundColor = [UIColor orangeColor];
    JKLogRetainCount(@"alloc testView",testView);
    
    [self.view addSubview:testView];
    JKLogRetainCount(@"add testView",testView);
    
    
    /// strong类型的block属性对象，__NSMallocBlock__，只会强引用外部变量2次，因为ARC会自动copy stackBlock
    
    self.strongBlock = ^(){
        testView.backgroundColor = [UIColor blueColor];
        JKLogRetainCount(@"self.strongBlock 内部 testView", testView);
    };
    NSLog(@"3:%@",self.strongBlock);
    self.strongBlock();
    JKLogRetainCount(@"self.strongBlock 外部 testView", testView);


    /**<  
     [控制台打印] alloc testView  RetainCount = 1
     [控制台打印] add testView  RetainCount = 2
     [控制台打印] 3:<__NSMallocBlock__: 0x60800044d050>
     [控制台打印] self.strongBlock 内部 testView  RetainCount = 4
     [控制台打印] self.strongBlock 外部 testView  RetainCount = 4
     */
    
}








- (void)mallocBlockTest:(void(^)(UIView *))mallocBlock {
    NSLog(@"stackBlock Func Log：%@",mallocBlock);
    
    mallocBlock([UIView new]);
}





- (void)stackBlockTest:(void(^)(UIView *))stackBlock {
     NSLog(@"stackBlock Func Log：%@",stackBlock);
    
    stackBlock([UIView new]);
    
    /// 接收参数中的NSStackBlock,tempStackBlock会是__NSMallocBlock__，应该执行了copy
    void(^tempStackBlock)(UIView *) = stackBlock;
    NSLog(@"tempStackBlock = stackBlock   1: %@",tempStackBlock);
}




- (void)globalBlockTest:(void(^)(void))globalBlock {
    NSLog(@"globalBlock Func Log：%@",globalBlock);
    globalBlock();
}







- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"\n\n******************************************************__viewDidAppear__**************\n.");
    

    //    self.weakBlock();
        self.copyBlock();
        self.strongBlock();
    
//        NSLog(@"stackBlock:%@",self.weakBlock);
        NSLog(@"self.copyBlock   :%@",self.copyBlock);
        NSLog(@"self.strongBlock :%@",self.strongBlock);

    
    /**<  
     [控制台打印] self.copyBlock 内部testView  RetainCount = 3
     [控制台打印] self.strongBlock 内部 testView  RetainCount = 3
     [控制台打印] self.copyBlock   :<__NSMallocBlock__: 0x60800044d080>
     [控制台打印] self.strongBlock :<__NSMallocBlock__: 0x60800044d050>
     */
}


@end
