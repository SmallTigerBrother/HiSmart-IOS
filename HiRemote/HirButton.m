//
//  HirBaseTableCell.h
//  HiRemote
//
//  Created by rick on 15/6/30.
//  Copyright (c) 2015年 hiremote. All rights reserved.
//

#import "HirButton.h"

@implementation HirButton

-(id)initWithFrame:(CGRect)frame withTitle:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self = [UIButton buttonWithType:UIButtonTypeCustom];
        self.frame = frame;
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        self.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = FONT_ALERTVIEW_TITLE;

    }
    return self;
}

-(id)initWithFrame:(CGRect)frame withWhiteColorTitle:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self = [UIButton buttonWithType:UIButtonTypeCustom];
        self.frame = frame;
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        self.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = FONT_ALERTVIEW_TITLE;
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame withType:(customBtnType)customBtnType
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self = [UIButton buttonWithType:UIButtonTypeCustom];
        self.frame = frame;
        
        NSString *imageStr = [NSString string];
        NSString *imageHighStr = [NSString string];
        UIColor *titleColor = [UIColor whiteColor];
        
        switch (customBtnType) {
            case customBtnTypeParkMainColorBtn:
            {
                imageStr = @"color_main";
                imageHighStr = @"color_main";
                titleColor = [UIColor whiteColor];
                break ;
            }
            default:
                break;
        }
        [self setBackgroundImage:[[UIImage imageNamed:imageStr] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)] forState:UIControlStateNormal];
        [self setBackgroundImage:[[UIImage imageNamed:imageHighStr] resizableImageWithCapInsets:UIEdgeInsetsMake(4, 4, 4, 4)] forState:UIControlStateHighlighted];
       
        [self setTitleColor:titleColor forState:UIControlStateNormal];
    }
    return self;
}



-(id)initWithFrame:(CGRect)frame withTitle:(NSString *)title andSeparateView:(UIColor*)color{


    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self = [UIButton buttonWithType:UIButtonTypeCustom];
        self.frame = frame;
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:COLOR_THEME forState:UIControlStateNormal];
        [self setTitleColor:COLOR_THEME forState:UIControlStateHighlighted];
        self.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = FONT_ALERTVIEW_TITLE;
        
        UIView *separeateView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0.5)];
        [separeateView setBackgroundColor:COLOR_FRAME];
        [self addSubview:separeateView];

        
        
    }
    return self;
}
@end























