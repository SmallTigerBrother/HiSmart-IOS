//
//  HIRConnSuccViewController.m
//  HiRemote
//
//  Created by parker on 6/30/15.
//  Copyright (c) 2015 hiremote. All rights reserved.
//

#import "HIRConnSuccViewController.h"
#import "HIRRenameViewController.h"
#import "PureLayout.h"

@interface HIRConnSuccViewController ()
@property (nonatomic, strong)UIImageView *connectedImageV;
@property (nonatomic, strong)UILabel *connectedLabel;
@property (nonatomic, assign) BOOL didSetupConstraints;
@end

@implementation HIRConnSuccViewController
@synthesize connectedImageV;
@synthesize connectedLabel;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.35 green:0.75 blue:0.58 alpha:1];
    self.connectedImageV = [[UIImageView alloc] init];
    self.connectedImageV.image = [UIImage imageNamed:@"connectedSuccess"];
    self.connectedLabel = [[UILabel alloc] init];
    self.connectedLabel.text = NSLocalizedString(@"addedSuccess", @"");
    self.connectedLabel.textColor = [UIColor whiteColor];
    self.connectedLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.connectedImageV];
    [self.view addSubview:self.connectedLabel];
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        [self.connectedImageV autoSetDimensionsToSize:CGSizeMake(150, 150)];
        [self.connectedImageV autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [self.connectedImageV autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:80];
        [self.connectedLabel autoSetDimension:ALDimensionHeight toSize:40];
        [self.connectedLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:20];
        [self.connectedLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:20];
        [self.connectedLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.connectedImageV withOffset:20];
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    double delayInSeconds = 0.8;
    dispatch_time_t dispatchTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(dispatchTime,dispatch_get_main_queue(), ^(void){
        HIRRenameViewController *renameVC = [[HIRRenameViewController alloc] init];
        [self.navigationController pushViewController:renameVC animated:YES];
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    NSLog(@"connect delloc");
    self.connectedImageV = nil;
    self.connectedLabel = nil;
}

@end
