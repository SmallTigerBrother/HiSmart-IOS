//
//  HirUserDefault.h
//  HiRemote
//
//  Created by rick on 15/7/5.
//  Copyright (c) 2015年 hiremote. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBPeripheral.h"

typedef NS_ENUM(NSInteger, CurrentViewControllerType) {
    CurrentViewControllerType_other,
    CurrentViewControllerType_phone,
};

@class DBPeripheral;
@interface HirUserInfo : NSObject
+(HirUserInfo *)shareUserInfo;

@property (nonatomic, strong)NSString *userId;

//0:未定义 1:相机 2:录音(第一下开始,第二下结束)
@property (nonatomic, assign)CurrentViewControllerType currentViewControllerType;

//现在选择的设备index
@property (nonatomic, assign)NSInteger currentPeripheraIndex;

@property (nonatomic, strong)NSMutableArray *deviceInfoArray; ///临时保存设备信息（可能有多个设备）

@property (nonatomic, strong)DBPeripheral *currentPeriphera;

@property (nonatomic, assign)BOOL appIsEnterBackgroud;  //系统是否已进入后台
@property (nonatomic, assign)BOOL isNotificationMyWhenDeviceNoWithin;   //当设备断开连接是否提示我
@property (nonatomic, assign)BOOL isNotificationForVoiceMemo;   //设置了语音追踪开关
@property (nonatomic, assign)BOOL isNotificationPlaySounds; //是否播放声音
@end
