//
//  HirLocationHistoryTableCell.h
//  HiRemote
//
//  Created by rick on 15/6/27.
//  Copyright (c) 2015年 hiremote. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
#import "HirVerticalLabel.h"

@interface HirLocationHistoryTableCell:SWTableViewCell
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) HirVerticalLabel *contentLabel;
@property (strong, nonatomic) UIImageView *LocationImgView;

@property (nonatomic, strong) NSIndexPath *indexPath;

+(CGFloat)heightOfCellWithData:(NSString *)content;

@end
