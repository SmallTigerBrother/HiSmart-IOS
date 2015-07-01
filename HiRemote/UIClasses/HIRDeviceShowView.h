//
//  HIRDeviceShowView.h
//  HiRemote
//
//  Created by parker on 6/26/15.
//  Copyright (c) 2015 hiremote. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HIRBatteryPercentView.h"
#import "HIRArcImageView.h"

@interface HIRDeviceShowView : UIView
@property (nonatomic, strong) HIRArcImageView *avatarImageView;
@property (nonatomic, strong) HIRBatteryPercentView *batteryPercent;
@property (nonatomic, strong) UILabel *deviceNameLabel;
@property (nonatomic, strong) UILabel *deviceLocationLabel;
@end
