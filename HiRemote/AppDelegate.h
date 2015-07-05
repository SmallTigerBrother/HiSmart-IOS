//
//  AppDelegate.h
//  HiRemote
//
//  Created by parker on 6/25/15.
//  Copyright (c) 2015 hiremote. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPCoreLocationManger.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property(nonatomic) UIWindow *window;

@property(nonatomic) HPCoreLocationManger *locManger;

- (void)addNewDevice;
- (void)connectSuccessToShowRootVC; ////显示主界面


@end

