//
//  HirLocationHistoryTableCell.h
//  HiRemote
//
//  Created by minfengliu on 15/6/27.
//  Copyright (c) 2015年 hiremote. All rights reserved.
//

#import "MultiFunctionCell.h"

@interface HirLocationHistoryTableCell : MultiFunctionCell

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *contentLabel;
@property (strong, nonatomic) UIImageView *LocationImgView;

+(CGFloat)heightOfCellWithData:(id)data;

@end
