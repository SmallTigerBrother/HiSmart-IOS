//
//  HirBaseTableCell.h
//  HiRemote
//
//  Created by minfengliu on 15/6/30.
//  Copyright (c) 2015年 hiremote. All rights reserved.
//

#import "HirAlertView.h"
#import "HirButton.h"
//#import "UIView+AddLine.h"
//font size
#define Size_font_title (20)

@interface HirAlertView (){
    BOOL _isHaveCancelBtn;
}
@property (nonatomic,strong)NSMutableArray *otherButtonTitles;
@property (nonatomic,weak) id<HirAlertViewDelegate> delegater;
@property (nonatomic,strong)UIView *backView;
@property (nonatomic,copy)HirAlertViewClick alertViewClick;
@end

@implementation HirAlertView

- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id /*<HirAlertViewDelegate>*/)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION{
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    if(self){
        self.delegater = delegate;
        self.isModelView = YES;
        self.alpha = 0;
        self.backgroundColor = POPUP_WINDOW_BG_COLOR;
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        
        // 边框
        self.backView = [[UIView alloc]init];
        self.backView.layer.cornerRadius = IMAGE_CORNER_RADIUS;
        self.backView.userInteractionEnabled = YES;
        self.backView.layer.masksToBounds = YES ;
        [self.backView setBackgroundColor:COLOR_ALERTVIEW_BACKGROUD_GRAY];
        self.backView.autoresizingMask  = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:self.backView];
        
        //add title
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(Padding_horizontal, Padding_vertical, WINDOW_WIDTH - 2 * Padding_horizontal, Size_font_title + 2)];
        titleLabel.font = FONT_ALERTVIEW_TITLE;
        
        titleLabel.textColor = Color_title;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = title;
        [self.backView addSubview:titleLabel];
        
        //add message
        UILabel *messageLabel = [[UILabel alloc]init];
        messageLabel.font = Font_message;
        messageLabel.numberOfLines = 0;
        messageLabel.textColor = Color_message;
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.text = message;
        CGSize sizeOfMessage = [messageLabel.text sizeWithFont:Font_message constrainedToSize:CGSizeMake(WINDOW_WIDTH - 2 * Padding_horizontal, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        messageLabel.frame = CGRectMake(Padding_horizontal, Padding_vertical + titleLabel.frame.size.height + titleLabel.frame.origin.y, WINDOW_WIDTH - 2 * Padding_horizontal, sizeOfMessage.height);
        [self.backView addSubview:messageLabel];
        
        //add btn
        self.otherButtonTitles = [[NSMutableArray alloc]initWithCapacity:0];
        va_list args;
        va_start(args, otherButtonTitles);
        for (NSString * otherTitle = otherButtonTitles; otherTitle.length > 0; otherTitle = va_arg(args, NSString*)) {
            NSLog(@"otherTitle=%@",otherTitle);
            [self.otherButtonTitles addObject:otherTitle];
        }
        va_end(args);
        
        NSInteger countOfBtn = [self.otherButtonTitles count];
        if(cancelButtonTitle.length>0){
            countOfBtn++;
            _isHaveCancelBtn = YES;
        }
        CGFloat widOfBtn = WINDOW_WIDTH/countOfBtn;
        CGFloat originYOfBtn = messageLabel.frame.origin.y + messageLabel.frame.size.height + Padding_vertical;

        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, originYOfBtn-SEPARATE_LINE_HEIGHT_DEFAULT, WINDOW_WIDTH, SEPARATE_LINE_HEIGHT_DEFAULT)];
        line.backgroundColor = BG_COLOR_C8C7CC;
        [self.backView addSubview:line];

        for(NSInteger i = 0;i < countOfBtn; i++){
            
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(widOfBtn*i, originYOfBtn, widOfBtn, Height_btton)];
            btn.titleLabel.font = TEXT_FONT_XXXL;
            btn.tag = i;
            [btn addTarget:self action:@selector(btnPress:) forControlEvents:UIControlEventTouchUpInside];
            if(i==0 && _isHaveCancelBtn){
                [btn setTitle:cancelButtonTitle forState:UIControlStateNormal];
                [btn setTitleColor:COLOR_ALERT_BTN_TITLE forState:UIControlStateNormal];
            }
            else{
                NSInteger titleIndex = _isHaveCancelBtn?i-1:i;
                [btn setTitle:[self.otherButtonTitles objectAtIndex:titleIndex] forState:UIControlStateNormal];
                [btn setTitleColor:TEXT_COLOR_TL forState:UIControlStateNormal];
            }
            
            if(i!=0){
                [btn addLine:HirAddLineTypeLeft];
            }
            
            
            [self.backView addSubview:btn];
        }
        
        CGFloat heightOfBackView = originYOfBtn + (countOfBtn>0?(Height_btton):0);
        self.backView.frame = CGRectMake(WINDOW_LEFT_PADDING, (SCREEN_HEIGHT - heightOfBackView)/2 - 50, WINDOW_WIDTH, heightOfBackView);
    }
    return self;
}

-(instancetype)initWithTitle:(NSString *)title message:(NSString *)message clickBlock:(HirAlertViewClick)alertViewClick cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...{
    self = [self initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
    if (self) {
        self.alertViewClick = alertViewClick;
    }
    return self;
}

- (id)initWithTitle:(NSString *)title contenView:(UIView *)contenView clickBlock:(HirAlertViewClick)alertViewClick cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION{
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    if(self){
        self.isModelView = YES;
        self.alertViewClick = alertViewClick;
        self.alpha = 0;
        self.backgroundColor = POPUP_WINDOW_BG_COLOR;
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        
        // 边框
        self.backView = [[UIView alloc]init];
        self.backView.layer.cornerRadius = IMAGE_CORNER_RADIUS;
        self.backView.userInteractionEnabled = YES;
        self.backView.layer.masksToBounds = YES ;
        [self.backView setBackgroundColor:BG_COLOR_EFEFF4];
        self.backView.autoresizingMask  = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:self.backView];
        
        //add title
        UILabel *titleLabel;
        CGFloat originY = 0;
        if(title.length>0){
            titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(Padding_horizontal, Padding_vertical, WINDOW_WIDTH - 2 * Padding_horizontal, Size_font_title + 2)];
            titleLabel.font = Font_title;
            titleLabel.textColor = Color_title;
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.text = title;
            [self.backView addSubview:titleLabel];
            originY += Padding_vertical + titleLabel.frame.size.height;
        }
        
        self.contentView = [[UIView alloc]initWithFrame:CGRectMake(0,  originY, WINDOW_WIDTH, contenView.frame.size.height)];
        [self.contentView addSubview:contenView];
        [self.backView addSubview:self.contentView];
        originY += self.contentView.frame.size.height + Padding_vertical;
        
        //add btn
        self.otherButtonTitles = [[NSMutableArray alloc]initWithCapacity:0];
        va_list args;
        va_start(args, otherButtonTitles);
        for (NSString * otherTitle = otherButtonTitles; otherTitle.length > 0; otherTitle = va_arg(args, NSString*)) {
            NSLog(@"otherTitle=%@",otherTitle);
            [self.otherButtonTitles addObject:otherTitle];
        }
        va_end(args);
        
        NSInteger countOfBtn = [self.otherButtonTitles count];
        if(cancelButtonTitle.length>0){
            countOfBtn++;
            _isHaveCancelBtn = YES;
        }
        CGFloat widOfBtn = WINDOW_WIDTH/countOfBtn;
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, originY-1, WINDOW_WIDTH, SEPARATE_LINE_HEIGHT_DEFAULT)];
        line.backgroundColor = BG_COLOR_C8C7CC;
        [self.backView addSubview:line];
        
        for(NSInteger i = 0;i < countOfBtn; i++){
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(widOfBtn*i, originY, widOfBtn, Height_btton)];
            btn.tag = i;
            [btn addTarget:self action:@selector(btnPress:) forControlEvents:UIControlEventTouchUpInside];
            btn.titleLabel.font = TEXT_FONT_XXXL;
            if(i==0 && _isHaveCancelBtn){
                [btn setTitle:cancelButtonTitle forState:UIControlStateNormal];
                
                [btn setTitleColor:TEXT_COLOR_TA forState:UIControlStateNormal];
            }
            else{
                NSInteger titleIndex = _isHaveCancelBtn?i-1:i;
                [btn setTitle:[self.otherButtonTitles objectAtIndex:titleIndex] forState:UIControlStateNormal];
                [btn setTitleColor:TEXT_COLOR_TL forState:UIControlStateNormal];
            }
            if(i!=0){
                [btn addLine:HirAddLineTypeLeft];
            }
            [self.backView addSubview:btn];
        }
        
        CGFloat heightOfBackView = originY + (countOfBtn>0?(Height_btton):(-Padding_vertical));
        self.backView.frame = CGRectMake(WINDOW_LEFT_PADDING, (SCREEN_HEIGHT - heightOfBackView)/2 - 50, WINDOW_WIDTH, heightOfBackView);
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification object:nil];
        self.backView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma HirAlertView delegate methods
- (void)HirAlertView:(HirAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (self.alertViewClick) {
        self.alertViewClick(buttonIndex);
    }
}

-(void)showWithAnimation:(BOOL)isHaveAnimation{
    if (isHaveAnimation) {
        [UIView animateWithDuration:Time_animation animations:^(void){
            self.alpha = 1.;
        }completion:nil];
    }
    else{
        self.alpha = 1.;
    }
}

-(void)hideWithAnimation:(BOOL)isHaveAnimation{
    if (isHaveAnimation) {
        [UIView animateWithDuration:Time_animation animations:^(void){
            self.alpha = 0;
        }completion:^(BOOL finished){
            [self removeFromSuperview];

        }];
    }
    else{
        self.alpha = 0;
        [self removeFromSuperview];

    }
}



#pragma mark action
-(void)btnPress:(id)sender{
    
    UIButton *btn = (UIButton *)sender;
    NSLog(@"btn pressed tag=%ld",(long)btn.tag);
    if (btn.tag==0 && _isHaveCancelBtn) {
        [self hideWithAnimation:YES];
        return;
    }
    else{
        if (self.alertViewClick) {
            self.alertViewClick(btn.tag);
        }
        if (self.delegater && [self.delegater respondsToSelector:@selector(HirAlertView:clickedButtonAtIndex:)]) {
            [self.delegater HirAlertView:self clickedButtonAtIndex:btn.tag];
        }
        [self hideWithAnimation:NO];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    
    [self endEditing:YES];
    
    if(!self.isModelView){
        [self hideWithAnimation:YES];
    }
}


-(void)keyboardWillShow:(NSNotification*)notification{
    
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    CGFloat keyBoardHeight = keyboardRect.size.height;
    BOOL isNeedChangeRect = (_backView.frame.origin.y + _backView.frame.size.height) > (SCREEN_HEIGHT - keyBoardHeight) ? YES : NO  ;
    
    if (isNeedChangeRect) {
        
        [UIView animateWithDuration:animationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            CGFloat insetY =   ((SCREEN_HEIGHT - keyBoardHeight) - _backView.frame.size.height) ;
            
//            CGRect insetRect  =  CGRectInset(_backView.frame, 0, insetY - GAP_TINY) ;/** GAP_KEYBOARD_VIEW增加键盘与控键之间的间隙*/
            
            CGRect insetRect  =  _backView.frame;
            insetRect.origin.y = insetY - GAP_TINY;
            [_backView setFrame:insetRect];
            
        } completion:^(BOOL finished) {
            
        }];

    }
}

-(void)keyboardWillHide:(NSNotification*)notification{
    
    NSDictionary *userInfo = [notification userInfo];
//    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
//    CGRect keyboardRect = [aValue CGRectValue];
//    CGFloat keyBoardHeight = keyboardRect.size.height;

    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    BOOL isNeedChangeRect = (SCREEN_HEIGHT - self.backView.frame.size.height)/2 - 50 > self.backView.frame.origin.y ? YES : NO  ;
    
    if (isNeedChangeRect) {
        
        [UIView animateWithDuration:animationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            self.backView.frame = CGRectMake(WINDOW_LEFT_PADDING, (SCREEN_HEIGHT - self.backView.frame.size.height)/2 - 50, WINDOW_WIDTH, self.backView.frame.size.height);

            
        } completion:^(BOOL finished) {
            
        }];
        
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
