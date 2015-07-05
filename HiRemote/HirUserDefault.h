//
//  HirUserDefault.h
//  HiRemote
//
//  Created by minfengliu on 15/7/5.
//  Copyright (c) 2015年 hiremote. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HirUserDefault : NSObject
+(HirUserDefault *)shareUserDefaults;

//0:未定义 1:相机
@property (nonatomic, assign)NSInteger currentViewController;
@end
