//
//  HirDataManageCenter+Location.h
//  HiRemote
//
//  Created by minfengliu on 15/7/5.
//  Copyright (c) 2015年 hiremote. All rights reserved.
//

#import "HirDataManageCenter.h"
#import "DBPeripheraLocationInfo.h"

@interface HirDataManageCenter (Location)
//查找设备ID为:peripheraUUID的定位记录信息
+(NSArray *)findAllLocationRecordByPeripheraUUID:(NSString *)peripheraUUID;

+(DBPeripheraLocationInfo *)findLastLocationByPeriperaUUID:(NSString *)peripheraUUID;

//插入一条记录
+(void)insertLocationRecordByPeripheraUUID:(NSString *)peripheraUUID latitude:(NSNumber *)latitude longitude:(NSNumber *)longitude location:(NSString *)location recordTime:(NSNumber *)recordTime;

//删除一条记录
+(void)delLocationRecordByModel:(DBPeripheraLocationInfo *)peripheraLocationInfo;

//保存修改后的记录
+(void)saveLocationRecordByModel:(DBPeripheraLocationInfo *)peripheraLocationInfo;

@end
