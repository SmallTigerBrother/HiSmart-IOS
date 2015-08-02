//
//  HirDataManageCenter+Perphera.h
//  HiRemote
//
//  Created by rick on 15/7/5.
//  Copyright (c) 2015年 hiremote. All rights reserved.
//

#import "HirDataManageCenter.h"
#import "DBPeripheral.h"

@interface HirDataManageCenter (Perphera)
//查找设备ID为:peripheraUUID的定位记录信息
+(DBPeripheral *)findPerpheraByPeripheraUUID:(NSString *)uuid;

//查找所有设备
+(NSMutableArray *)findAllPerphera;

+(NSString *)getNameWithPerphera:(DBPeripheral *)periphera;

//插入一条记录
+(void)insertPerpheraByUUID:(NSString *)uuid name:(NSString *)name remarkName:(NSString *)remarkName avatarPath:(NSString *)avatarPath battery:(NSNumber *)battery;

//删除一条记录
+(void)delPerpheraByModel:(DBPeripheral *)periphera;

//保存修改后的记录
+(void)savePerpheraByModel:(DBPeripheral *)periphera;

@end
