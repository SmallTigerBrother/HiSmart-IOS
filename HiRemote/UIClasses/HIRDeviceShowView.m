//
//  HIRDeviceShowView.m
//  HiRemote
//
//  Created by parker on 6/26/15.
//  Copyright (c) 2015 hiremote. All rights reserved.
//

#import "HIRDeviceShowView.h"
#import "PureLayout.h"
#import "HirDevice.h"

@interface HIRDeviceShowView ()
@property (nonatomic, assign) BOOL didSetupConstraints;
@end



@implementation HIRDeviceShowView
@synthesize avatarImageView;
@synthesize batteryPercent;
@synthesize deviceNameLabel;
@synthesize deviceLocationLabel;
@synthesize reconnectionButton;

- (id)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];//[UIColor colorWithRed:0.61 green:0.61 blue:0.63 alpha:1];
        self.avatarImageView = [[HIRArcImageView alloc] init];
        //self.avatarImageView.backgroundColor = [UIColor redColor];
        self.batteryPercent = [[HIRBatteryPercentView alloc] init];
        self.batteryPercent.arcFinishColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.93 alpha:1];
        self.batteryPercent.arcUnfinishColor = [UIColor colorWithRed:0.38 green:0.74 blue:0.56 alpha:1];
        ///这个是背景颜色,不随百分比变化
        self.batteryPercent.arcBackColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.93 alpha:1];
        //self.batteryPercent.percent = 1;
        self.reconnectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.deviceNameLabel = [[UILabel alloc] init];
        self.deviceNameLabel.textColor = [UIColor whiteColor];
       // self.deviceNameLabel.backgroundColor = [UIColor yellowColor];
        self.deviceNameLabel.font = [UIFont boldSystemFontOfSize:17];
        self.deviceNameLabel.textAlignment = NSTextAlignmentCenter;
       // self.deviceNameLabel.text = @"sdafasfdasfasdfas";
        self.deviceLocationLabel = [[UILabel alloc] init];
        self.deviceLocationLabel.textColor = [UIColor whiteColor];
        self.deviceLocationLabel.font = [UIFont systemFontOfSize:13];
        self.deviceLocationLabel.textAlignment = NSTextAlignmentCenter;
      //  self.deviceLocationLabel.backgroundColor = [UIColor greenColor];
       // self.deviceLocationLabel.text = @"22333444";
        
        [self addSubview:self.batteryPercent];
        [self addSubview:self.avatarImageView];
        [self addSubview:self.reconnectionButton];
        [self addSubview:self.deviceNameLabel];
        [self addSubview:self.deviceLocationLabel];
        
        [self setNeedsUpdateConstraints];
        
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        if (DEVICE_IS_IPHONE6p) {
            [self.avatarImageView autoSetDimensionsToSize:CGSizeMake(135, 135)];
            [self.avatarImageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
            [self.avatarImageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5];
            
            [self.batteryPercent autoSetDimensionsToSize:CGSizeMake(140, 140)];
            [self.batteryPercent autoAlignAxisToSuperviewAxis:ALAxisVertical];
            [self.batteryPercent autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:2];
        }else if(DEVICE_IS_IPHONE6){
            [self.avatarImageView autoSetDimensionsToSize:CGSizeMake(120, 120)];
            [self.avatarImageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
            [self.avatarImageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5];
            
            [self.batteryPercent autoSetDimensionsToSize:CGSizeMake(125, 125)];
            [self.batteryPercent autoAlignAxisToSuperviewAxis:ALAxisVertical];
            [self.batteryPercent autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:2];
        }else {
            [self.avatarImageView autoSetDimensionsToSize:CGSizeMake(100, 100)];
            [self.avatarImageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
            [self.avatarImageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5];
            
            [self.batteryPercent autoSetDimensionsToSize:CGSizeMake(105, 105)];
            [self.batteryPercent autoAlignAxisToSuperviewAxis:ALAxisVertical];
            [self.batteryPercent autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:2];
        }
        
        [self.reconnectionButton autoSetDimensionsToSize:CGSizeMake(140, 140)];
        [self.reconnectionButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [self.reconnectionButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:2];
        
        [self.deviceNameLabel autoSetDimension:ALDimensionHeight toSize:23];
        [self.deviceNameLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:40.0];
        [self.deviceNameLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:40.0];
        [self.deviceNameLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.batteryPercent withOffset:0];
        
        [self.deviceLocationLabel autoSetDimension:ALDimensionHeight toSize:16];
        [self.deviceLocationLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:40.0];
        [self.deviceLocationLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:40.0];
        [self.deviceLocationLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.deviceNameLabel withOffset:0];
        self.didSetupConstraints = YES;
    }
    
    [super updateConstraints];
}



- (void)dealloc {
    NSLog(@"show view dealloc");
    self.avatarImageView = nil;
    self.batteryPercent = nil;
    self.reconnectionButton = nil;
    self.deviceLocationLabel = nil;
    self.deviceNameLabel = nil;
}

@end
