//
//  HIRScanningViewController.m
//  HiRemote
//
//  Created by parker on 6/25/15.
//  Copyright (c) 2015 hiremote. All rights reserved.
//

#import "HIRScanningViewController.h"
#import "HIRConnSuccViewController.h"
#import "HIRConnFailViewController.h"
#import "HIRCBCentralClass.h"
#import "PureLayout.h"

@interface HIRScanningViewController ()
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *tipsLabel1;
@property (nonatomic, strong) UILabel *tipsLabel2;
@property (nonatomic, strong) UIImageView *controlImageV;
@property (nonatomic, strong) UILabel *scaningLabel;
@property (nonatomic, strong) UIActivityIndicatorView *scanIndicator;
@property (nonatomic, strong) NSTimer *outTimer;
@property (nonatomic, assign) BOOL didSetupConstraints;

@end

@implementation HIRScanningViewController
@synthesize backButton;
@synthesize titleLabel;
@synthesize tipsLabel1;
@synthesize tipsLabel2;
@synthesize controlImageV;
@synthesize scaningLabel;
@synthesize scanIndicator;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.35 green:0.75 blue:0.58 alpha:1];
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton setImage:[UIImage imageNamed:@"nextBtn"] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = NSLocalizedString(@"addAHiRemote", @"");
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    self.tipsLabel1 = [[UILabel alloc] init];
    self.tipsLabel1.text = NSLocalizedString(@"addTipsOne", @"");
    self.tipsLabel1.textColor = [UIColor whiteColor];
    self.tipsLabel1.textAlignment = NSTextAlignmentLeft;
    self.tipsLabel1.numberOfLines = 2;
    
    self.tipsLabel2 = [[UILabel alloc] init];
    self.tipsLabel2.text = NSLocalizedString(@"addTipsTwo", @"");
    self.tipsLabel2.textColor = [UIColor whiteColor];
    self.tipsLabel2.textAlignment = NSTextAlignmentLeft;
    self.tipsLabel2.numberOfLines = 2;
    
    self.controlImageV = [[UIImageView alloc] init];
    self.controlImageV.image = [UIImage imageNamed:@"controlm"];
    
    self.scanIndicator = [[UIActivityIndicatorView alloc] init];
    self.scanIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    self.scaningLabel = [[UILabel alloc] init];
    self.scaningLabel.text = NSLocalizedString(@"scanning", @"");
    self.scaningLabel.textAlignment = NSTextAlignmentCenter;
    self.scaningLabel.textColor = [UIColor whiteColor];
    self.scaningLabel.font = [UIFont boldSystemFontOfSize:17];
   // [self.view addSubview:self.backButton];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.tipsLabel1];
    [self.view addSubview:self.tipsLabel2];
    [self.view addSubview:self.controlImageV];
    [self.view addSubview:self.scanIndicator];
    [self.view addSubview:self.scaningLabel];
    
    [self.view setNeedsUpdateConstraints];
    // Do any additional setup after loading the view.
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hirCBStateChange:) name:HIR_CBSTATE_CHANGE_NOTIFICATION object:nil];
    
    
}

- (void)outTimerForScanning {
    NSNotification *notif = [NSNotification notificationWithName:HIR_CBSTATE_CHANGE_NOTIFICATION object:nil userInfo:[NSDictionary dictionaryWithObject:CBCENTERAL_CONNECT_PERIPHERAL_FAIL forKey:@"state"]];
    [self hirCBStateChange:notif];
    [self.outTimer invalidate];
    self.outTimer = nil;
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    ///放在这里进行扫描的原因是，当失败后再扫描时回回到该页面再扫描
    self.outTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(outTimerForScanning) userInfo:nil repeats:NO];
    [self.scanIndicator startAnimating];
    [[HIRCBCentralClass shareHIRCBcentralClass] scanPeripheral];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.outTimer invalidate];
    self.outTimer = nil;
    [self.scanIndicator stopAnimating];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
//        [self.backButton autoSetDimensionsToSize:CGSizeMake(60, 50)];
//        [self.backButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:30];
//        [self.backButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
//        
        [self.titleLabel autoSetDimensionsToSize:CGSizeMake(200, 40)];
        [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:70];
        [self.titleLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
        
        [self.tipsLabel1 autoSetDimensionsToSize:CGSizeMake(250, 45)];
        [self.tipsLabel1 autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [self.tipsLabel1 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.titleLabel withOffset:20];
        
        [self.tipsLabel2 autoSetDimensionsToSize:CGSizeMake(250, 45)];
        [self.tipsLabel2 autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [self.tipsLabel2 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.tipsLabel1 withOffset:5];
        
        [self.controlImageV autoSetDimensionsToSize:CGSizeMake(160, 160)];
        [self.controlImageV autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [self.controlImageV autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.tipsLabel2 withOffset:5];
        
        [self.scanIndicator autoSetDimensionsToSize:CGSizeMake(50, 50)];
        [self.scanIndicator autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [self.scanIndicator autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:60];
        
        [self.scaningLabel autoSetDimension:ALDimensionHeight toSize:30];
        [self.scaningLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:40.0];
        [self.scaningLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:40.0];
        [self.scaningLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.scanIndicator withOffset:5];
        self.didSetupConstraints = YES;
    }
    
    [super updateViewConstraints];
}

- (void)backButtonClick:(id)sender {
    [self.scanIndicator startAnimating];
    [[HIRCBCentralClass shareHIRCBcentralClass] stopCentralManagerScan];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)hirCBStateChange:(NSNotification *)notif {
    [self.outTimer invalidate];
    self.outTimer = nil;
    
    NSDictionary *info = notif.userInfo;
    NSString *state = [info valueForKey:@"state"];
    if ([state isEqualToString:CBCENTERAL_STATE_NOT_SUPPORT] || [state isEqualToString:CBCENTERAL_CONNECT_PERIPHERAL_FAIL]) {
        ////蓝牙不支持或关闭或者链接失败
        [self.scanIndicator stopAnimating];
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"tips", @"") message:NSLocalizedString(@"checkBluetooth", @"") delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"ok", @""), nil] show];
        HIRConnFailViewController *connFailVC = [[HIRConnFailViewController alloc] init];
        [self.navigationController pushViewController:connFailVC animated:YES];
    }else if ([state isEqualToString:CBCENTERAL_CONNECT_PERIPHERAL_SUCCESS]) {
        ////蓝牙链接外设成功
        double delayInSeconds = 2;
        dispatch_time_t dispatchTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(dispatchTime,dispatch_get_main_queue(), ^(void){
            HIRConnSuccViewController *connectedVC = [[HIRConnSuccViewController alloc] init];
            [self.navigationController pushViewController:connectedVC animated:YES];
        });
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    NSLog(@"scann delloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.backButton = nil;
    self.titleLabel = nil;
    self.tipsLabel1 = nil;
    self.tipsLabel2 = nil;
    self.controlImageV = nil;
    self.scanIndicator = nil;
    self.scaningLabel = nil;
}

@end
