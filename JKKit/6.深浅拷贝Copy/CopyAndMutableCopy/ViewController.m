//
//  ViewController.m
//  CopyAndMutableCopy
//
//  Created by 蒋鹏 on 17/1/11.
//  Copyright © 2017年 溪枫狼. All rights reserved.
//

#import "ViewController.h"
#import "JKObj.h"


static inline void JKLogRetainCount(NSString * des ,id obj) {
    if (nil != obj) {
        /// 实际的RetainCount 比 CFGetRetainCount 小 1
        NSLog(@"%@  RetainCount = %zd", des,CFGetRetainCount((__bridge CFTypeRef)obj) - 1);
    } else {
        NSLog(@"%@  RetainCount = 0, obj == nil",des);
    }
}


@interface ViewController ()

@property (nonatomic, strong) NSArray * array_strong;
@property (nonatomic, strong) NSString * str_strong;

@property (nonatomic, copy) NSArray * array_copy;
@property (nonatomic, copy) NSString * str_copy;

@property (nonatomic, copy)   NSDictionary * dict_copy;
@property (nonatomic, strong) NSDictionary * dict_strong;



@property (nonatomic, copy)   void(^copyBlock)();
@property (nonatomic, strong) void(^strongBlock)();

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSMutableString * mutStr = [[NSMutableString alloc] initWithString:@"AAAA"];
    NSLog(@"mutStr        = %@ : %p",mutStr,mutStr);
    self.str_copy = mutStr;
    NSLog(@"self.str_copy = %@ : %p",self.str_copy,self.str_copy);
    mutStr = [[NSMutableString alloc] initWithString:@"BBBB"];
    NSLog(@"mutStr        = %@ : %p",mutStr,mutStr);
    NSLog(@"self.str_copy = %@ : %p",self.str_copy,self.str_copy);
    
    
    NSLog(@".");
    NSLog(@"self.str_copy : %@  是否可变: %@",self.str_copy.class,self.str_copy == [self.str_copy copy] ? @"NO" : @"YES");
    NSLog(@"mutStr        : %@  是否可变: %@",mutStr.class,mutStr == [mutStr copy] ? @"NO" : @"YES");
    NSLog(@".");
    
    /**<  
     [控制台打印] mutStr        = AAAA : 0x610000070580
     [控制台打印] self.str_copy = AAAA : 0xa000000414141414
     [控制台打印] mutStr        = BBBB : 0x600000071b80
     [控制台打印] self.str_copy = AAAA : 0xa000000414141414
     [控制台打印] .
     [控制台打印] self.str_copy : NSTaggedPointerString  是否可变: NO
     [控制台打印] mutStr        : __NSCFString  是否可变: YES
     */
    
    
    
    self.str_strong = mutStr;
    NSLog(@"mutStr          = %@ : %p",mutStr,mutStr);
    NSLog(@"self.str_strong = %@ : %p",self.str_strong,self.str_strong);
    mutStr = [[NSMutableString alloc] initWithString:@"CCCC"];
    NSLog(@"mutStr          = %@ : %p",mutStr,mutStr);
    
    NSLog(@".");
    NSLog(@"self.str_strong : %@  是否可变: %@",self.str_strong.class,self.str_strong == [self.str_strong copy] ? @"NO" : @"YES");
    NSLog(@"mutStr          : %@  是否可变: %@",mutStr.class,mutStr == [mutStr copy] ? @"NO" : @"YES");
    NSLog(@".");
    
    
    /**<
     [控制台打印] mutStr          = BBBB : 0x600000071b80
     [控制台打印] self.str_strong = BBBB : 0x600000071b80
     [控制台打印] mutStr          = CCCC : 0x608000073080
     [控制台打印] .
     [控制台打印] self.str_strong : __NSCFString  是否可变: YES
     [控制台打印] mutStr          : __NSCFString  是否可变: YES
     */
    
    
    NSString * strTemp = @"KKKK";
    NSString * str_copy = [strTemp copy];
    NSMutableString * mut_copy = [strTemp mutableCopy];
    
    NSLog(@"strTemp    : %p",strTemp);
    NSLog(@"str_copy   : %p",str_copy);
    NSLog(@"mut_copy   : %p",mut_copy);
    
    NSLog(@"str_copy   : %@  是否可变: %@",str_copy.class,str_copy == [str_copy copy] ? @"NO" : @"YES");
    NSLog(@"mut_copy   : %@  是否可变: %@",mut_copy.class,mut_copy == [mut_copy copy] ? @"NO" : @"YES");
    NSLog(@".");
    
    /**<  
     [控制台打印] strTemp    : 0x104e50310
     [控制台打印] str_copy   : 0x104e50310
     [控制台打印] mut_copy   : 0x600000071f00
     [控制台打印] str_copy   : __NSCFConstantString  是否可变: NO
     [控制台打印] mut_copy   : __NSCFString  是否可变: YES
     */
    
    
    mutStr = [NSMutableString stringWithString:@"HHHH"];
    str_copy = [mutStr copy];
    mut_copy = [mutStr mutableCopy];
    NSLog(@"mutStr     : %p",mutStr);
    NSLog(@"str_copy   : %p",str_copy);
    NSLog(@"mut_copy   : %p",mut_copy);
    
    
    NSLog(@"str_copy   : %@  是否可变: %@",str_copy.class,str_copy == [str_copy copy] ? @"NO" : @"YES");
    NSLog(@"mut_copy   : %@  是否可变: %@",mut_copy.class,mut_copy == [mut_copy copy] ? @"NO" : @"YES");
    NSLog(@".");
    
    
    /**<
     [控制台打印] mutStr     : 0x6080000732c0
     [控制台打印] str_copy   : 0xa000000484848484
     [控制台打印] mut_copy   : 0x608000073080
     [控制台打印] str_copy   : NSTaggedPointerString  是否可变: NO
     [控制台打印] mut_copy   : __NSCFString  是否可变: YES
     */
    
    
    

    
    
    

    NSMutableArray * mutArray = [NSMutableArray arrayWithArray:@[@"1"]];
    self.array_strong = mutArray;
    self.array_copy = mutArray;
    [mutArray addObject:@"2"];
    
    
    NSLog(@"mutArray          : %p    %@    %@ ",mutArray,mutArray.class,mutArray);
    NSLog(@"self.array_strong : %p    %@",self.array_strong,self.array_strong);
    NSLog(@"self.array_copy   : %p    %@",self.array_copy,self.array_copy);
    NSLog(@"self.array_strong : %@    是否可变: %@",self.array_strong.class,[self.array_strong.class isSubclassOfClass:NSClassFromString(@"__NSArrayM")] ? @"YES" : @"NO");
    NSLog(@"self.array_copy   : %@    是否可变: %@",self.array_copy.class,[self.array_copy.class isSubclassOfClass:NSClassFromString(@"__NSArrayM")] ? @"YES" : @"NO");
    /**<  
     [控制台打印] mutArray          : 0x60800005c140    __NSArrayM    (
     1,
     2
     )
     [控制台打印] self.array_strong : 0x60800005c140    (
     1,
     2
     )
     [控制台打印] self.array_copy   : 0x60800001cde0    (
     1
     )
     [控制台打印] self.array_strong : __NSArrayM    是否可变: YES
     [控制台打印] self.array_copy   : __NSSingleObjectArrayI    是否可变: NO
     */
    
    NSArray * array = @[@"1"];
    self.array_strong = array;
    self.array_copy = array;
    NSLog(@"array             : %p    %@    %@ ",array,array.class,array);
    NSLog(@"self.array_strong : %p    %@",self.array_strong,self.array_strong);
    NSLog(@"self.array_copy   : %p    %@",self.array_copy,self.array_copy);
    NSLog(@"self.array_strong : %@    是否可变:%@",self.array_strong.class,[self.array_strong.class isSubclassOfClass:NSClassFromString(@"__NSArrayM")] ? @"YES" : @"NO");
    NSLog(@"self.array_copy   : %@    是否可变:%@",self.array_copy.class,[self.array_copy.class isSubclassOfClass:NSClassFromString(@"__NSArrayM")] ? @"YES" : @"NO");
    /**<  
     [控制台打印] array             : 0x61000001cbf0    __NSSingleObjectArrayI    (
     1
     )
     [控制台打印] self.array_strong : 0x61000001cbf0    (
     1
     )
     [控制台打印] self.array_copy   : 0x61000001cbf0    (
     1
     )
     [控制台打印] self.array_strong : __NSSingleObjectArrayI    是否可变:NO
     [控制台打印] self.array_copy   : __NSSingleObjectArrayI    是否可变:NO
     */
    
    
    
    NSArray * mutArray_copy = [mutArray copy];
    NSMutableArray * mutArray_mutCopy = [mutArray mutableCopy];
    
    NSArray * array_copy = [array copy];
    NSMutableArray * array_mutCopy = [array mutableCopy];
    
    NSLog(@"array            : %p     %@    %@ ",array,array.class,array);
    NSLog(@"array_copy       : %p     %@ ",array_copy,array_copy);
    NSLog(@"array_mutCopy    : %p     %@ ",array_mutCopy,array_mutCopy);
    NSLog(@"mutArray         : %p     %@    %@ ",mutArray,mutArray.class,mutArray);
    NSLog(@"mutArray_copy    : %p     %@ ",mutArray_copy,mutArray_copy);
    NSLog(@"mutArray_mutCopy : %p     %@ ",mutArray_mutCopy,mutArray_mutCopy);
    
    NSLog(@"array_copy       : %@     是否可变: %@",array_copy.class,[array_copy.class isSubclassOfClass:NSClassFromString(@"__NSArrayM")] ? @"YES" : @"NO");
    NSLog(@"array_mutCopy    : %@     是否可变: %@",array_mutCopy.class,[array_mutCopy.class isSubclassOfClass:NSClassFromString(@"__NSArrayM")] ? @"YES" : @"NO");
    NSLog(@"mutArray_copy    : %@     是否可变: %@",mutArray_copy.class,[mutArray_copy.class isSubclassOfClass:NSClassFromString(@"__NSArrayM")] ? @"YES" : @"NO");
    NSLog(@"mutArray_mutCopy : %@     是否可变: %@",mutArray_mutCopy.class,[mutArray_mutCopy.class isSubclassOfClass:NSClassFromString(@"__NSArrayM")] ? @"YES" : @"NO");
    
    
    /**<
     [控制台打印] array            : 0x61000001cbf0    __NSSingleObjectArrayI    (
     1
     )
     
     [控制台打印] array_copy       : 0x61000001cbf0     (
     1
     )
     [控制台打印] array_mutCopy    : 0x61800005af10     (
     1
     )
     
     [控制台打印] mutArray         : 0x60800005c140    __NSArrayM    (
     1,
     2
     )
     [控制台打印] mutArray_copy    : 0x61800003a5e0     (
     1,
     2
     )
     [控制台打印] mutArray_mutCopy : 0x61800005b060     (
     1,
     2
     )
     [控制台打印] array_copy       : __NSSingleObjectArrayI     是否可变: NO
     [控制台打印] array_mutCopy    : __NSArrayM     是否可变: YES
     [控制台打印] mutArray_copy    : __NSArrayI     是否可变: NO
     [控制台打印] mutArray_mutCopy : __NSArrayM     是否可变: YES
     */
    
    
    NSDictionary * dict = @{@"key":@"1"};
    NSMutableDictionary * mutDict = [NSMutableDictionary dictionaryWithObject:@"1" forKey:@"key"];
//    JKLogRetainCount(@"", dict);
    NSDictionary * dict_copy = [dict copy];
//    JKLogRetainCount(@"", dict);
//    JKLogRetainCount(@"", dict_copy);
    NSMutableDictionary * dict_mutCopy = [dict mutableCopy];
//    JKLogRetainCount(@"", dict);
//    JKLogRetainCount(@"", dict_mutCopy);
    
    NSArray * mutDict_copy = [mutDict copy];
    NSMutableArray * mutDict_mutCopy = [mutDict mutableCopy];
    
    NSLog(@"dict           :%p      %@ ",dict,dict);
    NSLog(@"mutDict        :%p      %@ ",mutDict,mutDict);
    NSLog(@"dict_copy      :%p      %@ ",dict_copy,dict_copy);
    NSLog(@"dict_mutCopy   :%p      %@ ",dict_mutCopy,dict_mutCopy);
    NSLog(@"mutDict_copy   :%p      %@ ",mutDict_copy,mutDict_copy);
    NSLog(@"mutDict_mutCopy:%p      %@ ",mutDict_mutCopy,mutDict_mutCopy);
    
    NSLog(@"dict_copy       :%@     是否可变: %@",dict_copy.class,[dict_copy.class isSubclassOfClass:NSClassFromString(@"__NSDictionaryM")] ? @"YES" : @"NO");
    NSLog(@"dict_mutCopy    :%@     是否可变: %@",dict_mutCopy.class,[dict_mutCopy.class isSubclassOfClass:NSClassFromString(@"__NSDictionaryM")] ? @"YES" : @"NO");
    NSLog(@"mutDict_copy    :%@     是否可变: %@",mutDict_copy.class,[mutDict_copy.class isSubclassOfClass:NSClassFromString(@"__NSDictionaryM")] ? @"YES" : @"NO");
    NSLog(@"mutDict_mutCopy :%@     是否可变: %@",mutDict_mutCopy.class,[mutDict_mutCopy.class isSubclassOfClass:NSClassFromString(@"__NSDictionaryM")] ? @"YES" : @"NO");
    
    
    /**<
     [控制台打印] dict           :0x60000003aca0      {
     key = 1;
     }
     [控制台打印] mutDict        :0x60000005f410      {
     key = 1;
     }
     [控制台打印] dict_copy      :0x60000003aca0      {
     key = 1;
     }
     [控制台打印] dict_mutCopy   :0x60000005f770      {
     key = 1;
     }
     [控制台打印] mutDict_copy   :0x60000007a580      {
     key = 1;
     }
     [控制台打印] mutDict_mutCopy:0x60000005fd10      {
     key = 1;
     }
     [控制台打印] dict_copy       :__NSSingleEntryDictionaryI     是否可变: NO
     [控制台打印] dict_mutCopy    :__NSDictionaryM     是否可变: YES
     [控制台打印] mutDict_copy    :__NSDictionaryI     是否可变: NO
     [控制台打印] mutDict_mutCopy :__NSDictionaryM     是否可变: YES
     */
    
    
    
    
    dict = @{@"Key":@"Value"};
    self.dict_copy = dict;
    self.dict_strong = dict;
    NSLog(@"dict             : %p   %@    %@",dict,dict,dict.class);
    NSLog(@"self.dict_copy   : %p   %@",self.dict_copy,self.dict_copy);
    NSLog(@"self.dict_strong : %p   %@",self.dict_strong,self.dict_strong);
    NSLog(@"self.dict_copy   : %@   是否可变: %@",self.dict_copy.class,self.dict_copy == [self.dict_copy copy] ? @"NO" : @"YES");
    NSLog(@"self.dict_strong : %@   是否可变: %@",self.dict_strong.class,self.dict_strong == [self.dict_strong copy] ? @"NO" : @"YES");
    
    /**<  
     [控制台打印] dict             : 0x608000036aa0   {
     Key = Value;
     }    __NSSingleEntryDictionaryI
     [控制台打印] self.dict_copy   : 0x608000036aa0   {
     Key = Value;
     }
     [控制台打印] self.dict_strong : 0x608000036aa0   {
     Key = Value;
     }
     [控制台打印] self.dict_copy   : __NSSingleEntryDictionaryI   是否可变: NO
     [控制台打印] self.dict_strong : __NSSingleEntryDictionaryI   是否可变: NO
     */
    
    
    
    mutDict = [NSMutableDictionary dictionaryWithDictionary:@{@"Key":@"Value"}];
    self.dict_copy = mutDict;
    self.dict_strong = mutDict;
    NSLog(@"mutDict          : %p   %@    %@",mutDict,mutDict,mutDict.class);
    NSLog(@"self.dict_copy   : %p   %@",self.dict_copy,self.dict_copy);
    NSLog(@"self.dict_strong : %p   %@",self.dict_strong,self.dict_strong);
    NSLog(@"self.dict_copy   : %@   是否可变: %@",self.dict_copy.class,self.dict_copy == [self.dict_copy copy] ? @"NO" : @"YES");
    NSLog(@"self.dict_strong : %@   是否可变: %@",self.dict_strong.class,self.dict_strong == [self.dict_strong copy] ? @"NO" : @"YES");
    
    
    /**<  
     [控制台打印] mutDict          : 0x60000004f8d0   {
     Key = Value;
     }    __NSDictionaryM
     [控制台打印] self.dict_copy   : 0x600000075bc0   {
     Key = Value;
     }
     [控制台打印] self.dict_strong : 0x60000004f8d0   {
     Key = Value;
     }
     [控制台打印] self.dict_copy   : __NSDictionaryI   是否可变: NO
     [控制台打印] self.dict_strong : __NSDictionaryM   是否可变: YES
     */
    
    
    
    void (^globalBlock)(void) = ^(){
        NSLog(@".");
    };
    NSLog(@"globalBlock               : %@",globalBlock);
    NSLog(@"[globalBlock copy]        : %@",[globalBlock copy]);
    //    NSLog(@"[globalBlock mutableCopy] : %@",[globalBlock mutableCopy]);
    
    
    /**<
     [控制台打印] globalBlock               : <__NSGlobalBlock__: 0x104e50100>
     [控制台打印] [globalBlock copy]        : <__NSGlobalBlock__: 0x104e50100>
     [控制台打印] -[__NSGlobalBlock__ mutableCopyWithZone:]: unrecognized selector sent to instance 0x104e50100
     */
    
    
    UIView * testView = [[UIView alloc] initWithFrame:CGRectMake(100, 400, 50, 50)];
    testView.backgroundColor = [UIColor orangeColor];
    JKLogRetainCount(@"", testView);
    __weak void(^stackBlock)() = ^(){
        testView.backgroundColor = [UIColor redColor];
    };
    JKLogRetainCount(@"", testView);
    void (^tempMallocBlock)() = [stackBlock copy];
    JKLogRetainCount(@"", testView);
    void (^tempMallocBlock_copy)() = [tempMallocBlock copy];
    JKLogRetainCount(@"", testView);
    
    
    /// tempMallocBlock  ==  [tempMallocBlock copy]
    /// 但是外部变量的引用计数不会再增加
    
    NSLog(@"stackBlock               : %@",stackBlock);
    NSLog(@"[stackBlock copy]        : %@",tempMallocBlock);
    NSLog(@"[[stackBlock copy] copy] : %@",tempMallocBlock_copy);
    
    
    
    /// 这里只能释放指针，栈区stackBlock实则由系统释放，直到stackBlock被系统释放才会解除对外部变量的强引用
//    stackBlock = nil;
//    JKLogRetainCount(@"", testView);
//    NSLog(@"%@",tempMallocBlock);
//    tempMallocBlock = nil;
//    JKLogRetainCount(@"", testView);
//    NSLog(@"%@",tempMallocBlock_copy);
//    tempMallocBlock_copy = nil;
//    JKLogRetainCount(@"", testView);
    
    
    /**<
     [控制台打印] stackBlock               : <__NSStackBlock__: 0x7fff5442e9c0>
     [控制台打印] [stackBlock copy]        : <__NSMallocBlock__: 0x61800005b060>
     [控制台打印] [[stackBlock copy] copy] : <__NSMallocBlock__: 0x61800005b060>
     */
    
    
    testView = [[UIView alloc] initWithFrame:CGRectMake(100, 400, 50, 50)];
    testView.backgroundColor = [UIColor orangeColor];
    JKLogRetainCount(@"alloc testView",testView);
    
    [self.view addSubview:testView];
    JKLogRetainCount(@"add   testView",testView);
    
    /// copy类型的block属性对象，__NSMallocBlock__，只会强引用外部变量2次，因为ARC会自动copy stackBlock
    self.copyBlock = ^(){
        testView.backgroundColor = [UIColor blueColor];
        JKLogRetainCount(@"self.copyBlock内部testView", testView);
    };
    NSLog(@"self.copyBlock : %@",self.copyBlock);
    self.copyBlock();
    JKLogRetainCount(@"self.copyBlock外部testView", testView);
    
    
    
    /**<
     [控制台打印] alloc testView  RetainCount = 1
     [控制台打印] add   testView  RetainCount = 2
     [控制台打印] self.copyBlock : <__NSMallocBlock__: 0x6180000594a0>
     [控制台打印] self.copyBlock内部testView  RetainCount = 4
     [控制台打印] self.copyBlock外部testView  RetainCount = 4
     */
    
    
    
    testView = [[UIView alloc] initWithFrame:CGRectMake(100, 400, 50, 50)];
    testView.backgroundColor = [UIColor orangeColor];
    JKLogRetainCount(@"alloc testView",testView);
    
    [self.view addSubview:testView];
    JKLogRetainCount(@"add   testView",testView);
    
    
    /// strong类型的block属性对象，__NSMallocBlock__，只会强引用外部变量2次，因为ARC会自动copy stackBlock
    
    self.strongBlock = ^(){
        testView.backgroundColor = [UIColor blueColor];
        JKLogRetainCount(@"self.strongBlock内部testView", testView);
    };
    NSLog(@"self.strongBlock : %@",self.strongBlock);
    self.strongBlock();
    JKLogRetainCount(@"self.strongBlock外部testView", testView);
    
    
    
    /// ARC模式下block属性，用copy和strong的效果一样
    
    /**<
     [控制台打印] alloc testView  RetainCount = 1
     [控制台打印] add   testView  RetainCount = 2
     [控制台打印] self.strongBlock : <__NSMallocBlock__: 0x608000241800>
     [控制台打印] self.strongBlock内部testView  RetainCount = 4
     [控制台打印] self.strongBlock外部testView  RetainCount = 4
     */
    
    
    /**<  
     
     判断字符串、数组、字典是否可变：  str == [str copy]
     
     */
    
    
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.copyBlock();
    self.strongBlock();
    NSLog(@"self.copyBlock   :%@",self.copyBlock);
    NSLog(@"self.strongBlock :%@",self.strongBlock);
    
    
    /**<  
     [控制台打印] self.copyBlock   内部testView  RetainCount = 3
     [控制台打印] self.strongBlock 内部testView  RetainCount = 3
     [控制台打印] self.copyBlock   :<__NSMallocBlock__: 0x6180000594a0>
     [控制台打印] self.strongBlock :<__NSMallocBlock__: 0x608000241800>
     */
    
    
    /// 拷贝：等效于对被拷贝对象进行retain。
    /// 浅拷贝：是对容器的拷贝，深拷贝：对容器内元素的拷贝。
    /// 无论是copy还是mutableCopy，都会指向原数组里面的对象元素，不会产生新的对象元素。
    /// 浅拷贝不会增加数组内对象元素的引用计数，深拷贝会产生新的数组对象，并指向数组里面的对象元素，会增加数组里面对象元素的引用计数。
    
    JKObj * obj1 = [JKObj new];
    JKObj * obj2 = [JKObj new];
    JKObj * obj3 = [JKObj new];
    NSArray * array = @[obj1,obj2,obj3];
    JKLogRetainCount(@"", obj1);
    NSArray * array_copy = array.copy;
    JKLogRetainCount(@"", obj1);
    NSMutableArray * array_mutCopy = array.mutableCopy;
    JKLogRetainCount(@"", obj1);
    NSLog(@"%p      %@",array,array);
    NSLog(@"%p      %@",array_copy,array_copy);
    NSLog(@"%p      %@",array_mutCopy,array_mutCopy);
    
    NSArray * mutArr_copy = array_mutCopy.copy;
    JKLogRetainCount(@"", obj1);
    NSMutableArray * mutArr_mutCopy = array_mutCopy.mutableCopy;
    JKLogRetainCount(@"", obj1);
    NSLog(@"%p      %@",mutArr_copy,mutArr_copy);
    NSLog(@"%p      %@",mutArr_mutCopy,mutArr_mutCopy);
    JKLogRetainCount(@"", obj1);
    
    JKLogRetainCount(@"", array);
    JKLogRetainCount(@"", array_copy);
    JKLogRetainCount(@"", array_mutCopy);
    JKLogRetainCount(@"", mutArr_copy);
    JKLogRetainCount(@"", mutArr_mutCopy);
    
    
    NSLog(@".\n.");
    
    obj1 = [JKObj new];
    obj2 = [JKObj new];
    obj3 = [JKObj new];
    NSDictionary * dict = @{@"obj1":obj1,@"obj2":obj2,@"obj3":obj3};
    JKLogRetainCount(@"", obj1);
    NSDictionary * dict_copy = dict.copy;
    JKLogRetainCount(@"", obj1);
    NSMutableDictionary * dict_mutCopy = dict.mutableCopy;
    JKLogRetainCount(@"", obj1);
    
    NSLog(@"%p    %@",dict,dict);
    NSLog(@"%p    %@",dict_copy,dict_copy);
    NSLog(@"%p    %@",dict_mutCopy,dict_mutCopy);
    
    
    NSDictionary * mutDict_copy = dict_mutCopy.copy;
    JKLogRetainCount(@"", obj1);
    NSMutableDictionary * mutDict_mutCopy = dict_mutCopy.mutableCopy;
    JKLogRetainCount(@"", obj1);
    NSLog(@"%p    %@",mutDict_copy,mutDict_copy);
    NSLog(@"%p    %@",mutDict_mutCopy,mutDict_mutCopy);
    
    
    JKLogRetainCount(@"", dict);
    JKLogRetainCount(@"", dict_copy);
    JKLogRetainCount(@"", dict_mutCopy);
    JKLogRetainCount(@"", mutDict_copy);
    JKLogRetainCount(@"", mutDict_mutCopy);
    
    
    
    
    /**<  
     2017-01-15 11:15:44.323 CopyAndMutableCopy[16370:6995568]   RetainCount = 2
     2017-01-15 11:15:44.323 CopyAndMutableCopy[16370:6995568]   RetainCount = 2
     2017-01-15 11:15:44.323 CopyAndMutableCopy[16370:6995568]   RetainCount = 3
     2017-01-15 11:15:44.323 CopyAndMutableCopy[16370:6995568] 0x6180000427c0      (
     "<JKObj: 0x618000008e80>",
     "<JKObj: 0x618000008e90>",
     "<JKObj: 0x618000008ea0>"
     )
     2017-01-15 11:15:44.323 CopyAndMutableCopy[16370:6995568] 0x6180000427c0      (
     "<JKObj: 0x618000008e80>",
     "<JKObj: 0x618000008e90>",
     "<JKObj: 0x618000008ea0>"
     )
     2017-01-15 11:15:44.324 CopyAndMutableCopy[16370:6995568] 0x6080000453a0      (
     "<JKObj: 0x618000008e80>",
     "<JKObj: 0x618000008e90>",
     "<JKObj: 0x618000008ea0>"
     )
     2017-01-15 11:15:44.369 CopyAndMutableCopy[16370:6995568]   RetainCount = 4
     2017-01-15 11:15:44.370 CopyAndMutableCopy[16370:6995568]   RetainCount = 5
     2017-01-15 11:15:44.370 CopyAndMutableCopy[16370:6995568] 0x600000049ba0      (
     "<JKObj: 0x618000008e80>",
     "<JKObj: 0x618000008e90>",
     "<JKObj: 0x618000008ea0>"
     )
     2017-01-15 11:15:44.370 CopyAndMutableCopy[16370:6995568] 0x61000024ea30      (
     "<JKObj: 0x618000008e80>",
     "<JKObj: 0x618000008e90>",
     "<JKObj: 0x618000008ea0>"
     )
     2017-01-15 11:15:44.370 CopyAndMutableCopy[16370:6995568]   RetainCount = 5
     2017-01-15 11:15:44.370 CopyAndMutableCopy[16370:6995568]   RetainCount = 2
     2017-01-15 11:15:44.371 CopyAndMutableCopy[16370:6995568]   RetainCount = 2
     2017-01-15 11:15:44.371 CopyAndMutableCopy[16370:6995568]   RetainCount = 1
     2017-01-15 11:15:44.371 CopyAndMutableCopy[16370:6995568]   RetainCount = 1
     2017-01-15 11:15:44.371 CopyAndMutableCopy[16370:6995568]   RetainCount = 1
     2017-01-15 11:15:44.371 CopyAndMutableCopy[16370:6995568] .
     .
     2017-01-15 11:15:44.371 CopyAndMutableCopy[16370:6995568]   RetainCount = 2
     2017-01-15 11:15:44.372 CopyAndMutableCopy[16370:6995568]   RetainCount = 2
     2017-01-15 11:15:44.372 CopyAndMutableCopy[16370:6995568]   RetainCount = 3
     2017-01-15 11:15:44.372 CopyAndMutableCopy[16370:6995568] 0x610000077b00    {
     obj1 = "<JKObj: 0x6100000090b0>";
     obj2 = "<JKObj: 0x6100000090f0>";
     obj3 = "<JKObj: 0x6100000090d0>";
     }
     2017-01-15 11:15:44.372 CopyAndMutableCopy[16370:6995568] 0x610000077b00    {
     obj1 = "<JKObj: 0x6100000090b0>";
     obj2 = "<JKObj: 0x6100000090f0>";
     obj3 = "<JKObj: 0x6100000090d0>";
     }
     2017-01-15 11:15:44.372 CopyAndMutableCopy[16370:6995568] 0x618000044920    {
     obj1 = "<JKObj: 0x6100000090b0>";
     obj2 = "<JKObj: 0x6100000090f0>";
     obj3 = "<JKObj: 0x6100000090d0>";
     }
     2017-01-15 11:15:44.372 CopyAndMutableCopy[16370:6995568]   RetainCount = 4
     2017-01-15 11:15:44.373 CopyAndMutableCopy[16370:6995568]   RetainCount = 5
     2017-01-15 11:15:44.373 CopyAndMutableCopy[16370:6995568] 0x608000067a00    {
     obj1 = "<JKObj: 0x6100000090b0>";
     obj2 = "<JKObj: 0x6100000090f0>";
     obj3 = "<JKObj: 0x6100000090d0>";
     }
     2017-01-15 11:15:44.373 CopyAndMutableCopy[16370:6995568] 0x608000044ad0    {
     obj1 = "<JKObj: 0x6100000090b0>";
     obj2 = "<JKObj: 0x6100000090f0>";
     obj3 = "<JKObj: 0x6100000090d0>";
     }
     2017-01-15 11:15:44.373 CopyAndMutableCopy[16370:6995568]   RetainCount = 2
     2017-01-15 11:15:44.373 CopyAndMutableCopy[16370:6995568]   RetainCount = 2
     2017-01-15 11:15:44.374 CopyAndMutableCopy[16370:6995568]   RetainCount = 1
     2017-01-15 11:15:44.374 CopyAndMutableCopy[16370:6995568]   RetainCount = 1
     2017-01-15 11:15:44.374 CopyAndMutableCopy[16370:6995568]   RetainCount = 1

     
     */
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
