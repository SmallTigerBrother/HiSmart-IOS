//
//  AppDelegate.h
//  HiRemote
//
//  Created by parker on 6/25/15.
//  Copyright (c) 2015 hiremote. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPCoreLocationManger.h"
<<<<<<< HEAD
=======
#import "HIRRootViewController.h"
>>>>>>> 1f4a0e438f3422d53e2c06218d0bd0db715d1473

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property(nonatomic) UIWindow *window;

@property(nonatomic) HPCoreLocationManger *locManger;
@property(nonatomic) HIRRootViewController *rootVC;
- (void)addNewDevice;
- (void)connectSuccessToShowRootVC; ////显示主界面


@end

