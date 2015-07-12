//
//  HIRMapViewController.h
//  HiRemote
//
//  Created by parker on 7/1/15.
//  Copyright (c) 2015 hiremote. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "HirBaseViewController.h"
@interface HIRMapViewController : HirBaseViewController

@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) NSString *hiRemoteName;
@property (nonatomic, strong) NSString *remarkName;
@property (nonatomic, strong) NSString *locationStr;
@end
