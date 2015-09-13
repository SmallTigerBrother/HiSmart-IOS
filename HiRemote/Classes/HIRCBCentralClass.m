//
//  HIRCBCentralClass.m
//  HiRemote
//
//  Created by parker on 6/29/15.
//  Copyright (c) 2015 hiremote. All rights reserved.
//

#import "HIRCBCentralClass.h"
//#import "HIRRemoteData.h"
#import "HirMsgPlaySound.h"
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"
#import "HirDataManageCenter+Perphera.h"

@interface HIRCBCentralClass () <CBCentralManagerDelegate, CBPeripheralDelegate>
@property (strong, nonatomic) NSString *theChangeUuid;
@property (nonatomic, assign) BOOL isScanningPeripherals;
@end


@implementation HIRCBCentralClass
@synthesize centralManager;
@synthesize discoveredPeripheral;
@synthesize alertImmediateCharacter;
@synthesize alertLossCharacter;
@synthesize firePowerCharacter;
@synthesize batteryCharacter;
@synthesize searchPhoneCharacter;
@synthesize theAddNewNeedToAvoidLastUuid;

- (id)init {
    self = [super init];
    if (self) {
        self.discoveredPeripheral = nil;
        self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        _theChangeUuid = nil;
        self.theAddNewNeedToAvoidLastUuid = nil;
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



- (void)scanPeripheral:(NSString *)uuid {
    self.theChangeUuid = uuid;
    ///蓝牙关闭的
    if (self.centralManager.state != CBCentralManagerStatePoweredOn) {
        [self stopCentralManagerScan];
        return;
    }

    if (_isScanningPeripherals) {
        [self stopCentralManagerScan];
        self.discoveredPeripheral.delegate = nil;
        self.discoveredPeripheral = nil;
    }
    
    _isScanningPeripherals = YES;
    NSArray	*uuidArray	= [NSArray arrayWithObjects:[CBUUID UUIDWithString:SPARK_ANTILOST_BLE_UUID_IMMEDIATE_ALERT_SERVICE],[CBUUID UUIDWithString:SPARK_ANTILOST_BLE_UUID_LOSS_ALERT_SERVICE],[CBUUID UUIDWithString:SPARK_ANTILOST_BLE_UUID_POWER_SERVICE],[CBUUID UUIDWithString:SPARK_ANTILOST_BLE_UUID_BATTERY_SERVICE],[CBUUID UUIDWithString:SPARK_ANTILOST_BLE_UUID_SEARCHPHONE_SERVICE], nil];
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], CBCentralManagerScanOptionAllowDuplicatesKey, nil];
    [self.centralManager scanForPeripheralsWithServices:uuidArray options:options];
}

-(void)stopCentralManagerScan
{
    NSLog(@"stooooooooop");
    [self.centralManager stopScan];
    _isScanningPeripherals = NO;
}

- (void)cancelConnectionWithPeripheral:(CBPeripheral *)peripheral {
    [self cleanDiscoveredPeripheral];
    self.discoveredPeripheral.delegate = nil;
    self.discoveredPeripheral = nil;
    self.theChangeUuid = nil;
}

#pragma mark - CBCentralManagerDelegate
//开始查看服务，蓝牙开启
-(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    ///表示蓝牙可用
    if (central.state == CBCentralManagerStatePoweredOn) {
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter postNotificationName:NEED_SCANNING_WHEN_BTOPEN_NOTIFICATION object:nil userInfo:nil];
    }else {
        [self stopCentralManagerScan];
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter postNotificationName:HIR_CBSTATE_CHANGE_NOTIFICATION object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:CBCENTERAL_STATE_NOT_SUPPORT,@"state", nil]];
        
        if (self.discoveredPeripheral) {
            [self stopCentralManagerScan];
            self.discoveredPeripheral.delegate = nil;
            self.discoveredPeripheral = nil;
            [notificationCenter postNotificationName:NEED_DISCONNECT_LOCATION_NOTIFICATION object:nil userInfo:nil];
        }
    }
}

//查到外设后，停止扫描，连接设备
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"per:%@, SSI:%d, uuid:%@, data:%@",peripheral,[RSSI intValue],peripheral.identifier,advertisementData);
    NSLog(@"changage：%@---avoid:%@",self.theChangeUuid,self.theAddNewNeedToAvoidLastUuid);
    if ([self.theChangeUuid length] > 0 && ![[peripheral.identifier UUIDString] isEqualToString:self.theChangeUuid]) {
        return;
    }
    
    if ([self.theAddNewNeedToAvoidLastUuid length] > 0 && [[peripheral.identifier UUIDString] isEqualToString:self.theAddNewNeedToAvoidLastUuid]) {
        return;
    }
    [self stopCentralManagerScan];
    self.discoveredPeripheral = peripheral;
    [self.centralManager connectPeripheral:peripheral options:nil];
    
    self.theChangeUuid = nil;
    
}

- (void)centralManager:(CBCentralManager *)central didRetrieveConnectedPeripherals:(NSArray *)peripherals
{
    [self stopCentralManagerScan];
    if(peripherals.count > 0)
    {
        [self.centralManager connectPeripheral:peripherals[0] options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBConnectPeripheralOptionNotifyOnDisconnectionKey]];
        NSLog(@"didRetrieveConnectedPeripheralsperhils is %@",peripherals[0]);
    }
}

//连接外设成功，开始发现服务
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    NSLog(@"connect:%@  %@",peripheral,peripheral.identifier);
    [self stopCentralManagerScan];
    if (self.discoveredPeripheral != peripheral) {
        self.discoveredPeripheral = peripheral;
    }
    self.discoveredPeripheral.delegate = self;
    
    NSString *perUuid = [peripheral.identifier UUIDString];
    
    [HirDataManageCenter insertPerpheraByUUID:perUuid name:peripheral.name remarkName:nil avatarPath:nil battery:nil];
    
    NSArray	*serviceArray = [NSArray arrayWithObjects:[CBUUID UUIDWithString:SPARK_ANTILOST_BLE_UUID_IMMEDIATE_ALERT_SERVICE],[CBUUID UUIDWithString:SPARK_ANTILOST_BLE_UUID_LOSS_ALERT_SERVICE],[CBUUID UUIDWithString:SPARK_ANTILOST_BLE_UUID_POWER_SERVICE],[CBUUID UUIDWithString:SPARK_ANTILOST_BLE_UUID_BATTERY_SERVICE],[CBUUID UUIDWithString:SPARK_ANTILOST_BLE_UUID_SEARCHPHONE_SERVICE], nil];
    
    [peripheral discoverServices:serviceArray];
}

//连接外设失败
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"%@",error);
    self.theChangeUuid = nil;
    [self cleanDiscoveredPeripheral];
    self.discoveredPeripheral.delegate = nil;
    self.discoveredPeripheral = nil;
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter postNotificationName:HIR_CBSTATE_CHANGE_NOTIFICATION object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:CBCENTERAL_CONNECT_PERIPHERAL_FAIL,@"state", nil]];
}

-(void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error
{
    //NSLog(@"%s,%@",__PRETTY_FUNCTION__,peripheral);
    int rssi = abs([peripheral.RSSI intValue]);
    CGFloat ci = (rssi - 49) / (10 * 4.);
    NSString *length = [NSString stringWithFormat:@"发现BLT4.0热点:%@,距离:%.1fm",peripheral,pow(10,ci)];
    NSLog(@"距离：%@",length);
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    self.theChangeUuid = nil;
    [self cleanDiscoveredPeripheral];
    self.discoveredPeripheral.delegate = nil;
    self.discoveredPeripheral = nil;

    NSLog(@"断开连接，要定位");
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
     [notificationCenter postNotificationName:HIR_CBSTATE_CHANGE_NOTIFICATION object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:CBCENTERAL_CONNECT_PERIPHERAL_FAIL,@"state", nil]];
    [notificationCenter postNotificationName:NEED_DISCONNECT_LOCATION_NOTIFICATION object:nil userInfo:nil];
    ///并定位手机
    // We're disconnected, so start scanning again
}


//已发现服务
-(void) peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    if (error) {
        return;
    }
    
    for (CBService *aService in peripheral.services) {
        NSLog(@"sever:%@",aService.UUID);
        /* Immediate Alert */
        if ([aService.UUID isEqual:[CBUUID UUIDWithString:SPARK_ANTILOST_BLE_UUID_IMMEDIATE_ALERT_SERVICE]] || [aService.UUID isEqual:[CBUUID UUIDWithString:SPARK_ANTILOST_BLE_UUID_LOSS_ALERT_SERVICE]] || [aService.UUID isEqual:[CBUUID UUIDWithString:SPARK_ANTILOST_BLE_UUID_POWER_SERVICE]] || [aService.UUID isEqual:[CBUUID UUIDWithString:SPARK_ANTILOST_BLE_UUID_BATTERY_SERVICE]] || [aService.UUID isEqual:[CBUUID UUIDWithString:SPARK_ANTILOST_BLE_UUID_SEARCHPHONE_SERVICE]]){
            
            [peripheral discoverCharacteristics:nil forService:aService];
        }
    }
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter postNotificationName:HIR_CBSTATE_CHANGE_NOTIFICATION object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:CBCENTERAL_CONNECT_PERIPHERAL_SUCCESS, @"state", nil]];
}

//已搜索到Characteristics
-(void) peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    if (error) {
        return;
    }
    
    NSLog(@"========dis char=========");
    NSLog(@"server:%@",service.UUID);
    for (CBCharacteristic *characteristic in service.characteristics) {
        NSLog(@"char:%@",characteristic.UUID);
    }
    
    if([service.UUID isEqual:[CBUUID UUIDWithString:SPARK_ANTILOST_BLE_UUID_IMMEDIATE_ALERT_SERVICE]]) {
        for (CBCharacteristic *characteristic in service.characteristics) {
            if([characteristic.UUID isEqual:[CBUUID UUIDWithString:SPARK_BLE_DATA_ALERT_LOSS_CHARACTER]])
                self.alertImmediateCharacter = characteristic;
            NSLog(@"immed loss charct%@",characteristic.value);
            
        }
    }else if([service.UUID isEqual:[CBUUID UUIDWithString:SPARK_ANTILOST_BLE_UUID_LOSS_ALERT_SERVICE]]) {
        for (CBCharacteristic *characteristic in service.characteristics) {
            if([characteristic.UUID isEqual:[CBUUID UUIDWithString:SPARK_BLE_DATA_ALERT_LOSS_CHARACTER]]) {
                [peripheral readValueForCharacteristic:characteristic];
                self.alertLossCharacter = characteristic;
                NSLog(@"alert loss charct%@",characteristic.value);
            }
        }
        
    }else if([service.UUID isEqual:[CBUUID UUIDWithString:SPARK_ANTILOST_BLE_UUID_POWER_SERVICE]]) {
        for (CBCharacteristic *characteristic in service.characteristics) {
            if([characteristic.UUID isEqual:[CBUUID UUIDWithString:SPARK_BLE_DATA_POWER_CHARACTER]]){
              //  [peripheral readValueForCharacteristic:characteristic];
                self.firePowerCharacter = characteristic;
                NSLog(@"power charct%@",characteristic.value);
            }
        }
        
    }else if([service.UUID isEqual:[CBUUID UUIDWithString:SPARK_ANTILOST_BLE_UUID_BATTERY_SERVICE]]) {
        for (CBCharacteristic *characteristic in service.characteristics) {
            if([characteristic.UUID isEqual:[CBUUID UUIDWithString:SPARK_BLE_DATA_BATTERY_CHARACTER]]){
                [peripheral setNotifyValue:YES forCharacteristic:characteristic];
                NSLog(@"battery charct%@",characteristic.value);
                self.batteryCharacter = characteristic;
            }
        }
        
    }else if([service.UUID isEqual:[CBUUID UUIDWithString:SPARK_ANTILOST_BLE_UUID_SEARCHPHONE_SERVICE]]) {
        for (CBCharacteristic *characteristic in service.characteristics) {
            if([characteristic.UUID isEqual:[CBUUID UUIDWithString:SPARK_BLE_DATA_SEARCHPHONE_CHARACTER]]){
                [peripheral setNotifyValue:YES forCharacteristic:characteristic];
                NSLog(@"phone charct:%@",characteristic.value);
                self.batteryCharacter = characteristic;
            }
        }
        
    }
}

//中心读取外设实时数据
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
        return;
    }
    // Notification has started
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:SPARK_BLE_DATA_BATTERY_CHARACTER]] && characteristic.isNotifying) {
        NSLog(@"nitoffffffuuid:%@---val:%@",characteristic.UUID,characteristic.value);
        [peripheral readValueForCharacteristic:characteristic];
    }
}

-(NSString *) hexadecimalString:(NSData *)data {
    NSString* result;
    const unsigned char* dataBuffer = (const unsigned char*)[data bytes];
    if(!dataBuffer){
        return nil;
    }
    NSUInteger dataLength = [data length];
    NSMutableString* hexString = [NSMutableString stringWithCapacity:(dataLength * 2)];
    for(int i = 0; i < dataLength; i++){
        [hexString appendString:[NSString stringWithFormat:@"%lx", (unsigned long)dataBuffer[i]]];
    }
    result = [NSString stringWithString:hexString];
    return result;
}

//获取外设发来的数据，不论是read和notify,获取数据都是从这个方法中读取。
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        return;
    }
    
    NSString *strr = [self hexadecimalString:characteristic.value];
    NSLog(@"cha:%@---%ld",characteristic.UUID,strtol([strr UTF8String], 0, 16));
    
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:SPARK_BLE_DATA_ALERT_LOSS_CHARACTER]]) {
        ///表示是断开提醒
        NSString *value = [self hexadecimalString:characteristic.value];
        if ([characteristic.service.UUID isEqual:[CBUUID UUIDWithString:SPARK_ANTILOST_BLE_UUID_LOSS_ALERT_SERVICE]]) {
            float lostValue = [value floatValue];
            ///写临时数据目的是，当主界面没生成时，通知接收不到。该临时数据读取完毕后要删除
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:[NSNumber numberWithFloat:lostValue] forKey:@"tempLostAlertValue"];
            [userDefaults synchronize];
            
            NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:lostValue],@"value", nil];
            NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
            [notificationCenter postNotificationName:LOSS_ALERT_NEED_UPDATEUI_NOTIFICATION object:nil userInfo:userInfo];
            NSLog(@"断开报警当前设备值：%f",lostValue);

        }

    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:SPARK_BLE_DATA_BATTERY_CHARACTER]]) {
        NSString *strr = [self hexadecimalString:characteristic.value];
        float level = (float)strtol([strr UTF8String], 0, 16)/99.99f;
        
        if (level > 1) {
            level = 1;
        }
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithFloat:level] forKey:@"level"];
        [dic setObject:[peripheral.identifier UUIDString] forKey:@"uuid"];
        
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter postNotificationName:BATTERY_LEVEL_CHANGE_NOTIFICATION object:nil userInfo:dic];
    }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:SPARK_BLE_DATA_SEARCHPHONE_CHARACTER]]) {
        ///让手机叫
        if ([[self hexadecimalString:characteristic.value] isEqualToString:@"3"]) {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
            [notificationCenter postNotificationName:NEED_IPHONE_ALERT_NOTIFICATION object:nil userInfo:nil];
        }else {
            ////判断是否打开相机
            switch ([HirUserInfo shareUserInfo].currentViewControllerType) {
                case CurrentViewControllerType_other:
                {
                    /////定位手机
                    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
                    [notificationCenter postNotificationName:NEED_SAVE_PERIPHERAL_LOCATION_NOTIFICATION object:nil userInfo:nil];
                    
                }
                    break;
                case CurrentViewControllerType_phone:
                {
                    ////自动拍照
                    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
                    [notificationCenter postNotificationName:NEED_AUTO_PHONE_NOTIFICATION object:nil userInfo:nil];
                    
                }
                    break;
                default:
                    break;
            }
        }
        
        
        NSLog(@"查找手机：%@",[self hexadecimalString:characteristic.value]);
    }else {
        NSLog(@"update value fialue==%@",[self hexadecimalString:characteristic.value]);
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

- (void)cleanDiscoveredPeripheral{
    if (self.discoveredPeripheral.state == CBPeripheralStateDisconnected) {
        return;
    }
    if (self.discoveredPeripheral.services != nil) {
        for (CBService *service in self.discoveredPeripheral.services) {
            if (service.characteristics != nil) {
                for (CBCharacteristic *characteristic in service.characteristics) {
                    if (characteristic.isNotifying) {
                        [self.discoveredPeripheral setNotifyValue:NO forCharacteristic:characteristic];
                    }
                }
            }
        }
    }
    [self.centralManager cancelPeripheralConnection:self.discoveredPeripheral];
}


- (void)dealloc {
    self.centralManager = nil;
    self.discoveredPeripheral = nil;
    self.alertImmediateCharacter = nil;
    self.alertLossCharacter = nil;
    self.firePowerCharacter = nil;
    self.batteryCharacter = nil;
    self.searchPhoneCharacter = nil;
}
@end
