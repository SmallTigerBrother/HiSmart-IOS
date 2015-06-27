//
//  HIRMainMenuView.m
//  HiRemote
//
//  Created by parker on 6/26/15.
//  Copyright (c) 2015 hiremote. All rights reserved.
//

#import "HIRMainMenuView.h"
#import "PureLayout.h"

@interface HIRMainMenuView()
@property (nonatomic, strong) UIButton *locBtn;
@property (nonatomic, strong) UILabel *locLabel;
@property (nonatomic, strong) UIButton *cameraBtn;
@property (nonatomic, strong) UILabel *cameraLabel;
@property (nonatomic, strong) UIButton *findBtn;
@property (nonatomic, strong) UILabel *findLabel;
@property (nonatomic, strong) UIButton *voiceBtn;
@property (nonatomic, strong) UILabel *voiceLabel;
@property (nonatomic, assign) BOOL didSetupConstraints;
@end



@implementation HIRMainMenuView
@synthesize delegate;

- (id)init{
    self = [super init];
    if (self) {
        self.locBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.locBtn.tag = 1;
        self.locBtn.frame = CGRectMake(0, 0, self.frame.size.width/2, 100);
        [self.locBtn setImage:[UIImage imageNamed:@"location.jpg"] forState:UIControlStateNormal];
        [self.locBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        self.locLabel = [[UILabel alloc] init];
        self.locLabel.text = NSLocalizedString(@"pinnedLocations", @"");
        
        self.cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cameraBtn.tag = 2;
        [self.cameraBtn setImage:[UIImage imageNamed:@"camera.jpg"] forState:UIControlStateNormal];
        [self.cameraBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        self.cameraLabel = [[UILabel alloc] init];
        self.cameraLabel.text = NSLocalizedString(@"cameraShutte", @"");
        
        self.findBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.findBtn.tag = 3;
        [self.findBtn setImage:[UIImage imageNamed:@"find.jpg"] forState:UIControlStateNormal];
        [self.findBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        self.findLabel = [[UILabel alloc] init];
        self.findLabel.text = NSLocalizedString(@"findMyItem", @"");
        
        self.voiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.voiceBtn.tag = 4;
        [self.voiceBtn setImage:[UIImage imageNamed:@"voice.jpg"] forState:UIControlStateNormal];
        [self.voiceBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        self.voiceLabel = [[UILabel alloc] init];
        self.voiceLabel.text = NSLocalizedString(@"voiceMemos", @"");
        
        [self addSubview:self.locBtn];
        [self addSubview:self.locLabel];
        [self addSubview:self.cameraBtn];
        [self addSubview:self.cameraLabel];
        [self addSubview:self.findBtn];
        [self addSubview:self.findLabel];
        [self addSubview:self.voiceBtn];
        [self addSubview:self.voiceLabel];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        [self.locBtn autoSetDimensionsToSize:CGSizeMake(90, 90)];
        [self.locBtn autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:60];
        [self.locBtn autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:20];
        [self.locLabel autoSetDimensionsToSize:CGSizeMake(90, 90)];
        [self.locLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:60];
        [self.locLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.locBtn withOffset:5];

       NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.cameraBtn attribute:NSLayoutAttributeTrailing relatedBy: NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:60];
        NSLayoutConstraint *constraint2 = [NSLayoutConstraint constraintWithItem:self.cameraBtn attribute:NSLayoutAttributeHeight relatedBy: NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:90];
        NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:self.cameraBtn attribute:NSLayoutAttributeWidth relatedBy: NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:90];
//
        [self.cameraBtn addConstraint:constraint2];
        [self.cameraBtn addConstraint:constraint3];
        [self addConstraint:constraint];
//        
//        [self.cameraBtn autoSetDimensionsToSize:CGSizeMake(90, 90)];
//        [self.cameraBtn autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:20];
//        [self.cameraBtn autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:60];
//       // [self.cameraBtn autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.locBtn withOffset:60];
//        [self.cameraLabel autoSetDimensionsToSize:CGSizeMake(90, 90)];
//        [self.cameraLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:60];
//        [self.cameraLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.cameraBtn withOffset:5];
//        
        [self.findBtn autoSetDimensionsToSize:CGSizeMake(90, 90)];
        [self.findBtn autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:60];
        [self.findBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.locLabel withOffset:60];
        [self.findLabel autoSetDimensionsToSize:CGSizeMake(90, 90)];
        [self.findLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:60];
        [self.findLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.findBtn withOffset:5];
        
        [self.voiceBtn autoSetDimensionsToSize:CGSizeMake(90, 90)];
        [self.voiceBtn autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:60];
        [self.voiceBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.cameraLabel withOffset:60];
        [self.voiceLabel autoSetDimensionsToSize:CGSizeMake(90, 90)];
        [self.voiceLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:60];
        [self.voiceLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.voiceBtn withOffset:5];
        
        self.didSetupConstraints = YES;
    }
    
    [super updateConstraints];
}

- (void)buttonClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    int tag = btn.tag;
    //[self.delegate performSelector:@selector(mainMenuButtonClick:) withObject:[NSNumber numberWithInt:tag]];
}

- (void)dealloc {
    self.delegate = nil;
    self.locBtn = nil;
    self.locLabel = nil;
    self.cameraBtn = nil;
    self.cameraLabel = nil;
    self.findBtn = nil;
    self.findLabel = nil;
    self.voiceBtn = nil;
    self.voiceLabel = nil;
}


@end
