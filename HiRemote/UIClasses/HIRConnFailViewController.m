//
//  HIRConnFailViewController.m
//  HiRemote
//
//  Created by parker on 6/30/15.
//  Copyright (c) 2015 hiremote. All rights reserved.
//

#import "HIRConnFailViewController.h"
#import "PureLayout.h"

@interface HIRConnFailViewController ()

@property (nonatomic, strong) UILabel *tipsLabel1;
@property (nonatomic, strong) UILabel *tipsLabel2;
@property (nonatomic, strong) UIButton *retryButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIView *leftLine;
@property (nonatomic, strong) UILabel *tipsLabel3;
@property (nonatomic, strong) UIView *rightLine;
@property (nonatomic, assign) BOOL didSetupConstraints;

@end


@implementation HIRConnFailViewController
@synthesize tipsLabel1;
@synthesize tipsLabel2;
@synthesize retryButton;
@synthesize cancelButton;
@synthesize leftLine;
@synthesize tipsLabel3;
@synthesize rightLine;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.35 green:0.75 blue:0.58 alpha:1];
    self.tipsLabel1 = [[UILabel alloc] init];
    
    self.tipsLabel1.textColor = [UIColor whiteColor];
    self.tipsLabel1.font = [UIFont boldSystemFontOfSize:18];
    self.tipsLabel1.text = NSLocalizedString(@"oops", @"");
    self.tipsLabel2 = [[UILabel alloc] init];
    self.tipsLabel2.textColor = [UIColor whiteColor];
    self.tipsLabel2.font = [UIFont boldSystemFontOfSize:15];
    self.tipsLabel2.numberOfLines = 0;
    self.tipsLabel2.text = NSLocalizedString(@"cannotFind", @"");
    self.retryButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.retryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.retryButton setTitle:NSLocalizedString(@"retry", @"") forState:UIControlStateNormal];
    [self.retryButton addTarget:self action:@selector(retryButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.retryButton.backgroundColor = [UIColor colorWithRed:0.44 green:0.76 blue:0.63 alpha:1];
    
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.cancelButton setTitle:NSLocalizedString(@"cancel", @"") forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.cancelButton.backgroundColor = [UIColor colorWithRed:0.44 green:0.76 blue:0.63 alpha:1];
    self.leftLine = [[UIView alloc] init];
    self.leftLine.backgroundColor = [UIColor whiteColor];
    self.tipsLabel3 = [[UILabel alloc] init];
    self.tipsLabel3.textColor = [UIColor whiteColor];
    self.tipsLabel3.textAlignment = NSTextAlignmentCenter;
    self.tipsLabel3.text = NSLocalizedString(@"haveProblem", @"");
    self.rightLine = [[UIView alloc] init];
    self.rightLine.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tipsLabel1];
    [self.view addSubview:self.tipsLabel2];
    [self.view addSubview:self.retryButton];
    [self.view addSubview:self.cancelButton];
    [self.view addSubview:self.leftLine];
    [self.view addSubview:self.tipsLabel3];
    [self.view addSubview:self.rightLine];
    [self.view setNeedsUpdateConstraints];
}




- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        [self.tipsLabel1 autoSetDimension:ALDimensionHeight toSize:40];
        [self.tipsLabel1 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:30];
        [self.tipsLabel1 autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:self.view.frame.size.height/6];
        [self.tipsLabel1 autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
        
        [self.tipsLabel2 autoSetDimension:ALDimensionHeight toSize:50];
        [self.tipsLabel2 autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.tipsLabel1 withOffset:30];
        [self.tipsLabel2 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.tipsLabel1 withOffset:10];
        [self.tipsLabel2 autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:50];
        
        [self.retryButton autoSetDimension:ALDimensionHeight toSize:40];
        [self.retryButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:40];
        [self.retryButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:40];
        [self.retryButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:self.view.frame.size.height/3 * 2];
        
        [self.cancelButton autoSetDimension:ALDimensionHeight toSize:40];
        [self.cancelButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:40];
        [self.cancelButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:40];
        [self.cancelButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.retryButton withOffset:20];
        
        [self.leftLine autoSetDimensionsToSize:CGSizeMake(50, 4)];
        [self.leftLine autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:20];
        [self.leftLine autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.cancelButton withOffset:23];
        
        [self.rightLine autoSetDimensionsToSize:CGSizeMake(50, 4)];
        [self.rightLine autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:20];
        [self.rightLine autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.cancelButton withOffset:23];

        [self.tipsLabel3 autoSetDimension:ALDimensionHeight toSize:30];
        [self.tipsLabel3 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.leftLine withOffset:5];
        [self.tipsLabel3 autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.rightLine withOffset:-5];
        [self.tipsLabel3 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.cancelButton withOffset:10];
        
        self.didSetupConstraints = YES;
    }
    [super updateViewConstraints];
}

- (void)retryButtonClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cancelButtonClick:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)dealloc {
    NSLog(@"fail connect DELLOC");
    self.tipsLabel1 = nil;
    self.tipsLabel2 = nil;
    self.tipsLabel3 = nil;
    self.retryButton = nil;
    self.cancelButton = nil;
}
@end
