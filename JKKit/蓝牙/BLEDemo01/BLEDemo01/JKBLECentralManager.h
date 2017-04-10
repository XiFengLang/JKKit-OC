//
//  JKBLECentralManager.h
//  BLEDemo01
//
//  Created by 蒋鹏 on 16/8/22.
//  Copyright © 2016年 蒋鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <UIKit/UIKit.h>

@class JKBLECentralManager;
@protocol JKBLECentralManagerDelegate <NSObject>

@required
- (void)jk_BLECentralManager:(JKBLECentralManager *)centralManager BLEServiceEnable:(BOOL)enable;

@optional


- (void)jk_BLECentralManager:(JKBLECentralManager *)centralManager didUpdateConnections:(NSArray<CBPeripheral *> *)peripherals;
- (void)jk_BLECentralManager:(JKBLECentralManager *)centralManager didUpdateDiscoveredPeripherals:(NSArray<CBPeripheral *> *)peripherals;

@end





@interface JKBLECentralManager : NSObject
JKSharedSingletonMethod_Declaration(JKBLECentralManager)

@property (nonatomic, weak)id<JKBLECentralManagerDelegate> delegate;






/**    检查蓝牙服务是否可用    */
- (BOOL)checkBLECentralManagerState;
+ (BOOL)checkBLECentralManagerState;

/**    开始扫描周边设备    */
- (void)stateScanPeripheral;
+ (void)stateScanPeripheral;

/**    停止扫描周边设备    */
- (void)stopScanPeripheral;
+ (void)stopScanPeripheral;


/**    判断与某个周边设备的连接状态    */
- (NSString *)connecteStateWithPeripheral:(CBPeripheral *)peripheral;
+ (NSString *)connecteStateWithPeripheral:(CBPeripheral *)peripheral;

/**    连接某个周边设备    */
- (void)connectToPeripheral:(CBPeripheral *)peripheral;
+ (void)connectToPeripheral:(CBPeripheral *)peripheral;

/**    与某个周边设备断开连接    */
- (void)disconnectWithPeripheral:(CBPeripheral *)peripheral;
+ (void)disconnectWithPeripheral:(CBPeripheral *)peripheral;

/**    断开所有的连接    */
- (void)cancelAllPeripheralConnection;
+ (void)cancelAllPeripheralConnection;
@end
