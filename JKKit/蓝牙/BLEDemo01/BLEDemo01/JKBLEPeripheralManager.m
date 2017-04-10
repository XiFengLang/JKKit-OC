//
//  JKBLEPeripheralManager.m
//  BLEDemo01
//
//  Created by 蒋鹏 on 16/8/31.
//  Copyright © 2016年 蒋鹏. All rights reserved.
//

#import "JKBLEPeripheralManager.h"
static const char * PeripheralManagerDelegateQueueKey = "PeripheralManagerDelegateQueueKey";


@interface JKBLEPeripheralManager ()<CBPeripheralManagerDelegate>


@property (nonatomic, strong)CBPeripheralManager * peripheralManager;
@property (nonatomic, strong)CBMutableService * firstService;
@property (nonatomic, strong)CBMutableCharacteristic * characteristic;
@end

@implementation JKBLEPeripheralManager
JKSharedSingletonMethod_Implementation(JKBLEPeripheralManager)

- (instancetype)init{
    if (self = [super init]) {
        dispatch_queue_t delegateQueue = dispatch_queue_create(PeripheralManagerDelegateQueueKey, DISPATCH_QUEUE_SERIAL);
        self.peripheralManager = [[CBPeripheralManager alloc]initWithDelegate:self queue:delegateQueue];

        
        // peripheral上的services 和 characteristics属于树状结构，即peripheral包括services和characteristics，而services又能包含services和characteristics
        // services 和 characteristics 通过128位的蓝牙特定 UUID 来标识,
        // 部分service或characteristic的UUID都被 Bluetooth Special Interest Group (Bluetooth SIG) 预定义过，为了便于使用这些 [通用UUID] 已被缩短为16位，比如标识心率service的UUID为180D
        
        
        CBUUID * serviceUUID = [CBUUID UUIDWithString:@"A7E77A31-748B-4D4A-93A0-BDAB264DD9F1"];
        // [CBUUID UUIDWithString:@"180D"];
        
        // primary代表是主要service还是次要service
        CBMutableService * firstService = [[CBMutableService alloc]initWithType:serviceUUID primary:YES];
        self.firstService = firstService;
        
        
        CBUUID * charactUUID = [CBUUID UUIDWithString:@"51DB1FD1-7E10-41C1-B16F-4430B506CDE7"];
        NSData * data = [@"JK特征" dataUsingEncoding:NSUTF8StringEncoding];
        
        // 若为 characteristic指定了一个值value，这个值会被缓存且它的属性和权限会被设置为可读,如果值可写或广播过程中会改变,value必须传值nil,每当它收到从已连接 central 发来的读或写请求,遵循这一条可以保证这个值会被动态处理.
        // properties：读写订阅等属性，permissions：(加密)可读/写
    
        CBMutableCharacteristic * characteristic = [[CBMutableCharacteristic alloc]initWithType:charactUUID properties:CBCharacteristicPropertyRead value:data permissions:CBAttributePermissionsReadable];
        self.characteristic = characteristic;
        
        // 1.构建 services 和 characteristics 树
        firstService.characteristics = @[characteristic];
        
        // 2.发布到设备的 services 和 characteristics 数据库中,这个service被将缓存且不能再对其做修改。
        // 3.发布成功则广播(多个)服务
        [self.peripheralManager addService:firstService];
        
        
    }return self;
}


/**    检查BLE可用状态    */
- (BOOL)checkBLEPeripheralManagerState{
    BOOL BLEAvailable = NO;
    NSMutableString * localDeacription = [NSMutableString stringWithString:@"本地蓝牙-中心设备-"];
    switch (self.peripheralManager.state) {
        case CBPeripheralManagerStateUnknown:{
            [localDeacription appendString:@"未知状态"];
        }break;
        case CBPeripheralManagerStateResetting:{
            [localDeacription appendString:@"正在重新设置蓝牙"];
        }break;
        case CBPeripheralManagerStateUnsupported:{
            [localDeacription appendString:@"当前设备不支持BLE"];
        }break;
        case CBPeripheralManagerStateUnauthorized:{
            [localDeacription appendString:@"用户未授权"];
        }break;
        case CBPeripheralManagerStatePoweredOff:{
            [localDeacription appendString:@"BLE服务已关闭"];
        }break;
        case CBPeripheralManagerStatePoweredOn:{
            BLEAvailable = YES;
            [localDeacription appendString:@"BLE服务已开启"];
        }break;
    }
    
    JKLog(@"2.BLEAvailable = %@  ,  %@",BLEAvailable ? @"YES" : @"NO",localDeacription);
    
    return BLEAvailable;
}


#pragma mark - CBPeripheralManagerDelegate


/**    蓝牙状态更改    */
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral{
    JKLog(@"1.蓝牙状态发生更改%@",peripheral);
    [self checkBLEPeripheralManagerState];
}



/**    添加service回调    */
- (void)peripheralManager:(CBPeripheralManager *)peripheral didAddService:(CBService *)service error:(NSError *)error{
    if (error) {
        NSLog(@"2.添加服务失败:%@",error.localizedDescription);
    }else{
        NSLog(@"2.添加service成功,开始广播：%@",service);
        [self.peripheralManager startAdvertising:@{CBAdvertisementDataServiceUUIDsKey:@[self.firstService.UUID]}];
    }
}


/**    广播service回调，应用在后台时，广播行为也会受到影响    */
- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error{
    if (error) {
        NSLog(@"3.广播service失败:%@",error.localizedDescription);
    }else{
        NSLog(@"3.广播service成功:%@",peripheral);
    }
}


#pragma mark - CBPeripheralManagerDelegate响应中心角色的请求

/**    当中心角色请求读值时，会调用此代理    */
- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveReadRequest:(CBATTRequest *)request{
    if ([request.characteristic.UUID isEqual:self.characteristic.UUID]) {
        // 若 characteristic 的 UUID 匹配，下一步是确保这个读取请求的读取的地址范围没有超出 characteristic 值的边界
        if (request.offset > self.characteristic.value.length) {
            [self.peripheralManager respondToRequest:request
                                          withResult:CBATTErrorInvalidOffset];
            return;
        }else{
            request.value = [self.characteristic.value subdataWithRange:NSMakeRange(request.offset,self.characteristic.value.length - request.offset)];
        }
        // 必须保证在每次 peripheralManager:didReceiveReadRequest: delegate 方法被调用时，只调用一次 respondToRequest:withResult: 方法。
        [peripheral respondToRequest:request withResult:CBATTErrorSuccess];
    }else{
        // 如果UUID不匹配，也应该返回一个CBATTError说明原因
        [peripheral respondToRequest:request withResult:CBATTErrorInvalidHandle];
    }
}


/**    收到写值请求    */
- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveWriteRequests:(NSArray<CBATTRequest *> *)requests{
    
    CBATTError writeError = CBATTErrorInvalidHandle;
    for (NSInteger index = 0; index < requests.count; index ++) {
        CBATTRequest * request = requests[index];
        if ([request.characteristic.UUID isEqual:self.characteristic.UUID]) {
            // 若 characteristic 的 UUID 匹配，下一步是确保这个读取请求的读取的地址范围没有超出 characteristic 值的边界
            if (request.offset > self.characteristic.value.length) {
                [self.peripheralManager respondToRequest:request
                                              withResult:CBATTErrorInvalidOffset];
                return;
            }else{
                self.characteristic.value = request.value;
                writeError = CBATTErrorSuccess;
            }
        }else{
            // 如果任何一个请求无法完成，都不应该去完成其它任何一个。而是，立即调用 respondToRequest:withResult: 方法，提供指示了错误原因的返回结果
            writeError = CBATTErrorInvalidHandle;
            [peripheral respondToRequest:request withResult:writeError];
            return;
        }
    }
    
    // 只有全部全部写入成功，再返回成功,收到的数组不止一个请求,应该传入数组的第一个请求对象，如下：
    [peripheral respondToRequest:requests.firstObject withResult:writeError];
}


/**    当一个已连接的 central 订阅了你的 characteristic 值之一时，会调用此方法    */
- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didSubscribeToCharacteristic:(CBCharacteristic *)characteristic{
    NSData * updateValue = self.characteristic.value;
    if (updateValue) {
        // onSubscribedCentrals 发送新值给订阅者，Nil:已连接的且已订阅的 central 都将被更新
        [peripheral updateValue:updateValue forCharacteristic:self.characteristic onSubscribedCentrals:nil];
        
        // 如果传输更新值所用的下层队列已满，这个方法返回 NO。peripheral manager 于是会等到传输队列有可用空间时，调用它的 delegate 对象的 peripheralManagerIsReadyToUpdateSubscribers: 方法
    }
}


/**    updateValue失败时调用，见上一个方法解说    */
- (void)peripheralManagerIsReadyToUpdateSubscribers:(CBPeripheralManager *)peripheral{
    NSData * updateValue = self.characteristic.value;
    if (updateValue) {
        [peripheral updateValue:updateValue forCharacteristic:self.characteristic onSubscribedCentrals:nil];
    }
}

@end
