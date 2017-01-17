//
//  ViewController.m
//  JKChartView_01
//
//  Created by 蒋鹏 on 17/1/17.
//  Copyright © 2017年 溪枫狼. All rights reserved.
//

#import "ViewController.h"
#import "UIView+CGRect.h"
#import "JKViewFactory.h"

@interface ViewController () <CAAnimationDelegate>

//@property (nonatomic, strong) NSMutableArray * columnarLayerArray;
//@property (nonatomic, strong) NSMutableArray * columnarLayerFianalFrames;
//
//@property (nonatomic, strong) NSMutableArray * valueLayerArray;
//@property (nonatomic, strong) NSMutableArray * valueLayerFinalPoints;

@property (nonatomic, strong) UIBezierPath * lineBgFinalPath;
@property (nonatomic, strong) CAShapeLayer * lineBGLayer;

@property (nonatomic, strong) CAShapeLayer * lineLayer;
@property (nonatomic, strong) UIBezierPath * lineFinalPath;

@property (nonatomic, assign) NSUInteger index;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView * contentView = [[UIView alloc] initWithFrame:CGRectMake(20, 100, self.view.bounds.size.width - 40, 200)];
    contentView.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.8];
    [self.view addSubview:contentView];
    
    
    UIColor * coordinateAxisColor = [UIColor lightGrayColor];
    CGFloat coordinateAxisBorderWidth = 1.0;
    
    UIEdgeInsets chartViewEdgeInsets = UIEdgeInsetsMake(30, 30, 30, 30);
    
    /// Y轴
    CAShapeLayer * yAxisLayer = [CAShapeLayer layer];
    yAxisLayer.backgroundColor = coordinateAxisColor.CGColor;
    yAxisLayer.frame = CGRectMake(chartViewEdgeInsets.left, chartViewEdgeInsets.top, coordinateAxisBorderWidth, contentView.jk_height - chartViewEdgeInsets.top - chartViewEdgeInsets.bottom);
    [contentView.layer addSublayer:yAxisLayer];
    
    
    
    /// X轴
    CAShapeLayer * xAxisLayer = [CAShapeLayer layer];
    xAxisLayer.backgroundColor = coordinateAxisColor.CGColor;
    xAxisLayer.frame = CGRectMake(chartViewEdgeInsets.left, contentView.jk_height - chartViewEdgeInsets.bottom, contentView.jk_width - chartViewEdgeInsets.left - chartViewEdgeInsets.right, coordinateAxisBorderWidth);
    [contentView.layer addSublayer:xAxisLayer];
    
    
    /// 水平线
    CGFloat horizontalAxisSpacing = yAxisLayer.bounds.size.height / 4.0;
    for (NSInteger index = 0; index < 5-1; index ++) {
        CAShapeLayer * verticalAxisLayer = [CAShapeLayer layer];
        verticalAxisLayer.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3].CGColor;
        verticalAxisLayer.frame = CGRectMake(chartViewEdgeInsets.left, chartViewEdgeInsets.top + index * horizontalAxisSpacing, xAxisLayer.bounds.size.width, 0.5);
        [contentView.layer addSublayer:verticalAxisLayer];
     }
    
    /// 垂直下标数值
    CGFloat yMaxValue = contentView.jk_height - chartViewEdgeInsets.top;
    CGFloat flagFontSize = 10;
    UIFont * flagTextFont = [UIFont systemFontOfSize:flagFontSize];
    CGFloat maxHorizontalValue = 0;
    
    for (NSInteger index = 0; index < 5; index ++) {
        NSString * text = [NSString stringWithFormat:@"%zd",index * 2];
        if (text.floatValue > maxHorizontalValue) {
            maxHorizontalValue = text.floatValue;
        }
        
        
        CGSize textSize = [text jk_sizeWithFont:flagTextFont andFitWidth:40];
        
        CATextLayer * flagTextLayer = [CATextLayer layer];
        flagTextLayer.string = text;
        flagTextLayer.foregroundColor = [UIColor lightGrayColor].CGColor;
//        flagTextLayer.font = (__bridge CFTypeRef _Nullable)(flagTextFont);
        flagTextLayer.fontSize = 10;
        flagTextLayer.frame = CGRectMake(chartViewEdgeInsets.left - 5 - textSize.width, yMaxValue - textSize.height / 2.0 - index * horizontalAxisSpacing, textSize.width, textSize.height);
//        flagTextLayer.backgroundColor = [UIColor whiteColor].CGColor;
        flagTextLayer.alignmentMode = kCAAlignmentCenter;
        flagTextLayer.contentsScale = JKScreenScale();
//        flagTextLayer.transform = CATransform3DRotate(flagTextLayer.transform, 1, 0, 0, M_PI * -20);
        [contentView.layer addSublayer:flagTextLayer];
    }
    
    
    
    /// 垂直线
    CGFloat verticalAxisSpacing = xAxisLayer.bounds.size.width / 9.0;
    for (NSInteger index = 0; index < 10-1; index ++) {
        CAShapeLayer * horizontalAxisLayer = [CAShapeLayer layer];
        horizontalAxisLayer.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3].CGColor;
        horizontalAxisLayer.frame = CGRectMake(chartViewEdgeInsets.left + (index + 1) * verticalAxisSpacing, chartViewEdgeInsets.top, 0.5, yAxisLayer.bounds.size.height);
        [contentView.layer addSublayer:horizontalAxisLayer];
    }
    
    
    /// 水平下标数值
    CGFloat maxVerticalValue = 0;
    for (NSInteger index = 0; index < 10; index ++) {
        NSString * text = [NSString stringWithFormat:@"%zd",index];
        if (text.floatValue > maxVerticalValue) {
            maxVerticalValue = text.floatValue;
        }
        
        CGSize size = [text jk_sizeWithFont:flagTextFont andFitWidth:30];
        CGRect frame = CGRectMake(chartViewEdgeInsets.left - size.width / 2.0 + index * verticalAxisSpacing, contentView.jk_height - chartViewEdgeInsets.bottom + 5, size.width, size.height);
        
        CATextLayer * textLayer = [CATextLayer layer];
        textLayer.string = text;
        textLayer.fontSize = flagFontSize;
        textLayer.foregroundColor = [UIColor lightGrayColor].CGColor;
        textLayer.frame = frame;
        textLayer.alignmentMode = kCAAlignmentCenter;
        textLayer.contentsScale = JKScreenScale();
        [contentView.layer addSublayer:textLayer];
    }
    
    
    /// 颜色覆盖分区
    for (NSInteger index = 0; index < 5-1; index ++) {
        if (index % 2 == 0) {
            CGRect frame = CGRectMake(chartViewEdgeInsets.left, chartViewEdgeInsets.top + horizontalAxisSpacing * index, contentView.jk_width - chartViewEdgeInsets.left - chartViewEdgeInsets.right, horizontalAxisSpacing);
            CAShapeLayer * rectLayer = [CAShapeLayer layer];
            rectLayer.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2].CGColor;
            rectLayer.frame = frame;
            [contentView.layer addSublayer:rectLayer];
        }
    }
    
    NSArray * values = @[@"4",@"2",@"5",@"2",@"6"];
    
    
    /// 折线背景动画的最终贝塞尔曲线
    UIBezierPath * lineBgPath = [UIBezierPath bezierPath];
    [lineBgPath moveToPoint:CGPointMake(chartViewEdgeInsets.left, contentView.jk_height - chartViewEdgeInsets.bottom)];
    
    /// 折线背景动画的初始贝塞尔曲线
    UIBezierPath * tempPath = [UIBezierPath bezierPath];
    [tempPath moveToPoint:CGPointMake(chartViewEdgeInsets.left + 1, xAxisLayer.frame.origin.y)];
    
    
    UIBezierPath * lineFinalPath = [UIBezierPath bezierPath];
    self.lineFinalPath = lineFinalPath;
    
    
    UIBezierPath * lineTempPath = [UIBezierPath bezierPath];
    
    
    NSMutableArray * valuePointArray = [NSMutableArray array];
    CGPoint finalPoint = CGPointZero;
    for (NSInteger index = 0; index < values.count; index ++) {
        
        CGFloat height = (contentView.jk_height - chartViewEdgeInsets.top - chartViewEdgeInsets.bottom) * ([values[index] floatValue] / maxHorizontalValue);
        CGPoint valuePoint = CGPointMake(1 + chartViewEdgeInsets.left + verticalAxisSpacing * index, contentView.jk_height - chartViewEdgeInsets.bottom - height);
        
        [lineBgPath addLineToPoint:valuePoint];
        [tempPath addLineToPoint:CGPointMake(valuePoint.x, xAxisLayer.frame.origin.y)];
        
        if (index == 0) {
            [lineFinalPath moveToPoint:valuePoint];
            [lineTempPath moveToPoint:CGPointMake(valuePoint.x, xAxisLayer.frame.origin.y)];
        } else {
            [lineFinalPath addLineToPoint:valuePoint];
            [lineTempPath addLineToPoint:CGPointMake(valuePoint.x, xAxisLayer.frame.origin.y)];
        }
        [valuePointArray addObject:[NSValue valueWithCGPoint:valuePoint]];
        
        if (index == values.count -1) {
            finalPoint = valuePoint;
            [lineBgPath addLineToPoint:CGPointMake(valuePoint.x, xAxisLayer.frame.origin.y)];
            [tempPath addLineToPoint:CGPointMake(valuePoint.x, xAxisLayer.frame.origin.y)];
        }
    }
    
    /// 添加的点数要一致，拐点一样，才能有协调的动画。
    [tempPath closePath];
    [lineBgPath closePath];
    self.lineBgFinalPath = lineBgPath;
    
    /// 折线
    CAShapeLayer * lineLayer = [CAShapeLayer layer];
    lineLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    lineLayer.borderWidth = 1.0;
    lineLayer.fillColor = [UIColor clearColor].CGColor;
    lineLayer.path = lineTempPath.CGPath;
    [contentView.layer addSublayer:lineLayer];
    self.lineLayer = lineLayer;
    
    
    /// 折线的背景layer
    CAShapeLayer * lineBGLayer = [CAShapeLayer layer];
    lineBGLayer.path = tempPath.CGPath;
    lineBGLayer.fillColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5].CGColor;
    [contentView.layer addSublayer:lineBGLayer];
    self.lineBGLayer = lineBGLayer;
    
    
    
    /// 折线上的圆点
    for (NSInteger index = 0; index < valuePointArray.count; index ++) {
        CGPoint center = [valuePointArray[index] CGPointValue];
        
        UIBezierPath * bezierPath = [UIBezierPath bezierPathWithArcCenter:center radius:5 startAngle:0 endAngle:M_2_PI clockwise:NO];
        
        CAShapeLayer * dotLayer = [CAShapeLayer layer];
        dotLayer.fillColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7].CGColor;
        dotLayer.path = bezierPath.CGPath;
        [contentView.layer addSublayer:dotLayer];
    }
    
    
    
    
    
    
    /*
    
    /// 柱状图
     
     
    self.columnarLayerArray = [NSMutableArray array];
    self.valueLayerArray = [NSMutableArray array];
    self.columnarLayerFianalFrames = [NSMutableArray array];
    self.valueLayerFinalPoints = [NSMutableArray array];
    
    
    for (NSInteger index = 0; index < values.count; index ++) {

        CGFloat height = (contentView.jk_height - chartViewEdgeInsets.top - chartViewEdgeInsets.bottom) * ([values[index] floatValue] / maxHorizontalValue);
        CGRect frame = CGRectMake(chartViewEdgeInsets.left + index * verticalAxisSpacing + 0.5, contentView.jk_height - chartViewEdgeInsets.bottom - height, verticalAxisSpacing - 1, height);
        CGRect tempFrame = CGRectMake(frame.origin.x, CGRectGetMaxY(frame), frame.size.width, 0);
        UIBezierPath * bezierPath = [UIBezierPath bezierPathWithRect:tempFrame];
     
        
        /// 柱状layer
        CAShapeLayer * columnarLayer = [CAShapeLayer layer];
        columnarLayer.fillColor = [UIColor lightGrayColor].CGColor;
        columnarLayer.path = bezierPath.CGPath;
        [contentView.layer addSublayer:columnarLayer];
        
        [self.columnarLayerArray addObject:columnarLayer];
        [self.columnarLayerFianalFrames addObject:[NSValue valueWithCGRect:frame]];
        
        /// 数值
        CATextLayer * textLayer = [CATextLayer layer];
        textLayer.string = values[index];
        CGSize size = [textLayer.string jk_sizeWithFont:flagTextFont andFitWidth:30];
        CGRect textFrame = CGRectMake(CGRectGetMidX(frame) - size.width / 2.0, CGRectGetMinY(frame) - size.height - 5, size.width, size.height);
        textLayer.frame = textFrame;
        [self.valueLayerFinalPoints addObject:[NSValue valueWithCGPoint:textLayer.position]];
        
        CGRect tempTextFrame = CGRectMake(textFrame.origin.x, CGRectGetMaxY(frame) - 5 - size.height, size.width, size.height);
        textLayer.frame = tempTextFrame;
        
        textLayer.fontSize = flagFontSize;
        textLayer.foregroundColor = [UIColor clearColor].CGColor;
        textLayer.alignmentMode = kCAAlignmentCenter;
        textLayer.contentsScale = JKScreenScale();
        [contentView.layer addSublayer:textLayer];
        
        [self.valueLayerArray addObject:textLayer];
    }
    
    */
}


/*
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
dispatch_async(dispatch_queue_create("queue", DISPATCH_QUEUE_CONCURRENT), ^{
    for (NSInteger index = 0; index < self.columnarLayerArray.count; index ++) {
        
        CAShapeLayer * columnarLayer = self.columnarLayerArray[index];
        NSValue * columnarFrame = self.columnarLayerFianalFrames[index];

        
        UIBezierPath * berierPath = [UIBezierPath bezierPathWithRect:[columnarFrame CGRectValue]];
        
        
        CABasicAnimation * colmnarAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
        colmnarAnimation.fromValue = (__bridge id _Nullable)(columnarLayer.path);
        colmnarAnimation.toValue = (__bridge id _Nullable)(berierPath.CGPath);
        colmnarAnimation.timingFunction = [CAMediaTimingFunction functionWithName:@"easeInEaseOut"];
        colmnarAnimation.duration = 0.7;
        colmnarAnimation.fillMode = kCAFillModeForwards;
        colmnarAnimation.removedOnCompletion = NO;
        
        CATextLayer * textLayer = self.valueLayerArray[index];
        
        CABasicAnimation * textAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
        textAnimation.fromValue = [NSValue valueWithCGPoint:textLayer.position];
        textAnimation.toValue = (NSValue *)self.valueLayerFinalPoints[index];
        textAnimation.timingFunction = [CAMediaTimingFunction functionWithName:@"easeInEaseOut"];
        textAnimation.duration = 0.7;
        textAnimation.fillMode = kCAFillModeForwards;
        textAnimation.removedOnCompletion = NO;
        textAnimation.delegate = self;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [columnarLayer addAnimation:colmnarAnimation forKey:nil];
            [textLayer addAnimation:textAnimation forKey:@"position"];
        });
        [NSThread sleepForTimeInterval:0.08];
    }
});
    
}

- (void)animationDidStart:(CAAnimation *)anim {
    CATextLayer * textLayer = self.valueLayerArray[self.index];
    [UIView animateWithDuration:0.6 delay:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        textLayer.foregroundColor = [UIColor lightGrayColor].CGColor;
    } completion:nil];
    self.index += 1;
}


*/



- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
    CABasicAnimation * lineBGAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    lineBGAnimation.fromValue = (__bridge id _Nullable)(self.lineBGLayer.path);
    lineBGAnimation.toValue = (__bridge id _Nullable)(self.lineBgFinalPath.CGPath);
    lineBGAnimation.timingFunction = [CAMediaTimingFunction functionWithName:@"easeInEaseOut"];
    lineBGAnimation.duration = 0.7;
    lineBGAnimation.fillMode = kCAFillModeForwards;
    lineBGAnimation.removedOnCompletion = NO;
    
    
    CABasicAnimation * lineAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    lineAnimation.fromValue = (__bridge id _Nullable)(self.lineLayer.path);
    lineAnimation.toValue = (__bridge id _Nullable)(self.lineFinalPath.CGPath);
    lineAnimation.timingFunction = [CAMediaTimingFunction functionWithName:@"easeInEaseOut"];
    lineAnimation.duration = 0.7;
    lineAnimation.fillMode = kCAFillModeForwards;
    lineAnimation.removedOnCompletion = NO;
    
    self.lineLayer.strokeStart = 0.0;
    self.lineLayer.strokeEnd = 0.0;
    CABasicAnimation * lineStrakeAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    lineStrakeAnimation.fromValue = @0;
    lineStrakeAnimation.toValue = @1;
    lineStrakeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:@"easeInEaseOut"];
    lineStrakeAnimation.duration = 0.7;
    lineStrakeAnimation.fillMode = kCAFillModeForwards;
    lineStrakeAnimation.removedOnCompletion = NO;
    
    
    [self.lineLayer addAnimation:lineAnimation forKey:@"path"];
    [self.lineBGLayer addAnimation:lineBGAnimation forKey:@"path"];
    [self.lineLayer addAnimation:lineStrakeAnimation forKey:@"strokeEnd"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
