//
//  ViewController.m
//  JKViewFactory
//
//  Created by 蒋鹏 on 16/12/16.
//  Copyright © 2016年 溪枫狼. All rights reserved.
//

#import "ViewController.h"
#import "JKViewFactory.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    /// 富文本Button备用
    NSMutableAttributedString * mutAttributedStr = [[NSMutableAttributedString alloc]init];
    NSAttributedString * att = [NSAttributedString jk_attributeStringWithFont:JKFontWithSize(19)
                                                              foregroundColor:JKWhiteColor()
                                                                       string:@"白色"];
    [mutAttributedStr appendAttributedString:att];
    att = [NSAttributedString jk_attributeStringWithFont:JKFont_Default_15()
                                         foregroundColor:JKBlackColor()
                                                  string:@"黑色"];
    [mutAttributedStr appendAttributedString:att];
    
    
    /// View
    UIView * view = [UIView jk_viewWithFrame:CGRectMake(20, 20, 50, 50)];
    view.backgroundColor = JKRedColor();
    [self.view addSubview:view];
    
    /// 圆角View
    view = [UIView jk_roundedViewWithFrame:CGRectMake(100, 20, 50, 50)
                               borderWidth:2
                               borderColor:JKBlackColor()
                               cornrRadius:5
                           backgroundColor:JKWhiteColor()];
    [self.view addSubview:view];
    
    
    /// 富文本Label备用
    NSAttributedString * attributedStr = [NSAttributedString jk_attributeStringWithFont:JKFont_Default_15()
                                                                        foregroundColor:[UIColor whiteColor]
                                                                                 string:@"测试文本"];
    /// 富文本Label
    UILabel * label = [UILabel jk_adaptiveLabelWithAttributeds:attributedStr
                                                        origin:CGPointMake(180, 20)];
    label.backgroundColor = JKRedColor();
    [self.view addSubview:label];
    
    /// 单行左对齐的Label
    label = [UILabel jk_labelWithFrame:CGRectMake(250, 20, 80, 30)
                              fontSize:15
                                  text:@"测试文本"];
    label.backgroundColor = JKRedColor();
    [self.view addSubview:label];
    
    
    /// 自适应大小，自动计算frame的label,居中对齐
    label = [UILabel jk_adaptiveLabelWithOrigin:CGPointMake(340, 20)
                                       fontSize:15
                                    andFitWidth:100
                                           text:@"测试"];
    label.backgroundColor = JKRedColor();
    [self.view addSubview:label];
    
    
    CGSize imageSize = CGSizeMake(150, 80);
    
    /// 无边框图片
    UIImage * image = [UIImage jk_borderlessImageWithFillColor:[UIColor redColor]
                                                          size:imageSize
                                                  cornerRadius:20];
    
    /// ImageView工厂
    UIImageView * imageView = [UIImageView jk_imageViewWithFrame:JKRectMake(20, view.jk_maxY + 10, imageSize)
                                                           image:image];
    [self.view addSubview:imageView];
    
//    [imageView jk_addTopLine];
//    [imageView jk_addBottomLine];
    
    /// 边框图片
    image = [UIImage jk_boundedImageWithFillColor:JKRedColor()
                                      borderColor:JKBlackColor()
                                      borderWidth:2
                                             size:imageSize
                                     cornerRadius:0];
    imageView = [UIImageView jk_imageViewWithFrame:JKRectMake(200, view.jk_maxY + 10, imageSize)
                                             image:image];
    [self.view addSubview:imageView];
    
    ///  无边框圆角Button
    UIButton * button = [UIButton jk_borderlessButtonWithFrame:JKRectMake(20, imageView.jk_maxY + 10, imageSize)
                                                     fillColor:JKRedColor()
                                                  cornerRadius:5
                                                    titleColor:JKWhiteColor()
                                                         title:@"无边框"];
    [self.view addSubview:button];
    
    ///  边框圆角Button
    button = [UIButton jk_boundedButtonWithFrame:JKRectMake(200, imageView.jk_maxY + 10, imageSize)
                                      titleColor:JKWhiteColor()
                                     borderColor:JKBlackColor()
                                       fillColor:JKRedColor()
                                    cornerRadius:5
                                     borderWidth:2
                                           title:@"有边框"];
    [self.view addSubview:button];
    
    ///  无边框圆角带小icon的Button
    UIImage * icon = [UIImage jk_borderlessImageWithFillColor:JKWhiteColor()
                                                         size:CGSizeMake(23, 23)
                                                 cornerRadius:5];
    button = [UIButton jk_borderlessButtonWithIcon:icon iconSize:icon.size
                                             frame:JKRectMake(20, button.jk_maxY+ 10, imageSize)
                                         fillColor:JKRedColor()
                                      cornerRadius:5];
    [self.view addSubview:button];
    
    ///  边框圆角带小icon的Button
    button = [UIButton jk_boundedButtonWithIcon:icon
                                       iconSize:icon.size
                                          frame:JKRectMake(200, button.frame.origin.y, imageSize)
                                      fillColor:JKRedColor()
                                   cornerRadius:5
                                    borderWidth:2
                                    borderColor:JKBlackColor()];
    [self.view addSubview:button];
    
    
    /// ‘图文混排’按钮  左图右文
    attributedStr = mutAttributedStr.copy;
    button = [UIButton jk_borderlessButtonWithAttributedStr:attributedStr
                                             imageTextModel:JKImageTextModelImageLeftTextRight
                                                       icon:icon
                                                   iconSize:icon.size
                                                      frame:JKRectMake(20, button.jk_maxY + 10, imageSize)
                                                  fillColor:JKRedColor()
                                               cornerRadius:5];
    [self.view addSubview:button];
    
    
    /// ‘图文混排’按钮  左文右图
    button = [UIButton jk_borderlessButtonWithAttributedStr:attributedStr
                                             imageTextModel:JKImageTextModelImageRightTextLeft
                                                       icon:icon
                                                   iconSize:icon.size
                                                      frame:JKRectMake(20, button.jk_maxY + 10, imageSize)
                                                  fillColor:JKRedColor()
                                               cornerRadius:5];
    [self.view addSubview:button];
    
    /// ‘图文混排’按钮  上图下文
    button = [UIButton jk_borderlessButtonWithAttributedStr:attributedStr
                                             imageTextModel:JKImageTextModelImageTopTextBottom
                                                       icon:icon
                                                   iconSize:icon.size
                                                      frame:JKRectMake(20, button.jk_maxY + 10, imageSize)
                                                  fillColor:JKRedColor()
                                               cornerRadius:5];
    [self.view addSubview:button];
    
    /// ‘图文混排’按钮  下图上文
    button = [UIButton jk_borderlessButtonWithAttributedStr:attributedStr
                                             imageTextModel:JKImageTextModelImageBottomTextTop
                                                       icon:icon
                                                   iconSize:icon.size
                                                      frame:JKRectMake(20, button.jk_maxY + 10, imageSize)
                                                  fillColor:JKRedColor()
                                               cornerRadius:5];
    [self.view addSubview:button];
    
    
    
    button = [UIButton jk_boundedButtonWithAttributedStr:attributedStr
                                          imageTextModel:JKImageTextModelImageBottomTextTop
                                                    icon:icon
                                                iconSize:icon.size
                                                   frame:JKRectMake(200, button.jk_y, imageSize)
                                               fillColor:JKRedColor()
                                            cornerRadius:5
                                             borderColor:JKBlackColor()
                                             borderWidth:2];
    [self.view addSubview:button];
    
    button = [UIButton jk_boundedButtonWithAttributedStr:attributedStr
                                          imageTextModel:JKImageTextModelImageTopTextBottom
                                                    icon:icon
                                                iconSize:icon.size
                                                   frame:JKRectMake(200, button.jk_y - 90, imageSize)
                                               fillColor:JKRedColor()
                                            cornerRadius:5
                                             borderColor:JKBlackColor()
                                             borderWidth:2];
    [self.view addSubview:button];
    
    button = [UIButton jk_boundedButtonWithAttributedStr:attributedStr
                                          imageTextModel:JKImageTextModelImageRightTextLeft
                                                    icon:icon
                                                iconSize:icon.size
                                                   frame:JKRectMake(200, button.jk_y - 90, imageSize)
                                               fillColor:JKRedColor()
                                            cornerRadius:5
                                             borderColor:JKBlackColor()
                                             borderWidth:2];
    [self.view addSubview:button];
    
    
    button = [UIButton jk_boundedButtonWithAttributedStr:attributedStr
                                          imageTextModel:JKImageTextModelImageLeftTextRight
                                                    icon:icon
                                                iconSize:icon.size
                                                   frame:JKRectMake(200, button.jk_y - 90, imageSize)
                                               fillColor:JKRedColor()
                                            cornerRadius:5
                                             borderColor:JKBlackColor()
                                             borderWidth:2];
    [self.view addSubview:button];
    
    [button jk_addTarget:self touchUpInsideAction:@selector(description)];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
