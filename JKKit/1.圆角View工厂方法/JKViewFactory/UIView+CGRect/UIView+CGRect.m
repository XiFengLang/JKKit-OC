//
//  UIView+CGRect.m
//  JKViewFactory
//
//  Created by 蒋鹏 on 16/12/27.
//  Copyright © 2016年 溪枫狼. All rights reserved.
//

#import "UIView+CGRect.h"

@implementation UIView (CGRect)

- (void)setJk_x:(CGFloat)jk_x {
    CGRect temp = self.frame;
    temp.origin.x = jk_x;
    self.frame = temp;
}
- (CGFloat)jk_x {
    return self.frame.origin.x;
}



- (void)setJk_y:(CGFloat)jk_y {
    CGRect temp = self.frame;
    temp.origin.y = jk_y;
    self.frame = temp;
}
- (CGFloat)jk_y {
    return self.frame.origin.y;
}


- (void)setJk_width:(CGFloat)jk_width {
    CGRect temp = self.frame;
    temp.size.width = jk_width;
    self.frame = temp;
}
- (CGFloat)jk_width {
    return self.frame.size.width;
}


- (void)setJk_height:(CGFloat)jk_height {
    CGRect temp = self.frame;
    temp.size.height = jk_height;
    self.frame = temp;
}
- (CGFloat)jk_height {
    return self.frame.size.height;
}




- (void)setJk_centerX:(CGFloat)jk_centerX {
    CGPoint temp = self.center;
    temp.x = jk_centerX;
    self.center = temp;
}
- (CGFloat)jk_centerX {
    return self.center.x;
}



- (void)setJk_centerY:(CGFloat)jk_centerY {
    CGPoint temp = self.center;
    temp.y = jk_centerY;
    self.center = temp;
}
- (CGFloat)jk_centerY {
    return self.center.y;
}



- (void)setJk_origin:(CGPoint)jk_origin {
    CGRect temp = self.frame;
    temp.origin = jk_origin;
    self.frame = temp;
}
- (CGPoint)jk_origin {
    return self.frame.origin;
}



- (void)setJk_size:(CGSize)jk_size {
    CGRect temp = self.frame;
    temp.size = jk_size;
    self.frame = temp;
}
- (CGSize)jk_size {
    return self.frame.size;
}


- (CGFloat)jk_midX {
    return CGRectGetMidX(self.frame);
}

- (CGFloat)jk_midY {
    return CGRectGetMidY(self.frame);
}

- (CGFloat)jk_maxX {
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)jk_maxY {
    return CGRectGetMaxY(self.frame);
}

- (CGRect)jk_windowFrame {
    return [self.superview convertRect:self.frame toView:[UIApplication sharedApplication].keyWindow];
}


- (CGPoint)jk_centerOfBounds {
    return CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
}

- (CGRect)jk_suitableCenterFrameWithSize:(CGSize)size {
    return CGRectMake(self.jk_centerOfBounds.x - size.width / 2.0, self.jk_centerOfBounds.y - size.height / 2.0, size.width, size.height);
}


@end
