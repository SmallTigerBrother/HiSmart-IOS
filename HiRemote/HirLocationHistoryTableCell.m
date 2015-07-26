//
//  HirLocationHistoryTableCell.m
//  HiRemote
//
//  Created by rick on 15/6/27.
//  Copyright (c) 2015年 hiremote. All rights reserved.
//

#import "HirLocationHistoryTableCell.h"
#define HeightOfCell (15*2 + PVI02_SIZE_M * 3)
@implementation HirLocationHistoryTableCell

+(CGFloat)heightOfCellWithData:(id)data{
    CGFloat height = HeightOfCell;
    return height;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier containingTableView:(UITableView *)containingTableView leftUtilityButtons:(NSArray *)leftUtilityButtons rightUtilityButtons:(NSArray *)rightUtilityButtons{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier containingTableView:containingTableView leftUtilityButtons:leftUtilityButtons rightUtilityButtons:rightUtilityButtons]) {
        [self addSubviewToCell];
    }
    return self;
}

- (void)addSubviewToCell{
    
    self.titleLabel = [[UILabel alloc]init];
    [self.contentView addSubview:self.titleLabel];
    
    UIImage *locationImg = [UIImage imageNamed:@"locationIcon"];
    self.LocationImgView = [[UIImageView alloc]init];
    self.LocationImgView.image = locationImg;
    [self.contentView addSubview:self.LocationImgView];
    
    self.contentLabel = [[HirVerticalLabel alloc]init];
    self.contentLabel.verticalAlignment = VerticalAlignmentTop;
    [self.contentView addSubview:self.contentLabel];
    
    self.timeLabel = [[UILabel alloc]init];
    [self.contentView addSubview:self.timeLabel];
    
    self.LocationImgView.image = [UIImage imageNamed:@"locationIcon"];
    UIImage *accessoryImg = [UIImage imageNamed:@"cellDetailAccessory"];
    UIImageView *accessoryView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, accessoryImg.size.width, accessoryImg.size.height)];
    accessoryView.image = accessoryImg;
    self.accessoryView = accessoryView;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.titleLabel.frame = CGRectMake(Cell_LeftMargin, PVI02_SIZE_M, 195, 15);
    self.LocationImgView.frame = CGRectMake(Cell_LeftMargin, HeightOfCell - PVI02_SIZE_M -15, self.LocationImgView.image.size.width, self.LocationImgView.image.size.height);
    self.contentLabel.frame = CGRectMake(CGRectGetMaxX(self.LocationImgView.frame) + Cell_Pand_H, CGRectGetMinY(self.LocationImgView.frame), CGRectGetMinX(self.accessoryView.frame) - CGRectGetMaxX(self.LocationImgView.frame) - 2*Cell_Pand_H, 15);
    CGFloat widthOfTimeLabel = 76;
    self.timeLabel.frame = CGRectMake(SCREEN_WIDTH - 33 - widthOfTimeLabel, PVI02_SIZE_M, widthOfTimeLabel, 15);
}
@end


/*


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


*/
//@end
