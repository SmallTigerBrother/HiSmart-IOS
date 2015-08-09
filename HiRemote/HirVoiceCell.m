//
//  HirVoiceCell.m
//  HiRemote
//
//  Created by rick on 15/7/4.
//  Copyright (c) 2015年 hiremote. All rights reserved.
//

#import "HirVoiceCell.h"
#define HeightOfCell (55)

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
    self.titleLabel.frame = CGRectMake(Cell_LeftMargin, Cell_Pand_V, 195, 20);
    self.dateLabel.frame = CGRectMake(Cell_LeftMargin, HeightOfCell - Cell_Pand_V - 15, 80, 15);
    self.voiceRecodeTimeLabel.frame = CGRectMake(CGRectGetMaxX(self.dateLabel.frame) + Cell_Pand_H, HeightOfCell - Cell_Pand_V - 15, 100, 15);
}

@end
