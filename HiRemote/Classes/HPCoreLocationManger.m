//
//  HPCoreLocationManger.m
//  SmartHeadphone
//
//  Created by dehangsui on 14-12-16.
//  Copyright (c) 2014年 Spark. All rights reserved.
//

#import "HPCoreLocationManger.h"
@interface HPCoreLocationManger()<CLLocationManagerDelegate>
{

    BOOL _isGeocode;
    NSDateFormatter *_dayFormater;
}
@end
@implementation HPCoreLocationManger

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self getLocMgr];
        NSDateFormatter* dateFormatter =[[NSDateFormatter alloc] init];
        
        dateFormatter.dateFormat = @"yyyy-MM-dd";//@"yyyy-MM-dd"
        _dayFormater = dateFormatter;
    }
    return self;
}

-(void)startUpdatingUserLocation
{
        NSLog(@"startUpdatingUserLocation is%d",_isStartUpdate);
    if(!_isStartUpdate)
    {
        _isStartUpdate = YES;
         self.locMgr.distanceFilter = 10;
       [self.locMgr startUpdatingLocation];
   
    }
}

-(void)startMonitoringSignificantLocation
{
   
    NSLog(@"startMonitoringSignificantLocation is%d",_isStartUpdate);
    
        _isStartUpdate = NO;
        [self stopUpdatingUserLocation];
        [self.locMgr startMonitoringSignificantLocationChanges];
        
    
}
-(void)stopMonitoringSignificantLocation
{
    
    NSLog(@"stopMonitoringSignificantLocation is%d",_isStartUpdate);
    
   
    [self.locMgr stopMonitoringSignificantLocationChanges];
    [self startUpdatingUserLocation];
    
}
-(void)startToConfirmUserRightLocation
{
     NSLog(@"startToConfirmUserRightLocation is%d",_isStartUpdate);
    _isStartUpdate = YES;
     self.locMgr.distanceFilter = 10.0f;
    [self.locMgr startUpdatingLocation];
}
-(void)stopUpdatingUserLocation
{
   
    _isStartUpdate = NO;
    
    [self.locMgr stopUpdatingLocation];
}

- (CLLocationManager *)getLocMgr
{
    
    if(![CLLocationManager locationServicesEnabled]) return nil;
    
    if (!_locMgr) {
        // 创建定位管理者
        _locMgr = [[CLLocationManager alloc] init];
        _locMgr.desiredAccuracy = kCLLocationAccuracyBest;
        // 设置代理
        _locMgr.delegate = self;
       
    }
#ifdef __IPHONE_8_0
    if([_locMgr respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [_locMgr requestWhenInUseAuthorization];
        [_locMgr requestAlwaysAuthorization];
    }
    
#endif
  
    return _locMgr;
}
- (CLGeocoder *)geocoder
{
    if (!_geocoder) {
        self.geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}
-(BOOL)getCLLocationManagerDeniedStatus
{
    
    if([CLLocationManager authorizationStatus]== kCLAuthorizationStatusDenied)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    
   
}
-(void)showUserSportPrompt
{

}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    // 1.取出位置对象
    CLLocation *loc = [locations lastObject];
    // 2.取出经纬度
  
  
    NSTimeInterval locationAge = -[loc.timestamp timeIntervalSinceNow];
    if (locationAge < 5.0 && loc.horizontalAccuracy > 0)
    {
        _locatioin = loc;
        
    }

    
    
        
   
}

-(void)reverseGeocode
{
    
    if(_isGeocode ||!_locatioin) return;
    
     _isGeocode = YES;
    
    // 1.包装位置
    CLLocationDegrees latitude = _locatioin.coordinate.latitude;
    CLLocationDegrees longitude = _locatioin.coordinate.longitude;
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    __unsafe_unretained typeof (self)tempVC = self;

    // 2.反地理编码
    [self.geocoder reverseGeocodeLocation:loc completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) { // 有错误（地址乱输入）
            NSLog(@"the errir is %@",[error localizedDescription]);
        } else { // 编码成功
            // 取出最前面的地址
            CLPlacemark *pm = [placemarks firstObject];
            NSLog(@"the city is %@,%@,%@,%@",pm.name,pm.postalCode,pm.subAdministrativeArea,pm.administrativeArea);
            // 设置具体地址
         
          
            _curCity =pm.locality;
            _curProvince =pm.administrativeArea;
            _curCountry = pm.country;

        }
    }];
}
-(void)initOffsetCorrdinate
{
    _offsetCoordinate =CLLocationCoordinate2DMake(0, 0);
}


-(void)postUpdateDataNotification
{

}
@end
