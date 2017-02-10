//
//  JKPackageNavigationController.h
//  TransparentNavgationBar
//
//  Created by 蒋鹏 on 17/2/5.
//  Copyright © 2017年 XiFengLang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JKPackageNavigationController : UINavigationController



/**
 取所有的普通子控制器，JKPackageNavigationController.viewControllers则会取出所有的外壳(容器)控制器JKInterLayerViewController
 
 */
@property (nonatomic, strong, readonly) NSArray <UIViewController *> * jk_viewControllers;


@end
