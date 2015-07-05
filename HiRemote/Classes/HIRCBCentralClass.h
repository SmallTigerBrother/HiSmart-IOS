//
//  HIRCBCentralClass.h
//  HiRemote
//
//  Created by parker on 6/29/15.
//  Copyright (c) 2015 hiremote. All rights reserved.
//

typedef enum
{
    kPeripheralStateDiscovered = 1,
    kPeripheralStateDiscoveredConnected,
    kPeripheralStateConnectedFail,
    kPeripheralStateConnected,
    kPeripheralStateDisconnect,
    kPeripheralStateBloothClosed,
    
}PeripheralState;
//NSString * const HIRCBStateChangeNotification = @"HirCBStateChangeNotification";

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

////立即报警：只写（without response）： 特征是2A06 0无，1低，2高
#define      SPARK_ANTILOST_BLE_UUID_IMMEDIATE_ALERT_SERVICE     @"1802"  ///立即报警 服务

////断开报警：读写: 特征是2A06  0无，1低，2高
#define      SPARK_ANTILOST_BLE_UUID_LOSS_ALERT_SERVICE          @"1803"  ///断开丢失 服务

////发射功能：只读: 特征是2A07  -100--20
#define      SPARK_ANTILOST_BLE_UUID_POWER_SERVICE               @"1804"  ///发射功率 服务

////电池状态：只读/通知: 特征是2A19 0--100
#define      SPARK_ANTILOST_BLE_UUID_BATTERY_SERVICE             @"180F"  ///电池状态 服务

////查找手机：只读/通知: 特征是FFE1 1按键按下
#define      SPARK_ANTILOST_BLE_UUID_SEARCHPHONE_SERVICE         @"FFE0"  ///查找手机 服务

#define      SPARK_BLE_DATA_ALERT_LOSS_CHARACTER   @"2A06" ///特征：立即报警服务和断开服务使用 0无，1低，2高
#define      SPARK_BLE_DATA_POWER_CHARACTER        @"2A07" ///特征：发射功率服务使用 -100--20
#define      SPARK_BLE_DATA_BATTERY_CHARACTER      @"2A19" ///特征：电池服务使用 -100--20
#define      SPARK_BLE_DATA_SEARCHPHONE_CHARACTER  @"FFE1" ///特征：查找手机服务使用 1


////通知名称
#define HIR_CBSTATE_CHANGE_NOTIFICATION @"HirCBStateChangeNotification" //蓝牙状态改变通知（可用，不可用,链接商，断开链接等）
#define NEED_SAVE_PERIPHERAL_LOCATION_NOTIFICATION  @"needSavePeripheralLocation" ///需要定位外设位置通知


#define CBCENTERAL_STATE_NOT_SUPPORT @"notSupport"   ////蓝牙不支持 （通知值）
#define CBCENTERAL_CONNECT_PERIPHERAL_FAIL @"connectPeripheralFail" ///外设链接失败 (通知值）
#define CBCENTERAL_CONNECT_PERIPHERAL_SUCCESS  @"connectPeripheralSuccess"  ///外设链接成功 （通知值）


@interface HIRCBCentralClass : NSObject
@property (strong, nonatomic) CBCentralManager *centralManager;
@property (strong, nonatomic) CBPeripheral *discoveredPeripheral;
@property (strong, nonatomic) CBCharacteristic *alertImmediateCharacter;
@property (strong, nonatomic) CBCharacteristic *alertLossCharacter;
@property (strong, nonatomic) CBCharacteristic *firePowerCharacter;
@property (strong, nonatomic) CBCharacteristic *batteryCharacter;
@property (strong, nonatomic) CBCharacteristic *searchPhoneCharacter;
@property (nonatomic, assign) BOOL isDisconnectByUser;
+ (HIRCBCentralClass *)shareHIRCBcentralClass;
- (void)scanPeripheral;
-(void)stopCentralManagerScan;
- (void)cancelConnectionWithPeripheral:(CBPeripheral *)peripheral;
@end
