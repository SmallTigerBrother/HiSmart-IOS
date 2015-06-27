//
//  HIRScanningViewController.m
//  HiRemote
//
//  Created by parker on 6/25/15.
//  Copyright (c) 2015 hiremote. All rights reserved.
//

#import "HIRScanningViewController.h"
#import "PureLayout.h"

@interface HIRScanningViewController ()
@property (nonatomic)UILabel *scaningLabel;
@property (nonatomic, assign) BOOL didSetupConstraints;

@end

@implementation HIRScanningViewController
@synthesize delegate;
@synthesize scaningLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"scanningbg"]];
    self.scaningLabel = [[UILabel alloc] init];
    self.scaningLabel.text = NSLocalizedString(@"scanning", @"");
    self.scaningLabel.textAlignment = NSTextAlignmentCenter;
    self.scaningLabel.textColor = [UIColor whiteColor];
    self.scaningLabel.font = [UIFont boldSystemFontOfSize:17];
    [self.view addSubview:self.scaningLabel];
    
    [self.view setNeedsUpdateConstraints];
    // Do any additional setup after loading the view.
    
    
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    ///test
    [self performSelector:@selector(goToRootViewController) withObject:nil afterDelay:1];
}


- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        [self.scaningLabel autoSetDimension:ALDimensionHeight toSize:35];
        [self.scaningLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:40.0];
        [self.scaningLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:40.0];
        [self.scaningLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:80];
        self.didSetupConstraints = YES;
    }
    
    [super updateViewConstraints];
}




- (void)goToRootViewController {
    [self.delegate performSelector:@selector(scanningFinishToShowRootVC) withObject:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    self.delegate = nil;
    self.scaningLabel = nil;
}

@end
