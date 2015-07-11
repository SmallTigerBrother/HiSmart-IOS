//
//  HirBaseTableCell.h
//  HiRemote
//
//  Created by rick on 15/6/30.
//  Copyright (c) 2015年 hiremote. All rights reserved.
//

#import "UIView+AddLine.h"

@implementation UIView (AddLine)
-(void)addLine:(NSInteger)addLineType{
    BOOL upFlag     = addLineType & (1);
    BOOL leftFlag   = addLineType & (1<<1);
    BOOL downFlag   = addLineType & (1<<2);
    BOOL rightFlag  = addLineType & (1<<3);
    
    if (upFlag) {
        UIView *upLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, SEPARATE_LINE_HEIGHT_DEFAULT)];
        upLine.backgroundColor = BG_COLOR_C8C7CC;
        [self addSubview:upLine];
    }
    if (leftFlag) {
        UIView *leftLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SEPARATE_LINE_HEIGHT_DEFAULT, self.frame.size.height)];
        leftLine.backgroundColor = BG_COLOR_C8C7CC;
        [self addSubview:leftLine];
    }
    if (downFlag) {
        UIView *downLine = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - SEPARATE_LINE_HEIGHT_DEFAULT, self.frame.size.width, SEPARATE_LINE_HEIGHT_DEFAULT)];
        downLine.backgroundColor = BG_COLOR_C8C7CC;
        [self addSubview:downLine];
    }
    if (rightFlag) {
        UIView *rightLine = [[UIView alloc]initWithFrame:CGRectMake(self.frame.size.width - SEPARATE_LINE_HEIGHT_DEFAULT, 0, SEPARATE_LINE_HEIGHT_DEFAULT, self.frame.size.height)];
        rightLine.backgroundColor = BG_COLOR_C8C7CC;
        [self addSubview:rightLine];
    }
}
@end
