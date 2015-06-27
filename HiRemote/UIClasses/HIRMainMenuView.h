//
//  HIRMainMenuView.h
//  HiRemote
//
//  Created by parker on 6/26/15.
//  Copyright (c) 2015 hiremote. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HIRMainMenuViewDelegate <NSObject>

- (void)mainMenuButtonClick:(NSNumber *)tag;

@end


@interface HIRMainMenuView : UIScrollView
@property (nonatomic, weak) id<HIRMainMenuViewDelegate> delegate;
@end
