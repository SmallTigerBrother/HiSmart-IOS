//
//  HirDataManageCenter+Location.m
//  HiRemote
//
//  Created by rick on 15/7/5.
//  Copyright (c) 2015年 hiremote. All rights reserved.
//

#import "HirDataManageCenter+Location.h"
#import "CLLocation+Sino.h"

@implementation HirDataManageCenter (Location)
+(NSArray *)findAllLocationRecordByPeripheralUUID:(NSString *)peripheralUUID  dataType:(NSNumber *)dataType{
    NSString *userId = [HirUserInfo shareUserInfo].userId;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"peripheralUUID == %@ AND dataType == %@ AND userId = %@",peripheralUUID,dataType,userId];
    NSArray *results = [DBPeripheralLocationInfo MR_findAllSortedBy:@"timestamp" ascending:NO withPredicate:predicate];
    
    return results;
}

+(DBPeripheralLocationInfo *)findLastLocationByPeriperaUUID:(NSString *)peripheraUUID{
    
    NSString *userId = [HirUserInfo shareUserInfo].userId;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"peripheralUUID == %@ AND userId = %@",peripheraUUID,userId];
    
    DBPeripheralLocationInfo *peripheraLocationInfo = [DBPeripheralLocationInfo MR_findFirstWithPredicate:predicate sortedBy:@"timestamp" ascending:NO];
    
    return peripheraLocationInfo;
}

+(void)insertLocationRecordByPeripheraUUID:(NSString *)peripheraUUID latitude:(NSString *)latitude longitude:(NSString *)longitude location:(NSString *)location dataType:(NSNumber *)dataType remark:(NSString *)remark battery:(NSNumber *)battery{
    NSLog(@"latitude = %@,longitude = %@",latitude,longitude);
        
    NSString *userId = [HirUserInfo shareUserInfo].userId;
    
    DBPeripheralLocationInfo *peripheraLocationInfo = [DBPeripheralLocationInfo MR_createEntity];
    peripheraLocationInfo.peripheralUUID = peripheraUUID;
    peripheraLocationInfo.userId = userId;
    peripheraLocationInfo.latitude = latitude;
    peripheraLocationInfo.longitude = longitude;
    peripheraLocationInfo.address = location;
    peripheraLocationInfo.timestamp = @([NSDate date].timeIntervalSince1970 *1000);
    peripheraLocationInfo.dataType = dataType;
    peripheraLocationInfo.remark = remark;
    peripheraLocationInfo.sync = @0;
    peripheraLocationInfo.battery = battery;
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    
    if (dataType.integerValue == HirLocationDataType_history) {
        [[NSNotificationCenter defaultCenter] postNotificationName:PERIPHERAL_HISTORY_LOCATION_UPDATA_NOTIFICATION object:nil];
    }
    else if (dataType.integerValue == HirLocationDataType_lost){
        [[NSNotificationCenter defaultCenter] postNotificationName:PERIPHERAL_DISCONNECT_LOCATION_UPDATA_NOTIFICATION object:nil];
    }
}

//删除一条记录
+(void)delLocationRecordByModel:(DBPeripheralLocationInfo *)peripheraLocationInfo{
    [peripheraLocationInfo MR_deleteEntity];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

//保存修改后的记录
+(void)saveLocationRecordByModel:(DBPeripheralLocationInfo *)peripheraLocationInfo{
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}
@end
