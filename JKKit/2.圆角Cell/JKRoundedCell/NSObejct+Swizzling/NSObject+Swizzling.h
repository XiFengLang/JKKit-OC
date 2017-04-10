//
//  NSObject+Swizzling.h
//  JKMethodSwizzling
//
//  Created by 蒋鹏 on 17/1/3.
//  Copyright © 2017年 溪枫狼. All rights reserved.
//
//  Runtime Method Swizzling 使用小结   简书[http://www.jianshu.com/p/437fd9d399a3]
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSObject (Swizzling)


/**
 【JK-Method Swizzling-慎用】用于替换同一类的2个[实例]方法。建议放在+(void)load方法使用

 @param originalSEL 被替换的SEL
 @param objectSEL   用于替换的自定义SEL
 @param objectClass 进行用于替换的自定义SEL的Class
 */
void JK_ExchangeInstanceMethod(SEL originalSEL, SEL objectSEL, Class objectClass);



/**
 【JK-Method Swizzling-慎用】用于替换同一类的2个[类]方法。建议放在+(void)load方法使用
 
 @param originalSEL 被替换的SEL
 @param objectSEL   用于替换的自定义SEL
 @param objectClass 进行用于替换的自定义SEL的Class
 */
void JK_ExchangeClassMethod(SEL originalSEL, SEL objectSEL, Class objectClass);


@end




/**
 实时打印即将显示的界面，方便调试
 */
@interface UIViewController (Swizzling)
@end



/**
 优先无缓存加载,imageWithContentsOfFile
 */
@interface UIImage (Swizzling)
@end



/**
 打印字典时，支持打印中文
 */
@interface NSDictionary (Swizzling)
@end



/**
 打印数组时，支持打印中文[暂时关闭，按需打开]
 */
@interface NSArray (Swizzling)
@end



/**
 处理数组越界【慎用】
 */
@interface NSArray (SafeSwizzling)
@end


/**
 处理数组越界、插入nil【慎用】
 */
@interface NSMutableArray (SafeSwizzling)
@end


/**
 处理插入nil【慎用】
 */
@interface NSMutableDictionary (SafeSwizzling)
@end









