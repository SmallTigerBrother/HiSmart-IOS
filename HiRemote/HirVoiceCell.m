//
//  HirVoiceCell.m
//  HiRemote
//
//  Created by rick on 15/7/4.
//  Copyright (c) 2015年 hiremote. All rights reserved.
//

#import "HirVoiceCell.h"
#define HeightOfCell (44)

@implementation HirVoiceCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self addSubviewToCell];
    }
    return self;
}

+(CGFloat)heightOfCellWithData:(id)data{
    return HeightOfCell;
}

- (void)addSubviewToCell{
    
    self.titleLabel = [[UILabel alloc]init];
    [self.contentView addSubview:self.titleLabel];
    
    self.dateLabel = [[UILabel alloc]init];
    [self.contentView addSubview:self.dateLabel];
    
    self.voiceRecodeTimeLabel = [[UILabel alloc]init];
    [self.contentView addSubview:self.voiceRecodeTimeLabel];
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.titleLabel.frame = CGRectMake(Cell_LeftMargin, Cell_Pand_V, 195, 15);
    self.dateLabel.frame = CGRectMake(Cell_LeftMargin, CGRectGetMaxY(self.titleLabel.frame)+Cell_Pand_V, 80, 15);
    self.voiceRecodeTimeLabel.frame = CGRectMake(CGRectGetMaxX(self.dateLabel.frame) + Cell_Pand_H, CGRectGetMaxY(self.titleLabel.frame)+Cell_Pand_V, 100, 15);
}

@end
