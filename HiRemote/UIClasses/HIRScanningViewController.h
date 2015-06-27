//
//  HIRScanningViewController.h
//  HiRemote
//
//  Created by parker on 6/25/15.
//  Copyright (c) 2015 hiremote. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HIRScanningViewControllerDelegate <NSObject>

- (void)scanningFinishToShowRootVC;

@end


@interface HIRScanningViewController : UIViewController
@property (nonatomic ,weak) id<HIRScanningViewControllerDelegate> delegate;
@end
