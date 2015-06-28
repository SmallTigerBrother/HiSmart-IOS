//
//  HIRWelcomeViewController.m
//  Utility
//
//  Created by Steve Jobs on 1/19/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "HIRWelcomeViewController.h"
#import "PureLayout.h"
#define WELCOME_PAGE_COUNT 5


@interface HIRWelcomeViewController () <UIScrollViewDelegate>

@property (nonatomic ,strong) UIScrollView *welcomeScrollView;
@property (nonatomic ,strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIButton *startButton;
@property (nonatomic, assign) BOOL didSetupConstraints;
@end


@implementation HIRWelcomeViewController
@synthesize delegate;
@synthesize welcomeScrollView;
@synthesize pageControl;
@synthesize startButton;

 
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.welcomeScrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    self.welcomeScrollView.pagingEnabled = YES;
    self.welcomeScrollView.bounces = NO;
    self.welcomeScrollView.contentSize = CGSizeMake(self.view.frame.size.width * WELCOME_PAGE_COUNT, self.view.frame.size.height);
    self.welcomeScrollView.showsHorizontalScrollIndicator = NO;
    self.welcomeScrollView.showsVerticalScrollIndicator = NO;
    self.welcomeScrollView.scrollsToTop = NO;
    self.welcomeScrollView.delegate = self;
    
    for (int i = 0; i < WELCOME_PAGE_COUNT; i++) {
        [self loadScrollViewWithPage:i];
    }
    [self.view addSubview:self.welcomeScrollView];
    
    self.pageControl = [[UIPageControl alloc] init];
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = WELCOME_PAGE_COUNT;
    
    [self.pageControl addTarget:self action:@selector(pageControlChange:) forControlEvents:UIControlEventValueChanged];
    self.startButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.startButton setTitle:NSLocalizedString(@"getStarted", @"") forState:UIControlStateNormal];
    [self.startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.startButton addTarget:self action:@selector(startButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.startButton.backgroundColor = [UIColor colorWithRed:0.57 green:0.84 blue:0.73 alpha:1];
    [self.view addSubview:self.pageControl];
    [self.view addSubview:self.startButton];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)pageControlChange:(id)sender {
    int page = (int)self.pageControl.currentPage;
    [self.welcomeScrollView  setContentOffset:CGPointMake(page * self.view.frame.size.width, 0) animated:YES];
}

- (void)startButtonClick:(id)sender {
    [delegate performSelector:@selector(welcomViewControllerNeedDisapear) withObject:nil];
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        [self.pageControl autoSetDimensionsToSize:CGSizeMake(180, 20)];
        [self.pageControl autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [self.pageControl autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:120];
        
        [self.startButton autoSetDimension:ALDimensionHeight toSize:35];
        [self.startButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:40.0];
        [self.startButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:40.0];
        [self.startButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.pageControl withOffset:20.0];
        self.didSetupConstraints = YES;
    }
    
    [super updateViewConstraints];
}

- (UIImage *)imageForNumber:(int)num {
    NSString *imageName = [NSString stringWithFormat:@"welpage_%d",num + 1];
    return [UIImage imageNamed:imageName];
    
//    if ([[UIScreen mainScreen] bounds].size.height > 500) {
//        NSString *imageName = [NSString stringWithFormat:@"welpage568_%d.png",num + 1];
//        return [UIImage imageNamed:imageName];
//    }else
//    {
//        NSString *imageName = [NSString stringWithFormat:@"welpage_%d.png",num + 1];
//        return [UIImage imageNamed:imageName];
//    }
}

- (void)loadScrollViewWithPage:(int)page {
    if (page < 0 || page >= WELCOME_PAGE_COUNT) return;
    UIImageView *imagePage = [[UIImageView alloc] initWithImage:[self imageForNumber:page]];
    if (nil == imagePage.superview) {
        CGRect frame = welcomeScrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        imagePage.frame = frame;
        [welcomeScrollView addSubview:imagePage];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    CGFloat pageWidth = scrollView.frame.size.width;
    int page = scrollView.contentOffset.x / pageWidth;
    self.pageControl.currentPage = page;
    

        ////检查是否有最新的广告图片advertisement_cfy
      //  UtilityAppDelegate *appDelegate = (UtilityAppDelegate *)[[UIApplication sharedApplication] delegate];
      //  [appDelegate performSelector:@selector(updateAdvertisementImage)];

    
}


- (void)dealloc
{   self.delegate = nil;
    self.welcomeScrollView = nil;
    self.pageControl = nil;
    self.startButton = nil;
}

@end
