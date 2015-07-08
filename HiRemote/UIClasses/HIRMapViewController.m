//
//  HIRMapViewController.m
//  HiRemote
//
//  Created by parker on 7/1/15.
//  Copyright (c) 2015 hiremote. All rights reserved.
//

#import "HIRMapViewController.h"
#import <MapKit/MapKit.h>
#import "HIRAnnotations.h"
#import "CallOutAnnotationVifew.h"

@interface HIRMapViewController ()<MKMapViewDelegate>
@property (nonatomic, strong)MKMapView *mapView;

@end

@implementation HIRMapViewController
@synthesize mapView;
@synthesize location;
@synthesize hiRemoteName;
@synthesize currentState;
@synthesize currentCity;
@synthesize currentStreet;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"location", @"");
    self.mapView = [[MKMapView alloc] initWithFrame:self.view.frame];
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    [self.view addSubview:self.mapView];
    
    [self setAnnotation];
}

- (void)setAnnotation {
    CLLocationCoordinate2D c2d = self.location.coordinate;

    HIRAnnotations *annotation = [[HIRAnnotations alloc] initWithCoordinate:c2d];
    annotation.title = self.hiRemoteName;
    [mapView addAnnotation:annotation];
    MKCoordinateRegion newRegion;
    newRegion.center = annotation.coordinate;
    newRegion.span.latitudeDelta = 0.2f;
    newRegion.span.longitudeDelta = 0.2f;
    [mapView setRegion:newRegion];
}


- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]]){
        return nil;
    }
    
    if ([annotation isKindOfClass:[HIRAnnotations class]])
    {
        static NSString* annotationIdentifier = @"annotationIdentifier";
        
//        
//        CallOutAnnotationVifew *annotationView = (CallOutAnnotationVifew *)[mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
//        if (!annotationView) {
//            annotationView = [[CallOutAnnotationVifew alloc] initWithAnnotation:annotation reuseIdentifier:annotationIdentifier];
//        }
//        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//        [rightButton addTarget:self action:@selector(showDetails:) forControlEvents:UIControlEventTouchUpInside];
//        rightButton.tag = ((HIRAnnotations *)annotation).tag;
//        annotationView.rightCalloutAccessoryView = rightButton;
//        annotationView.annotation = annotation;
//        
//        return annotationView;
        
        MKPinAnnotationView* pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
        if (!pinView){
            pinView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:annotationIdentifier] ;
           // pinView.image = [UIImage imageNamed:@"pinImage"];
            pinView.canShowCallout = YES;
        }
        
        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [rightButton addTarget:self action:@selector(showDetails:) forControlEvents:UIControlEventTouchUpInside];
        rightButton.tag = ((HIRAnnotations *)annotation).tag;
        pinView.rightCalloutAccessoryView = rightButton;
        
        pinView.annotation = annotation;
        return pinView;
    }
    return nil;
}

- (void) showDetails:(id)sender {
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    self.mapView = nil;
    self.location = nil;
    self.hiRemoteName = nil;
    self.currentCity = nil;
    self.currentState = nil;
    self.currentStreet = nil;
}

@end
