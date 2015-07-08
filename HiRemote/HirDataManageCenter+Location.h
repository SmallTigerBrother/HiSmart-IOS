//
//  HirDataManageCenter+Location.h
//  HiRemote
//
//  Created by minfengliu on 15/7/5.
//  Copyright (c) 2015年 hiremote. All rights reserved.
//

#import "HirDataManageCenter.h"
#import "DBPeripheraLocationInfo.h"

#define PERIPHERAL_HISTORY_LOCATION_UPDATA_NOTIFICATION @"PERIPHERAL_HISTORY_LOCATION_UPDATA_NOTIFICATION"
#define PERIPHERAL_DISCONNECT_LOCATION_UPDATA_NOTIFICATION @"PERIPHERAL_DISCONNECT_LOCATION_UPDATA_NOTIFICATION"

@interface HirDataManageCenter (Location)
//查找设备ID为:peripheraUUID的定位记录信息
+(NSArray *)findAllLocationRecordByPeripheraUUID:(NSString *)peripheraUUID dataType:(NSNumber *)dataType;

+(DBPeripheraLocationInfo *)findLastLocationByPeriperaUUID:(NSString *)peripheraUUID;

//插入一条记录
+(void)insertLocationRecordByPeripheraUUID:(NSString *)peripheraUUID latitude:(NSString *)latitude longitude:(NSString *)longitude location:(NSString *)location dataType:(NSNumber *)dataType remark:(NSString *)remark;

//删除一条记录
+(void)delLocationRecordByModel:(DBPeripheraLocationInfo *)peripheraLocationInfo;

//保存修改后的记录
+(void)saveLocationRecordByModel:(DBPeripheraLocationInfo *)peripheraLocationInfo;

@end
