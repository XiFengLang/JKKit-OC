//
//  UIColor+JKViewFactory.h
//  JKViewFactory
//
//  Created by 蒋鹏 on 16/12/16.
//  Copyright © 2016年 溪枫狼. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 UIColor缓存池（NSCache单例）

 @return NSCache
 */
static inline NSCache * JK_ColorCahcePool() {
    static NSCache * cache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache = [[NSCache alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidReceiveMemoryWarningNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
            [cache removeAllObjects];
        }];
    });
    return cache;
}


static inline UIColor * JKWhiteColor(){
    return [UIColor whiteColor];
}

static inline UIColor * JKClearColor(){
    return [UIColor clearColor];
}

static inline UIColor * JKBlackColor(){
    return [UIColor blackColor];
}

static inline UIColor * JKRedColor(){
    return [UIColor redColor];
}

static inline UIColor * JKColorWithRGBA(NSUInteger R,NSUInteger G,NSUInteger B, CGFloat A){
    return [UIColor colorWithRed:R / 255.0 green:G/ 255.0  blue:B / 255.0 alpha:A];
}


/**
 此函数会将UIColor对象存入缓存中，优先从缓存中获取颜色

 @param R R
 @param G G
 @param B B
 @return 优先返回缓存的UIColor
 */
static inline UIColor * JKColorWithRGB(NSUInteger R,NSUInteger G,NSUInteger B){
    NSString * key = [NSString stringWithFormat:@"%zd*%zd*%zd",R,G,B];
    UIColor * color = [JK_ColorCahcePool() objectForKey:key];
    if (nil == color) {
        color = JKColorWithRGBA(R, G, B, 1.0f);
        [JK_ColorCahcePool() setObject:color forKey:key];
    }
    return color;
}


/**
 底线颜色

 @return color
 */
static inline UIColor * JKLineColor(){
    return JKColorWithRGB(209, 200, 209);
}


/**
 16进制颜色 0xffffff

 @param HEXValue 十六进制值
 @return 16进制颜色
 */
static inline UIColor * JKHEXColor(NSUInteger HEXValue) {
    return JKColorWithRGB((HEXValue & 0xFF0000) >> 16,
                          (HEXValue & 0xFF00) >> 8,
                          HEXValue & 0xFF);
}



@interface UIColor (JKViewFactory)


/**
 【JK-UIColor】根据16进制字符串创建RGB Color

 @param hexStr 16进制字符串
 @return RGB Color
 */
+ (UIColor *)jk_colorWithHEXString:(NSString *)hexStr;

@end
