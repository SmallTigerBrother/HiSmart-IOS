//
//  HIRFindViewController.m
//  HiRemote
//
//  Created by parker on 7/1/15.
//  Copyright (c) 2015 hiremote. All rights reserved.
//

#import "HIRFindViewController.h"
#import <MapKit/MapKit.h>
#import "HIRAnnotations.h"
#import "PureLayout.h"
#import "CallOutAnnotationVifew.h"
#import "HIRRemoteData.h"
#import "AppDelegate.h"

@interface HIRFindViewController ()<MKMapViewDelegate>
@property (nonatomic, assign) BOOL didSetupConstraints;
@property (nonatomic, strong) UIButton *buzzBtn;
@property (nonatomic, strong) UIButton *stopBtn;
@property (nonatomic, strong) UIImageView *bgImgV;
@property (nonatomic, strong) UIImageView *avtarImgV;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UILabel *versLab;
@property (nonatomic, strong) UILabel *loclLab;
@property (nonatomic, strong) UIImageView *connnectImgV;
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) HIRRemoteData *hiremoteData;

@end

@implementation HIRFindViewController
@synthesize buzzBtn;
@synthesize stopBtn;
@synthesize bgImgV;
@synthesize avtarImgV;
@synthesize nameLab;
@synthesize versLab;
@synthesize loclLab;
@synthesize connnectImgV;
@synthesize mapView;
@synthesize location;
@synthesize hiRemoteName;
@synthesize currentState;
@synthesize currentCity;
@synthesize currentStreet;
@synthesize hiremoteData;
@synthesize deviceIndex;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"edit20", @"");
    self.view.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
    
    self.buzzBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.buzzBtn.layer.borderWidth = 0.5;
    [self.buzzBtn.layer setBorderColor:[UIColor colorWithRed:0.25 green:0.73 blue:0.81 alpha:1].CGColor];
    [self.buzzBtn setTitle:NSLocalizedString(@"buzzItem", @"") forState:UIControlStateNormal];
    [self.buzzBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.buzzBtn setTitleColor:[UIColor colorWithRed:0.25 green:0.73 blue:0.81 alpha:1] forState:UIControlStateNormal];
    [self.buzzBtn addTarget:self action:@selector(buzzButton:) forControlEvents:UIControlEventTouchUpInside];
    self.stopBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.stopBtn.layer.borderWidth = 0.5;
    [self.stopBtn.layer setBorderColor:[UIColor colorWithRed:0.25 green:0.73 blue:0.81 alpha:1].CGColor];
    [self.stopBtn setTitle:NSLocalizedString(@"stop", @"") forState:UIControlStateNormal];
    [self.stopBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.stopBtn setTitleColor:[UIColor colorWithRed:0.25 green:0.73 blue:0.81 alpha:1] forState:UIControlStateNormal];
    [self.stopBtn addTarget:self action:@selector(stopButton:) forControlEvents:UIControlEventTouchUpInside];
    self.avtarImgV = [[UIImageView alloc] init];
    self.bgImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"avatar_circle"]];
    self.nameLab = [[UILabel alloc] init];
    self.nameLab.backgroundColor = [UIColor orangeColor];
    self.nameLab.textAlignment = NSTextAlignmentLeft;
    self.versLab = [[UILabel alloc] init];
    self.versLab.backgroundColor = [UIColor purpleColor];
    self.versLab.textAlignment = NSTextAlignmentLeft;
    self.loclLab = [[UILabel alloc] init];
    self.loclLab.backgroundColor = [UIColor darkGrayColor];
    self.loclLab.textAlignment = NSTextAlignmentLeft;
    self.connnectImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"darkConn"]];
    self.connnectImgV.backgroundColor = [UIColor greenColor];
    self.mapView = [[MKMapView alloc] init];
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    
    
    NSMutableArray *deviceInfoAry = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).deviceInfoArray;
    if ([deviceInfoAry count] > deviceIndex) {
        self.hiremoteData = [deviceInfoAry objectAtIndex:deviceIndex];
        UIImage *image = [UIImage imageWithContentsOfFile:self.hiremoteData.avatarPath];
        self.avtarImgV.image = image;
        self.nameLab.text = self.hiremoteData.name;
        self.loclLab.text = self.hiremoteData.lastLocation;
    }
    
    [self.view addSubview:self.buzzBtn];
    [self.view addSubview:self.stopBtn];
    [self.view addSubview:self.avtarImgV];
    [self.view addSubview:self.bgImgV];
    [self.view addSubview:self.nameLab];
    [self.view addSubview:self.versLab];
    [self.view addSubview:self.loclLab];
    [self.view addSubview:self.connnectImgV];
    [self.view addSubview:self.mapView];
    [self setAnnotation];
    [self.view setNeedsUpdateConstraints];
}


- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        [self.buzzBtn autoSetDimensionsToSize:CGSizeMake(self.view.frame.size.width/3, 40)];
        [self.buzzBtn autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:self.view.frame.size.width/2 + 20];
        [self.buzzBtn autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:20];
        
        [self.stopBtn autoSetDimensionsToSize:CGSizeMake(self.view.frame.size.width/3, 40)];
        [self.stopBtn autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:self.view.frame.size.width/2+ 20];
        [self.stopBtn autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:20];
        
        [self.bgImgV autoSetDimensionsToSize:CGSizeMake(90, 90)];
        [self.bgImgV autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:self.view.frame.size.width/2 + 30];
        [self.bgImgV autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.buzzBtn withOffset:-25];
        [self.avtarImgV autoSetDimensionsToSize:CGSizeMake(90, 90)];
        [self.avtarImgV autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:self.view.frame.size.width/2 + 30];
        [self.avtarImgV autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.buzzBtn withOffset:-25];
        
        [self.loclLab autoSetDimensionsToSize:CGSizeMake(180, 25)];
        [self.loclLab autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.avtarImgV withOffset:10];
        [self.loclLab autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.buzzBtn withOffset:-40];
        
        [self.versLab autoSetDimensionsToSize:CGSizeMake(100, 25)];
        [self.versLab autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.avtarImgV withOffset:10];
        [self.versLab autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.loclLab withOffset:0];
        
        [self.nameLab autoSetDimensionsToSize:CGSizeMake(100, 25)];
        [self.nameLab autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.avtarImgV withOffset:10];
        [self.nameLab autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.versLab withOffset:0];
        
        
        [self.connnectImgV autoSetDimensionsToSize:CGSizeMake(40, 40)];
        [self.connnectImgV autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.versLab withOffset:0];
        [self.connnectImgV autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.versLab withOffset:10];
        
        
        [self.mapView autoSetDimension:ALDimensionWidth toSize:self.view.frame.size.width];
        [self.mapView autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [self.mapView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
        [self.mapView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.avtarImgV withOffset:-15];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (void)buzzButton:(id)sender {
    
}
- (void)stopButton:(id)sender {
    
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
            pinView.image = [UIImage imageNamed:@"pinImage"];
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
    self.buzzBtn = nil;
    self.stopBtn = nil;
    self.bgImgV = nil;
    self.avtarImgV = nil;
    self.nameLab = nil;
    self.versLab = nil;
    self.loclLab = nil;
    self.connnectImgV = nil;
    self.mapView = nil;
    self.location = nil;
    self.hiRemoteName = nil;
    self.currentCity = nil;
    self.currentState = nil;
    self.currentStreet = nil;
    self.hiremoteData = nil;
}

@end
