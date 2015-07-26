//
//  HPCoreLocationManger.h
//  SmartHeadphone
//
//  Created by dehangsui on 14-12-16.
//  Copyright (c) 2014年 Spark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol HPCoreLocationMangerDelegate <NSObject>

///定位完成（成功或者失败） location表示当前的位置（失败为nil) isSuccess是Bool值，表示定位成功还是失败
- (void) locationFinished:(CLLocation *)location withFlag:(NSNumber *)isSuccess;

@end



@interface HPCoreLocationManger : NSObject

@property (nonatomic, strong) NSString *currentState;
@property (nonatomic, strong) NSString *currentCity;
@property (nonatomic, strong) NSString *currentStreet;

@property (nonatomic, strong) NSString *fullLocation;

@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, weak) id <HPCoreLocationMangerDelegate> delegate;

-(void)startUpdatingUserLocation;
@end
