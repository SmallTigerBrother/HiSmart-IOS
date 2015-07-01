//
//  HIRRegisterViewController.m
//  HiRemote
//
//  Created by parker on 6/30/15.
//  Copyright (c) 2015 hiremote. All rights reserved.
//

#import "HIRRegisterViewController.h"
#import "HIRScanningViewController.h"
#import "PureLayout.h"


@interface HIRRegisterViewController ()
@property (nonatomic, strong) UILabel *tipsLabel1;
@property (nonatomic, strong) UILabel *tipsLabel2;
@property (nonatomic, strong) UIButton *registerButton;
@property (nonatomic, strong) UIView *leftLine;
@property (nonatomic, strong) UILabel *tipsLabel3;
@property (nonatomic, strong) UIView *rightLine;
@property (nonatomic, assign) BOOL didSetupConstraints;
@end


@implementation HIRRegisterViewController
@synthesize tipsLabel1;
@synthesize tipsLabel2;
@synthesize registerButton;
@synthesize leftLine;
@synthesize tipsLabel3;
@synthesize rightLine;
@synthesize isNeedAutoPushScanVC;

- (id)init{
    self = [super init];
    if (self) {
        self.isNeedAutoPushScanVC = NO;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.35 green:0.75 blue:0.58 alpha:1];
    self.tipsLabel1 = [[UILabel alloc] init];
    
    self.tipsLabel1.textColor = [UIColor whiteColor];
    self.tipsLabel1.font = [UIFont boldSystemFontOfSize:18];
    self.tipsLabel1.text = NSLocalizedString(@"welcome", @"");
    self.tipsLabel2 = [[UILabel alloc] init];
    self.tipsLabel2.textColor = [UIColor whiteColor];
    self.tipsLabel2.font = [UIFont boldSystemFontOfSize:15];
    self.tipsLabel2.text = NSLocalizedString(@"hiRemote", @"");
    self.registerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.registerButton.backgroundColor = [UIColor whiteColor];
    [self.registerButton setTitle:NSLocalizedString(@"signUp", @"") forState:UIControlStateNormal];
    [self.registerButton addTarget:self action:@selector(registerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.leftLine = [[UIView alloc] init];
    self.leftLine.backgroundColor = [UIColor whiteColor];
    self.tipsLabel3 = [[UILabel alloc] init];
    self.tipsLabel3.textColor = [UIColor whiteColor];
    self.tipsLabel3.textAlignment = NSTextAlignmentCenter;
    self.tipsLabel3.text = NSLocalizedString(@"haveAccount", @"");
    self.rightLine = [[UIView alloc] init];
    self.rightLine.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tipsLabel1];
    [self.view addSubview:self.tipsLabel2];
    [self.view addSubview:self.registerButton];
    [self.view addSubview:self.leftLine];
    [self.view addSubview:self.tipsLabel3];
    [self.view addSubview:self.rightLine];
    [self.view setNeedsUpdateConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.isNeedAutoPushScanVC) {
        self.isNeedAutoPushScanVC = NO;
        HIRScanningViewController *scanVC = [[HIRScanningViewController alloc] init];
        [self.navigationController pushViewController:scanVC animated:NO];
    }
}


- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        [self.tipsLabel1 autoSetDimension:ALDimensionHeight toSize:40];
        [self.tipsLabel1 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:30];
        [self.tipsLabel1 autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:self.view.frame.size.height/6];
        [self.tipsLabel1 autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
        
        [self.tipsLabel2 autoSetDimension:ALDimensionHeight toSize:40];
        [self.tipsLabel2 autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.tipsLabel1 withOffset:30];
        [self.tipsLabel2 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.tipsLabel1 withOffset:10];
        [self.tipsLabel2 autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
        
        [self.registerButton autoSetDimension:ALDimensionHeight toSize:40];
        [self.registerButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:40];
        [self.registerButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:40];
        [self.registerButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:self.view.frame.size.height/3 * 2.2];
        
        [self.leftLine autoSetDimensionsToSize:CGSizeMake(30, 4)];
        [self.leftLine autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:20];
        [self.leftLine autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.registerButton withOffset:23];
        
        [self.rightLine autoSetDimensionsToSize:CGSizeMake(30, 4)];
        [self.rightLine autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:20];
        [self.rightLine autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.registerButton withOffset:23];
        
        [self.tipsLabel3 autoSetDimension:ALDimensionHeight toSize:30];
        [self.tipsLabel3 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.leftLine withOffset:5];
        [self.tipsLabel3 autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.rightLine withOffset:-5];
        [self.tipsLabel3 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.registerButton withOffset:10];

        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (void)registerButtonClick:(id)sender {
    HIRScanningViewController *scanVC = [[HIRScanningViewController alloc] init];
    [self.navigationController pushViewController:scanVC animated:YES];
}

- (void)dealloc {
    NSLog(@"REG S DELLOC");
    self.tipsLabel1 = nil;
    self.tipsLabel2 = nil;
    self.leftLine = nil;
    self.tipsLabel3 = nil;
    self.rightLine = nil;
    self.registerButton = nil;
}
@end
