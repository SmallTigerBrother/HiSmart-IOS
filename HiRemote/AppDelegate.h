//
//  AppDelegate.h
//  HiRemote
//
//  Created by parker on 6/25/15.
//  Copyright (c) 2015 hiremote. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPCoreLocationManger.h"
#import "HIRRootViewController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property(nonatomic) UIWindow *window;

@property(nonatomic) HPCoreLocationManger *locManger;
@property(nonatomic) HIRRootViewController *rootVC;
@property(nonatomic) long updateStatus; ///应用更新状态，在3的时候将不可用
- (void)addNewDevice;
- (void)connectSuccessToShowRootVC; ////显示主界面

- (void)needUpdateAppForce;

@end

