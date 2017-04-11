//
//  UIView+CGRect.m
//  JKViewFactory
//
//  Created by 蒋鹏 on 16/12/27.
//  Copyright © 2016年 溪枫狼. All rights reserved.
//

#import "UIView+JKLayout.h"




@implementation UIView (JKLayout)

- (void)setLeft:(CGFloat)left {
    CGRect temp = self.frame;
    temp.origin.x = left;
    self.frame = temp;
}
- (CGFloat)left {
    return self.frame.origin.x;
}


- (void)setRight:(CGFloat)right {
    self.width = right - self.left;
}
- (CGFloat)right {
    return CGRectGetMaxX(self.frame);
}


- (void)setTop:(CGFloat)top {
    CGRect temp = self.frame;
    temp.origin.y = top;
    self.frame = temp;
}
- (CGFloat)top {
    return self.frame.origin.y;
}


- (void)setBottom:(CGFloat)bottom {
    self.height = bottom - self.top;
}
- (CGFloat)bottom {
    return CGRectGetMaxY(self.frame);
}


- (void)setWidth:(CGFloat)width {
    CGRect temp = self.frame;
    temp.size.width = width;
    self.frame = temp;
}
- (CGFloat)width {
    return self.frame.size.width;
}


- (void)setHeight:(CGFloat)height {
    CGRect temp = self.frame;
    temp.size.height = height;
    self.frame = temp;
}
- (CGFloat)height {
    return self.frame.size.height;
}




- (void)setCenterX:(CGFloat)centerX {
    CGPoint temp = self.center;
    temp.x = centerX;
    self.center = temp;
}
- (CGFloat)centerX {
    return self.center.x;
}



- (void)setCenterY:(CGFloat)centerY {
    CGPoint temp = self.center;
    temp.y = centerY;
    self.center = temp;
}
- (CGFloat)centerY {
    return self.center.y;
}



- (void)setOrigin:(CGPoint)origin {
    CGRect temp = self.frame;
    temp.origin = origin;
    self.frame = temp;
}
- (CGPoint)origin {
    return self.frame.origin;
}



- (void)setSize:(CGSize)size {
    CGRect temp = self.frame;
    temp.size = size;
    self.frame = temp;
}
- (CGSize)size {
    return self.frame.size;
}



- (void)setLayout:(JKLayout)layout {
    CGRect temp = self.frame;
    temp.origin.x = layout.left;
    temp.origin.y = layout.top;
    temp.size.width = fabs(layout.right - layout.left);
    temp.size.height = fabs(layout.bottom - layout.top);
    self.frame = temp;
}


- (JKLayout)layout {
    struct JKLayout layout;
    layout.left = self.frame.origin.x;
    layout.right = self.frame.origin.x + self.frame.size.width;
    layout.top = self.frame.origin.y;
    layout.bottom = self.frame.origin.y + self.frame.size.height;
    return layout;
}


- (CGFloat)midX {
    return CGRectGetMidX(self.frame);
}

- (CGFloat)midY {
    return CGRectGetMidY(self.frame);
}

- (CGFloat)maxX {
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)maxY {
    return CGRectGetMaxY(self.frame);
}

- (CGRect)windowFrame {
    return [self.superview convertRect:self.frame toView:[UIApplication sharedApplication].keyWindow];
}


- (CGPoint)centerOfBounds {
    return CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
}

- (CGRect)suitableCenterFrameWithSize:(CGSize)size {
    return CGRectMake(self.centerOfBounds.x - size.width / 2.0, self.centerOfBounds.y - size.height / 2.0, size.width, size.height);
}


@end
