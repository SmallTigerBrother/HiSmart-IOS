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
#define      SPARK_ANTILOST_BLE_UUID_IMMEDIATE_ALERT_SERVICE    @"1802"
#define      SPARK_ANTILOST_BLE_UUID_LINK_LOSS_SERVICE          @"1803"
#define      SPARK_ANTILOST_POWER_COMMUNICATE_SERVICE           @"1804"
#define      SPARK_BLE_DATA_ANTIALERT_CHARACTER_UUID           @"2A06"
#define      SPARK_BLE_DATA_POWER_CHARACTER_UUID               @"2A07"
#define      SPARK_BLE_DATA_ALERT_HIGHT_LEVEL                  2
#define      SPARK_BLE_DATA_ALERT_OFF_LEVEL                    0
#define      SPARK_BLE_DATA_ALERT_LOW_LEVEL                    1
#define      SPARK_ANTILOST_KEY_SERVICE           @"FFE0"
#define      SPARK_BLE_KEY_CHARACTER_UUID           @"FFE1"



#define HIR_CBSTATE_CHANGE_NOTIFICATION_NAME @"HirCBStateChangeNotificationName"
#define CBCENTERAL_STATE_NOT_SUPPORT @"notSupport"
#define CBCENTERAL_CONNECT_PERIPHERAL_FAIL @"connectPeripheralFail"
#define CBCENTERAL_CONNECT_PERIPHERAL_SUCCESS @"connectPeripheralSuccess"

@interface HIRCBCentralClass : NSObject
@property (strong, nonatomic) CBCentralManager *centralManager;
@property (strong, nonatomic) CBPeripheral *discoveredPeripheral;
@property (strong, nonatomic) CBCharacteristic *alertIASCharacter;
@property (strong, nonatomic) CBCharacteristic *alertLLSCharacter;
@property (strong, nonatomic) CBCharacteristic *powerCharacter;
@property (strong, nonatomic) CBCharacteristic *dataSendCharacter;

+ (HIRCBCentralClass *)shareHIRCBcentralClass;
- (void)scanPeripheral;
@end
