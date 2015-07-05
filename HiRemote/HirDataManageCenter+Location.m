//
//  HirDataManageCenter+Location.m
//  HiRemote
//
//  Created by minfengliu on 15/7/5.
//  Copyright (c) 2015年 hiremote. All rights reserved.
//

#import "HirDataManageCenter+Location.h"

@implementation HirDataManageCenter (Location)
+(NSArray *)findAllLocationRecordByPeripheraUUID:(NSString *)peripheraUUID dataType:(NSNumber *)dataType{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"peripheraUUID == %@ AND dataType == %@",peripheraUUID,dataType];
    NSArray *results = [DBPeripheraLocationInfo MR_findAllWithPredicate:predicate];
    
    return results;
}

+(DBPeripheraLocationInfo *)findLastLocationByPeriperaUUID:(NSString *)peripheraUUID{
    DBPeripheraLocationInfo *peripheraLocationInfo = [DBPeripheraLocationInfo MR_findFirstOrderedByAttribute:@"recordTime" ascending:NO];

    return peripheraLocationInfo;
}

+(void)insertLocationRecordByPeripheraUUID:(NSString *)peripheraUUID latitude:(NSNumber *)latitude longitude:(NSNumber *)longitude location:(NSString *)location dataType:(NSNumber *)dataType remark:(NSString *)remark{
    DBPeripheraLocationInfo *peripheraLocationInfo = [DBPeripheraLocationInfo MR_createEntity];
    peripheraLocationInfo.peripheraUUID = peripheraUUID;
    peripheraLocationInfo.latitude = latitude;
    peripheraLocationInfo.longitude = longitude;
    peripheraLocationInfo.location = location;
    peripheraLocationInfo.recordTime = @([NSDate date].timeIntervalSinceReferenceDate);
    peripheraLocationInfo.dataType = dataType;
    peripheraLocationInfo.remark = remark;
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
