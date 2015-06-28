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
        self.currentStreet = placeMark.subLocality;
        [self.delegate performSelector:@selector(locationFinished:withFlag:) withObject:self.location withObject:[NSNumber numberWithBool:YES]];
        NSLog(@"state:%@  city:%@  street:%@",self.currentState,self.currentCity,self.currentStreet);
    }
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
