//
//  AppDelegate.h
//  HiRemote
//
//  Created by parker on 6/25/15.
//  Copyright (c) 2015 hiremote. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (nonatomic, strong) NSMutableArray *deviceInfoArray; ///临时保存设备信息（可能有多个设备）
@property(nonatomic) UIWindow *window;

- (void)addNewDevice;
- (void)connectSuccessToShowRootVC; ////显示主界面


@end

