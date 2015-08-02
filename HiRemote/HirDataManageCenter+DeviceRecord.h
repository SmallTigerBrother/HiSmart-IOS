//
//  HirDataManageCenter+DeviceRecord.h
//  HiRemote
//
//  Created by minfengliu on 15/7/13.
//  Copyright (c) 2015年 hiremote. All rights reserved.
//

#import "HirDataManageCenter.h"
#import "DBDeviceRecord.h"

#define DEVICE_RECORD_UPDATA_NOTIFICATION @"DEVICE_RECORD_UPDATA_NOTIFICATION"

@interface HirDataManageCenter (DeviceRecord)

+(DBDeviceRecord *)findDeviceRecordByPeripheraUUID:(NSString *)peripheraUUID;

+(NSMutableArray *)findAllRecordByPeripheraUUID:(NSString *)peripheraUUID;

//插入一条记录
+(void)insertVoicePath:(NSString *)voicePath peripheraUUID:(NSString *)peripheraUUID recoderTimestamp:(NSNumber *)recoderTimestamp title:(NSString *)title voiceTime:(NSNumber *)voiceTime;

//删除一条记录
+(void)delDeviceRecordByModel:(DBDeviceRecord *)deviceRecord;

//保存修改后的记录
+(void)saveDeviceRecordByModel:(DBDeviceRecord *)deviceRecord;

@end
