//
//  HirActionTextView.m
//  HiRemote
//
//  Created by minfengliu on 15/7/2.
//  Copyright (c) 2015年 hiremote. All rights reserved.
//

#import "HirActionTextView.h"

@implementation HirActionTextView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)init{
    if(self = [super init]){
        self.layer.cornerRadius = IMAGE_CORNER_RADIUS;
        self.clipsToBounds = YES;
        self.layer.borderWidth = 1.f;
    }
    return self;
}

-(void)drawBorderColorWith:(UIColor *)borderColor{
    self.layer.borderColor = borderColor.CGColor;
}
@end
