//
//  UIControl+AddLine.h
//  HiRemote
//
//  Created by rick on 15/7/3.
//  Copyright (c) 2015年 hiremote. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIControl (AddLine)
//0x1111  上左下右
-(void)addLine:(NSInteger)addLineType;

@property (nonatomic, strong)UIColor *lineColor;

@end
