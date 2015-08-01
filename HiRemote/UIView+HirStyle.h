//
//  UIView+HirStyle.h
//  HiRemote
//
//  Created by Peng on 15/8/1.
//  Copyright (c) 2015年 hiremote. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HirStyleViewColor) {
    HirStyleViewColor_Pale,
};

@interface UIView (HirStyle)

-(void)settingStyle:(HirStyleViewColor)styleViewColor;

@end
