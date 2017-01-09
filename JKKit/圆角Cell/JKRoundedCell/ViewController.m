//
//  ViewController.m
//  JKRoundedCell
//
//  Created by 蒋鹏 on 17/1/4.
//  Copyright © 2017年 溪枫狼. All rights reserved.
//



#import "ViewController.h"
#import "JKTableViewCell.h"

static NSString * const TitleKey = @"title";
static NSString * const SubTitleKey = @"subTitle";

@interface ViewController () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSMutableArray * dataArray;

@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"粗仿🔨日历";
    
    self.dataArray = [NSMutableArray array];
    [self.dataArray addObject:@[@[@"日历账户管理",@"所有日历"]]];
    [self.dataArray addObject:@[@[@"默认其实时间",@"全天"],@[@"默认提醒时间",@"无"],@[@"默认日历",@"本地日历"]]];
    [self.dataArray addObject:@[@[@"周数显示方式",@"本月(2017年1月第二周)"],@[@"每周起始日",@"周一"]]];
    
    
    self.tableView.backgroundColor = JKColorWithRGB(215, 215, 215);
    self.tableView.separatorColor = JKColorWithRGB(215, 215, 215);
    self.tableView.rowHeight = 60;
    self.tableView.sectionHeaderHeight = 10;
    self.tableView.sectionFooterHeight = 5;
    self.tableView.contentInset = UIEdgeInsetsMake(- 25, 0, 0, 0);
}




#pragma mark - TableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArray[section] count];
}


NSString * const JKCellKey = @"JKTableViewCell";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JKTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:JKCellKey];
    [cell configueCellWithDatas:self.dataArray[indexPath.section][indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [cell setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
    [cell setLayoutMargins:UIEdgeInsetsMake(0, 10, 0, 10)];
    [cell setPreservesSuperviewLayoutMargins:NO];

    CGSize cellSize = CGSizeMake(JKScreenWidth() - 20, 60);
    UIBezierPath * bezierPath = nil;
    
    
    CGFloat radius = 7;
    NSUInteger rowCount = [tableView numberOfRowsInSection:indexPath.section];
    if (rowCount == 1) {
        /// 一组一行
        bezierPath = [UIBezierPath jk_pathWithOriginY:10 size:cellSize borderWidth:0
                                  leftTopCornerRadius:radius rightTopCornerRadius:radius
                              rightBottomCornerRadius:radius leftBottomCornerRadius:radius];
    } else if (indexPath.row == 0) {
        /// 一组多行的第一行
        bezierPath = [UIBezierPath jk_pathWithOriginY:10 size:cellSize borderWidth:0
                               leftTopCornerRadius:radius rightTopCornerRadius:radius
                           rightBottomCornerRadius:0 leftBottomCornerRadius:0];
    } else if (indexPath.row == rowCount - 1) {
        /// 一组多行的中间行
        bezierPath = [UIBezierPath jk_pathWithOriginY:10 size:cellSize borderWidth:0
                               leftTopCornerRadius:0 rightTopCornerRadius:0
                           rightBottomCornerRadius:radius leftBottomCornerRadius:radius];
    } else {
        /// 一组多行的最后一行
        bezierPath = [UIBezierPath jk_pathWithOriginY:10 size:cellSize borderWidth:0
                                  leftTopCornerRadius:0 rightTopCornerRadius:0
                              rightBottomCornerRadius:0 leftBottomCornerRadius:0];
    }
    
    
    CAShapeLayer * cellBackgroundLayer = [[CAShapeLayer alloc] init];
    cellBackgroundLayer.path = bezierPath.CGPath;
    cellBackgroundLayer.fillColor = JKWhiteColor().CGColor;
    
    UIView * backgroundView = [UIView jk_viewWithFrame:JKRectMake(0, 0, cellSize) backgroundColor:[UIColor clearColor]];
    [backgroundView.layer insertSublayer:cellBackgroundLayer atIndex:0];
    cell.backgroundView = backgroundView;
    
    
    
    CAShapeLayer * cellSelectionLayer = [[CAShapeLayer alloc] init];
    cellSelectionLayer.fillColor = JKColorWithRGB(101, 135, 209).CGColor;
    cellSelectionLayer.path = bezierPath.CGPath;
    
    UIView * selectedBackgroundView = [UIView jk_viewWithFrame:JKRectMake(0, 0, cellSize) backgroundColor:[UIColor clearColor]];
    [selectedBackgroundView.layer insertSublayer:cellSelectionLayer atIndex:0];
    cell.selectedBackgroundView = selectedBackgroundView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    JKTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell willHighlight];
    return YES;
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    JKTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell didUnhighlight];
}

@end
