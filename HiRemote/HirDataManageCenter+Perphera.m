//
//  HirDataManageCenter+Perphera.m
//  HiRemote
//
//  Created by minfengliu on 15/7/5.
//  Copyright (c) 2015年 hiremote. All rights reserved.
//

#import "HirDataManageCenter+Perphera.h"

@implementation HirDataManageCenter (Perphera)
//查找设备ID为:peripheraUUID的定位记录信息
+(DBPeriphera *)findPerpheraByPeripheraUUID:(NSString *)uuid{
    DBPeriphera *periphera = [[DBPeriphera MR_findByAttribute:@"uuid" withValue:uuid]firstObject];
    return periphera;
}

//插入一条记录
+(void)insertPerpheraByUUID:(NSString *)uuid name:(NSString *)name avatarPath:(NSString *)avatarPath battery:(NSNumber *)battery{
    DBPeriphera *periphera = [HirDataManageCenter findPerpheraByPeripheraUUID:uuid];
    if (periphera) {
        periphera.name = name;
        periphera.avatarPath = avatarPath;
        periphera.battery = battery;
    }
    else{
        DBPeriphera *periphera = [DBPeriphera MR_createEntity];
        periphera.uuid = uuid;
        periphera.name = name;
        periphera.avatarPath = avatarPath;
        periphera.battery = battery;
    }
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
