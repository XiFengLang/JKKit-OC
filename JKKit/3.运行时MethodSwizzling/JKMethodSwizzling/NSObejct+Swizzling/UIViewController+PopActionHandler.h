//
//  UIViewController+PopActionHandler.h
//  JKMethodSwizzling
//
//  Created by 蒋鹏 on 17/1/6.
//  Copyright © 2017年 溪枫狼. All rights reserved.
//
//  Runtime Method Swizzling 使用小结   简书[http://www.jianshu.com/p/437fd9d399a3]
//



#import <UIKit/UIKit.h>




/**
 需要拦截导航栏上系统自带的‘返回’按钮事件，就实现此协议方法
 */
@protocol JKViewControllerPopActionHandler <NSObject>

@optional
- (BOOL)jk_navigationControllerShouldPopOnBackButton;

@end


/**
 所有控制器都遵守JKViewControllerPopActionHandler协议
 */
@interface UIViewController (PopActionHandler)<JKViewControllerPopActionHandler>

@end



/**
 用Runtime Method Swizzling拦截@selector(navigationBar:shouldPopItem:)
 */
@interface UINavigationController (PopActionHandler)

@end
