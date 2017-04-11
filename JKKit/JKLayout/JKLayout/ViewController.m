//
//  ViewController.m
//  JKLayout
//
//  Created by 蒋鹏 on 17/3/28.
//  Copyright © 2017年 溪枫狼. All rights reserved.
//

#import "ViewController.h"
#import "UIView+JKLayout.h"
#import <ImageIO/ImageIO.h>

@interface ViewController ()


@property (nonatomic, weak) UIImageView * imgView;
@property (nonatomic, assign) NSUInteger index;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView * view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1024"]];
    view.left = self.view.left + 40;
    view.top = self.view.top + 40;
    view.size = CGSizeMake(280, 152);
//    view.right = self.view.right - 40;
//    view.bottom = self.view.top + 200;
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    self.imgView = view;


    JKLayout rect = self.view.layout;
    NSLog(@"%@",NSStringFromJKLayout(rect));
    
    
    
    NSString * uid = @"1";
    NSString * gid = @"2";
    
    // 初始化字典的快捷宏
    NSDictionary * dict = NSDictionaryOfVariableBindings(uid,gid);
    NSLog(@"%@",dict);
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [self turnplateAnimation];
    
    /// 280 152
    NSString * path = [[NSBundle mainBundle] pathForResource:@"hua" ofType:@"gif"];
    NSData * gifData = [NSData dataWithContentsOfFile:path];
    CGImageSourceRef imageSource = CGImageSourceCreateWithData((__bridge CFDataRef)gifData,
                                                               (__bridge CFDictionaryRef)@{(NSString *)kCGImageSourceShouldCache: @NO});
    size_t gifCount = CGImageSourceGetCount(imageSource);

    __block UIImage * gif = nil;
    if (gifCount > 1) {
        NSMutableArray <UIImage *>* gifImages = [NSMutableArray array];
        NSTimeInterval duration = 0.0f;
        
        for (int index = 0; index < gifCount; index ++) {
            CGImageRef cgImage = CGImageSourceCreateImageAtIndex(imageSource, index, (__bridge CFDictionaryRef)@{(NSString *)kCGImageSourceShouldCache: @NO});
            UIImage * image = [[UIImage alloc] initWithCGImage:cgImage scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
            [gifImages addObject:image];
            duration += [self getFrameDurationAtIndex:index source:imageSource];
        }
        
        gif = [UIImage animatedImageWithImages:gifImages duration:duration];
        
//        [self.imgView setAnimationDuration:duration];
//        [self.imgView setAnimationImages:gifImages];
//        [self.imgView setAnimationRepeatCount:1];
//        [self.imgView startAnimating];
        
        [gifImages removeAllObjects];
    } else {
        gif = [UIImage imageWithData:gifData];
    }
    CFRelease(imageSource);

    self.imgView.image = gif;

    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self.imgView stopAnimating];
        [self.imgView setAnimationImages:nil];
        [self.imgView removeFromSuperview];
    });
    
}


- (float)getFrameDurationAtIndex:(NSUInteger)index source:(CGImageSourceRef)spurce {
    float frameDuration = 0.1f;
    CFDictionaryRef cfFrameProperties = CGImageSourceCopyPropertiesAtIndex(spurce, index, NULL);
    NSDictionary * frameProperties = (__bridge NSDictionary *)cfFrameProperties;
    NSDictionary * gifProperties = frameProperties[(__bridge NSString *)kCGImagePropertyGIFDictionary];
    
    NSNumber * delayTimeUnclampedProp = gifProperties[(__bridge NSString *)kCGImagePropertyGIFUnclampedDelayTime];
    if (delayTimeUnclampedProp) {
        frameDuration = delayTimeUnclampedProp.floatValue;
        
    } else {
        NSNumber * delayTimeProp = gifProperties[(__bridge NSString *)kCGImagePropertyGIFDelayTime];
        if (delayTimeProp) {
            frameDuration = delayTimeProp.floatValue;
        }
    }
    if (frameDuration < 0.011f) {
        frameDuration = 0.100f;
    }
    CFRelease(cfFrameProperties);
    return frameDuration;
}


- (void)turnplateAnimation {
    
    [UIView animateKeyframesWithDuration:1 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear | UIViewKeyframeAnimationOptionBeginFromCurrentState animations:^{
        
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.25 animations:^{
            self.index += 1;
            CGFloat angle = self.index * M_PI_2;
            self.imgView.transform = CGAffineTransformMakeRotation(angle);
        }];
        
        
        [UIView addKeyframeWithRelativeStartTime:0.25 relativeDuration:0.25 animations:^{
            self.index += 1;
            CGFloat angle = self.index * M_PI_2;
            self.imgView.transform = CGAffineTransformMakeRotation(angle);
        }];
        
        
        [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:0.25 animations:^{
            self.index += 1;
            CGFloat angle = self.index * M_PI_2;
            self.imgView.transform = CGAffineTransformMakeRotation(angle);
        }];
        
        [UIView addKeyframeWithRelativeStartTime:0.75 relativeDuration:0.25 animations:^{
            self.index += 1;
            CGFloat angle = self.index * M_PI_2;
            self.imgView.transform = CGAffineTransformMakeRotation(angle);
        }];
        
    } completion:^(BOOL finished) {
        NSLog(@"completion");
        if (finished) {
            [self turnplateAnimation];
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
