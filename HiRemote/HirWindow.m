//
//  HirBaseTableCell.h
//  HiRemote
//
//  Created by minfengliu on 15/6/30.
//  Copyright (c) 2015年 hiremote. All rights reserved.
//

#import "HirWindow.h"

#define GAP_KEYBOARD_VIEW 20 /** 增加键盘与控键之间的间隙*/


@interface HirWindow ()
@property (nonatomic, strong) UIView *firstResponserView; //第一响应的控件
@property (nonatomic, strong) UIView *needScrollBackView; //要滚动的view
@property (nonatomic, assign) CGRect needScrollViewBaseFrame;
@end

@implementation HirWindow

- (void)awakeFromNib
{
    [super awakeFromNib];

    [self setup];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        [self setup];
    }
    return self;
}


- (void)setup
{

    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.backgroundColor = POPUP_WINDOW_BG_COLOR;
    
    _removeWindowTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeWindow)];
    _removeWindowTap.delegate = self ;
    [self addGestureRecognizer:_removeWindowTap];
    
    
    
    
    //sroll
    _inputViewAry = [[NSMutableArray alloc]initWithCapacity:0];
    
    
    _needScrollBackView = self ;
    _needScrollViewBaseFrame = _needScrollBackView.frame;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];

}


-(void)removeWindow{


    if (_delegateOfHirWindow && [_delegateOfHirWindow respondsToSelector:@selector(removeOpenWindow:)] ) {
        [_delegateOfHirWindow performSelector:@selector(removeOpenWindow:) withObject:self];
    }

}


#pragma mark - Gesture Delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    // 输出点击的view的类名
    NSLog(@"%@", NSStringFromClass([touch.view class]));
    
    
    
    
    if([touch.view isKindOfClass:[self class]])
    {
        
        return YES;
    }
    else{
        
        return NO ;
    }
    
    
    return  YES;
    
    
}



#pragma mark - sroll function

-(void)keyboardWillShow:(NSNotification*)notification{
    
    
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [self inputViewWithKeyboardHeight:keyboardRect.size.height withDuration:animationDuration];
}

-(void)keyboardWillHide:(NSNotification*)notification{
    
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    
    [self restoreViewKeyBoardHeight:keyboardRect.size.height withDuration:animationDuration];
    
}



-(void)inputViewWithKeyboardHeight:(CGFloat)keyBoardHeight withDuration:(NSTimeInterval)animationDuration
{
    
    
    [self firstResponserViewInViewAry:_inputViewAry] ;
    
   // CGRect kFirstResponserFrame = [_needScrollBackView  convertRect:_firstResponserView.frame fromView:_firstResponserView.superview];//textview相对坐标转换
    
    CGRect kFirstResponserFrame = [_needScrollBackView  convertRect:_firstResponserView.superview.frame fromView:_firstResponserView.superview.superview];//textview superview 相对坐标转换

    BOOL isNeedChangeRect = (kFirstResponserFrame.origin.y + kFirstResponserFrame.size.height) > (SCREEN_HEIGHT - keyBoardHeight) ? YES : NO  ;
    
    if (isNeedChangeRect) {
        
        
        [UIView animateWithDuration:animationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            CGFloat insetY =   ((SCREEN_HEIGHT - keyBoardHeight) - kFirstResponserFrame.size.height) - kFirstResponserFrame.origin.y ;
            
            CGRect insetRect  =  CGRectInset(_needScrollViewBaseFrame, 0, insetY - GAP_KEYBOARD_VIEW) ;/** GAP_KEYBOARD_VIEW增加键盘与控键之间的间隙*/

            [_needScrollBackView setFrame:insetRect];
            
        } completion:^(BOOL finished) {
            
        }];
        
        
        
    }
}


-(void)restoreViewKeyBoardHeight:(CGFloat)keyBoardHeight withDuration:(NSTimeInterval)animationDuration{
    
    BOOL isNeedChangeRect = _needScrollBackView.frame.origin.y < 0 ? YES : NO  ;
    
    if (isNeedChangeRect) {
        [UIView animateWithDuration:animationDuration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            
            CGRect changeRect = _needScrollBackView.frame ;
            changeRect.origin.y = 0 ;
            
            
            [_needScrollBackView setFrame:changeRect];
            
            
            
        } completion:^(BOOL finished) {
            
        }];
        
    }
    
}

-(void)firstResponserViewInViewAry:(NSArray*)subviews{
    
    
    for (UIView *object in subviews) {
        
        if ([object isFirstResponder]) {
            
            _firstResponserView = object ;
            
            
            return ;
            
        }
        else {
            
            
            if ([object.subviews count]) {
                
                [self firstResponserViewInViewAry:object.subviews];
                
            }
        }
        
    }
    
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [super touchesBegan:touches withEvent:event];
    
    [self endEditing:YES];
    
}


@end
