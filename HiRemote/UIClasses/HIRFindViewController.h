//
//  HIRFindViewController.h
//  HiRemote
//
//  Created by parker on 7/1/15.
//  Copyright (c) 2015 hiremote. All rights reserved.
//

#import "HirBaseViewController.h"

#import <CoreLocation/CoreLocation.h>
@interface HIRFindViewController : HirBaseViewController
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) NSString *hiRemoteName;
@property (nonatomic, strong) NSString *currentState;
@property (nonatomic, strong) NSString *currentCity;
@property (nonatomic, strong) NSString *currentStreet;
@end
