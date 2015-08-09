//
//  HirLocationHistoryTableCell.m
//  HiRemote
//
//  Created by rick on 15/6/27.
//  Copyright (c) 2015年 hiremote. All rights reserved.
//

#import "HirLocationHistoryTableCell.h"
#define HeightOfCell (16*3 + PVI02_SIZE_M * 3)
@implementation HirLocationHistoryTableCell

+(CGFloat)heightOfCellWithData:(NSString *)content{
    
    return HeightOfCell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier containingTableView:(UITableView *)containingTableView leftUtilityButtons:(NSArray *)leftUtilityButtons rightUtilityButtons:(NSArray *)rightUtilityButtons{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier containingTableView:containingTableView leftUtilityButtons:leftUtilityButtons rightUtilityButtons:rightUtilityButtons]) {
        [self addSubviewToCell];
        self.titleLabel.font = FONT_TABLE_CELL_TITLE;
        self.contentLabel.font = FONT_TABLE_CELL_CONTENT;
        self.timeLabel.font = FONT_TABLE_CELL_RIGHT_TIME;

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
    self.contentLabel.verticalAlignment = VerticalAlignmentMiddle;
    self.contentLabel.numberOfLines = 0;
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
    self.LocationImgView.frame = CGRectMake(Cell_LeftMargin, CGRectGetMaxY(self.titleLabel.frame), self.LocationImgView.image.size.width, self.frame.size.height - CGRectGetMaxY(self.titleLabel.frame));
    self.LocationImgView.contentMode = UIViewContentModeScaleAspectFit;
    self.contentLabel.frame = CGRectMake(CGRectGetMaxX(self.LocationImgView.frame) + PHI01_SIZE_S, CGRectGetMaxY(self.titleLabel.frame) + PVI02_SIZE_M, CGRectGetMinX(self.accessoryView.frame) - CGRectGetMaxX(self.LocationImgView.frame) - PHI01_SIZE_S*2, 32);
    
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
