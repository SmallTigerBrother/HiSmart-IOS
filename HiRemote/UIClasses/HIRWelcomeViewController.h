//
//  HIRWelcomeViewController.h
//  Utility
//
//  Created by Steve Jobs on 1/19/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HIRWelcomeViewControllerDelegate <NSObject>

- (void)welcomViewControllerNeedDisapear;

@end


@interface HIRWelcomeViewController :UIViewController

@property (nonatomic ,weak) id<HIRWelcomeViewControllerDelegate> delegate;

@end
