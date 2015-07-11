//
//  HirBaseTableCell.h
//  HiRemote
//
//  Created by rick on 15/6/30.
//  Copyright (c) 2015年 hiremote. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HirWindowDelegate <NSObject>

@optional

- (void)removeOpenWindow:(UIView *)window;

@end

@interface HirWindow : UIView<UIGestureRecognizerDelegate>
@property (nonatomic, strong) NSMutableArray *inputViewAry;/*需要滚动防止键盘遮蔽的控件*/
@property (nonatomic, weak) id<HirWindowDelegate>delegateOfHirWindow;
@property (nonatomic, strong) UITapGestureRecognizer *removeWindowTap;

-(void)removeWindow;
@end
