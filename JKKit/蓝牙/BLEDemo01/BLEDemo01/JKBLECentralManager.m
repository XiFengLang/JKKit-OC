//
//  JKBLETool.m
//  BLEDemo01
//
//  Created by 蒋鹏 on 16/8/22.
//  Copyright © 2016年 蒋鹏. All rights reserved.
//

#import "JKBLECentralManager.h"

#define JKConstDefineForString(myKey,myValue)  static NSString * const myKey = myValue;

JKConstDefineForString(kEWenJiName,
                       @"FitThm_")
JKConstDefineForString(kEWenJiServiceUUID,
                       @"0000FC00-0000-1000-8000-00805F9B34FB")
JKConstDefineForString(kEWenJiCharacteristicUUIDForNotify,
                       @"0000FCA1-0000-1000-8000-00805F9B34FB")
JKConstDefineForString(kEWenJiCharacteristicUUIDForWriteable,
                       @"0000FCA0-0000-1000-8000-00805F9B34FB")



static const char * CentralManagerDelegateQueueKey = "CentralManagerDelegateQueueKey";

@interface JKBLECentralManager ()<CBCentralManagerDelegate,CBPeripheralDelegate>
{
    CBUUID * _serviceUUID;
    CBUUID * _service_Short_UUID;
    CBUUID * _characteristic_Notifiy_Short_UUID;
    CBUUID * _characteristic_Writable_Short_UUID;
    NSArray * _characteristicUUIDArray;
    
    CBCharacteristic * _notifyCharacteristic;
    CBCharacteristic * _writaleCharacteristic;
    
    BOOL _didReceived_Zero_Zero_Packet;
    BOOL _didReceived_Zero_Three_Packet;
    BOOL _didReceived_Zero_Four_Packet;
    
    CBPeripheral * _currentPeripheral;
}
@property (nonatomic, strong)CBCentralManager * centralManager;
@property (nonatomic, strong)NSMutableArray * discoveredPeripherals;
@property (nonatomic, strong)NSMutableArray * connectedPeripherals;
@property (nonatomic, strong)NSMutableArray * connectedPeripheralIdentifies;

@property (nonatomic, strong)NSTimer * sendDataTimer;
@property (nonatomic, strong)NSDateFormatter *formatter;

@property (nonatomic, assign)NSUInteger retryConnectTimes;
@property (nonatomic, strong)NSMutableData * tempContentData;
@end

@implementation JKBLECentralManager
JKSharedSingletonMethod_Implementation(JKBLECentralManager)
JKLazyLoadForNSMutableArray(discoveredPeripherals)
JKLazyLoadForNSMutableArray(connectedPeripherals)
JKLazyLoadForNSMutableArray(connectedPeripheralIdentifies)

- (NSDateFormatter *)formatter{
    if (!_formatter) {
        _formatter = [[NSDateFormatter alloc]init];
        [_formatter setDateFormat:@"yyMMddHHmmss"];
    }return _formatter;
}

- (NSMutableData *)tempContentData{
    if (!_tempContentData) {
        _tempContentData = [[NSMutableData alloc]init];
    }return _tempContentData;
}

- (instancetype)init{
    if (self = [super init]) {
        // 建立中心角色
        dispatch_queue_t delegateQueue = dispatch_queue_create(CentralManagerDelegateQueueKey, DISPATCH_QUEUE_SERIAL);
        CBCentralManager * centralManager = [[CBCentralManager alloc]initWithDelegate:self queue:delegateQueue];
        self.centralManager = centralManager;
        
        //  这些UUID由设备厂商、硬件部门提供,解析、发送数据包的协议同样也是由对方提供,按协议解析拼包解包
        //  参考资料：http://www.jianshu.com/users/3f8e2a3945de/latest_articles
        
        NSString * short_service_uuid = [kEWenJiServiceUUID substringWithRange:NSMakeRange(4, 4)];
        NSString * short_characteristic_notify_uuid = [kEWenJiCharacteristicUUIDForNotify substringWithRange:NSMakeRange(4, 4)];
        NSString * short_characteristic_writable_uuid = [kEWenJiCharacteristicUUIDForWriteable substringWithRange:NSMakeRange(4, 4)];
        
        _serviceUUID = [CBUUID UUIDWithString:kEWenJiServiceUUID];
        _service_Short_UUID = [CBUUID UUIDWithString:short_service_uuid];
        _characteristic_Notifiy_Short_UUID = [CBUUID UUIDWithString:short_characteristic_notify_uuid];
        _characteristic_Writable_Short_UUID = [CBUUID UUIDWithString:short_characteristic_writable_uuid];
        
        CBUUID * characteristic_Notify_UUID = [CBUUID UUIDWithString:kEWenJiCharacteristicUUIDForNotify];
        CBUUID * characteristic_Writable_UUID = [CBUUID UUIDWithString:kEWenJiCharacteristicUUIDForWriteable];
        _characteristicUUIDArray = @[characteristic_Notify_UUID,characteristic_Writable_UUID];
        
        
        /* ⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️
         关于蓝牙重连机制：http://www.jianshu.com/p/9be0e624d242
         
         ⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️*/
        
        
    }return self;
}

#pragma mark - 检查蓝牙服务是否可用
+ (BOOL)checkBLECentralManagerState{
    return [[JKBLECentralManager sharedJKBLECentralManager] checkBLECentralManagerState];
}

- (BOOL)checkBLECentralManagerState{
    BOOL BLEAvailable = NO;
    NSMutableString * localDeacription = [NSMutableString stringWithString:@"本地蓝牙-中心设备-"];
    switch (self.centralManager.state) {
        case CBCentralManagerStateUnknown:{
            [localDeacription appendString:@"未知状态"];
        }break;
        case CBCentralManagerStateResetting:{
            [localDeacription appendString:@"正在重新设置蓝牙"];
        }break;
        case CBCentralManagerStateUnsupported:{
            [localDeacription appendString:@"当前设备不支持BLE"];
        }break;
        case CBCentralManagerStateUnauthorized:{
            [localDeacription appendString:@"用户未授权"];
        }break;
        case CBCentralManagerStatePoweredOff:{
            [localDeacription appendString:@"BLE服务已关闭"];
        }break;
        case CBCentralManagerStatePoweredOn:{
            BLEAvailable = YES;
            [localDeacription appendString:@"BLE服务已开启"];
        }break;
    }
    
    JKLog(@"2.BLEAvailable = %@  ,  %@",BLEAvailable ? @"YES" : @"NO",localDeacription);
    
    return BLEAvailable;
}

#pragma mark - 开始扫描周边设备
+ (void)stateScanPeripheral{
    [[JKBLECentralManager sharedJKBLECentralManager] stateScanPeripheral];
}
- (void)stateScanPeripheral{
    if (self.centralManager.isScanning == NO) {
        BOOL enable = [self checkBLECentralManagerState];
        if (enable) {
            
            // ⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️
            // @{CBCentralManagerScanOptionAllowDuplicatesKey:@(YES)}/CBCentralManagerScanOptionSolicitedServiceUUIDsKey:@[UUID,...]
            // 默认情况下一个广播中 peripheral 的多次发现会被合并成一次发现事件，每扫描到一个新的Peripheral会调用一次centralManager:didDiscoverPeripheral:advertisementData:RSSI: ,而设置CBCentralManagerScanOptionAllowDuplicatesKey后则是每收到一个广播包就会调用一次，频率会增强，缺点：耗电！
            // ⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️
            
            
            // 扫描周边设备，Services:nil代表扫描所有周边设备
            [self.centralManager scanForPeripheralsWithServices:nil options:nil];
            
            // 扫描特定周边设备
            //    [self.centralManager scanForPeripheralsWithServices:[NSArray arrayWithObject:[CBUUID UUIDWithString:@"180D"]] options:nil];
        }
        
        [self.delegate jk_BLECentralManager:self BLEServiceEnable:enable];
    }else if ([self checkBLECentralManagerState]) {
        [self.centralManager stopScan];
    }
}

#pragma mark - 停止扫描周边设备
+ (void)stopScanPeripheral{
    [[JKBLECentralManager sharedJKBLECentralManager] stopScanPeripheral];
}
- (void)stopScanPeripheral{
    if ([self.centralManager isScanning]) {
        [self.centralManager stopScan];
    }
    
    JKLog(@"已停止扫描周边蓝牙设备");
}

#pragma mark - 判断与某个周边设备的连接状态
+ (NSString *)connecteStateWithPeripheral:(CBPeripheral *)peripheral{
    return [[JKBLECentralManager sharedJKBLECentralManager] connecteStateWithPeripheral:peripheral];
}
- (NSString *)connecteStateWithPeripheral:(CBPeripheral *)peripheral{
    NSString * connected = @"未连接";
    switch (peripheral.state) {
        case CBPeripheralStateDisconnected:
            connected = @"未连接";
            break;
        case CBPeripheralStateConnecting:
            connected = @"正在连接";
            break;
        case CBPeripheralStateConnected:
            connected = @"已连接";
            break;
        case CBPeripheralStateDisconnecting:
            connected = @"正在断开连接";
            break;
    }
    return connected;
}


#pragma mark - 连接某个周边设备
+ (void)connectToPeripheral:(CBPeripheral *)peripheral{
    [[JKBLECentralManager sharedJKBLECentralManager] connectToPeripheral:peripheral];
}
- (void)connectToPeripheral:(CBPeripheral *)peripheral{
    // 一个中心设备可以同时连接多个周边设备
    [self.centralManager connectPeripheral:peripheral options:nil];
}


#pragma mark - 与某个周边设备断开连接
+ (void)disconnectWithPeripheral:(CBPeripheral *)peripheral{
    [[JKBLECentralManager sharedJKBLECentralManager] disconnectWithPeripheral:peripheral];
}

/**    1.不能获取数据时断开连接，2.获取完所有需要的数据断开连接，已减少电池损耗    */
- (void)disconnectWithPeripheral:(CBPeripheral *)peripheral{
    [self.centralManager cancelPeripheralConnection:peripheral];
    
    if ([self.connectedPeripherals containsObject:peripheral]) {
        [self.connectedPeripherals removeObject:peripheral];
        peripheral.delegate = nil;
    }
    
    
    [self clearPropertyCache];
    
    [self invalidateTimer];
}


- (void)clearPropertyCache{
    _currentPeripheral = nil;
    
    _serviceUUID = nil;
    _service_Short_UUID = nil;
    
    _characteristicUUIDArray = nil;
    
    _characteristic_Notifiy_Short_UUID = nil;
    _characteristic_Writable_Short_UUID = nil;
    
    _notifyCharacteristic = nil;
    _writaleCharacteristic = nil;
}


#pragma mark - 断开所有的连接
+ (void)cancelAllPeripheralConnection{
    [[JKBLECentralManager sharedJKBLECentralManager]cancelAllPeripheralConnection];
}
- (void)cancelAllPeripheralConnection{
    for (CBPeripheral * peripheral in self.connectedPeripherals) {
        [self.centralManager cancelPeripheralConnection:peripheral];
    }
    [self.connectedPeripherals removeAllObjects];
}

#pragma mark - 重新连接,最好走下面3步骤，而不是直接走扫描
+ (void)retryConnectToPeripheralWithUUIDString:(NSString *)UUIDString{
    [[JKBLECentralManager sharedJKBLECentralManager] retryConnectToPeripheralWithUUIDString:UUIDString];
}


- (void)retryConnectToPeripheralWithUUIDString:(NSString *)UUIDString{
    CBUUID * UUID = [CBUUID UUIDWithString:UUIDString];
    
    self.retryConnectTimes ++;
    
    //  匹配UUID，判断是不是我们想要重连的UUID
    BOOL (^matchingWithRetrievePeripherals)(NSArray <CBPeripheral *>*) = ^(NSArray <CBPeripheral *>* retrievePeripherals){
        BOOL boolValue = retrievePeripherals && retrievePeripherals.count;
        BOOL boolValue_copy = NO;
        if (boolValue) {
            for (CBPeripheral * peripheral in retrievePeripherals) {
                if ([peripheral.identifier isEqual:UUID]) {
                    boolValue_copy = YES;
                }
            }
        }
        return boolValue_copy;
    };
    
    
    //  步骤1.调用retrievePeripheralsWithIdentifiers,传保存的UUID数组，如果数组为空，尝试步骤2，\
        不为空则让用户选择连接某个CBPeripheral,如果连接不上，则重新扫描
    NSArray <CBPeripheral *>* retrievePeripherals = [self.centralManager retrievePeripheralsWithIdentifiers:self.connectedPeripheralIdentifies.copy];
    
    
    BOOL boolValue = matchingWithRetrievePeripherals(retrievePeripherals);
    
    if (boolValue) {
        [self connectToPeripheral:retrievePeripherals.firstObject];
        
    //  步骤2.调用retrieveConnectedPeripheralsWithServices，传服务UUID数组，如果数组为空，重新扫描，\
        不为空，让用户选择连接某个CBPeripheral,如果连接不上，则重新扫描
    }else{
        retrievePeripherals = [self.centralManager retrieveConnectedPeripheralsWithServices:@[_serviceUUID,_service_Short_UUID]];
        boolValue = matchingWithRetrievePeripherals(retrievePeripherals);
        
        if (boolValue) {
            [self connectToPeripheral:retrievePeripherals.firstObject];
        }else{
            
            //  步骤3.重新扫描
            if (self.centralManager.isScanning) {
                [self.centralManager stopScan];
            }
            [self stateScanPeripheral];
        }
    }
}

#pragma mark - 中央设备CBCentralManagerDelegate

/**    状态发生更改    */
- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    JKLog(@"1.本地蓝牙-中心设备-状态更改");
    if ([JKBLECentralManager checkBLECentralManagerState]) {
        
        
        NSArray * serviceUUIDArray = _serviceUUID ? @[_serviceUUID,_service_Short_UUID]: nil;
        [central scanForPeripheralsWithServices:serviceUUIDArray options:@{CBCentralManagerScanOptionAllowDuplicatesKey:@(YES)}];
    }else{
        JKLog(@"提示用户打开蓝牙并授权APP使用");
    }
}


/**    dict包含了应用程序关闭是系统保存的central的信息，用dic去恢复central    */
- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary<NSString *, id> *)dict{
    JKLog(@"willRestoreState : %@",dict);
}



/**    发现新周边设备，peripheral必须被强引用，不然会被释放    */
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI{
//    if (peripheral.name == nil) return;
    JKLog(@"3.发现新周边设备：peripheral   %@   %@",peripheral,advertisementData);
    
    NSString * name = advertisementData[@"kCBAdvDataLocalName"];
    if ([name hasPrefix:kEWenJiName]) {
        if ([self.discoveredPeripherals containsObject:peripheral] == NO) {
            // peripheral必须被强引用
            [self.discoveredPeripherals addObject:peripheral];
            
            [central connectPeripheral:peripheral options:nil];
            [self stopScanPeripheral];
        }
    }
    

    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        if ([self.delegate respondsToSelector:@selector(jk_BLECentralManager:didUpdateDiscoveredPeripherals:)]) {
//            [self.delegate jk_BLECentralManager:self didUpdateDiscoveredPeripherals:self.discoveredPeripherals.copy];
//        }
//    });
    
    // 链接外设
    //    [self.centralManager connectPeripheral:peripheral options:@{CBConnectPeripheralOptionNotifyOnDisconnectionKey : @(YES)}];
}

/**    连接周边设备_B失败    */
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error{
    JKLog(@"5.连接周边设备失败 %@   \n%@",peripheral,error);
    [self updateConnectedPeripherals];
    
    
    //  重连步骤1.1,连接失败则重新扫描
    if (self.retryConnectTimes > 0) {
        if (self.centralManager.isScanning) {
            [self.centralManager stopScan];
        }
        [self stateScanPeripheral];
    }
}


/**    已经连接到周边设备_B   */
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    JKLog(@"5.已连接周边设备%@",peripheral);
    if ([self.connectedPeripherals containsObject:peripheral] == NO) {
        [self.connectedPeripherals addObject:peripheral];
    }
    
    // 重连成功则复位
    self.retryConnectTimes = 0;
    
    // 保存连接过的peripheral的UUID(不删除)，用于重新连接
    if ([self.connectedPeripheralIdentifies containsObject:peripheral.identifier]) {
        [self.connectedPeripheralIdentifies addObject:peripheral.identifier];
    }
    
    /* ⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️
     当扫描到需要的peripheral或者连接到需要的peripheral后停止扫描，最好是扫描到就停止
     ⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️*/
    
    [self stopScanPeripheral];
    [self updateConnectedPeripherals];
    
    
    // 设置peripheral.delegate并查找peripheral中的服务和特征值
    peripheral.delegate = self;
    _currentPeripheral = peripheral;
    
    // ⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️
    // 传nil代表查询所有服务，传特定的UUID则可查询特定的服务
    // 查询所有服务会损耗电量，最好是需要什么传什么UUID
    // ⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️
    
    [peripheral discoverServices:@[_serviceUUID]];
    // 会触发代理方法@selector(peripheral:didDiscoverServices:)
}




/**    和周边设备_B断开连接    */
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error{
    [self.connectedPeripherals removeObject:peripheral];
    JKLog(@"6.和周边设备断开连接%@  \n%@",peripheral,error);
    [self updateConnectedPeripherals];
    
    
    // 重新连接
    [self retryConnectToPeripheralWithUUIDString:peripheral.identifier.UUIDString];
}




/**    更新代理    */
- (void)updateConnectedPeripherals{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(jk_BLECentralManager:didUpdateDiscoveredPeripherals:)]) {
            [self.delegate jk_BLECentralManager:self didUpdateDiscoveredPeripherals:self.discoveredPeripherals.copy];
        }
        
        if ([self.delegate respondsToSelector:@selector(jk_BLECentralManager:didUpdateConnections:)]) {
            [self.delegate jk_BLECentralManager:self didUpdateConnections:self.connectedPeripherals.copy];
        }
    });
}

#pragma mark - 周边设备CBPeripheralDelegate

/**    查找到周边设备的服务service    */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    if (error) {
        JKLog(@"7.查找周边设备广播的服务出错%@",error.localizedDescription);
        [self disconnectWithPeripheral:peripheral];
        return;
    }
    
    JKLog(@"7.查找某个周边设备广播的服务 %@",peripheral.services);
    for (CBService * service in peripheral.services) {
        if ([_service_Short_UUID isEqual:service.UUID]) {
            [peripheral discoverCharacteristics:_characteristicUUIDArray forService:service];
        }
    }
    
    // 服务有service UUID  ，特征有characteristics UUID
    
    // ⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️
    // 查询感兴趣的（特定）服务的特征characteristics，最好是需要什么传什么UUID
    // CBUUID数组指的是在这些UUID中的特征,nil代表查找此service的所有的characteristics
    // ⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️
    
    
    // [peripheral discoverCharacteristics:nil forService:peripheral.services.firstObject];
    // 会触发代理方法@selector(peripheral:didDiscoverCharacteristicsForService:error:)
}

/**    查询某个服务中的特征characteristic    */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(nonnull CBService *)service error:(nullable NSError *)error{
    if (error) {
        JKLog(@"8.查找周边设备的服务_特征出错%@",error.localizedDescription);
        [self disconnectWithPeripheral:peripheral];
        return;
    }
    
    JKLog(@"8.0.查找某个周边设备的某个广播服务的特征：%@",service.characteristics);
    for (CBCharacteristic * characteristic in service.characteristics) {
        if ([characteristic.UUID isEqual:_characteristic_Notifiy_Short_UUID]) {
            _notifyCharacteristic = characteristic;
            if (characteristic.properties == CBCharacteristicPropertyNotify) {
                [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            }
            // 先订阅读值，再决定要不要写数据
        }else if ([characteristic.UUID isEqual:_characteristic_Writable_Short_UUID]){
            _writaleCharacteristic = characteristic;
        }else{
            JKLog(@"8.1.不是我们想要的特征");
        }
    }
    
    
//    CBCharacteristic * characteristic = service.characteristics.firstObject;
    
    /* ⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️
    readValueForCharacteristic: 和setNotifyValue:YES forCharacteristic都能读值
     最佳实践是尽可能使用订阅。
    ⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️*/

    // 如果有感兴趣的characteristic,可以进行读值（先判断是否可读），读值适合读取一次数据，多次读取characteristic的数据变化则需要进行订阅监听，并且判断characteristic是否支持被订阅
    // 可先判断是否可读，不然会在下一个代理方法中返回error
//    if (characteristic.properties == CBCharacteristicPropertyRead) {
//        [peripheral readValueForCharacteristic:characteristic];
//         // 会触发@selector(peripheral:didUpdateValueForCharacteristic:error:)
//    }
    
    // 订阅某个characteristic的数据变化
//    else if (characteristic.properties == CBCharacteristicPropertyNotify) {
//        [peripheral setNotifyValue:YES forCharacteristic:characteristic];
//        // 订阅、取消订阅都会触发@selector(peripheral:didUpdateNotificationStateForCharacteristic:error:)
//        
//    }
    
    // 写入characteristic值,某些场景需要给characteristic写入预设值,CBCharacteristicWriteWithResponse代表需要响应写值结果，会调用
//    else if (characteristic.properties == CBCharacteristicPropertyWrite) {
//        [peripheral writeValue:[NSData data] forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
//        // 会调用 @selector(peripheral:didWriteValueForCharacteristic:error:)
//    }
    
    
//    else{
//        JKLog(@"characteristic不可读、不可订阅、不可写，characteristic.properties = %zd",characteristic.properties);
//    }
}

/**    订阅characteristic的状态发生改变的相应方法    */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    if (error) {
        JKLog(@"8.5.订阅characteristic失败：%@  %@",characteristic.UUID.UUIDString,error.localizedDescription);
        // 取消订阅
        [peripheral setNotifyValue:NO forCharacteristic:characteristic];
    }else{
        JKLog(@"8.5.订阅某个特征的状态发生改变:%@ \n value %@",characteristic, characteristic.value);
        // 和readValueForCharacteristic一样都会触发@selector(peripheral:didUpdateValueForCharacteristic:error:)
        // readValueForCharacteristic是主动读值，订阅则是在数据变化时被动接收
        
        
        if ([_characteristicUUIDArray containsObject:characteristic.UUID]) {
            if (characteristic.isNotifying) {
                if (characteristic.properties == CBCharacteristicPropertyRead) {
                    [peripheral readValueForCharacteristic:characteristic];
                }
            }else{
                [self disconnectWithPeripheral:peripheral];
            }
            
            if (!_didReceived_Zero_Zero_Packet && !_sendDataTimer) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.sendDataTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(repeatToSendZeroZeroPacket) userInfo:nil repeats:YES];
                    [self.sendDataTimer fire];
                });
            }
        }
        
    }
}

/**    读取某个characteristic的值    */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(nonnull CBCharacteristic *)characteristic error:(nullable NSError *)error{
    if (error) {
        JKLog(@"9.characteristic读值失败: %@  %@",characteristic.UUID.UUIDString,error.localizedDescription);
        // 取消订阅
        [peripheral setNotifyValue:NO forCharacteristic:characteristic];
    }else{
        NSData * data = characteristic.value;
        JKLog(@"9.读取某个特征的值/订阅某个特征后值发生改变：characteristic：%@ ",characteristic);
        [self analysisPacket:data];

        
        /* ⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️
         为了节省电池损耗，提高性能，以下情况可以结束订阅并且断开连接
         1.已经从peripheral上获取所有需要的值
         2.peripheral订阅的所有 characteristic 值都已停止广播，isNotifying可以判断是否在广播
         ⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️*/
        
        if (characteristic.isNotifying == NO) {
            [peripheral setNotifyValue:NO forCharacteristic:characteristic];
            [self.centralManager cancelPeripheralConnection:peripheral];
        }
    }
}


/**    写入characteristic值的响应方法，    */
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    if (error) {
        JKLog(@"写入characteristic值出错： %@",error.localizedDescription);
    }else{
//        JKLog(@"已经对characteristic完成写值%@",characteristic);
    }
}


#pragma mark - 发送数据包

- (void)invalidateTimer{
    if (self.sendDataTimer) {
        [self.sendDataTimer invalidate];
        self.sendDataTimer = nil;
    }
}





/**    00-查询包    */
- (void)repeatToSendZeroZeroPacket{
    if (_writaleCharacteristic == nil) {
        return;
    }
    
    
    NSData * zeraPackageData = [self assembleDatePackageWithDateTime:[self getDateTimeByte]
                                                              cmdNum:0x00
                                                          totalLenth:14];
    [_currentPeripheral writeValue:zeraPackageData
                 forCharacteristic:_writaleCharacteristic
                              type:CBCharacteristicWriteWithResponse];
    JKLog(@"发送Zera-Zero数据包 %@",zeraPackageData);
}


/**    03-确认收到数据    */
- (void)sendZeroThreePacket{

    
    NSData * zeraPackageData = [self assembleDatePackageWithDateTime:nil
                                                              cmdNum:0x03
                                                          totalLenth:8];
    [_currentPeripheral writeValue:zeraPackageData
                 forCharacteristic:_writaleCharacteristic
                              type:CBCharacteristicWriteWithResponse];
    JKLog(@"发送Zera-Three数据包 %@",zeraPackageData);
}


/**    04-确认结束    */
- (void)sendZeroFourPacket{
    [self invalidateTimer];
    
    NSData * zeraPackageData = [self assembleDatePackageWithDateTime:nil
                                                              cmdNum:0x04
                                                          totalLenth:10];
    
    
    [_currentPeripheral writeValue:zeraPackageData
                 forCharacteristic:_writaleCharacteristic
                              type:CBCharacteristicWriteWithoutResponse];
    JKLog(@"发送Zera-Four数据包 %@",zeraPackageData);
}




#pragma mark - 数据包拼接

/**    拼接日期子包    */
- (NSData *)getDateTimeByte{
    NSString * dateTime = [self.formatter stringFromDate:[NSDate date]];
    Byte dateTimeByte[6];
    for (NSInteger index = 0; index < 6; index ++) {
        NSString * timeStr = [dateTime substringWithRange:NSMakeRange(index*2, 2)];
//        NSScanner * scanner = [[NSScanner alloc]initWithString:timeStr];
//        unsigned int timeNum;
//        [scanner scanHexInt:&timeNum];
        dateTimeByte[index] = timeStr.integerValue;
    }
    return [[NSData alloc]initWithBytes:dateTimeByte length:6];
}


/**    拼接数据包（总API）    */
- (NSData *)assembleDatePackageWithDateTime:(NSData *)dateTime
                                     cmdNum:(unsigned int)cmdNum
                                 totalLenth:(NSInteger)totalLenth{
    
    Byte assembleByte[totalLenth];
    assembleByte[0] = 0x7f;
    assembleByte[1] = totalLenth / 256;
    assembleByte[2] = totalLenth % 256;
    assembleByte[3] = 0x01;
    assembleByte[4] = 0x01;
    assembleByte[5] = cmdNum;
    
    
    unsigned int checksum = assembleByte[0] + assembleByte[1] + assembleByte[2] + assembleByte[3] + assembleByte[4] + assembleByte[5];
    
    if (dateTime && dateTime.length) {
        Byte * dateTimeByte = (Byte *)[self getDateTimeByte].bytes;
        for (NSInteger index = 0; index < dateTime.length; index ++) {
            assembleByte[6 + index] = dateTimeByte[index];
            checksum += assembleByte[6 + index];
        }
    }
    checksum += 0x8f;
    assembleByte[totalLenth - 2] = checksum % 256;
    assembleByte[totalLenth - 1] = 0x8f;
    
    return [[NSData alloc]initWithBytes:assembleByte length:totalLenth];
}


#pragma mark - 数据包解析

/**    解析数据库（总入口）    */
- (void)analysisPacket:(NSData *)packet{
    // 无临时数据
    if (self.tempContentData.length == 0) {

        [self.tempContentData appendData:packet];
        
        Byte * packetByte = (Byte *)packet.bytes;
        if (packet.length < packetByte[2] && packetByte[7] == 0x00) {
            JKLog(@"收到残缺00包");
        }
        
    // 有临时数据
    }else{
        Byte * tempByte = (Byte *)self.tempContentData.bytes;
        Byte * packetByte = (Byte *)packet.bytes;
        
        if (self.tempContentData.length < tempByte[2]) {
            [self.tempContentData appendData:packet];
            
            if (self.tempContentData.length == tempByte[2]) {
                if (tempByte[7] == 0x00) {
                    [self invalidateTimer];
                    _didReceived_Zero_Zero_Packet = YES;
                    
                    
                    // 计算设备SN号
                    tempByte = (Byte *)self.tempContentData.bytes;
                    Byte SNCodeByte[16];
                    for (NSInteger i = 0; i < 16; i++) {
                        SNCodeByte[i] = tempByte[10 + i];
                    }
                    
                    NSData * data = [[NSData alloc] initWithBytes:SNCodeByte length:16];
                    NSString * SNCodeString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    JKLog(@"收到完整00包-提示用户开始测量-设备SN号:%@",SNCodeString);
                }
            }
            
            
        }else if (packet.length == packetByte[2]){
            self.tempContentData.length = 0;
            [self.tempContentData appendData:packet];
            
            if (packetByte[7] == 0x03) {
                _didReceived_Zero_Three_Packet = YES;
                [self sendZeroThreePacket];
                
                
                // 计算温度
                NSInteger count1 = packetByte[8];
                NSInteger count2 = packetByte[9];
                CGFloat temperature = (count1 * 256.0 + count2)/100.0;
                
                JKLog(@"收到03包:温度:%.1f",temperature);
                
            }else if (packetByte[7] == 0x04){
                _didReceived_Zero_Four_Packet = YES;
                [self disconnectWithPeripheral:_currentPeripheral];
                
                JKLog(@"收到04包");
            }
            
        }else{
            JKLog(@"数据包结构有问题");
        }
    }
    
    JKLog(@"临时容器:%@    \n  收到的包:%@",self.tempContentData,packet);
}



/**    

 不完整的包<7f001c01 00a15a00 0f0c5246 46413135 303730>，有临时容器接收
 和前面的包拼接，一起存入临时容器<33303030 303135b6 8f>
 拼接后<7f001c01 00a15a00 0f0c5246 46413135 30373033 30303030 3135b68f>
 
 结束定时器—停止发送00包
 
 NSNumber *type = [NSNumber numberWithInteger:byte[4]];
 NSNumber *year = [NSNumber numberWithInteger:byte[8]];
 NSNumber *month = [NSNumber numberWithInteger:byte[9]];
 
 再取10-26的数据，拼接成包—即产品SN号：RFFA150703000015
 
 提示开始测量
 
 释放临时容器
 
 
 收到03包
 <7f000c01 00a15a03 ee01088f>
 
 NSNumber *temperature = [NSNumber numberWithFloat:(count1 * 256 + count2)];
 再除100得到温度
 
 
 发送03包,确认收到数据
 
 收到04包,确认结束
 
 */
@end
