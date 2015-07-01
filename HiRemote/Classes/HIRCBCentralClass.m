//
//  HIRCBCentralClass.m
//  HiRemote
//
//  Created by parker on 6/29/15.
//  Copyright (c) 2015 hiremote. All rights reserved.
//

#import "HIRCBCentralClass.h"


@interface HIRCBCentralClass () <CBCentralManagerDelegate, CBPeripheralDelegate>
@property (strong, nonatomic) NSMutableArray *peripheralsMArray;
@property (nonatomic, assign) BOOL isScanningPeripherals;
@end


@implementation HIRCBCentralClass
@synthesize centralManager;
@synthesize discoveredPeripheral;
@synthesize peripheralsMArray;

- (id)init {
    self = [super init];
    if (self) {
        self.peripheralsMArray = [NSMutableArray arrayWithCapacity:5];
        self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        _isScanningPeripherals = NO;
    }
    return self;
}


+ (HIRCBCentralClass *)shareHIRCBcentralClass {
    static HIRCBCentralClass *shareHIRCBCentralClass = nil;
    static dispatch_once_t _theOnce;
    dispatch_once(&_theOnce, ^{
        shareHIRCBCentralClass = [[HIRCBCentralClass alloc] init];
    });
    
    return shareHIRCBCentralClass;
}

- (void)scanPeripheral {
    if (_isScanningPeripherals) {
        return;
    }
   // if (self.centralManager.state == CBCentralManagerStatePoweredOn) {
        _isScanningPeripherals = YES;
        NSArray	*uuidArray	= [NSArray arrayWithObjects:[CBUUID UUIDWithString:SPARK_ANTILOST_BLE_UUID_IMMEDIATE_ALERT_SERVICE],[CBUUID UUIDWithString:SPARK_ANTILOST_BLE_UUID_LINK_LOSS_SERVICE],[CBUUID UUIDWithString:SPARK_ANTILOST_POWER_COMMUNICATE_SERVICE], [CBUUID UUIDWithString:SPARK_ANTILOST_KEY_SERVICE], nil];
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], CBCentralManagerScanOptionAllowDuplicatesKey, nil];
        [self.centralManager scanForPeripheralsWithServices:uuidArray options:options];
   // }
}


#pragma mark - CBCentralManagerDelegate
//开始查看服务，蓝牙开启
-(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    NSLog(@"centrr:%ld",central.state);
    ///表示蓝牙可用
    if (central.state == CBCentralManagerStatePoweredOn) {
        
    }else {
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter postNotificationName:HIR_CBSTATE_CHANGE_NOTIFICATION_NAME object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:CBCENTERAL_STATE_NOT_SUPPORT,@"state", nil]];

    }

}

//查到外设后，停止扫描，连接设备
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"per:%@, SSI:%d, uuid:%@, data:%@",peripheral,RSSI,peripheral.identifier,advertisementData);

}

//连接外设成功，开始发现服务
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    NSLog(@"connect:%@  %@",peripheral,peripheral.identifier);
   
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter postNotificationName:HIR_CBSTATE_CHANGE_NOTIFICATION_NAME object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:CBCENTERAL_CONNECT_PERIPHERAL_SUCCESS, @"state", nil]];
}

//连接外设失败
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"%@",error);
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter postNotificationName:HIR_CBSTATE_CHANGE_NOTIFICATION_NAME object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:CBCENTERAL_CONNECT_PERIPHERAL_FAIL,@"state", nil]];
}

-(void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error
{
    //NSLog(@"%s,%@",__PRETTY_FUNCTION__,peripheral);
    int rssi = abs([peripheral.RSSI intValue]);
    CGFloat ci = (rssi - 49) / (10 * 4.);
    NSString *length = [NSString stringWithFormat:@"发现BLT4.0热点:%@,距离:%.1fm",peripheral,pow(10,ci)];
    NSLog(@"距离：%@",length);
}
//已发现服务
-(void) peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    
    int i=0;
    for (CBService *s in peripheral.services) {
        NSLog(@"discover server:%d  s.uuid:%@",i,s.UUID);
        i++;
        [peripheral discoverCharacteristics:nil forService:s];
    }
}

//已搜索到Characteristics
-(void) peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    NSLog(@"discover22 server s.uuid:%@",service.UUID);
    for (CBCharacteristic *c in service.characteristics) {
        NSLog(@"discover c.uuid:%@",c.UUID);
        if ([c.UUID isEqual:[CBUUID UUIDWithString:@"2A06"]]) {
           // _writeCharacteristic = c;
        }
        if ([c.UUID isEqual:[CBUUID UUIDWithString:@"2A19"]]) {
           // [_peripheral readValueForCharacteristic:c];
        }
        
        if ([c.UUID isEqual:[CBUUID UUIDWithString:@"FFA1"]]) {
          //  [_peripheral readRSSI];
        }
      //  [_nCharacteristics addObject:c];
    }
}


//获取外设发来的数据，不论是read和notify,获取数据都是从这个方法中读取。
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    // BOOL isSaveSuccess;
    
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A19"]]) {
        NSString *value = [[NSString alloc]initWithData:characteristic.value encoding:NSUTF8StringEncoding];
        float batteryValue = [value floatValue];
        NSLog(@"电量%f",batteryValue);
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFA1"]]) {
        NSString *value = [[NSString alloc]initWithData:characteristic.value encoding:NSUTF8StringEncoding];
        //_batteryValue = [value floatValue];
        NSLog(@"信号%@",value);
    }
    
    else
        NSLog(@"didUpdateValueForCharacteristic%@",[[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding]);
}

//中心读取外设实时数据
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
        NSLog(@"Error changing notification state: %@", error.localizedDescription);
    }
    // Notification has started
    if (characteristic.isNotifying) {
        [peripheral readValueForCharacteristic:characteristic];
        
    } else { // Notification has stopped
        // so disconnect from the peripheral
        NSLog(@"Notification stopped on %@.  Disconnecting", characteristic);
       // [self.manager cancelPeripheralConnection:self.peripheral];
    }
}
//用于检测中心向外设写数据是否成功
-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"=======%@",error.userInfo);
    }else{
        NSLog(@"发送数据成功");
    }
}


- (void)dealloc {
    self.peripheralsMArray = nil;
    self.centralManager = nil;
}
@end
