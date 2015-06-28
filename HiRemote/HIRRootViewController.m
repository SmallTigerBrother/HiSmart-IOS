//
//  HIRRootViewController.m
//  HiRemote
//
//  Created by parker on 6/25/15.
//  Copyright (c) 2015 hiremote. All rights reserved.
//

#import "HIRRootViewController.h"
#import "HIRDeviceShowView.h"
#import "HIRSegmentView.h"
#import "HIRUserInfoTableViewController.h"
#import "HIRMainMenuView.h"
#import "PureLayout.h"
#define SCROLLVIEW_HEIGHT 160
@interface HIRRootViewController () <UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,HIRSegmentViewDelegate,HIRMainMenuViewDelegate>
@property (nonatomic, strong) UIScrollView *showDeviceScrollView;
@property (nonatomic, strong) UIButton *preButton;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) HIRSegmentView *segControl;
@property (nonatomic, strong) HIRMainMenuView *mainMenuView;
@property (nonatomic, strong) UITableView *mainMenuTableView;
@property (nonatomic, strong) NSMutableArray *deviceShowArray;
@property (nonatomic, assign) BOOL didSetupConstraints;
@property (nonatomic, assign) NSInteger segmentIndex;
@end

@implementation HIRRootViewController
@synthesize showDeviceScrollView;
@synthesize preButton;
@synthesize nextButton;
@synthesize pageControl;
@synthesize segControl;
@synthesize mainMenuView;
@synthesize mainMenuTableView;
@synthesize deviceShowArray;

- (UIImage *)createImageWithColor:(UIColor *)color {
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _segmentIndex = 0;
    self.deviceShowArray = [NSMutableArray arrayWithCapacity:5];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    ///导航界面
    self.view.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.97 alpha:1];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:0.38 green:0.74 blue:0.59 alpha:1],NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    self.title = @"dsaw333okkkmyyyyyyyyy987";
    
    UIView *leftBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 44)];
    UIImageView *userAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    userAvatar.image = [UIImage imageNamed:@"userAvatar"];
    UILabel *userName = [[UILabel alloc] initWithFrame:CGRectMake(45, 0, 70, 40)];
    userName.text = @"zhang san feng";
    userName.textColor = [UIColor colorWithRed:0.38 green:0.74 blue:0.59 alpha:1];
    
    UIButton *actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    actionButton.frame = CGRectMake(0, 0, 60, 44);

    [actionButton addTarget:self action:@selector(avatarClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [actionButton addTarget:self action:@selector(avatarClickDown:) forControlEvents:UIControlEventTouchDown];
    
    [leftBarView addSubview:userAvatar];
    [leftBarView addSubview:userName];
    [leftBarView addSubview:actionButton];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"addDevice"] style:UIBarButtonItemStylePlain target:self action:@selector(addNewDevice:)];
    
    ////主界面
    self.showDeviceScrollView = [[UIScrollView alloc] init];
    self.showDeviceScrollView.pagingEnabled = YES;
    self.showDeviceScrollView.contentSize = CGSizeMake(self.view.frame.size.width,self.showDeviceScrollView.frame.size.height);
    self.showDeviceScrollView.showsHorizontalScrollIndicator = NO;
    self.showDeviceScrollView.showsVerticalScrollIndicator = NO;
    self.showDeviceScrollView.scrollsToTop = NO;
    self.showDeviceScrollView.delegate = self;
    //self.showDeviceScrollView.backgroundColor = [UIColor darkGrayColor];
    
    self.preButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.preButton.hidden = YES;
   // self.preButton.backgroundColor = [UIColor greenColor];
    [self.preButton setImage:[UIImage imageNamed:@"preBtn"] forState:UIControlStateNormal];
    [self.preButton addTarget:self action:@selector(preButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.nextButton.hidden = YES;
   // self.nextButton.backgroundColor = [UIColor brownColor];
    [self.nextButton setImage:[UIImage imageNamed:@"nextBtn"] forState:UIControlStateNormal];
    [self.nextButton addTarget:self action:@selector(nextButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.pageControl = [[UIPageControl alloc] init];
    self.pageControl.numberOfPages = 5;
    self.pageControl.currentPage = 0;
   // self.pageControl.backgroundColor = [UIColor redColor];
    [self.pageControl addTarget:self action:@selector(pageControlChange:) forControlEvents:UIControlEventValueChanged];
    
    self.segControl = [[HIRSegmentView alloc] initWithFrame:CGRectMake(60, SCROLLVIEW_HEIGHT + 15, self.view.frame.size.width - 120, 35) items:[NSArray arrayWithObjects:NSLocalizedString(@"myBag", @""),NSLocalizedString(@"edit", @""), nil]];
    self.segControl.tintColor = [UIColor colorWithRed:0.38 green:0.74 blue:0.56 alpha:1];
    self.segControl.delegate = self;
    
    self.mainMenuView = [[HIRMainMenuView alloc] init];
    self.mainMenuView.scrollEnabled = YES;
    self.mainMenuView.delegate = self;
    self.mainMenuView.showsHorizontalScrollIndicator = NO;
    self.mainMenuView.backgroundColor = [UIColor redColor];
    
//    self.mainMenuTableView = [[UITableView alloc] init];
//    self.mainMenuTableView.hidden = YES;
//    self.mainMenuTableView.dataSource = self;
//    self.mainMenuTableView.delegate = self;
//    //self.mainMenuTableView.backgroundColor = [UIColor yellowColor];
    
    [self setupScrollViewContentView];
    
    [self.view addSubview:self.showDeviceScrollView];
    [self.view addSubview:self.preButton];
    [self.view addSubview:self.nextButton];
    [self.view addSubview:self.pageControl];
    [self.view addSubview:self.segControl];
   
   // [self.view addSubview:self.mainMenuTableView];
     [self.view addSubview:self.mainMenuView];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
     [self.mainMenuView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height*2)];
    HIRDeviceShowView *show = [self.deviceShowArray objectAtIndex:0];
    show.batteryPercent.percent = pp;
    pp+= 0.1;
    [show.avatarImageView setImage:[UIImage imageNamed:@"Default-568"]];
}



- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        
        [self.showDeviceScrollView autoSetDimension:ALDimensionHeight toSize:SCROLLVIEW_HEIGHT];
        [self.showDeviceScrollView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
        [self.showDeviceScrollView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
        [self.showDeviceScrollView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
 
        [self.preButton autoSetDimensionsToSize:CGSizeMake(50, 40)];
        [self.preButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];;
        [self.preButton autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.showDeviceScrollView withOffset:SCROLLVIEW_HEIGHT/2 - 20];
        
        [self.nextButton autoSetDimensionsToSize:CGSizeMake(50, 40)];
        [self.nextButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
        [self.nextButton autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.showDeviceScrollView withOffset:SCROLLVIEW_HEIGHT/2 - 20];
        
        [self.pageControl autoSetDimension:ALDimensionHeight toSize:20];
        [self.pageControl autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:40];
        [self.pageControl autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:40];
        [self.pageControl autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.showDeviceScrollView withOffset:0];
        
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.mainMenuView attribute:NSLayoutAttributeLeft relatedBy: NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0f constant:10];
        NSLayoutConstraint *constraint2 = [NSLayoutConstraint constraintWithItem:self.mainMenuView attribute:NSLayoutAttributeWidth relatedBy: NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:100];
        NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:self.mainMenuView attribute:NSLayoutAttributeHeight relatedBy: NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:110];
        //NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:self.mainMenuView attribute:NSLayoutAttributeTop relatedBy: NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:20];
        [self.view addConstraint:constraint];
        [self.mainMenuView addConstraint:constraint2];
        [self.mainMenuView addConstraint:constraint3];
       // [self.mainMenuView addConstraint:constraint4];
        
//        [self.mainMenuView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
//        [self.mainMenuView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
//        [self.mainMenuView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
//        [self.mainMenuView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.segControl withOffset:15.0];
//        
//        [self.mainMenuTableView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
//        [self.mainMenuTableView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
//        [self.mainMenuTableView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
//        [self.mainMenuTableView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.segControl withOffset:15.0];
//        
        self.didSetupConstraints = YES;
    }
    
    [super updateViewConstraints];
}

- (void)setupScrollViewContentView {
    self.showDeviceScrollView.contentSize = CGSizeMake(self.view.frame.size.width * 5, SCROLLVIEW_HEIGHT);
    for (int i= 0; i<5; i++) {
        HIRDeviceShowView *showView = [[HIRDeviceShowView alloc] init];
        showView.deviceNameLabel.text = [NSString stringWithFormat:@"device---%d",i];
        showView.deviceLocationLabel.text = [NSString stringWithFormat:@"device location===%d",i];
        CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, SCROLLVIEW_HEIGHT);
        frame.origin.x = frame.size.width * i;
        frame.origin.y = 0;
        showView.frame = frame;
        [self.showDeviceScrollView addSubview:showView];
        [self.deviceShowArray addObject:showView];
    }
    
    int totalPage = (int)self.pageControl.numberOfPages;
    if (totalPage > 1) {
        self.nextButton.hidden = NO;
    }else {
        self.nextButton.hidden = YES;
    }
}

static float pp = 0;
- (void)avatarClickAction:(id)sender {
    HIRUserInfoTableViewController *userVC = [[HIRUserInfoTableViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:userVC];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
    
}

- (void)avatarClickDown:(id)sender {
    [UIView animateWithDuration:0.3f animations:^{
        ((UIView *)sender).superview.alpha = 0.5;
    } completion:^(BOOL finished) {
        ((UIView *)sender).superview.alpha = 1;
    }];
}

- (void)addNewDevice:(id)sender {
    
}

- (void)preButtonClick:(id)sender {
    int totalPage = (int)self.pageControl.numberOfPages;
    int page = (int)self.pageControl.currentPage;
    page--;
    if (totalPage > 1) {
        self.preButton.hidden = NO;
        self.nextButton.hidden = NO;
    }
    if (page <= 0) {
        self.preButton.hidden = YES;
    }
    self.pageControl.currentPage = page;
    [self pageControlChange:nil];
}
- (void)nextButtonClick:(id)sender {
    int totalPage = (int)self.pageControl.numberOfPages;
    int page = (int)self.pageControl.currentPage;
    page++;
    if (totalPage > 1) {
        self.preButton.hidden = NO;
        self.nextButton.hidden = NO;
    }
    if (page >= (totalPage - 1)) {
        self.nextButton.hidden = YES;
    }
    self.pageControl.currentPage = page;
    [self pageControlChange:nil];
}

- (void)segmentViewSelectIndex:(NSInteger)index {
    ///is My bag
    _segmentIndex = index;
    //[self.mainMenuTableView reloadData];
}

- (void)pageControlChange:(id)sender {
    int totalPage = (int)self.pageControl.numberOfPages;
    int page = (int)self.pageControl.currentPage;
    if (totalPage > 1) {
        self.preButton.hidden = NO;
        self.nextButton.hidden = NO;
    }
    if (page >= (totalPage - 1)) {
        self.nextButton.hidden = YES;
    }
    if (page <= 0) {
        self.preButton.hidden = YES;
    }
    [self.showDeviceScrollView  setContentOffset:CGPointMake(page * self.view.frame.size.width, 0) animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = scrollView.contentOffset.x / pageWidth;
    self.pageControl.currentPage = page;
    
    int totalPage = (int)self.pageControl.numberOfPages;
    if (totalPage > 1) {
        self.preButton.hidden = NO;
        self.nextButton.hidden = NO;
    }
    
    if (page >= (totalPage - 1)) {
        self.nextButton.hidden = YES;
    }
    if (page <= 0) {
        self.preButton.hidden = YES;
    }
}



/////for table view
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_segmentIndex == 0) {
        return 1;
    }else if(_segmentIndex == 1) {
        return 4;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifyCell = @"identifyCell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifyCell];
    if (cell == nil)
    {
        cell =  [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifyCell];
    }
    
    if (_segmentIndex == 0) {
        UIView *contentView = [[UIView alloc] initWithFrame:cell.frame];
        float width = contentView.frame.size.width;
        float itemWidth = width/3.5;
        
        UIButton *locBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        locBtn.frame = CGRectMake(itemWidth/2, 30, itemWidth, itemWidth);
        [locBtn setImage:[UIImage imageNamed:@"location.jpg"] forState:UIControlStateNormal];
        [locBtn addTarget:self action:@selector(location:) forControlEvents:UIControlEventTouchUpInside];
        UILabel *locLabel = [[UILabel alloc] initWithFrame:CGRectMake(itemWidth/2, locBtn.frame.origin.y+locBtn.frame.size.height, itemWidth, 40)];
        locLabel.text = NSLocalizedString(@"pinnedLocations", @"");
        
        UIButton *cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cameraBtn.frame = CGRectMake(width-itemWidth/2 - itemWidth, 30, itemWidth, itemWidth);
        [cameraBtn setImage:[UIImage imageNamed:@"camera.jpg"] forState:UIControlStateNormal];
        [cameraBtn addTarget:self action:@selector(camera:) forControlEvents:UIControlEventTouchUpInside];
        UILabel *cameraLabel = [[UILabel alloc] initWithFrame:CGRectMake(width-itemWidth/2 - itemWidth, cameraBtn.frame.origin.y+cameraBtn.frame.size.height, itemWidth, 40)];
        cameraLabel.text = NSLocalizedString(@"cameraShutte", @"");
        
        UIButton *findBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        findBtn.frame = CGRectMake(itemWidth/2, locLabel.frame.origin.y+locLabel.frame.size.height+30, itemWidth, itemWidth);
        [findBtn setImage:[UIImage imageNamed:@"find.jpg"] forState:UIControlStateNormal];
        [findBtn addTarget:self action:@selector(find:) forControlEvents:UIControlEventTouchUpInside];
        UILabel *findLabel = [[UILabel alloc] initWithFrame:CGRectMake(itemWidth/2, findBtn.frame.origin.y+findBtn.frame.size.height, itemWidth, 40)];
        findLabel.text = NSLocalizedString(@"findMyItem", @"");
        
        UIButton *voiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        voiceBtn.frame = CGRectMake(width-itemWidth/2 - itemWidth, cameraLabel.frame.origin.y+cameraLabel.frame.size.height+30, itemWidth, itemWidth);
        [voiceBtn setImage:[UIImage imageNamed:@"voice.jpg"] forState:UIControlStateNormal];
        [voiceBtn addTarget:self action:@selector(voice:) forControlEvents:UIControlEventTouchUpInside];
        UILabel *voiceLabel = [[UILabel alloc] initWithFrame:CGRectMake(width-itemWidth/2 - itemWidth, voiceBtn.frame.origin.y+voiceBtn.frame.size.height, itemWidth, 40)];
        voiceLabel.text = NSLocalizedString(@"voiceMemos", @"");
        
        [cell.contentView addSubview:locBtn];
        [cell.contentView addSubview:locLabel];
        [contentView addSubview:cameraBtn];
        [contentView addSubview:cameraLabel];
        [contentView addSubview:findBtn];
        [contentView addSubview:findLabel];
        [contentView addSubview:voiceBtn];
        [contentView addSubview:voiceLabel];
        [cell.contentView addSubview:contentView];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_segmentIndex == 0) {
        return tableView.frame.size.width;
    }
    return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    self.showDeviceScrollView = nil;
    self.preButton = nil;
    self.nextButton = nil;
    self.pageControl = nil;
    self.segControl = nil;
    self.mainMenuTableView = nil;
    self.deviceShowArray = nil;
}
@end
