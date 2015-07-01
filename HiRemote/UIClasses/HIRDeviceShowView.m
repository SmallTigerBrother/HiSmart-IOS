//
//  HIRDeviceShowView.m
//  HiRemote
//
//  Created by parker on 6/26/15.
//  Copyright (c) 2015 hiremote. All rights reserved.
//

#import "HIRDeviceShowView.h"
#import "PureLayout.h"


@interface HIRDeviceShowView ()
@property (nonatomic, assign) BOOL didSetupConstraints;
@end



@implementation HIRDeviceShowView
@synthesize avatarImageView;
@synthesize batteryPercent;
@synthesize deviceNameLabel;
@synthesize deviceLocationLabel;


- (id)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.61 green:0.61 blue:0.63 alpha:1];
        self.avatarImageView = [[HIRArcImageView alloc] init];
      //  self.avatarImageView.backgroundColor = [UIColor redColor];
        self.batteryPercent = [[HIRBatteryPercentView alloc] init];
        self.batteryPercent.arcFinishColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.93 alpha:1];
        self.batteryPercent.arcUnfinishColor = [UIColor colorWithRed:0.38 green:0.74 blue:0.56 alpha:1];
        self.batteryPercent.arcBackColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.93 alpha:1];
        //self.batteryPercent.percent = 1;
        self.deviceNameLabel = [[UILabel alloc] init];
        self.deviceNameLabel.textColor = [UIColor whiteColor];
        //self.deviceNameLabel.backgroundColor = [UIColor yellowColor];
        self.deviceNameLabel.font = [UIFont boldSystemFontOfSize:17];
        self.deviceNameLabel.textAlignment = NSTextAlignmentCenter;
        self.deviceLocationLabel = [[UILabel alloc] init];
        self.deviceLocationLabel.textColor = [UIColor whiteColor];
        self.deviceLocationLabel.font = [UIFont systemFontOfSize:13];
        self.deviceLocationLabel.textAlignment = NSTextAlignmentCenter;
        //self.deviceLocationLabel.backgroundColor = [UIColor greenColor];
        
        [self addSubview:self.batteryPercent];
        [self addSubview:self.avatarImageView];
        [self addSubview:self.deviceNameLabel];
        [self addSubview:self.deviceLocationLabel];
        
        [self setNeedsUpdateConstraints];
        
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        [self.avatarImageView autoSetDimensionsToSize:CGSizeMake(81, 81)];
        [self.avatarImageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [self.avatarImageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5];
        
        [self.batteryPercent autoSetDimensionsToSize:CGSizeMake(85, 85)];
        [self.batteryPercent autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [self.batteryPercent autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:3];
        
        [self.deviceNameLabel autoSetDimension:ALDimensionHeight toSize:25];
        [self.deviceNameLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:40.0];
        [self.deviceNameLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:40.0];
        [self.deviceNameLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.batteryPercent withOffset:0];
        
        [self.deviceLocationLabel autoSetDimension:ALDimensionHeight toSize:20];
        [self.deviceLocationLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:40.0];
        [self.deviceLocationLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:40.0];
        [self.deviceLocationLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.deviceNameLabel withOffset:-8];
        self.didSetupConstraints = YES;
    }
    
    [super updateConstraints];
}



- (void)dealloc {
    NSLog(@"show view dealloc");
    self.avatarImageView = nil;
    self.batteryPercent = nil;
    self.deviceLocationLabel = nil;
    self.deviceNameLabel = nil;
}

@end
