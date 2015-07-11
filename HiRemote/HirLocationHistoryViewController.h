//
//  ALLocationHistoryViewController.h
//  antiLost
//
//  Created by minfengliu on 15/6/27.
//  Copyright (c) 2015年 spark. All rights reserved.
//

#import "HirBaseViewController.h"


@interface HirLocationHistoryViewController : HirBaseViewController

-(instancetype)initWithDataType:(HirLocationDataType)dataType;

@property (nonatomic, weak)id findDelegate;
@end
