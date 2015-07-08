//
//  HirDataManageCenter+Location.m
//  HiRemote
//
//  Created by minfengliu on 15/7/5.
//  Copyright (c) 2015年 hiremote. All rights reserved.
//

#import "HirDataManageCenter+Location.h"
#import "CLLocation+Sino.h"

@implementation HirDataManageCenter (Location)
+(NSArray *)findAllLocationRecordByPeripheraUUID:(NSString *)peripheraUUID dataType:(NSNumber *)dataType{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"peripheraUUID == %@ AND dataType == %@",peripheraUUID,dataType];
    NSArray *results = [DBPeripheraLocationInfo MR_findAllSortedBy:@"recordTime" ascending:NO withPredicate:predicate];
    
    return results;
}

+(DBPeripheraLocationInfo *)findLastLocationByPeriperaUUID:(NSString *)peripheraUUID{
    DBPeripheraLocationInfo *peripheraLocationInfo = [DBPeripheraLocationInfo MR_findFirstOrderedByAttribute:@"recordTime" ascending:NO];

    return peripheraLocationInfo;
}

+(void)insertLocationRecordByPeripheraUUID:(NSString *)peripheraUUID latitude:(NSString *)latitude longitude:(NSString *)longitude location:(NSString *)location dataType:(NSNumber *)dataType remark:(NSString *)remark{
    NSLog(@"latitude = %@,longitude = %@",latitude,longitude);
    DBPeripheraLocationInfo *peripheraLocationInfo = [DBPeripheraLocationInfo MR_createEntity];
    peripheraLocationInfo.peripheraUUID = peripheraUUID;
    peripheraLocationInfo.latitude = latitude;
    peripheraLocationInfo.longitude = longitude;
    peripheraLocationInfo.location = location;
    peripheraLocationInfo.recordTime = @([NSDate date].timeIntervalSinceReferenceDate);
    peripheraLocationInfo.dataType = dataType;
    peripheraLocationInfo.remark = remark;
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    
    if (dataType.integerValue == HirLocationDataType_history) {
        [[NSNotificationCenter defaultCenter] postNotificationName:PERIPHERAL_HISTORY_LOCATION_UPDATA_NOTIFICATION object:nil];
    }
    else if (dataType.integerValue == HirLocationDataType_lost){
        [[NSNotificationCenter defaultCenter] postNotificationName:PERIPHERAL_DISCONNECT_LOCATION_UPDATA_NOTIFICATION object:nil];
    }
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
