//
//  HiRDevice.h
//  HiRemote
//
//  Created by rick on 15/6/27.
//  Copyright (c) 2015年 hiremote. All rights reserved.
//

#import "HirDesign.h"

#ifndef HiRemote_HiRDevice_h
#define HiRemote_HiRDevice_h



//DEVICE-------------------------------------------------------
#define DEVICE_IS_IPHONE6p ([[UIScreen mainScreen] bounds].size.height == 736)
#define DEVICE_IS_IPHONE6 ([[UIScreen mainScreen] bounds].size.height == 667)
#define DEVICE_IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height == 568)
#define DEVICE_IS_IPHONE4 ([[UIScreen mainScreen] bounds].size.height == 480)
#define is_iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define IOS7_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )

#define SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define is_LATER_IOS7 (SYSTEM_VERSION >= 7.0)
#define is_IOS8 (SYSTEM_VERSION >= 8.0 && SYSTEM_VERSION <9.0)
#define is_IOS6 (SYSTEM_VERSION >= 6.0 && SYSTEM_VERSION < 7.0)
#define is_EXACT_IOS7 (SYSTEM_VERSION >= 7.0 && SYSTEM_VERSION < 8.0)
#define is_LATER_IOS6 (SYSTEM_VERSION >= 6.0)


//判断是否为iPhone
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

//判断是否为iPad
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define APP_WIDTH [UIScreen mainScreen].applicationFrame.size.width
#define APP_HEIGHT [UIScreen mainScreen].applicationFrame.size.height


#define STATUS_BAR_HEIGHT [UIApplication sharedApplication].statusBarFrame.size.height


#define HEIGHT_NO_TAB (SCREEN_HEIGHT- TAB_BAR_HEIGHT)
#define HEIGHT_NO_STATUS_NAV (SCREEN_HEIGHT - STATUS_BAR_HEIGHT - NAV_BAR_HEIGHT)
#define HEIGHT_NO_STATUS_TAB (SCREEN_HEIGHT - STATUS_BAR_HEIGHT - TAB_BAR_HEIGHT)
#define HEIGHT_NO_STATUS_NAV_TAB (SCREEN_HEIGHT - STATUS_BAR_HEIGHT - NAV_BAR_HEIGHT - TAB_BAR_HEIGHT)
#define HEIGHT_NO_STATUS (SCREEN_HEIGHT - STATUS_BAR_HEIGHT)
#define HEIGHT_STATUS_AND_NAV (STATUS_BAR_HEIGHT + NAV_BAR_HEIGHT)


#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 60000
#define UITextAlignmentLeft NSTextAlignmentLeft
#define UITextAlignmentCenter NSTextAlignmentCenter
#define UITextAlignmentRight NSTextAlignmentRight

#endif

#endif
