//
//  HirActionTextField.m
//  HiRemote
//
//  Created by rick on 15/7/2.
//  Copyright (c) 2015年 hiremote. All rights reserved.
//

#import "HirActionTextField.h"

@implementation HirActionTextField

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.layer.cornerRadius = IMAGE_CORNER_RADIUS;
        self.clipsToBounds = YES;
        self.layer.borderWidth = 1.f;
        self.layer.borderColor = [UIColor clearColor].CGColor;
    }
    return self;
}

-(void)drawBorderColorWith:(UIColor *)borderColor{
    self.layer.borderColor = borderColor.CGColor;
}
@end
