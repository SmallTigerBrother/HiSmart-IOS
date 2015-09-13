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


@interface HIRWelcomeViewController ()
<UIScrollViewDelegate>

@property (nonatomic ,strong) UIScrollView *welcomeScrollView;
@property (nonatomic ,strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIButton *startButton;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) NSArray *notesArray;
@property (nonatomic, assign) BOOL didSetupConstraints;
@end


@implementation HIRWelcomeViewController
@synthesize delegate;
@synthesize welcomeScrollView;
@synthesize pageControl;
@synthesize startButton;
@synthesize titleArray;
@synthesize imageArray;
@synthesize notesArray;

 
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
    self.titleArray = [NSArray arrayWithObjects:NSLocalizedString(@"pinnedLocation", @""), NSLocalizedString(@"findMyItem", @""),NSLocalizedString(@"cameraShutte", @""),NSLocalizedString(@"voiceMemos", @""),NSLocalizedString(@"hiremoteControl", @""),nil];
    
    NSString *chinaControlm;
    if ([self isChinessLanguage]) {
        chinaControlm = @"controlm_cn";
    }
    else{
        chinaControlm = @"controlm";
    }
    
    self.imageArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"pinnedm"],[UIImage imageNamed:@"findm"],[UIImage imageNamed:@"cameram"],[UIImage imageNamed:@"voicem"],[UIImage imageNamed:chinaControlm], nil];
    self.notesArray = [NSArray arrayWithObjects:NSLocalizedString(@"pinedTips", @""), NSLocalizedString(@"findTips", @""),NSLocalizedString(@"cameraTips", @""),NSLocalizedString(@"voiceTips", @""),@"",nil];
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
    self.startButton = [[UIButton alloc]init];
    [self.startButton setTitle:NSLocalizedString(@"getStarted", @"") forState:UIControlStateNormal];
    [self.startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.startButton addTarget:self action:@selector(startButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.startButton.backgroundColor = [UIColor colorWithRed:0.57 green:0.84 blue:0.73 alpha:1];
    [self.view addSubview:self.pageControl];
    [self.view addSubview:self.startButton];
    

    // If there's already a cached token, read the profile information.
    
    [self.view setNeedsUpdateConstraints];
}

-(BOOL)isChinessLanguage{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
    NSString *currentLang = [languages objectAtIndex:0];

    BOOL isChinessLanguage;
    if([currentLang compare:@"zh-Hans" options:NSCaseInsensitiveSearch]==NSOrderedSame || [currentLang compare:@"zh-Hant" options:NSCaseInsensitiveSearch]==NSOrderedSame)
    {
        isChinessLanguage = YES;
        NSLog(@"current Language == Chinese");
    }else{
        isChinessLanguage = NO;
        NSLog(@"current Language == English");
    }
    return isChinessLanguage;
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
        [self.pageControl autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:100];
        
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
    CGRect frame = welcomeScrollView.frame;
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    label.text = [self.titleArray objectAtIndex:page];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:18];
    label.frame = CGRectMake(frame.size.width * page + 50, 70, frame.size.width - 100, 40);
    
    UIImageView *imageV = [[UIImageView alloc] initWithImage:[self.imageArray objectAtIndex:page]];
    if (page == 4) {
        imageV.frame = CGRectMake(frame.size.width * page + 25, 90, frame.size.width - 50, frame.size.width - 50);
    }else {
        imageV.frame = CGRectMake(frame.size.width * page + 80, 110, frame.size.width - 160, frame.size.width - 160);
    }
    NSLog(@"x:%f,y:%f,w:%f,h:%f",imageV.frame.origin.x,imageV.frame.origin.y,imageV.frame.size.width,imageV.frame.size.height);
    UILabel *label2 = [[UILabel alloc] init];
    label2.textColor = [UIColor whiteColor];
    label2.text = [self.notesArray objectAtIndex:page];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.numberOfLines = 2;
    label2.font = [UIFont systemFontOfSize:13];
    label2.frame = CGRectMake(frame.size.width * page + 70, 110+frame.size.width - 160, frame.size.width - 140, 45);
    
    [welcomeScrollView addSubview:label];
    [welcomeScrollView addSubview:imageV];
    [welcomeScrollView addSubview:label2];
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
    self.titleArray = nil;
    self.imageArray = nil;
    self.notesArray = nil;
}

@end
