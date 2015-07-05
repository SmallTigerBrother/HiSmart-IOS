//
//  HirUserDefault.h
//  HiRemote
//
//  Created by minfengliu on 15/7/5.
//  Copyright (c) 2015年 hiremote. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBPeriphera.h"

@class DBPeriphera;
@interface HirUserInfo : NSObject
+(HirUserInfo *)shareUserInfo;

//0:未定义 1:相机
@property (nonatomic, assign)NSInteger currentViewController;

//现在选择的设备index
@property (nonatomic, assign)NSInteger currentPeripheraIndex;

@property (nonatomic, strong)NSMutableArray *deviceInfoArray; ///临时保存设备信息（可能有多个设备）

@property (nonatomic, strong)DBPeriphera *currentPeriphera;
@end
