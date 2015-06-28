//
//  HirTableView.m
//  HiRemote
//
//  Created by minfengliu on 15/6/27.
//  Copyright (c) 2015年 hiremote. All rights reserved.
//

#import "HirTableView.h"

@implementation HirTableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if (!self.dragging) {
        [[self nextResponder ] touchesBegan:touches withEvent:event];
        
    }
    [super touchesBegan:touches withEvent:event];
    NSLog(@"tableview touch begon ******");
}

@end
