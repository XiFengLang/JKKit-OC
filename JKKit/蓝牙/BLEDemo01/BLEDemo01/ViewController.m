//
//  ViewController.m
//  BLEDemo01
//
//  Created by 蒋鹏 on 16/8/19.
//  Copyright © 2016年 蒋鹏. All rights reserved.
//

#import "ViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "JKBLECentralManager.h"





@interface ViewController () <JKBLECentralManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSArray * connectedPeripherals;
@property (nonatomic, strong)NSArray * discoveredPeripherals;
@end

@implementation ViewController{
    UIControl * button;
    UIButton * ibutton;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"蓝牙Demo";
    self.tableView.tableFooterView = UIView.new;
    [JKBLECentralManager sharedJKBLECentralManager].delegate = self;
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    for (UIView * subView in button.subviews) {
        JKLog(@"%@  %@",subView,subView.subviews);
    }
    
    for (UIView * subView in ibutton.subviews) {
        JKLog(@"%@  %@",subView,subView.subviews);
    }
}

/**    扫描周边设备    */
- (void)stateScanPeripheral{
    [JKBLECentralManager stateScanPeripheral];
}

/**    停止扫描    */
- (void)stopScanPeripheral{
    [JKBLECentralManager stopScanPeripheral];
}




/**    连接周边设备，中心设备可以同时连接多个周边设备    */
- (void)connectPeripheral:(CBPeripheral *)peripheral{
    [JKBLECentralManager connectToPeripheral:peripheral];
}

/**    断开连接    */
- (void)disconnectPeripheral:(CBPeripheral *)peripheral{
    [JKBLECentralManager disconnectWithPeripheral:peripheral];
}


#pragma mark - JKBLEToolDelegate
- (void)jk_BLECentralManager:(JKBLECentralManager *)centralManager BLEServiceEnable:(BOOL)enable{
    
}

- (void)jk_BLECentralManager:(JKBLECentralManager *)centralManager didUpdateConnections:(NSArray<CBPeripheral *> *)peripherals{
    self.connectedPeripherals = peripherals;
    [self.tableView reloadData];
}
- (void)jk_BLECentralManager:(JKBLECentralManager *)centralManager didUpdateDiscoveredPeripherals:(NSArray<CBPeripheral *> *)peripherals{
    self.discoveredPeripherals = peripherals;
    [self.tableView reloadData];
}

#pragma mark - TableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.discoveredPeripherals.count;
}


NSString * const JKCellKey = @"UITableViewCellReuseKey";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:JKCellKey];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:JKCellKey];
    }
    CBPeripheral * peripheral = self.discoveredPeripherals[indexPath.row];
    NSString * connected = [JKBLECentralManager connecteStateWithPeripheral:peripheral];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ : %@",peripheral.name,connected];
    cell.detailTextLabel.text = peripheral.identifier.UUIDString;
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    CBPeripheral * peripheral = self.discoveredPeripherals[indexPath.row];
    
    /**
     *  中心设备可以同时连接多个周边设备
     */
    if (peripheral.state == CBPeripheralStateConnected) {
        [self disconnectPeripheral:peripheral];
    }else{
        [self connectPeripheral:peripheral];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
