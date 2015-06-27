//
//  HPCoreLocationManger.h
//  SmartHeadphone
//
//  Created by dehangsui on 14-12-16.
//  Copyright (c) 2014年 Spark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface HPCoreLocationManger : NSObject

@property (nonatomic, strong) CLLocationManager *locMgr;
@property (copy, nonatomic) void (^updateLocationBlock)(CLLocation*  location);
@property (copy, nonatomic) void (^updateLocationOnceTimeBlock)();
@property (nonatomic,assign)CLLocationCoordinate2D offsetCoordinate;
@property (nonatomic,strong)CLLocation* locatioin;
@property (nonatomic,assign)BOOL isStartUpdate;
@property (nonatomic,assign)BOOL isLocatedRightLoc;
@property (nonatomic,assign)BOOL isPromtFirst;
@property (nonatomic, strong) CLGeocoder *geocoder;
@property (nonatomic, copy) NSString *curCountry;
@property (nonatomic, copy) NSString *curProvince;
@property (nonatomic, copy) NSString *curCity;
@property (nonatomic,assign)BOOL isCountSpeed;
-(void)startUpdatingUserLocation;
-(void)startToConfirmUserRightLocation;
-(void)stopUpdatingUserLocation;
-(BOOL)getCLLocationManagerDeniedStatus;
-(void)startMonitoringSignificantLocation;
-(void)stopMonitoringSignificantLocation;
-(void)initOffsetCorrdinate;
-(void)reverseGeocode;
@end
