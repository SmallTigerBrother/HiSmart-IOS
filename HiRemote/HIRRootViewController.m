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
#import "PureLayout.h"
#import "HIRRemoteData.h"
#import "AppDelegate.h"
#import "HIRCBCentralClass.h"
#import "HIRMapViewController.h"
#import "HirLocationHistoryViewController.h"
#import "HIRFindViewController.h"
#import "HirVoiceMemosViewController.h"
#import "SCNavigationController.h"
#import "HirDataManageCenter+Location.h"

#define SCROLLVIEW_HEIGHT 140
@interface HIRRootViewController () <UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,HIRSegmentViewDelegate>
@property (nonatomic, strong) UIScrollView *showDeviceScrollView;
@property (nonatomic, strong) UIButton *preButton;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) HIRSegmentView *segControl;
@property (nonatomic, strong) UIScrollView *mainMenuScrollView;
@property (nonatomic, strong) UITableView *mainMenuTableView;
@property (nonatomic, strong) NSMutableArray *deviceShowArray;
@property (nonatomic, strong) NSMutableArray *switchStatus;
@property (nonatomic, assign) BOOL didSetupConstraints;
@property (nonatomic, strong) NSMutableArray *deviceInfoArray;
@property (nonatomic, strong) SCNavigationController *cameraNavigationController;
@end

@implementation HIRRootViewController
@synthesize showDeviceScrollView;
@synthesize preButton;
@synthesize nextButton;
@synthesize pageControl;
@synthesize segControl;
@synthesize mainMenuScrollView;
@synthesize mainMenuTableView;
@synthesize deviceShowArray;
@synthesize deviceInfoArray;





- (void)viewDidLoad {
    [super viewDidLoad];
    self.switchStatus = [NSMutableArray arrayWithObjects:[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],nil];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    ///导航界面
    self.view.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.97 alpha:1];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:0.38 green:0.74 blue:0.59 alpha:1],NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    self.title = @"dsa";
    
    self.deviceShowArray = [NSMutableArray arrayWithCapacity:5];
    self.deviceInfoArray = [HirUserInfo shareUserInfo].deviceInfoArray;
    
   // self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"userAvatar"] style:UIBarButtonItemStylePlain target:self action:@selector(showUserInfoVC:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"addDevice"] style:UIBarButtonItemStylePlain target:self action:@selector(addNewDevice:)];
    
    ////主界面
    self.showDeviceScrollView = [[UIScrollView alloc] init];
    self.showDeviceScrollView.pagingEnabled = YES;
    self.showDeviceScrollView.showsHorizontalScrollIndicator = NO;
    self.showDeviceScrollView.showsVerticalScrollIndicator = NO;
    self.showDeviceScrollView.scrollsToTop = NO;
    self.showDeviceScrollView.delegate = self;
    
    self.preButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.preButton.hidden = YES;
    [self.preButton setImage:[UIImage imageNamed:@"preBtn"] forState:UIControlStateNormal];
    [self.preButton addTarget:self action:@selector(preButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.nextButton.hidden = YES;
    [self.nextButton setImage:[UIImage imageNamed:@"nextBtn"] forState:UIControlStateNormal];
    [self.nextButton addTarget:self action:@selector(nextButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.pageControl = [[UIPageControl alloc] init];
    if ([self.deviceInfoArray count] > 0) {
        self.pageControl.numberOfPages = [self.deviceInfoArray count];
    }else {
        self.pageControl.numberOfPages = 1;
    }
    
    self.pageControl.currentPage = 0;
    [self.pageControl addTarget:self action:@selector(pageControlChange:) forControlEvents:UIControlEventValueChanged];
    
    self.segControl = [[HIRSegmentView alloc] initWithFrame:CGRectMake(60, SCROLLVIEW_HEIGHT + 15, self.view.frame.size.width - 120, 35) items:[NSArray arrayWithObjects:NSLocalizedString(@"myBag", @""),NSLocalizedString(@"edit", @""), nil]];
    self.segControl.tintColor = [UIColor colorWithRed:0.38 green:0.74 blue:0.56 alpha:1];
    self.segControl.delegate = self;
    
    self.mainMenuScrollView = [[UIScrollView alloc] init];
    self.mainMenuScrollView.scrollEnabled = YES;
    self.mainMenuScrollView.showsHorizontalScrollIndicator = NO;
    self.mainMenuScrollView.showsVerticalScrollIndicator = YES;
    self.mainMenuScrollView.scrollsToTop = NO;
    
    self.mainMenuTableView = [[UITableView alloc] init];
    self.mainMenuTableView.hidden = YES;
    self.mainMenuTableView.dataSource = self;
    self.mainMenuTableView.delegate = self;
    self.mainMenuTableView.tableFooterView = [[UIView alloc] init];
    
    [self.view addSubview:self.showDeviceScrollView];
    [self.view addSubview:self.preButton];
    [self.view addSubview:self.nextButton];
    [self.view addSubview:self.pageControl];
    [self.view addSubview:self.segControl];
    [self.view addSubview:self.mainMenuScrollView];
    [self.view addSubview:self.mainMenuTableView];
    
    [self setupShowDeviceScrollViewContentView];
    [self setupMainMenuScrollViewContentView];
    
    [self.view setNeedsUpdateConstraints];
    
    double delayInSeconds = 0.2;
    dispatch_time_t dispatchTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(dispatchTime,dispatch_get_main_queue(), ^(void){
        NSLog(@"self.device:%@",self.deviceInfoArray);
        for (int i = 0; i < [self.deviceInfoArray count]; i++) {
            if ([self.deviceShowArray count] > i) {
                DBPeriphera *remoteData = [self.deviceInfoArray objectAtIndex:i];
                NSLog(@"rooot data:%@",remoteData);
                HIRDeviceShowView *device = [self.deviceShowArray objectAtIndex:i];
                
                NSString *currentUuid = [[HIRCBCentralClass shareHIRCBcentralClass].discoveredPeripheral.identifier UUIDString];
                if ([remoteData.uuid isEqualToString:currentUuid]) {
                    UIImage *image = [UIImage imageWithContentsOfFile:remoteData.avatarPath];
                    DBPeripheraLocationInfo *locationInfo = [HirDataManageCenter findLastLocationByPeriperaUUID:currentUuid];
                    NSLog(@"nn:%@--ll:%@--bb:%f",remoteData.name,locationInfo.location,remoteData.battery);
                    device.deviceNameLabel.text = remoteData.name;
                    device.deviceLocationLabel.text = locationInfo.location;
                    device.batteryPercent.percent = [HIRCBCentralClass shareHIRCBcentralClass].batteryLevel;
                    [device.avatarImageView setImage:image];
                }
            }
        }
    });
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(batteryLevelChange:) name:BATTERY_LEVEL_CHANGE_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(needSavePeripheralLocation:) name:NEED_SAVE_PERIPHERAL_LOCATION_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(peripheralDisconnect:) name:NEED_DISCONNECT_LOCATION_NOTIFICATION object:nil];
}


- (void)batteryLevelChange:(NSNotification *)notify {
    NSDictionary *info = notify.userInfo;
    float level = [[info valueForKey:@"level"] floatValue];
    
    int page = (int)(self.pageControl.currentPage);
    if ([self.deviceShowArray count] > page) {
        HIRDeviceShowView *view = [self.deviceShowArray objectAtIndex:page];
        view.batteryPercent.percent = level;
    }
}

-(void)needSavePeripheralLocation:(NSNotification *)notify{
    NSString *uuid = [HirUserInfo shareUserInfo].currentPeriphera.uuid;
    
    NSString *latitude = [NSString stringWithFormat:@"%f",appDelegate.locManger.location.coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f",appDelegate.locManger.location.coordinate.longitude];
    NSString *location = appDelegate.locManger.currentStreet;
    [HirDataManageCenter insertLocationRecordByPeripheraUUID:uuid latitude:latitude longitude:longitude location:location dataType:@(HirLocationDataType_history) remark:nil];
}

-(void)peripheralDisconnect:(NSNotification *)notify{
    NSString *uuid = [HirUserInfo shareUserInfo].currentPeriphera.uuid;
    NSNumber *latitude = [NSNumber numberWithDouble:appDelegate.locManger.location.coordinate.latitude];
    NSNumber *longitude = [NSNumber numberWithDouble:appDelegate.locManger.location.coordinate.longitude];
    NSString *location = appDelegate.locManger.currentStreet;
    [HirDataManageCenter insertLocationRecordByPeripheraUUID:uuid latitude:latitude longitude:longitude location:location dataType:@(HirLocationDataType_lost) remark:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
        
        [self.pageControl autoSetDimension:ALDimensionHeight toSize:18];
        [self.pageControl autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:40];
        [self.pageControl autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:40];
        [self.pageControl autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.showDeviceScrollView withOffset:-2];
        
        [self.mainMenuScrollView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
        [self.mainMenuScrollView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
        [self.mainMenuScrollView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
        [self.mainMenuScrollView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.segControl withOffset:15.0];
        
        [self.mainMenuTableView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
        [self.mainMenuTableView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
        [self.mainMenuTableView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
        [self.mainMenuTableView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.segControl withOffset:15.0];
        self.didSetupConstraints = YES;
    }
    
    [super updateViewConstraints];
}

- (void)setupShowDeviceScrollViewContentView {
    if ([self.deviceInfoArray count] > 0) {
        self.showDeviceScrollView.contentSize = CGSizeMake(self.view.frame.size.width * [self.deviceInfoArray count], SCROLLVIEW_HEIGHT);
    }else {
        self.showDeviceScrollView.contentSize = CGSizeMake(self.view.frame.size.width, SCROLLVIEW_HEIGHT);
    }
    
    NSLog(@"shooo:%f,%f",self.showDeviceScrollView.contentSize.width,self.showDeviceScrollView.contentSize.height);
    for (int i= 0; i < [self.deviceInfoArray count]; i++) {
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
- (void)setupMainMenuScrollViewContentView {
    self.mainMenuScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height*0.8);
    NSLog(@"%f,%f===",self.mainMenuScrollView.contentSize.width,self.mainMenuScrollView.contentSize.height);
    CGSize size = self.view.frame.size;
    float eightPercent = size.width/8;
    float fourPercent = size.width/4;
    
    UIButton *locBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    locBtn.frame = CGRectMake(eightPercent, 5, eightPercent*2.5,eightPercent*2.5);
    locBtn.tag = 0;
    locBtn.contentMode = UIViewContentModeScaleToFill;
    [locBtn setBackgroundImage:[UIImage imageNamed:@"location"] forState:UIControlStateNormal];
    [locBtn addTarget:self action:@selector(menuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *locLabel = [[UILabel alloc] init];
    locLabel.frame = CGRectMake(eightPercent*0.5, locBtn.frame.origin.y + locBtn.frame.size.height + 2, fourPercent*2-eightPercent*0.5,30);
    locLabel.textAlignment = NSTextAlignmentCenter;
    locLabel.font = [UIFont boldSystemFontOfSize:16];
    locLabel.text = NSLocalizedString(@"pinnedLocations", @"");
    
    UIButton *cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cameraBtn.frame = CGRectMake(size.width-eightPercent*2.5-eightPercent, 5, eightPercent*2.5,eightPercent*2.5);
    cameraBtn.tag = 1;
    [cameraBtn setImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
    [cameraBtn addTarget:self action:@selector(menuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *cameraLabel = [[UILabel alloc] init];
    cameraLabel.frame = CGRectMake(fourPercent*2, cameraBtn.frame.origin.y + cameraBtn.frame.size.height + 2, fourPercent*2-eightPercent*0.5,30);
    cameraLabel.textAlignment = NSTextAlignmentCenter;
    cameraLabel.font = [UIFont boldSystemFontOfSize:16];
    cameraLabel.text = NSLocalizedString(@"cameraShutte", @"");
    
    UIButton *findBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    findBtn.frame = CGRectMake(eightPercent, locLabel.frame.origin.y + locLabel.frame.size.height + 20, eightPercent*2.5,eightPercent*2.5);
    findBtn.tag = 2;
    [findBtn setImage:[UIImage imageNamed:@"find"] forState:UIControlStateNormal];
    [findBtn addTarget:self action:@selector(menuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *findLabel = [[UILabel alloc] init];
    findLabel.frame = CGRectMake(eightPercent*0.5, findBtn.frame.origin.y + findBtn.frame.size.height + 2, fourPercent*2-eightPercent*0.5,30);
    findLabel.textAlignment = NSTextAlignmentCenter;
    findLabel.font = [UIFont boldSystemFontOfSize:16];
    findLabel.text = NSLocalizedString(@"findMyItem", @"");
    
    UIButton *voiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    voiceBtn.frame = CGRectMake(size.width-eightPercent*2.5-eightPercent, cameraLabel.frame.origin.y+cameraLabel.frame.size.height + 20, eightPercent*2.5,eightPercent*2.5);
    voiceBtn.tag = 3;
    [voiceBtn setImage:[UIImage imageNamed:@"voice"] forState:UIControlStateNormal];
    [voiceBtn addTarget:self action:@selector(menuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *voiceLabel = [[UILabel alloc] init];
    voiceLabel.frame = CGRectMake(fourPercent*2, voiceBtn.frame.origin.y+voiceBtn.frame.size.height+2, fourPercent*2-eightPercent*0.5,30);
    voiceLabel.textAlignment = NSTextAlignmentCenter;
    voiceLabel.font = [UIFont boldSystemFontOfSize:16];
    voiceLabel.text = NSLocalizedString(@"voiceMemos", @"");
    
    [self.mainMenuScrollView addSubview:locBtn];
    [self.mainMenuScrollView addSubview:locLabel];
    [self.mainMenuScrollView addSubview:cameraBtn];
    [self.mainMenuScrollView addSubview:cameraLabel];
    [self.mainMenuScrollView addSubview:findBtn];
    [self.mainMenuScrollView addSubview:findLabel];
    [self.mainMenuScrollView addSubview:voiceBtn];
    [self.mainMenuScrollView addSubview:voiceLabel];
}


static float pp = 0;
-(void)menuButtonClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 0) {
        HirLocationHistoryViewController *locationHistoryViewController = [[HirLocationHistoryViewController alloc]initWithDataType:HirLocationDataType_history];
        [self.navigationController pushViewController:locationHistoryViewController animated:YES];
    }
    else if (btn.tag == 1){
        self.cameraNavigationController = [[SCNavigationController alloc] init];
        //        nav.scNaigationDelegate = self;
        [_cameraNavigationController showCameraWithParentController:self];
        
    }
    else if(btn.tag == 2) {
        HirLocationHistoryViewController *locationHistoryViewController = [[HirLocationHistoryViewController alloc]initWithDataType:HirLocationDataType_lost];
        [self.navigationController pushViewController:locationHistoryViewController animated:YES];
    }
    else if (btn.tag == 3){
        HirVoiceMemosViewController *voiceMemosViewController = [[HirVoiceMemosViewController alloc]initWithNibName:@"HirVoiceMemosViewController" bundle:nil];
        [self.navigationController pushViewController:voiceMemosViewController animated:YES];
    }
}

- (void)avatarClickAction:(id)sender {
//    TestViewController *test = [[TestViewController alloc] init];
//    // UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:test];
//    [self.navigationController pushViewController:test animated:YES];
    
    //   HIRUserInfoTableViewController *userVC = [[HIRUserInfoTableViewController alloc] init];
    //   UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:userVC];
    //  [self.navigationController presentViewController:nav animated:YES completion:nil];
    
}

- (void)addNewDevice:(id)sender {
    [[HIRCBCentralClass shareHIRCBcentralClass] cancelConnectionWithPeripheral:nil];
    AppDelegate *appDeleg = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDeleg addNewDevice];
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
    
    [HirUserInfo shareUserInfo].currentPeripheraIndex = page;
    
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
    if (index == 0) {
        self.mainMenuTableView.hidden = YES;
        self.mainMenuScrollView.hidden = NO;
    }else {
        self.mainMenuScrollView.hidden = YES;
        self.mainMenuTableView.hidden = NO;
    }
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
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifyCell = @"identifyCell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifyCell];
    if (cell == nil) {
        cell =  [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifyCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8, 3, self.view.frame.size.width-100, 20)];
        label.font = [UIFont boldSystemFontOfSize:16];
        label.tag = 10;
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(8, 25, self.view.frame.size.width- 70, 44)];
        label2.tag = 20;
        label2.numberOfLines = 3;
        UISwitch *theSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 60, 18, 70,40)];
        theSwitch.tintColor = COLOR_THEME;
        theSwitch.onTintColor = COLOR_THEME;
        theSwitch.tag = [indexPath row];
        [theSwitch setOn:[[self.switchStatus objectAtIndex:[indexPath row]] boolValue] animated:NO];
        [theSwitch addTarget:self action:@selector(theSwitchChange:) forControlEvents:UIControlEventValueChanged];
        [cell.contentView addSubview:label];
        [cell.contentView addSubview:label2];
        [cell.contentView addSubview:theSwitch];
    }
    NSString *title = @"";
    NSString *info = @"";
    if ([indexPath row] == 0) {
        title = @"edit10";
        info = @"edit11";
    }else if ([indexPath row] == 1) {
        title = @"edit20";
        info = @"edit21";
    }else if ([indexPath row] == 2) {
        title = @"edit30";
        info = @"edit31";
    }else if ([indexPath row] == 3) {
        title = @"edit40";
        info = @"edit41";
    }
    UILabel *lab1 = (UILabel *)[cell.contentView viewWithTag:10];
    lab1.text = NSLocalizedString(title, @"");
    UILabel *lab2 = (UILabel *)[cell.contentView viewWithTag:20];
    lab2.text = NSLocalizedString(info, @"");
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}


- (void)theSwitchChange:(id)sender {
    UISwitch *theSw = (UISwitch *)sender;
    long tag = theSw.tag;
    [self.switchStatus replaceObjectAtIndex:tag withObject:[NSNumber numberWithBool:theSw.on]];
    NSLog(@"tag :%ld---%d",tag,theSw.on);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    NSLog(@"rooot view dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.switchStatus = nil;
    self.showDeviceScrollView = nil;
    self.preButton = nil;
    self.nextButton = nil;
    self.pageControl = nil;
    self.segControl = nil;
    self.mainMenuScrollView = nil;
    self.mainMenuTableView = nil;
    self.deviceShowArray = nil;
    self.deviceInfoArray = nil;
}

@end
