//
//  HirBaseTableCell.h
//  HiRemote
//
//  Created by minfengliu on 15/6/30.
//  Copyright (c) 2015年 hiremote. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum
{
    VerticalAlignmentTop = 0, // default
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
} VerticalAlignment;

@interface HirVerticalLabel : UILabel

@property (nonatomic) VerticalAlignment verticalAlignment;
@end
