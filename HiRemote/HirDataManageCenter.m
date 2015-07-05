//
//  HirDataManageCenter.m
//  HiRemote
//
//  Created by minfengliu on 15/7/5.
//  Copyright (c) 2015年 hiremote. All rights reserved.
//

#import "HirDataManageCenter.h"
#import "DBPeripheraLocationInfo.h"
@implementation HirDataManageCenter
+(NSArray *)findAllLocationRecordByPeripheraUUID:(NSString *)peripheraUUID{
    NSArray *results = [DBPeripheraLocationInfo MR_findByAttribute:@"peripheraUUID" withValue:peripheraUUID];
    return results;
}

+(void)insertLocationRecordByPeripheraUUID:(NSString *)peripheraUUID latitude:(NSNumber *)latitude longitude:(NSNumber *)longitude location:(NSString *)location recordTime:(NSNumber *)recordTime name:(NSString *)name{
    DBPeripheraLocationInfo *peripheraLocationInfo = [DBPeripheraLocationInfo MR_createEntity];
    peripheraLocationInfo.peripheraUUID = peripheraUUID;
    peripheraLocationInfo.latitude = latitude;
    peripheraLocationInfo.longitude = longitude;
    peripheraLocationInfo.location = location;
    peripheraLocationInfo.recordTime = recordTime;
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

//删除一条记录
+(void)delLocationRecordByModel:(DBPeripheraLocationInfo *)peripheraLocationInfo{
    [peripheraLocationInfo MR_deleteEntity];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

//保存修改后的记录
+(void)saveLocationRecordByModel:(DBPeripheraLocationInfo *)peripheraLocationInfo{
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

@end
