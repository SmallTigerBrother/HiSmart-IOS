//
//  UIView+HirStyle.m
//  HiRemote
//
//  Created by Peng on 15/8/1.
//  Copyright (c) 2015年 hiremote. All rights reserved.
//

#import "UIView+HirStyle.h"

@implementation UIView (HirStyle)
-(void)settingStyle:(HirStyleViewColor)styleViewColor{
    switch (styleViewColor) {
        case HirStyleViewColor_Pale:
        {
            [self setStyleWithForeground:[UIColor whiteColor] backGroudColor:[UIColor colorWithRed:0.57 green:0.84 blue:0.73 alpha:1]];
        }
            break;
            
        default:
            break;
    }
}

-(void)setStyleWithForeground:(UIColor *)foregroundColor backGroudColor:(UIColor *)backGroundColor;
{
    if ([self isKindOfClass:[UIButton class]]) {
        UIButton *targetView = (UIButton *)self;
        [targetView setTitleColor:foregroundColor forState:UIControlStateNormal];
        targetView.backgroundColor = backGroundColor;
    }
    else if([self isKindOfClass:[UITextView class]]){
        UITextView *targetView = (UITextView *)self;
        targetView.textColor = foregroundColor;
        targetView.backgroundColor = backGroundColor;
    }
    else if ([self isKindOfClass:[UITextField class]]){
        UITextField *targetView = (UITextField *)self;
        targetView.textColor = foregroundColor;
        targetView.backgroundColor = backGroundColor;
    }
}
@end
