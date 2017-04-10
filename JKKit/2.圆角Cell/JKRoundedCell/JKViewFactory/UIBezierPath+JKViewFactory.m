//
//  UIBezierPath+JKViewFactory.m
//  JKViewFactory
//
//  Created by 蒋鹏 on 16/12/16.
//  Copyright © 2016年 溪枫狼. All rights reserved.
//

#import "UIBezierPath+JKViewFactory.h"

@implementation UIBezierPath (JKViewFactory)


+ (UIBezierPath *)jk_boundedPathWithSize:(CGSize)size
                             borderWidth:(CGFloat)borderWidth
                            cornerRadius:(CGFloat)cornerRadius{
    return [self jk_pathWithSize:size
                     borderWidth:borderWidth
             leftTopCornerRadius:cornerRadius
            rightTopCornerRadius:cornerRadius
         rightBottomCornerRadius:cornerRadius
          leftBottomCornerRadius:cornerRadius];
}


+ (UIBezierPath *)jk_borderlessPathWithSize:(CGSize)size
                               cornerRadius:(CGFloat)cornerRadius{
    return [self jk_pathWithSize:size
                     borderWidth:0
             leftTopCornerRadius:cornerRadius
            rightTopCornerRadius:cornerRadius
         rightBottomCornerRadius:cornerRadius
          leftBottomCornerRadius:cornerRadius];
}


+ (UIBezierPath *)jk_pathWithSize:(CGSize)size
                      borderWidth:(CGFloat)borderWidth
              leftTopCornerRadius:(CGFloat)leftTopCornerRadius
             rightTopCornerRadius:(CGFloat)rightTopCornerRadius
          rightBottomCornerRadius:(CGFloat)rightBottomCornerRadius
           leftBottomCornerRadius:(CGFloat)leftBottomCornerRadius{
    
    return [self jk_pathWithOriginY:0
                               size:size
                        borderWidth:borderWidth
                leftTopCornerRadius:leftTopCornerRadius
               rightTopCornerRadius:rightTopCornerRadius
            rightBottomCornerRadius:rightBottomCornerRadius
             leftBottomCornerRadius:leftBottomCornerRadius];
}



+ (UIBezierPath *)jk_pathWithOriginY:(CGFloat)originY
                                size:(CGSize)size
                         borderWidth:(CGFloat)borderWidth
                 leftTopCornerRadius:(CGFloat)leftTopCornerRadius
                rightTopCornerRadius:(CGFloat)rightTopCornerRadius
             rightBottomCornerRadius:(CGFloat)rightBottomCornerRadius
              leftBottomCornerRadius:(CGFloat)leftBottomCornerRadius{
    
    /// 2个同边的圆角半径的（和）再加上边框宽度 如果大于那条边的宽/高，则需要对圆角半径进行相应的缩减
    CGFloat top = size.width - leftTopCornerRadius - rightTopCornerRadius - borderWidth;
    if (top < 0) {
        leftTopCornerRadius -= borderWidth * (leftTopCornerRadius / size.width);
        rightTopCornerRadius -= borderWidth * (rightTopCornerRadius / size.width);
    }
    
    CGFloat right = size.height - rightTopCornerRadius - rightBottomCornerRadius - borderWidth;
    if (right < 0) {
        rightTopCornerRadius -= borderWidth * (rightTopCornerRadius / size.height);
        rightBottomCornerRadius -= borderWidth * (rightBottomCornerRadius / size.height);
    }
    
    CGFloat bottom = size.width - rightBottomCornerRadius - leftBottomCornerRadius - borderWidth;
    if (bottom < 0) {
        rightBottomCornerRadius -= borderWidth * (rightBottomCornerRadius / size.width);
        leftBottomCornerRadius -= borderWidth * (leftBottomCornerRadius / size.width);
    }
    
    CGFloat left = size.height - leftBottomCornerRadius - leftTopCornerRadius - borderWidth;
    if (left < 0) {
        leftBottomCornerRadius -= borderWidth * (leftBottomCornerRadius / size.height);
        leftTopCornerRadius -= borderWidth * (leftTopCornerRadius / size.height);
    }
    
    /// 左上角开始
    CGPoint point00 = CGPointMake(originY + leftTopCornerRadius + borderWidth / 2.0, borderWidth / 2.0);
    CGPoint point01 = CGPointMake(originY + size.width - rightTopCornerRadius - borderWidth / 2.0, borderWidth / 2.0);
    
    CGPoint center1 = CGPointMake(originY + size.width - rightTopCornerRadius - borderWidth / 2.0, rightTopCornerRadius + borderWidth / 2.0);
    CGPoint point10 = CGPointMake(originY + size.width - borderWidth / 2.0, size.height - rightBottomCornerRadius - borderWidth / 2.0);
    
    CGPoint center2 = CGPointMake(originY + size.width - rightBottomCornerRadius - borderWidth / 2.0, size.height - rightBottomCornerRadius - borderWidth / 2.0);
    
    CGPoint point20 = CGPointMake(originY + leftBottomCornerRadius + borderWidth / 2.0, size.height - borderWidth / 2.0);
    
    CGPoint center3 = CGPointMake(originY + leftBottomCornerRadius + borderWidth / 2.0, size.height - leftBottomCornerRadius - borderWidth / 2.0);
    CGPoint point30 = CGPointMake(originY + borderWidth / 2.0, leftTopCornerRadius + borderWidth / 2.0);
    
    CGPoint center0 = CGPointMake(originY + leftTopCornerRadius + borderWidth / 2.0, leftTopCornerRadius + borderWidth / 2.0);
    
    UIBezierPath *bPath = [UIBezierPath bezierPath];
    bPath.lineWidth = borderWidth;
    [bPath moveToPoint:point00];
    [bPath addLineToPoint:point01];
    
    if (rightTopCornerRadius) {
        [bPath addArcWithCenter:center1
                         radius:rightTopCornerRadius
                     startAngle:M_PI_2 * 3
                       endAngle:M_PI_2 * 4
                      clockwise:YES];
    }
    [bPath addLineToPoint:point10];
    
    if (rightBottomCornerRadius) {
        [bPath addArcWithCenter:center2
                         radius:rightBottomCornerRadius
                     startAngle:0
                       endAngle:M_PI_2
                      clockwise:YES];
    }
    [bPath addLineToPoint:point20];
    
    if (leftBottomCornerRadius) {
        [bPath addArcWithCenter:center3
                         radius:leftBottomCornerRadius
                     startAngle:M_PI_2
                       endAngle:M_PI
                      clockwise:YES];
    }
    [bPath addLineToPoint:point30];
    
    if (leftTopCornerRadius) {
        [bPath addArcWithCenter:center0
                         radius:leftTopCornerRadius
                     startAngle:M_PI
                       endAngle:M_PI_2 * 3
                      clockwise:YES];
    }
    [bPath closePath];
    return bPath;
}


@end
