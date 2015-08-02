//
//  HirDataManageCenter+Perphera.m
//  HiRemote
//
//  Created by rick on 15/7/5.
//  Copyright (c) 2015年 hiremote. All rights reserved.
//

#import "HirDataManageCenter+Perphera.h"

@implementation HirDataManageCenter (Perphera)
//查找设备ID为:peripheraUUID的定位记录信息
+(DBPeriphera *)findPerpheraByPeripheraUUID:(NSString *)uuid{
    if (!uuid) {
        return nil;
    }
    NSString *userId = [HirUserInfo shareUserInfo].userId;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uuid == %@ AND userId = %@",uuid,userId];
    
    DBPeriphera *periphera = [DBPeriphera MR_findFirstWithPredicate:predicate];
    return periphera;
}

+(NSString *)getNameWithPerphera:(DBPeriphera *)periphera{
    if (periphera.remarkName) {
        return periphera.remarkName;
    }
    return periphera.name;
}

+(NSMutableArray *)findAllPerphera{
    NSString *userId = [HirUserInfo shareUserInfo].userId;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId == %@",userId];
    
    NSArray *list = [DBPeriphera MR_findAllWithPredicate:predicate];
    if ([list count] == 0) {
        return [NSMutableArray arrayWithCapacity:3];
    }
    return  [NSMutableArray arrayWithArray:list];
}

//插入一条记录
+(void)insertPerpheraByUUID:(NSString *)uuid name:(NSString *)name remarkName:(NSString *)remarkName avatarPath:(NSString *)avatarPath battery:(NSNumber *)battery{
    
//    NSAssert(uuid, @"no find uuid");

    DBPeriphera *periphera = [HirDataManageCenter findPerpheraByPeripheraUUID:uuid];
    if (periphera) {
        if (name) {
            periphera.name = name;
        }
        if (remarkName) {
            periphera.remarkName = remarkName;
        }
        if (avatarPath) {
            periphera.avatarPath = avatarPath;
        }
        if (battery) {
            periphera.battery = battery;
        }
    }
    else{
        DBPeriphera *periphera = [DBPeriphera MR_createEntity];
        periphera.uuid = uuid;
        periphera.name = name;
        periphera.remarkName = remarkName;
        periphera.avatarPath = avatarPath;
        periphera.battery = battery;
    }
    NSString *userId = [HirUserInfo shareUserInfo].userId;

    periphera.userId = userId;
    
    [HirUserInfo shareUserInfo].deviceInfoArray = [HirDataManageCenter findAllPerphera];
    [[NSManagedObjectContext MR_context]MR_saveOnlySelfAndWait];    
}

//删除一条记录
+(void)delPerpheraByModel:(DBPeriphera *)periphera{
    [periphera MR_deleteEntity];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

//保存修改后的记录
+(void)savePerpheraByModel:(DBPeriphera *)periphera{
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

@end
