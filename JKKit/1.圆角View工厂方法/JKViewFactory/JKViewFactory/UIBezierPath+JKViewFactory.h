//
//  UIBezierPath+JKViewFactory.h
//  JKViewFactory
//
//  Created by 蒋鹏 on 16/12/16.
//  Copyright © 2016年 溪枫狼. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBezierPath (JKViewFactory)


/**
 【JK-BezierPath】创建‘带边框’的‘圆角’贝塞尔曲线
 
 @param size size
 @param cornerRadius 圆角半径
 @param borderWidth 边框宽度
 @return 圆角【带边框】的贝塞尔曲线
 */
+ (UIBezierPath *)jk_boundedPathWithSize:(CGSize)size
                             borderWidth:(CGFloat)borderWidth
                            cornerRadius:(CGFloat)cornerRadius;


/**
 【JK-BezierPath】创建‘无边框’的‘圆角’贝塞尔曲线
 
 @param size size
 @param cornerRadius 圆角半径
 @return 圆角【无边框】的贝塞尔取消
 */
+ (UIBezierPath *)jk_borderlessPathWithSize:(CGSize)size
                               cornerRadius:(CGFloat)cornerRadius;



/**
 【JK-BezierPath】贝塞尔曲线工厂方法，支持椭圆、长方形、圆角直角混合图形的贝塞尔曲线，并且兼容边框效果。（圆角半径和边框宽度不要太大，稍有瑕疵）
 
 @param size 画布的大小
 @param borderWidth 边框宽度
 @param leftTopCornerRadius 左上圆角半径
 @param rightTopCornerRadius 右上圆角半径
 @param rightBottomCornerRadius 右下圆角半径
 @param leftBottomCornerRadius 右下圆角半径
 @return 贝塞尔曲线
 */
+ (UIBezierPath *)jk_pathWithSize:(CGSize)size
                      borderWidth:(CGFloat)borderWidth
              leftTopCornerRadius:(CGFloat)leftTopCornerRadius
             rightTopCornerRadius:(CGFloat)rightTopCornerRadius
          rightBottomCornerRadius:(CGFloat)rightBottomCornerRadius
           leftBottomCornerRadius:(CGFloat)leftBottomCornerRadius;



+ (UIBezierPath *)jk_pathWithOriginY:(CGFloat)originY
                                size:(CGSize)size
                         borderWidth:(CGFloat)borderWidth
                 leftTopCornerRadius:(CGFloat)leftTopCornerRadius
                rightTopCornerRadius:(CGFloat)rightTopCornerRadius
             rightBottomCornerRadius:(CGFloat)rightBottomCornerRadius
              leftBottomCornerRadius:(CGFloat)leftBottomCornerRadius;

@end
