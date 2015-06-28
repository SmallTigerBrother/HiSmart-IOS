//
//  HirLocationHistoryTableCell.m
//  HiRemote
//
//  Created by minfengliu on 15/6/27.
//  Copyright (c) 2015年 hiremote. All rights reserved.
//

#import "HirLocationHistoryTableCell.h"
#define HeightOfCell 58
@implementation HirLocationHistoryTableCell


-(instancetype)init{
    if(self = [super init]){
        
        self.titleLabel = [[UILabel alloc]init];
        [self.contentView addSubview:self.titleLabel];
        
        UIImage *locationImg = [UIImage imageNamed:@"locationIcon"];
        self.LocationImgView = [[UIImageView alloc]init];
        self.LocationImgView.image = locationImg;
        [self.contentView addSubview:self.LocationImgView];
        
        self.contentLabel = [[UILabel alloc]init];
        [self.contentView addSubview:self.contentLabel];
        
        self.LocationImgView.image = [UIImage imageNamed:@"locationIcon"];
        UIImage *accessoryImg = [UIImage imageNamed:@"cellDetailAccessory"];
        UIImageView *accessoryView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, accessoryImg.size.width, accessoryImg.size.height)];
        accessoryView.image = accessoryImg;
        self.accessoryView = accessoryView;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews{
    self.titleLabel.frame = CGRectMake(Cell_Pand_H, Cell_Pand_V, 195, 21);
    self.LocationImgView.frame = CGRectMake(Cell_Pand_H, CGRectGetMaxY(self.titleLabel.frame)+ Cell_Pand_V + (self.contentLabel.frame.size.height - self.LocationImgView.image.size.height)/2, self.LocationImgView.image.size.width, self.LocationImgView.image.size.height);
    self.contentLabel.frame = CGRectMake(CGRectGetMaxX(self.LocationImgView.frame), CGRectGetMaxY(self.titleLabel.frame)+Cell_Pand_V, 163, 21);
    CGFloat widthOfTimeLabel = 76;
    self.timeLabel.frame = CGRectMake(SCREEN_WIDTH - 33 - widthOfTimeLabel, Cell_Pand_V, widthOfTimeLabel, 21);
}

+(CGFloat)heightOfCellWithData:(id)data{
    return HeightOfCell;
}

@end
