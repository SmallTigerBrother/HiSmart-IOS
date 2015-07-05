//
//  HirDataManageCenter+Perphera.h
//  HiRemote
//
//  Created by minfengliu on 15/7/5.
//  Copyright (c) 2015年 hiremote. All rights reserved.
//

#import "HirDataManageCenter.h"
#import "DBPeriphera.h"

@interface HirDataManageCenter (Perphera)
//查找设备ID为:peripheraUUID的定位记录信息
+(DBPeriphera *)findPerpheraByPeripheraUUID:(NSString *)uuid;

//查找所有设备
+(NSMutableArray *)findAllPerphera;

//插入一条记录
+(void)insertPerpheraByUUID:(NSString *)uuid name:(NSString *)name avatarPath:(NSString *)avatarPath battery:(NSNumber *)battery;

//删除一条记录
+(void)delPerpheraByModel:(DBPeriphera *)periphera;

//保存修改后的记录
+(void)savePerpheraByModel:(DBPeriphera *)periphera;

@end
