//
//  HPCoreLocationManger.m
//  SmartHeadphone
//
//  Created by dehangsui on 14-12-16.
//  Copyright (c) 2014年 Spark. All rights reserved.
//

#import "HPCoreLocationManger.h"
#import <UIKit/UIKit.h>
#import <CoreLocation/CLLocationManagerDelegate.h>
#import "CLLocation+Sino.h"

@interface HPCoreLocationManger() <CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locManager;
@property (nonatomic, strong) CLGeocoder *geocoder;

@end


@implementation HPCoreLocationManger
@synthesize locManager;
@synthesize currentState;
@synthesize currentCity;
@synthesize currentStreet;
@synthesize location;
@synthesize geocoder;


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.locManager = [[CLLocationManager alloc] init];
        self.locManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locManager.distanceFilter = 10.0f;
        self.locManager.delegate = self;
#ifdef __IPHONE_8_0
        if([self.locManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
        {
            [self.locManager requestWhenInUseAuthorization];
            [self.locManager requestAlwaysAuthorization];
        }
#endif

    }
    return self;
}

-(void)startUpdatingUserLocation {
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status || kCLAuthorizationStatusNotDetermined == status) {
        NSLog(@"need open location");
    }
    
    [self.locManager startUpdatingLocation];
    
    //在ios 8.0下要授权
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        [self.locManager requestWhenInUseAuthorization];  //调用了这句,就会弹出允许框了.
    }
}

- (void) startLocateToGeo {
    self.geocoder = [[CLGeocoder alloc]init];
    __weak typeof(self) weakSelf = self;
    [self.geocoder reverseGeocodeLocation:self.location completionHandler:^(NSArray *placeMarks, NSError *error) {
        NSLog(@"mkkk:%@",placeMarks);
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf geoAddress:placeMarks];
        });
        
     }];
}

- (void)geoAddress:(NSArray *)placeMarks {
    if([placeMarks count]>0) {
        CLPlacemark *placeMark = placeMarks[0];
        self.currentState = placeMark.administrativeArea;
        self.currentCity = placeMark.locality;
        NSMutableString *detailLocal = [NSMutableString string];
        if ([placeMark.subLocality length] > 0) {
            [detailLocal appendString:placeMark.subLocality];
        }
        if ([placeMark.thoroughfare length] > 0) {
            [detailLocal appendString:placeMark.thoroughfare];
        }
        if ([placeMark.subThoroughfare length] > 0) {
            [detailLocal appendString:placeMark.subThoroughfare];
        }
        self.currentStreet = detailLocal;
        [self.delegate performSelector:@selector(locationFinished:withFlag:) withObject:self.location withObject:[NSNumber numberWithBool:YES]];
        NSLog(@"state:%@  city:%@  street:%@",self.currentState,self.currentCity,self.currentStreet);
    }
}

-(NSString *)fullLocation{
    NSString *fullLocation;
    if([CLLocation isLocationOutOfChina:self.location.coordinate]){
        fullLocation = [NSString stringWithFormat:@"%@%@%@",self.currentStreet,self.currentCity,self.currentState];
    }
    else{
        fullLocation = [NSString stringWithFormat:@"%@%@%@",self.currentState,self.currentCity,self.currentStreet];
    }
    return fullLocation;
}

#pragma mark Core Location

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation * currLocation = [locations lastObject];
    self.location = currLocation;
    [self startLocateToGeo];
    
    [self.locManager stopUpdatingLocation];
    NSLog(@"lati:%f  long:%f",self.location.coordinate.latitude,self.location.coordinate.longitude);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [self.locManager stopUpdatingLocation];
    
    if ([error code] == kCLErrorDenied) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"tips", @"") message:NSLocalizedString(@"checkLocation", @"") delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"ok", @""), nil] show];
    }

    [self.delegate performSelector:@selector(locationFinished:withFlag:) withObject:nil withObject:[NSNumber numberWithBool:NO]];
}



- (void)dealloc {
    NSLog(@"geo delloc");
    self.locManager = nil;
}


@end
