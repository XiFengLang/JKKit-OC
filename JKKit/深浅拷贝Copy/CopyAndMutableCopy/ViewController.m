//
//  ViewController.m
//  CopyAndMutableCopy
//
//  Created by 蒋鹏 on 17/1/11.
//  Copyright © 2017年 溪枫狼. All rights reserved.
//

#import "ViewController.h"





@interface ViewController ()

@property (nonatomic, strong) NSArray * arrayA;
@property (nonatomic, strong) NSString * strA;

@property (nonatomic, copy) NSArray * arrayB;
@property (nonatomic, copy) NSString * strB;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSMutableString * str = [[NSMutableString alloc] initWithString:@"AAAA"];
    NSLog(@"str       = %@ : %p",str,str);
    self.strB = str;
    NSLog(@"self.strB = %@ : %p",self.strB,self.strB);
    str = [[NSMutableString alloc] initWithString:@"BBBB"];
    NSLog(@"str       = %@ : %p",str,str);
    NSLog(@"self.strB = %@ : %p",self.strB,self.strB);
    
    
    NSLog(@".");
    NSLog(@"self.strB : %@  是否继承NSMutableString: %@",self.strB.class,self.strB == [self.strB copy] ? @"YES" : @"NO");
    NSLog(@"str       : %@  是否继承NSMutableString: %@",str.class,str == [str copy] ? @"YES" : @"NO");
    NSLog(@".");
    
    
    
    
    
    self.strA = str;
    NSLog(@"str       = %@ : %p",str,str);
    NSLog(@"self.strB = %@ : %p",self.strA,self.strA);
    str = [[NSMutableString alloc] initWithString:@"CCCC"];
    NSLog(@"str       = %@ : %p",str,str);
    
    NSLog(@".");
    NSLog(@"self.strA : %@  是否继承NSMutableString: %@",self.strA.class,self.strA == [self.strA copy] ? @"YES" : @"NO");
    NSLog(@"str       : %@  是否继承NSMutableString: %@",str.class,str == [str copy] ? @"YES" : @"NO");
    NSLog(@".");
    
    
    /**<  
     [控制台打印] str       = AAAA : 0x6100002750c0
     [控制台打印] self.strB = AAAA : 0xa000000414141414
     [控制台打印] str       = BBBB : 0x61800026d7c0
     [控制台打印] self.strB = AAAA : 0xa000000414141414
     [控制台打印] .
     [控制台打印] self.strB : NSTaggedPointerString  是否继承NSMutableString: NO
     [控制台打印] str       : __NSCFString  是否继承NSMutableString: YES
     [控制台打印] .
     [控制台打印] str       = BBBB : 0x61800026d7c0
     [控制台打印] self.strB = BBBB : 0x61800026d7c0
     [控制台打印] str       = CCCC : 0x61800026d700
     [控制台打印] .
     [控制台打印] self.strA = BBBB : 0x61800026d7c0
     [控制台打印] self.strA : __NSCFString  是否继承NSMutableString: YES
     [控制台打印] str       : __NSCFString  是否继承NSMutableString: YES
     */
    
    
    NSString * strTemp = @"KKKK";
    NSString * str_copy = [strTemp copy];
    NSMutableString * mut_copy = [strTemp mutableCopy];
    
    NSLog(@"strTemp    : %p",strTemp);
    NSLog(@"str_copy   : %p",str_copy);
    NSLog(@"mut_copy   : %p",mut_copy);
    
    NSLog(@"str_copy   : %@  是否继承NSMutableString: %@",str_copy.class,str_copy == [str_copy copy] ? @"YES" : @"NO");
    NSLog(@"mut_copy   : %@  是否继承NSMutableString: %@",mut_copy.class,mut_copy == [mut_copy copy] ? @"YES" : @"NO");
    NSLog(@".");
    
    NSMutableString * mutStr = [NSMutableString stringWithString:@"HHHH"];
    str_copy = [mutStr copy];
    mut_copy = [mutStr mutableCopy];
    NSLog(@"mutStr     : %p",mutStr);
    NSLog(@"str_copy   : %p",str_copy);
    NSLog(@"mut_copy   : %p",mut_copy);
    
    
    NSLog(@"str_copy   : %@  是否继承NSMutableString: %@",str_copy.class,str_copy == [str_copy copy] ? @"YES" : @"NO");
    NSLog(@"mut_copy   : %@  是否继承NSMutableString: %@",mut_copy.class,mut_copy == [mut_copy copy] ? @"YES" : @"NO");
    NSLog(@".");
    
    
    /**<  
     [控制台打印] strTemp    : 0x101b2d1d8
     [控制台打印] str_copy   : 0x101b2d1d8
     [控制台打印] mut_copy   : 0x60000007adc0
     [控制台打印] str_copy   : __NSCFConstantString  是否继承NSMutableString: YES
     [控制台打印] mut_copy   : __NSCFString  是否继承NSMutableString: NO
     [控制台打印] .
     [控制台打印] mutStr     : 0x608000077cc0
     [控制台打印] str_copy   : 0xa000000484848484
     [控制台打印] mut_copy   : 0x608000077d00
     [控制台打印] str_copy   : NSTaggedPointerString  是否继承NSMutableString: YES
     [控制台打印] mut_copy   : __NSCFString  是否继承NSMutableString: NO
     */
    
    
    
    void (^globalBlock)(void) = ^(){
        NSLog(@"");
    };
    NSLog(@"globalBlock: %@",globalBlock);
    NSLog(@"[globalBlock copy]:  %@",[globalBlock copy]);
//    NSLog(@"[globalBlock mutableCopy]:  %@",[globalBlock mutableCopy]);
    
    
    /**<  
     [控制台打印] globalBlock: <__NSGlobalBlock__: 0x103f570e0>
     [控制台打印] [globalBlock copy]:  <__NSGlobalBlock__: 0x103f570e0>
     [控制台打印] -[__NSGlobalBlock__ mutableCopyWithZone:]: unrecognized selector sent to instance 0x103f570e0
     */
    
    
    __weak void(^stackBlock)() = ^(){
        self.view.backgroundColor = [UIColor redColor];
    };
    NSLog(@"stackBlock: %@",stackBlock);
    NSLog(@"[stackBlock copy]:  %@",[stackBlock copy]);
    NSLog(@"[[stackBlock copy] copy]:  %@",[[stackBlock copy] copy]);
    
    /**<  
     [控制台打印] stackBlock: <__NSStackBlock__: 0x7fff583ea9a0>
     [控制台打印] [stackBlock copy]:  <__NSMallocBlock__: 0x61000005a790>
     [控制台打印] [[stackBlock copy] copy]:  <__NSMallocBlock__: 0x61000005a790>
     */
    
    
    

    NSMutableArray * mutArray = [NSMutableArray arrayWithArray:@[@"1"]];
    
    self.arrayA = mutArray;
    self.arrayB = mutArray;
    [mutArray addObject:@"2"];
    
    
    NSLog(@"mutArray   :%p  %@  %@ ",mutArray,mutArray.class,mutArray);
    NSLog(@"self.arrayA:%p    %@",self.arrayA,self.arrayA);
    NSLog(@"self.arrayB:%p    %@",self.arrayB,self.arrayB);
    NSLog(@"self.arrayA:%@  是否可变:%@",self.arrayA.class,[self.arrayA.class isSubclassOfClass:NSClassFromString(@"__NSArrayM")] ? @"YES" : @"NO");
    NSLog(@"self.arrayB:%@  是否可变:%@",self.arrayB.class,[self.arrayB.class isSubclassOfClass:NSClassFromString(@"__NSArrayM")] ? @"YES" : @"NO");
    /**<  
     [控制台打印] mutArray   :0x61800024f150  __NSArrayM  (
     1,
     2
     )
     [控制台打印] self.arrayA:0x61800024f150    (
     1,
     2
     )
     [控制台打印] self.arrayB:0x6180000063b0    (
     1
     )
     [控制台打印] self.arrayA:__NSArrayM  是否可变:YES
     [控制台打印] self.arrayB:__NSSingleObjectArrayI  是否可变:NO
     */
    
    NSArray * array = @[@"1"];
    self.arrayA = array;
    self.arrayB = array;
    NSLog(@"array   :%p  %@  %@ ",array,array.class,array);
    NSLog(@"self.arrayA:%p    %@",self.arrayA,self.arrayA);
    NSLog(@"self.arrayB:%p    %@",self.arrayB,self.arrayB);
    NSLog(@"self.arrayA:%@  是否可变:%@",self.arrayA.class,[self.arrayA.class isSubclassOfClass:NSClassFromString(@"__NSArrayM")] ? @"YES" : @"NO");
    NSLog(@"self.arrayB:%@  是否可变:%@",self.arrayB.class,[self.arrayB.class isSubclassOfClass:NSClassFromString(@"__NSArrayM")] ? @"YES" : @"NO");
    /**<  
     [控制台打印] array      :0x60000001cd20  __NSSingleObjectArrayI  (
     1
     )
     [控制台打印] self.arrayA:0x60000001cd20  __NSSingleObjectArrayI  (
     1
     )
     [控制台打印] self.arrayB:0x60000001cd20  __NSSingleObjectArrayI  (
     1
     )
     */
    
    
    
    NSArray * mutArray_copy = [mutArray copy];
    NSMutableArray * mutArray_mutCopy = [mutArray mutableCopy];
    
    NSArray * array_copy = [array copy];
    NSMutableArray * array_mutCopy = [array mutableCopy];
    NSLog(@"array_copy      :%p      %@ ",array_copy,array_copy);
    NSLog(@"array_mutCopy   :%p      %@ ",array_mutCopy,array_mutCopy);
    NSLog(@"mutArray_copy   :%p      %@ ",mutArray_copy,mutArray_copy);
    NSLog(@"mutArray_mutCopy:%p      %@ ",mutArray_mutCopy,mutArray_mutCopy);
    
    NSLog(@"array_copy       :%@  是否可变:%@",array_copy.class,[array_copy.class isSubclassOfClass:NSClassFromString(@"__NSArrayM")] ? @"YES" : @"NO");
    NSLog(@"array_mutCopy    :%@  是否可变:%@",array_mutCopy.class,[array_mutCopy.class isSubclassOfClass:NSClassFromString(@"__NSArrayM")] ? @"YES" : @"NO");
    NSLog(@"mutArray_copy    :%@  是否可变:%@",mutArray_copy.class,[mutArray_copy.class isSubclassOfClass:NSClassFromString(@"__NSArrayM")] ? @"YES" : @"NO");
    NSLog(@"mutArray_mutCopy :%@  是否可变:%@",mutArray_mutCopy.class,[mutArray_mutCopy.class isSubclassOfClass:NSClassFromString(@"__NSArrayM")] ? @"YES" : @"NO");
    
    
    /**<  
     [控制台打印] array_copy      :0x60800001af40      (
     1
     )
     [控制台打印] array_mutCopy   :0x6000002471a0      (
     1
     )
     [控制台打印] mutArray_copy   :0x600000038e60      (
     1,
     2
     )
     [控制台打印] mutArray_mutCopy:0x6000002472f0      (
     1,
     2
     )
     [控制台打印] array_copy       :__NSSingleObjectArrayI  是否可变:NO
     [控制台打印] array_mutCopy    :__NSArrayM  是否可变:YES
     [控制台打印] mutArray_copy    :__NSArrayI  是否可变:NO
     [控制台打印] mutArray_mutCopy :__NSArrayM  是否可变:YES
     */
    
    
    NSDictionary * dict = @{@"key":@"1"};
    NSMutableDictionary * mutDict = [NSMutableDictionary dictionaryWithObject:@"1" forKey:@"key"];
    
    NSDictionary * dict_copy = [dict copy];
    NSMutableDictionary * dict_mutCopy = [dict mutableCopy];
    
    NSArray * mutDict_copy = [mutDict copy];
    NSMutableArray * mutDict_mutCopy = [mutDict mutableCopy];
    
    NSLog(@"dict           :%p      %@ ",dict,dict);
    NSLog(@"mutDict        :%p      %@ ",mutDict,mutDict);
    NSLog(@"dict_copy      :%p      %@ ",dict_copy,dict_copy);
    NSLog(@"dict_mutCopy   :%p      %@ ",dict_mutCopy,dict_mutCopy);
    NSLog(@"mutDict_copy   :%p      %@ ",mutDict_copy,mutDict_copy);
    NSLog(@"mutDict_mutCopy:%p      %@ ",mutDict_mutCopy,mutDict_mutCopy);
    
    NSLog(@"dict_copy       :%@  是否可变:%@",dict_copy.class,[dict_copy.class isSubclassOfClass:NSClassFromString(@"__NSDictionaryM")] ? @"YES" : @"NO");
    NSLog(@"dict_mutCopy    :%@  是否可变:%@",dict_mutCopy.class,[dict_mutCopy.class isSubclassOfClass:NSClassFromString(@"__NSDictionaryM")] ? @"YES" : @"NO");
    NSLog(@"mutDict_copy    :%@  是否可变:%@",mutDict_copy.class,[mutDict_copy.class isSubclassOfClass:NSClassFromString(@"__NSDictionaryM")] ? @"YES" : @"NO");
    NSLog(@"mutDict_mutCopy :%@  是否可变:%@",mutDict_mutCopy.class,[mutDict_mutCopy.class isSubclassOfClass:NSClassFromString(@"__NSDictionaryM")] ? @"YES" : @"NO");
    
    
    /**<  
     [控制台打印] dict           :0x600000029bc0      {
     key = 1;
     }
     [控制台打印] mutDict        :0x600000046c90      {
     key = 1;
     }
     [控制台打印] dict_copy      :0x600000029bc0      {
     key = 1;
     }
     [控制台打印] dict_mutCopy   :0x600000046e40      {
     key = 1;
     }
     [控制台打印] mutDict_copy   :0x600000077200      {
     key = 1;
     }
     [控制台打印] mutDict_mutCopy:0x600000046cf0      {
     key = 1;
     }
     [控制台打印] dict_copy       :__NSSingleEntryDictionaryI  是否可变:NO
     [控制台打印] dict_mutCopy    :__NSDictionaryM  是否可变:YES
     [控制台打印] mutDict_copy    :__NSDictionaryI  是否可变:NO
     [控制台打印] mutDict_mutCopy :__NSDictionaryM  是否可变:YES
     */
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
