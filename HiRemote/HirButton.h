//
//  HirBaseTableCell.h
//  HiRemote
//
//  Created by rick on 15/6/30.
//  Copyright (c) 2015年 hiremote. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 Gray 灰色
 green 绿色
 red 红色
 big high=44
 other high=29
 */
typedef NS_ENUM(NSInteger, customBtnType)
{
    customBtnTypeGray = 0,
    customBtnTypeGreen = 1,
    customBtnTypeRed = 2,
    customBtnTypeBigGray = 3,
    customBtnTypeBigGreen = 4,
    customBtnTypeBigDarkGreen = 5,
    customBtnTypeBigRed = 6,
    customBtnTypeTigerActionBtn = 7,
    customBtnTypeParkMainColorBtn = 8,
};

@interface HirButton : UIButton
-(id)initWithFrame:(CGRect)frame withTitle:(NSString *)title;

//白色字
-(id)initWithFrame:(CGRect)frame withWhiteColorTitle:(NSString *)title;

-(id)initWithFrame:(CGRect)frame withType:(customBtnType)customBtnType;
-(id)initWithFrame:(CGRect)frame withTitle:(NSString *)title andSeparateView:(UIColor*)color;
@end































