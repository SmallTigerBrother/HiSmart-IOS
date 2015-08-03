//
//  HirDataManageCenter+DeviceRecord.h
//  HiRemote
//
//  Created by minfengliu on 15/7/13.
//  Copyright (c) 2015年 hiremote. All rights reserved.
//

#import "HirDataManageCenter.h"
#import "DBPeripheralRecord.h"

#define DEVICE_RECORD_UPDATA_NOTIFICATION @"DEVICE_RECORD_UPDATA_NOTIFICATION"

@interface HirDataManageCenter (DeviceRecord)

+(DBPeripheralRecord *)findDeviceRecordByPeripheralUUID:(NSString *)peripheralUUID;

+(NSMutableArray *)findAllRecordByPeripheralUUID:(NSString *)peripheralUUID;

//插入一条记录
+(void)insertVoicePath:(NSString *)voicePath peripheraUUID:(NSString *)peripheraUUID recoderTimestamp:(NSNumber *)recoderTimestamp title:(NSString *)title voiceTime:(NSNumber *)voiceTime;

//删除一条记录
+(void)delDeviceRecordByModel:(DBPeripheralRecord *)deviceRecord;

//保存修改后的记录
+(void)saveDeviceRecordByModel:(DBPeripheralRecord *)deviceRecord;

@end
