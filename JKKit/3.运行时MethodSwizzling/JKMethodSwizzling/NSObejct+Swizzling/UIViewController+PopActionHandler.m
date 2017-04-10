//
//  UIViewController+PopActionHandler.m
//  JKMethodSwizzling
//
//  Created by 蒋鹏 on 17/1/6.
//  Copyright © 2017年 溪枫狼. All rights reserved.
//
//  Runtime Method Swizzling 使用小结   简书[http://www.jianshu.com/p/437fd9d399a3]
//

#import "UIViewController+PopActionHandler.h"
#import "NSObject+Swizzling.h"

@implementation UIViewController (PopActionHandler)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        JK_ExchangeInstanceMethod(@selector(viewDidAppear:), @selector(jk_viewDidAppear:), self);
        JK_ExchangeInstanceMethod(@selector(viewDidDisappear:), @selector(jk_viewDidDisappear:), self);
    });
}


- (void)jk_viewDidAppear:(BOOL)animated {
    [self jk_viewDidAppear:animated];
    if ([self respondsToSelector:@selector(jk_navigationControllerShouldPopOnBackButton)]) {
        /// 拦截Pop事件就关闭侧滑返回
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
}

- (void)jk_viewDidDisappear:(BOOL)animated {
    [self jk_viewDidDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}
@end



@implementation UINavigationController (PopActionHandler)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        JK_ExchangeInstanceMethod(@selector(navigationBar:shouldPopItem:), @selector(jk_navigationBar:shouldPopItem:), self);
    });
}



- (BOOL)jk_navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    if([self.viewControllers count] < [navigationBar.items count]) {
        return YES;
    }
    UIViewController* topVC = [self topViewController];
    BOOL enablePop = YES;
    if ([topVC respondsToSelector:@selector(jk_navigationControllerShouldPopOnBackButton)]) {
        enablePop = [topVC jk_navigationControllerShouldPopOnBackButton];
    }
    
    if (enablePop == YES) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self popViewControllerAnimated:YES];
        });
    }
    return NO;
}


@end
