//
//  HirBaseTableCell.h
//  HiRemote
//
//  Created by minfengliu on 15/6/30.
//  Copyright (c) 2015年 hiremote. All rights reserved.
//


#import "HirWindow.h"

#define WINDOW_LEFT_PADDING         (10)
#define WINDOW_WIDTH                (SCREEN_WIDTH - 2*WINDOW_LEFT_PADDING)

#define Size_font_message           FONT2(16)

#define Font_title                  FONT2(16)
#define Font_message                FONT2(16)

#define Padding_vertical            22.f
#define Padding_horizontal          15.f
#define Padding_btn_bottom          37.f

#define Height_btton                45.f

#define Time_animation              0.2f

#define Color_title                 [UIColor blackColor]
#define Color_message               (COLOR(109,109,114))

@protocol HirAlertViewDelegate;

typedef void (^HirAlertViewClick)(NSInteger index);

@interface HirAlertView : UIView

@property (nonatomic,assign)BOOL isModelView;   //是不是模态弹框,默认no

@property (nonatomic, strong)UIView *contentView;   //装载中间内容的view

- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id /*<HirAlertViewDelegate>*/)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

- (id)initWithTitle:(NSString *)title message:(NSString *)message clickBlock:(HirAlertViewClick)alertViewClick cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

- (id)initWithTitle:(NSString *)title contenView:(UIView *)contenView clickBlock:(HirAlertViewClick)alertViewClick cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

-(void)showWithAnimation:(BOOL)isHaveAnimation;
-(void)hideWithAnimation:(BOOL)isHaveAnimation;

@end

@protocol HirAlertViewDelegate <NSObject>

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)HirAlertView:(HirAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
@end