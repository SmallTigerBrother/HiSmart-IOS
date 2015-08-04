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
#import "CLLocation+Sino.h"
#import "HirMsgPlaySound.h"
#import <AVFoundation/AVFoundation.h>
#import "HirDataManageCenter+DeviceRecord.h"
#import "HirSettingTableViewController.h"

@interface HIRRootViewController () <UIScrollViewDelegate,
UITableViewDataSource,
UITableViewDelegate,
HIRSegmentViewDelegate,
HPCoreLocationMangerDelegate>
{
    BOOL toggle;
    enum
    {
        ENC_AAC = 1,
        ENC_ALAC = 2,
        ENC_IMA4 = 3,
        ENC_ILBC = 4,
        ENC_ULAW = 5,
        ENC_PCM = 6,
    } encodingTypes;
    int recordEncoding;
    NSTimer *timerForPitch;
    float Pitch;
    BOOL hadOpenVoicePath;
}

@property (nonatomic, strong) UIButton *headLeftBtn;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *headRightBtn;
@property (nonatomic, strong) UIScrollView *showDeviceScrollView;
@property (nonatomic, strong) UIActivityIndicatorView *changeIndicator;
@property (nonatomic, strong) UIButton *preButton;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) HIRSegmentView *segControl;
@property (nonatomic, strong) UIScrollView *mainMenuScrollView;
@property (nonatomic, strong) UITableView *mainMenuTableView;
@property (nonatomic, strong) NSMutableArray *deviceShowArray;
@property (nonatomic, strong) NSMutableArray *switchStatus;
@property (nonatomic, strong) NSTimer *outTimer;
@property (nonatomic, assign) BOOL didSetupConstraints;
@property (nonatomic, assign) BOOL isLocationing;
@property (nonatomic, assign) BOOL isDisconnectLocation;
@property (nonatomic, assign) BOOL isRecording;
@property (nonatomic, assign) float showDeviceFrameHeight;
@property (nonatomic, strong) NSMutableArray *deviceInfoArray;
@property (nonatomic, strong) SCNavigationController *cameraNavigationController;

@property (nonatomic, assign) NSInteger needSavePeripheralLocationCount;    //需要记录历史的次数
@property (nonatomic, assign) NSInteger peripheralDisconnectCount;          //需要记录到断开连接表的次数
@property (nonatomic, assign) BOOL isVoiceRecordNotification;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) AVAudioRecorder *audioRecorder;


@end

@implementation HIRRootViewController
@synthesize headLeftBtn;
@synthesize titleLabel;
@synthesize headRightBtn;
@synthesize showDeviceScrollView;
@synthesize changeIndicator;
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
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *statusArray = [userDefaults valueForKey:@"theHiremoteSettingStatus"];
    if (!statusArray || [statusArray count] < 3) {
        self.switchStatus = [NSMutableArray arrayWithObjects:[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO],nil];
    }else {
        self.switchStatus = [NSMutableArray arrayWithArray:statusArray];
    }
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSNumber *lossNumber = [defaults valueForKey:@"tempLostAlertValue"];
    if (lossNumber) {
        if ([lossNumber floatValue] > 0.01) {
            [self.switchStatus replaceObjectAtIndex:2 withObject:[NSNumber numberWithBool:YES]];
        }else {
            [self.switchStatus replaceObjectAtIndex:2 withObject:[NSNumber numberWithBool:NO]];
        }
        [defaults removeObjectForKey:@"tempLostAlertValue"];
        [defaults synchronize];
    }
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    NSString *bgPath = [[NSBundle mainBundle] pathForResource:@"mainviewbg" ofType:@"jpg"];
    UIImage *bgImage = [UIImage imageWithContentsOfFile:bgPath];
    self.view.layer.contents = (id)bgImage.CGImage;
   
    if (DEVICE_IS_IPHONE6p) {
        _showDeviceFrameHeight = 185;
    }else if (DEVICE_IS_IPHONE6) {
        _showDeviceFrameHeight = 170;
    }else {
        _showDeviceFrameHeight = 150;
    }
    
    self.deviceShowArray = [NSMutableArray arrayWithCapacity:5];
    self.deviceInfoArray = [HirUserInfo shareUserInfo].deviceInfoArray;
    
    //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"addDevice"] style:UIBarButtonItemStylePlain target:self action:@selector(showUserInfoVC:)];
//    self.headLeftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.headLeftBtn setImage:[UIImage imageNamed:@"addDevice"] forState:UIControlStateNormal];
//    [self.headLeftBtn addTarget:self action:@selector(showUserInfoVC:) forControlEvents:UIControlEventTouchUpInside];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.text = NSLocalizedString(@"hiRemote", @"");
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:19];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    self.headRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //self.headRightBtn.backgroundColor = [UIColor darkGrayColor];
    [self.headRightBtn setImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
    [self.headRightBtn addTarget:self action:@selector(addNewDevice:) forControlEvents:UIControlEventTouchUpInside];
    
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"addDevice"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(addNewDevice:)];
    
    ////主界面
    self.showDeviceScrollView = [[UIScrollView alloc] init];
    self.showDeviceScrollView.backgroundColor = [UIColor clearColor];
    self.showDeviceScrollView.pagingEnabled = YES;
    self.showDeviceScrollView.showsHorizontalScrollIndicator = NO;
    self.showDeviceScrollView.showsVerticalScrollIndicator = NO;
    self.showDeviceScrollView.scrollsToTop = NO;
    self.showDeviceScrollView.delegate = self;
    
    self.changeIndicator = [[UIActivityIndicatorView alloc] init];
    self.changeIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    ////[self.changeIndicator startAnimating];
    self.preButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.preButton.hidden = YES;
    [self.preButton setImage:[UIImage imageNamed:@"preBtn"] forState:UIControlStateNormal];
    [self.preButton addTarget:self action:@selector(preButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.nextButton.hidden = YES;
    [self.nextButton setImage:[UIImage imageNamed:@"nextBtn"] forState:UIControlStateNormal];
    [self.nextButton addTarget:self action:@selector(nextButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.pageControl = [[UIPageControl alloc] init];
    self.pageControl.userInteractionEnabled = NO;
    if ([self.deviceInfoArray count] > 0) {
        self.pageControl.numberOfPages = [self.deviceInfoArray count];
    }else {
        self.pageControl.numberOfPages = 1;
    }
    
    self.pageControl.currentPage = 0;
    self.segControl = [[HIRSegmentView alloc] initWithFrame:CGRectMake(20, _showDeviceFrameHeight + 80, self.view.frame.size.width - 40, 40) items:[NSArray arrayWithObjects:NSLocalizedString(@"myBag", @""),NSLocalizedString(@"edit", @""), nil]];
    self.segControl.tintColor = [UIColor colorWithRed:0.31 green:0.65 blue:0.53 alpha:1];
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
    
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.headRightBtn];
    [self.view addSubview:self.showDeviceScrollView];
    
    [self.view addSubview:self.preButton];
    [self.view addSubview:self.nextButton];
    [self.view addSubview:self.pageControl];
    [self.view addSubview:self.segControl];
    [self.view addSubview:self.mainMenuScrollView];
    [self.view addSubview:self.mainMenuTableView];
    [self.view addSubview:self.changeIndicator];
    
    
    [self setupShowDeviceScrollViewContentView];
    [self setupMainMenuScrollViewContentView];
    
    [self.view setNeedsUpdateConstraints];
    
    double delayInSeconds = 0.2;
    dispatch_time_t dispatchTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(dispatchTime,dispatch_get_main_queue(), ^(void){
        [HirUserInfo shareUserInfo].currentPeripheraIndex = 0;
        for (HIRDeviceShowView *showView in self.deviceShowArray) {
            [showView.avatarImageView setImage:[UIImage imageNamed:@"defaultDevice"]];
        }
        
        for (int i = 0; i < [self.deviceInfoArray count]; i++) {
            if ([self.deviceShowArray count] > i) {
                DBPeripheral *remoteData = [self.deviceInfoArray objectAtIndex:i];
                HIRDeviceShowView *device = [self.deviceShowArray objectAtIndex:i];
                
                NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
                documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"HiRemoteData"];
                if (![[NSFileManager defaultManager] fileExistsAtPath:documentsDirectory]) {
                    [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:TRUE attributes:nil error:nil];
                }
                //[device.avatarImageView setImage:[UIImage imageNamed:@"defaultDevice"]];
//                if (documentsDirectory) {
//                    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:remoteData.avatarPath];
//                    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
//                    UIImage *image = [UIImage imageWithData:imageData];
//                    if (image) {
//                        [device.avatarImageView setImage:image];
//                    }
//                }
                if ([remoteData.remarkName length] > 0) {
                    device.deviceNameLabel.text = remoteData.remarkName;
                }else {
                    device.deviceNameLabel.text = remoteData.name;
                }

                DBPeripheralLocationInfo *locationInfo = [HirDataManageCenter findLastLocationByPeriperaUUID:remoteData.uuid];
                NSString *currentUuid = [[HIRCBCentralClass shareHIRCBcentralClass].discoveredPeripheral.identifier UUIDString];
                if ([remoteData.uuid isEqualToString:currentUuid]) {
                    device.deviceLocationLabel.text = locationInfo.address;
                    device.batteryPercent.percent = [HIRCBCentralClass shareHIRCBcentralClass].batteryLevel;

                    self.pageControl.currentPage = i;
                    [HirUserInfo shareUserInfo].currentPeripheraIndex = i;
                    [self.showDeviceScrollView  setContentOffset:CGPointMake(i * self.view.frame.size.width, 0) animated:NO];
                    
                    CGFloat pageWidth = self.showDeviceScrollView.frame.size.width;
                    int page = self.showDeviceScrollView.contentOffset.x / pageWidth;
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
            }
        }
    });
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hirCBStateChange:) name:HIR_CBSTATE_CHANGE_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(batteryLevelChange:) name:BATTERY_LEVEL_CHANGE_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(needSavePeripheralLocationOrVoice:) name:NEED_SAVE_PERIPHERAL_LOCATION_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(peripheralDisconnect:) name:NEED_DISCONNECT_LOCATION_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openVoicePath) name:NotificationVoiceOpen object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLossAlertValue:) name:LOSS_ALERT_NEED_UPDATEUI_NOTIFICATION object:nil];

    appDelegate.locManger.delegate = self;
    [appDelegate.locManger startUpdatingUserLocation];
}

-(void)viewDidAppear:(BOOL)animated{
#ifdef ShowTestAlert
    [SGInfoAlert showInfo:@"this version is for test"];
#endif
    [self openVoicePath];
    
//#ifdef DEBUG
//    [self startRecording];
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self stopRecording];
//    });
//#endif
}

-(void)openVoicePath{
    if ([HirUserInfo shareUserInfo].isNotificationForVoiceMemo) {
        static dispatch_once_t pred = 0;
        dispatch_once(&pred, ^{
            [self startRecording];
            dispatch_time_t dispatchTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC));
            dispatch_after(dispatchTime,dispatch_get_main_queue(), ^(void){
                [self stopRecording];
            });
        });
    }
}

-(BOOL)isVoiceRecordNotification{
    if ([HirUserInfo shareUserInfo].isNotificationForVoiceMemo) {
        return YES;
    }
    return NO;
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

-(void)needSavePeripheralLocationOrVoice:(NSNotification *)notify{
    if (self.isVoiceRecordNotification) {
        self.isLocationing = NO;
        self.isDisconnectLocation = NO;
        appDelegate.locManger.delegate = nil;
        
        _isRecording = !_isRecording;
        
        if (_isRecording) {
            [self startRecording];
            NSLog(@"收到录音信号");
        }
        else{
            [self stopRecording];
            NSLog(@"收到停止录音信号");
        }
    }
    else{
        if (self.isLocationing) {
            return;
        }
        self.isLocationing = YES;
        self.isDisconnectLocation = NO;
        appDelegate.locManger.delegate = self;
        [appDelegate.locManger startUpdatingUserLocation];
    }
}

-(void) startRecording
{
    // kSeconds = 150.0;
    NSLog(@"startRecording");
    //    [SGInfoAlert showInfo:NSLocalizedString(@"startRecording", nil)];
    self.audioRecorder = nil;
    NSError *erro;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    //    [audioSession setCategory:AVAudioSessionCategoryRecord error:nil];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionAllowBluetooth|AVAudioSessionCategoryOptionDefaultToSpeaker error:&erro];
    
    NSMutableDictionary *recordSettings = [[NSMutableDictionary alloc] initWithCapacity:10];
//    if(recordEncoding == ENC_PCM)
//    {
        [recordSettings setObject:[NSNumber numberWithInt: kAudioFormatLinearPCM] forKey: AVFormatIDKey];
        [recordSettings setObject:[NSNumber numberWithFloat:44100.0] forKey: AVSampleRateKey];
        [recordSettings setObject:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
        [recordSettings setObject:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
        [recordSettings setObject:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
        [recordSettings setObject:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
//    }
//    else
//    {
//        NSNumber *formatObject;
    
//        switch (recordEncoding) {
//            case (ENC_AAC):
//                formatObject = [NSNumber numberWithInt: kAudioFormatMPEG4AAC];
//                break;
//            case (ENC_ALAC):
//                formatObject = [NSNumber numberWithInt: kAudioFormatAppleLossless];
//                break;
//            case (ENC_IMA4):
//                formatObject = [NSNumber numberWithInt: kAudioFormatAppleIMA4];
//                break;
//            case (ENC_ILBC):
//                formatObject = [NSNumber numberWithInt: kAudioFormatiLBC];
//                break;
//            case (ENC_ULAW):
//                formatObject = [NSNumber numberWithInt: kAudioFormatULaw];
//                break;
//            default:
//                formatObject = [NSNumber numberWithInt: kAudioFormatAppleIMA4];
//        }
    
//    NSNumber *formatObject = [NSNumber numberWithInt: kAudioFormatMPEGLayer3];

//        [recordSettings setObject:formatObject forKey: AVFormatIDKey];
//        [recordSettings setObject:[NSNumber numberWithFloat:44100.0] forKey: AVSampleRateKey];
//        [recordSettings setObject:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
//        [recordSettings setObject:[NSNumber numberWithInt:12800] forKey:AVEncoderBitRateKey];
//        [recordSettings setObject:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
//        [recordSettings setObject:[NSNumber numberWithInt: AVAudioQualityHigh] forKey: AVEncoderAudioQualityKey];
//    }
//    NSDictionary *recordSettings; = [NSDictionary dictionaryWithObjectsAndKeys:
//                                    [NSNumber numberWithInt: kAudioFormatMPEG4AAC], AVFormatIDKey,
//                                    [NSNumber numberWithFloat:16000.0], AVSampleRateKey,
//                                    [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,
//                                    nil];
    
//            [recordSettings setObject:[NSNumber numberWithInt: kAudioFormatMPEG4AAC] forKey: AVFormatIDKey];
//            [recordSettings setObject:[NSNumber numberWithFloat:44100.0] forKey: AVSampleRateKey];
//            [recordSettings setObject:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
//            [recordSettings setObject:[NSNumber numberWithInt:12800] forKey:AVEncoderBitRateKey];
//            [recordSettings setObject:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
//            [recordSettings setObject:[NSNumber numberWithInt: AVAudioQualityHigh] forKey: AVEncoderAudioQualityKey];

    
    //    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/recordTest.caf", [[NSBundle mainBundle] resourcePath]]];
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(
                                                            NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    
    NSString *mediaPath = [NSString stringWithFormat:@"%lld.caf",(long long)[[NSDate date] timeIntervalSince1970]];
    // NSString *mediaPath = [NSString stringWithFormat:@"%lld.caf",(long long)[[NSDate date]timeIntervalSinceReferenceDate]*1000000];
    NSLog(@"recoer mediaPath = %@",mediaPath);
    
    NSString *soundFilePath = [docsDir
                               stringByAppendingPathComponent:mediaPath];
    
    NSURL *url = [NSURL fileURLWithPath:soundFilePath];
    
    NSError *error = nil;
    self.audioRecorder = [[ AVAudioRecorder alloc] initWithURL:url settings:recordSettings error:&error];
    _audioRecorder.meteringEnabled = YES;
    if ([_audioRecorder prepareToRecord] == YES){
        _audioRecorder.meteringEnabled = YES;
        [_audioRecorder record];
        timerForPitch =[NSTimer scheduledTimerWithTimeInterval: 0.01 target: self selector: @selector(levelTimerCallback:) userInfo: nil repeats: YES];
    }else {
        
        int errorCode = CFSwapInt32HostToBig ([error code]);
        NSLog(@"Error: %@ [%4.4s])" , [error localizedDescription], (char*)&errorCode);
        
    }
}

-(void) stopRecording
{
    NSLog(@"stopRecording");
    
    //    [SGInfoAlert showInfo:NSLocalizedString(@"stopRecording", nil)];
    // kSeconds = 0.0;
    [_audioRecorder stop];
    NSLog(@"stopped");
    [timerForPitch invalidate];
    timerForPitch = nil;
    
    NSLog(@"url=%@",_audioRecorder.url);
    
    NSString *mediaPath = [_audioRecorder.url.path lastPathComponent];
    
    NSLog(@"mmmm:%@",mediaPath);
    NSRange range = [mediaPath rangeOfString:@"."];
    NSString *recoderTimestamp;
    if (range.location != NSNotFound) {
        recoderTimestamp = [mediaPath substringToIndex:range.location];
        NSLog(@"tttt:%@",recoderTimestamp);
    }
    
    double beginRecordTime = recoderTimestamp.doubleValue;
    
    NSLog(@"stop time = %f",[[NSDate date]timeIntervalSince1970]);
    
    double voiceTime = [[NSDate date]timeIntervalSince1970] - beginRecordTime;
    
    if (hadOpenVoicePath) {
        [HirDataManageCenter insertVoicePath:mediaPath peripheraUUID:[HirUserInfo shareUserInfo].currentPeriphera.uuid recoderTimestamp:[NSNumber numberWithDouble:beginRecordTime] title:NSLocalizedString(@"newRecording", nil) voiceTime:[NSNumber numberWithDouble:voiceTime]];
    }
    hadOpenVoicePath = YES;
}

- (void)levelTimerCallback:(NSTimer *)timer {
    [_audioRecorder updateMeters];
    //    NSLog(@"Average input: %f Peak input: %f", [audioRecorder averagePowerForChannel:0], [audioRecorder peakPowerForChannel:0]);
    
//    float linear = pow (10, [audioRecorder peakPowerForChannel:0] / 20);
    //    NSLog(@"linear===%f",linear);
//    float linear1 = pow (10, [audioRecorder averagePowerForChannel:0] / 20);
//    //    NSLog(@"linear1===%f",linear1);
//    if (linear1>0.03) {
//        
//        Pitch = linear1+.20;//pow (10, [audioRecorder averagePowerForChannel:0] / 20);//[audioRecorder peakPowerForChannel:0];
//    }
//    else {
//        
//        Pitch = 0.0;
//    }
    //Pitch =linear1;
    //    NSLog(@"Pitch==%f",Pitch);
    //    _customRangeBar.value = Pitch;//linear1+.30;
//    [_voiceProgressView setProgress:Pitch];
//    float minutes = floor(audioRecorder.currentTime/60);
//    float seconds = audioRecorder.currentTime - (minutes * 60);
    
//    NSString *time = [NSString stringWithFormat:@"%0.0f.%0.0f",minutes, seconds];
//    [self.recordTimeLabel setText:[NSString stringWithFormat:@"%@ sec", time]];
    //    NSLog(@"recording");
    
}

- (void)getLossAlertValue:(NSNotification *)notify {
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"tempLostAlertValue"];
    [defaults synchronize];
    
    NSDictionary *info = notify.userInfo;
    float level = [[info valueForKey:@"value"] floatValue];
    if (level > 0.01) {
        [self.switchStatus replaceObjectAtIndex:2 withObject:[NSNumber numberWithBool:YES]];
    }else {
        [self.switchStatus replaceObjectAtIndex:2 withObject:[NSNumber numberWithBool:NO]];
    }
    if (!(self.mainMenuTableView.hidden)) {
        [self.mainMenuTableView reloadData];
    }
}


-(void)peripheralDisconnect:(NSNotification *)notify{
    if ([HirUserInfo shareUserInfo].isNotificationMyWhenDeviceNoWithin) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        
        HirMsgPlaySound *msgPlaySound = [[HirMsgPlaySound alloc]initSystemSoundWithName:@"sms-received4" SoundType:@"caf"];
        [msgPlaySound play];
        
        if([HirUserInfo shareUserInfo].appIsEnterBackgroud){
            [self locationNotification];
        }
        else{
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"warning", nil) message:NSLocalizedString(@"youDeviceIsAwayFromYou", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitles:nil];
            [alertView show];
        }
    }
    
    if (self.isLocationing) {
        return;
    }
    self.isLocationing = YES;
    self.isDisconnectLocation = YES;
    appDelegate.locManger.delegate = self;
    [appDelegate.locManger startUpdatingUserLocation];
}

- (void)locationFinished:(CLLocation *)location withFlag:(NSNumber *)isSuccess{
    self.isLocationing = NO;
    
    NSString *uuid = [HirUserInfo shareUserInfo].currentPeriphera.uuid;
    NSString *latitude = [NSString stringWithFormat:@"%f",appDelegate.locManger.location.coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f",appDelegate.locManger.location.coordinate.longitude];
    NSString *locationStr = appDelegate.locManger.fullLocation;

    if (_isDisconnectLocation) {
        [HirDataManageCenter insertLocationRecordByPeripheraUUID:uuid latitude:latitude longitude:longitude location:locationStr dataType:@(HirLocationDataType_lost) remark:nil];
    }
    else{
        [HirDataManageCenter insertLocationRecordByPeripheraUUID:uuid latitude:latitude longitude:longitude location:locationStr dataType:@(HirLocationDataType_history) remark:nil];
    }
    
    for (int i = 0; i < [self.deviceInfoArray count]; i++) {
        if ([self.deviceShowArray count] > i) {
            DBPeripheral *remoteData = [self.deviceInfoArray objectAtIndex:i];
            HIRDeviceShowView *device = [self.deviceShowArray objectAtIndex:i];
            NSString *currentUuid = [[HIRCBCentralClass shareHIRCBcentralClass].discoveredPeripheral.identifier UUIDString];
            if ([remoteData.uuid isEqualToString:currentUuid]) {
                device.deviceLocationLabel.text = locationStr;
                break;
            }
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

-(void)locationNotification{
    if (is_IOS8) {
        if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)])
        {
            UIApplication *appDelega = [UIApplication sharedApplication];
            [appDelega registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
        }
    }
    
    UILocalNotification *notification=[[UILocalNotification alloc] init];
    if (notification!=nil) {
        NSLog(@">> support local notification");
        NSDate *now=[NSDate new];
        notification.fireDate=[now addTimeInterval:.1];
        notification.timeZone=[NSTimeZone defaultTimeZone];
        notification.alertBody=NSLocalizedString(@"youDeviceIsAwayFromYou", nil);
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}

- (void)updateViewConstraints
{
    if (!self.didSetupConstraints) {
        [self.titleLabel autoSetDimensionsToSize:CGSizeMake(100, 35)];
        [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:25];
        [self.titleLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
        
        [self.headRightBtn autoSetDimensionsToSize:CGSizeMake(45, 45)];
        [self.headRightBtn autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:20];
        [self.headRightBtn autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
        
        [self.showDeviceScrollView autoSetDimension:ALDimensionHeight toSize:_showDeviceFrameHeight];
        [self.showDeviceScrollView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.titleLabel withOffset:10];
        [self.showDeviceScrollView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
        [self.showDeviceScrollView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
        
        [self.changeIndicator autoSetDimensionsToSize:CGSizeMake(100, 100)];
        [self.changeIndicator autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [self.changeIndicator autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.showDeviceScrollView withOffset:-70];
        
        [self.preButton autoSetDimensionsToSize:CGSizeMake(40, 40)];
        [self.preButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];;
        [self.preButton autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.showDeviceScrollView withOffset:_showDeviceFrameHeight/2 - 20];
        
        [self.nextButton autoSetDimensionsToSize:CGSizeMake(40, 40)];
        [self.nextButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
        [self.nextButton autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.showDeviceScrollView withOffset:_showDeviceFrameHeight/2 - 20];
        
        [self.pageControl autoSetDimension:ALDimensionHeight toSize:18];
        [self.pageControl autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:40];
        [self.pageControl autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:40];
        [self.pageControl autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.showDeviceScrollView withOffset:-5];
        
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
        self.showDeviceScrollView.contentSize = CGSizeMake(self.view.frame.size.width * [self.deviceInfoArray count], _showDeviceFrameHeight);
    }else {
        self.showDeviceScrollView.contentSize = CGSizeMake(self.view.frame.size.width, _showDeviceFrameHeight);
    }
    if ([self.deviceInfoArray count] == 0) {
        HIRDeviceShowView *showView = [[HIRDeviceShowView alloc] init];
        CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, _showDeviceFrameHeight);
        frame.origin.x = 0;
        frame.origin.y = 0;
        showView.frame = frame;
        showView.deviceLocationLabel.text = NSLocalizedString(@"isNotConnected", @"");
        [self.showDeviceScrollView addSubview:showView];
        [self.deviceShowArray addObject:showView];
    }else {
        for (int i= 0; i < [self.deviceInfoArray count]; i++) {
            HIRDeviceShowView *showView = [[HIRDeviceShowView alloc] init];
            CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, _showDeviceFrameHeight);
            frame.origin.x = frame.size.width * i;
            frame.origin.y = 0;
            showView.frame = frame;
            showView.deviceLocationLabel.text = NSLocalizedString(@"isNotConnected", @"");
            [self.showDeviceScrollView addSubview:showView];
            [self.deviceShowArray addObject:showView];
        }
    }
    
    int totalPage = (int)self.pageControl.numberOfPages;
    if (totalPage > 1) {
        self.nextButton.hidden = NO;
    }else {
        self.nextButton.hidden = YES;
    }
}

- (void)setupMainMenuScrollViewContentView {
    self.mainMenuScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height*0.6);
    NSLog(@"%f,%f===",self.mainMenuScrollView.contentSize.width,self.mainMenuScrollView.contentSize.height);
    CGSize size = self.view.frame.size;
    float eightPercent = size.width/8;
    float fourPercent = size.width/4;
    
    long seletedTag = -1;
    NSNumber *lastTag = [[NSUserDefaults standardUserDefaults] valueForKey:@"lastSeletedButtonTag"];
    if (lastTag) {
        seletedTag = [lastTag longValue];
    }
    
    
    UIButton *locBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    locBtn.frame = CGRectMake(eightPercent, 5, eightPercent*2.5,eightPercent*2.5);
    locBtn.tag = 0;
    if (seletedTag == 0) {
        [locBtn setSelected:YES];
    }
    locBtn.contentMode = UIViewContentModeScaleToFill;
    [locBtn setImage:[UIImage imageNamed:@"location"] forState:UIControlStateNormal];
    [locBtn setImage:[UIImage imageNamed:@"locationSelecetd"] forState:UIControlStateSelected];
    [locBtn addTarget:self action:@selector(menuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *locLabel = [[UILabel alloc] init];
    locLabel.frame = CGRectMake(eightPercent*0.5, locBtn.frame.origin.y + locBtn.frame.size.height + 2, fourPercent*2-eightPercent*0.5,30);
    locLabel.textAlignment = NSTextAlignmentCenter;
    locLabel.textColor = [UIColor whiteColor];
    locLabel.backgroundColor = [UIColor clearColor];
    locLabel.font = [UIFont boldSystemFontOfSize:16];
    locLabel.text = NSLocalizedString(@"mpinnedLocations", @"");
    
    UIButton *cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cameraBtn.frame = CGRectMake(size.width-eightPercent*2.5-eightPercent, 5, eightPercent*2.5,eightPercent*2.5);
    cameraBtn.tag = 1;
    if (seletedTag == 1) {
        [cameraBtn setSelected:YES];
    }
    [cameraBtn setImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
    [cameraBtn setImage:[UIImage imageNamed:@"cameraSelected"] forState:UIControlStateSelected];
    [cameraBtn addTarget:self action:@selector(menuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *cameraLabel = [[UILabel alloc] init];
    cameraLabel.frame = CGRectMake(fourPercent*2, cameraBtn.frame.origin.y + cameraBtn.frame.size.height + 2, fourPercent*2-eightPercent*0.5,30);
    cameraLabel.textAlignment = NSTextAlignmentCenter;
    cameraLabel.font = [UIFont boldSystemFontOfSize:16];
    cameraLabel.textColor = [UIColor whiteColor];
    cameraLabel.backgroundColor = [UIColor clearColor];
    cameraLabel.text = NSLocalizedString(@"mcameraShutte", @"");
    
    UIButton *findBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    findBtn.frame = CGRectMake(eightPercent, locLabel.frame.origin.y + locLabel.frame.size.height + 20, eightPercent*2.5,eightPercent*2.5);
    findBtn.tag = 2;
    if (seletedTag == 2) {
        [findBtn setSelected:YES];
    }
    [findBtn setImage:[UIImage imageNamed:@"find"] forState:UIControlStateNormal];
    [findBtn setImage:[UIImage imageNamed:@"findSelected"] forState:UIControlStateSelected];
    [findBtn addTarget:self action:@selector(menuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *findLabel = [[UILabel alloc] init];
    findLabel.frame = CGRectMake(eightPercent*0.5, findBtn.frame.origin.y + findBtn.frame.size.height + 2, fourPercent*2-eightPercent*0.5,30);
    findLabel.textAlignment = NSTextAlignmentCenter;
    findLabel.font = [UIFont boldSystemFontOfSize:16];
    findLabel.textColor = [UIColor whiteColor];
    findLabel.backgroundColor = [UIColor clearColor];
    findLabel.text = NSLocalizedString(@"mfindMyItem", @"");
    
    UIButton *voiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    voiceBtn.frame = CGRectMake(size.width-eightPercent*2.5-eightPercent, cameraLabel.frame.origin.y+cameraLabel.frame.size.height + 20, eightPercent*2.5,eightPercent*2.5);
    voiceBtn.tag = 3;
    if (seletedTag == 3) {
        [voiceBtn setSelected:YES];
    }
    [voiceBtn setImage:[UIImage imageNamed:@"voice"] forState:UIControlStateNormal];
    [voiceBtn setImage:[UIImage imageNamed:@"voiceSelected"] forState:UIControlStateSelected];
    [voiceBtn addTarget:self action:@selector(menuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *voiceLabel = [[UILabel alloc] init];
    voiceLabel.frame = CGRectMake(fourPercent*2, voiceBtn.frame.origin.y+voiceBtn.frame.size.height+2, fourPercent*2-eightPercent*0.5,30);
    voiceLabel.textAlignment = NSTextAlignmentCenter;
    voiceLabel.font = [UIFont boldSystemFontOfSize:16];
    voiceLabel.textColor = [UIColor whiteColor];
    voiceLabel.backgroundColor = [UIColor clearColor];
    voiceLabel.text = NSLocalizedString(@"mvoiceMemos", @"");
    
    [self.mainMenuScrollView addSubview:locBtn];
    [self.mainMenuScrollView addSubview:locLabel];
    [self.mainMenuScrollView addSubview:cameraBtn];
    [self.mainMenuScrollView addSubview:cameraLabel];
    [self.mainMenuScrollView addSubview:findBtn];
    [self.mainMenuScrollView addSubview:findLabel];
    [self.mainMenuScrollView addSubview:voiceBtn];
    [self.mainMenuScrollView addSubview:voiceLabel];
    
}

-(void)menuButtonClick:(id)sender {
    NSNumber *lastTag = [[NSUserDefaults standardUserDefaults] valueForKey:@"lastSeletedButtonTag"];
    long seletedTag = [lastTag longValue];
    for (UIView *subV in [self.mainMenuScrollView subviews]) {
        if (subV.tag == seletedTag && [subV isKindOfClass:[UIButton class]]) {
            [(UIButton *)subV setSelected:NO];
            break;
        }
    }
    
    UIButton *btn = (UIButton *)sender;
    btn.selected = YES;
    long currentBtn = btn.tag;
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithLong:currentBtn] forKey:@"lastSeletedButtonTag"];

    if (btn.tag == 0) {
        HirLocationHistoryViewController *locationHistoryViewController = [[HirLocationHistoryViewController alloc]initWithDataType:HirLocationDataType_history];
        [self.navigationController pushViewController:locationHistoryViewController animated:YES];
    }
    else if (btn.tag == 1){
        self.cameraNavigationController = [[SCNavigationController alloc] init];
        [_cameraNavigationController showCameraWithParentController:self];
    }
    else if(btn.tag == 2) {
        HIRFindViewController *findViewController = [[HIRFindViewController alloc] init];
        DBPeripheral *remoteData = nil;
        if ([self.deviceInfoArray count] > [HirUserInfo shareUserInfo].currentPeripheraIndex) {
            remoteData = [self.deviceInfoArray objectAtIndex:[HirUserInfo shareUserInfo].currentPeripheraIndex];
            findViewController.hiRemoteName = remoteData.name;
            findViewController.remarkName = remoteData.remarkName;
        }
        DBPeripheralLocationInfo *locationInfo = [HirDataManageCenter findLastLocationByPeriperaUUID:remoteData.uuid];
   
        findViewController.locationStr = locationInfo.address;
        findViewController.location = [[[CLLocation alloc] initWithLatitude:locationInfo.latitude.doubleValue longitude:locationInfo.longitude.doubleValue]locationMarsFromEarth];
        [self.navigationController pushViewController:findViewController animated:YES];
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
    HirSettingTableViewController *settingTableViewController = [[HirSettingTableViewController alloc]init];
    [self.navigationController pushViewController:settingTableViewController animated:YES];
    
    return;
    ////添加新设备时，防止为上次的设备
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    [HIRCBCentralClass shareHIRCBcentralClass].theAddNewNeedToAvoidLastUuid = [[HIRCBCentralClass shareHIRCBcentralClass].discoveredPeripheral.identifier UUIDString];
//    [[HIRCBCentralClass shareHIRCBcentralClass] cancelConnectionWithPeripheral:nil];
//    AppDelegate *appDeleg = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    [appDeleg addNewDevice];
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
    [self.showDeviceScrollView  setContentOffset:CGPointMake(page * self.view.frame.size.width, 0) animated:YES];
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
    [self.showDeviceScrollView  setContentOffset:CGPointMake(page * self.view.frame.size.width, 0) animated:YES];
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

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
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
    
    [self changeTheDeviceByUser];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self changeTheDeviceByUser];
}


///以下是用来设置设备切换的
- (void)changeTheDeviceByUser {
    [self.outTimer invalidate];
    self.outTimer = nil;
    [self.changeIndicator stopAnimating];
    
    int page = (int)self.pageControl.currentPage;
    if (page != [HirUserInfo shareUserInfo].currentPeripheraIndex) {
        for (HIRDeviceShowView *tmpDevice in self.deviceShowArray) {
            tmpDevice.deviceLocationLabel.text = NSLocalizedString(@"isNotConnected", @"");
        }
        
        [HirUserInfo shareUserInfo].currentPeripheraIndex = page;
        [[HIRCBCentralClass shareHIRCBcentralClass] cancelConnectionWithPeripheral:nil];
        if ([self.deviceInfoArray count] > page) {
            DBPeripheral *remoteData = [self.deviceInfoArray objectAtIndex:page];
            [self.changeIndicator startAnimating];
            self.outTimer = [NSTimer scheduledTimerWithTimeInterval:45 target:self selector:@selector(outTimerForScanning) userInfo:nil repeats:NO];
            
            [HIRCBCentralClass shareHIRCBcentralClass].theAddNewNeedToAvoidLastUuid = nil; 
            [[HIRCBCentralClass shareHIRCBcentralClass] scanPeripheral:remoteData.uuid];
        }
    }
}

- (void)outTimerForScanning {
    [self.outTimer invalidate];
    self.outTimer = nil;
    [[HIRCBCentralClass shareHIRCBcentralClass] stopCentralManagerScan];
    NSNotification *notif = [NSNotification notificationWithName:HIR_CBSTATE_CHANGE_NOTIFICATION object:nil userInfo:[NSDictionary dictionaryWithObject:CBCENTERAL_CONNECT_PERIPHERAL_FAIL forKey:@"state"]];
    [self hirCBStateChange:notif];
}

- (void)hirCBStateChange:(NSNotification *)notif {
    [self.outTimer invalidate];
    self.outTimer = nil;
   
    [self.changeIndicator stopAnimating];
    [[HIRCBCentralClass shareHIRCBcentralClass] stopCentralManagerScan];
    NSDictionary *info = notif.userInfo;
    NSString *state = [info valueForKey:@"state"];
    if ([state isEqualToString:CBCENTERAL_STATE_NOT_SUPPORT] || [state isEqualToString:CBCENTERAL_CONNECT_PERIPHERAL_FAIL]) {
        ////蓝牙不支持或关闭或者链接失败
        if ([self.deviceShowArray count] > [HirUserInfo shareUserInfo].currentPeripheraIndex) {
            HIRDeviceShowView *device = [self.deviceShowArray objectAtIndex:[HirUserInfo shareUserInfo].currentPeripheraIndex];
            device.deviceLocationLabel.text = NSLocalizedString(@"isNotConnected", @"");
        }
        
        [SGInfoAlert showInfo:NSLocalizedString(@"deviceConnectionFailed", @"")];
        //[SGInfoAlert showInfo:NSLocalizedString(@"deviceConnectionFailed", @"") bgColor:[UIColor darkGrayColor].CGColor inView:[UIApplication sharedApplication].delegate.window vertical:.8];
        
    }else if ([state isEqualToString:CBCENTERAL_CONNECT_PERIPHERAL_SUCCESS]) {
        ////蓝牙链接外设成功
        if ([self.deviceInfoArray count] > [HirUserInfo shareUserInfo].currentPeripheraIndex && [self.deviceShowArray count] > [HirUserInfo shareUserInfo].currentPeripheraIndex) {
            DBPeripheral *remoteData = [self.deviceInfoArray objectAtIndex:[HirUserInfo shareUserInfo].currentPeripheraIndex];
            HIRDeviceShowView *device = [self.deviceShowArray objectAtIndex:[HirUserInfo shareUserInfo].currentPeripheraIndex];
            DBPeripheralLocationInfo *locationInfo = [HirDataManageCenter findLastLocationByPeriperaUUID:remoteData.uuid];
            NSString *discoverUuid = [[HIRCBCentralClass shareHIRCBcentralClass].discoveredPeripheral.identifier UUIDString];
            if ([discoverUuid isEqualToString:remoteData.uuid]) {
                if ([remoteData.remarkName length] > 0) {
                    device.deviceNameLabel.text = remoteData.remarkName;
                }else {
                    device.deviceNameLabel.text = remoteData.name;
                }
                device.deviceLocationLabel.text = locationInfo.address;
                device.batteryPercent.percent = [HIRCBCentralClass shareHIRCBcentralClass].batteryLevel;
            }
        }
    }
}
/////


/////for table view
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
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
        label2.font = [UIFont systemFontOfSize:12];
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
    
    for (UIView *tempV in [cell.contentView subviews]) {
        if ([tempV isKindOfClass:[UISwitch class]]) {
            [(UISwitch *)tempV setOn:[[self.switchStatus objectAtIndex:[indexPath row]] boolValue] animated:NO];
        }
    }

    NSString *title = @"";
    NSString *info = @"";
//    if ([indexPath row] == 0) {
//        title = @"edit10";
//        info = @"edit11";
//    }else
    if ([indexPath row] == 0) {
        title = @"edit30";
        info = @"edit31";
    }else if ([indexPath row] == 1) {
        title = @"edit40";
        info = @"edit41";
    }
    else if ([indexPath row] == 2){
        title = @"playSounds";
        info = @"";
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
    HirRootSetSwith tag = theSw.tag;
    
    [self.switchStatus replaceObjectAtIndex:tag withObject:[NSNumber numberWithBool:theSw.on]];
    [self.mainMenuTableView reloadData];
    
    ///设置是否响铃
    if (theSw.tag == 2) {
        if (theSw.on) {
            uint8_t val = 1;
            NSData* data = [NSData dataWithBytes:(void*)&val length:sizeof(val)];
            [[HIRCBCentralClass shareHIRCBcentralClass].discoveredPeripheral writeValue:data forCharacteristic:[HIRCBCentralClass shareHIRCBcentralClass].alertLossCharacter type:CBCharacteristicWriteWithResponse];
        }else {
            uint8_t val = 0;
            NSData* data = [NSData dataWithBytes:(void*)&val length:sizeof(val)];
            [[HIRCBCentralClass shareHIRCBcentralClass].discoveredPeripheral writeValue:data forCharacteristic:[HIRCBCentralClass shareHIRCBcentralClass].alertLossCharacter type:CBCharacteristicWriteWithResponse];
        }
    }
    
    [HirUserInfo shareUserInfo].isNotificationMyWhenDeviceNoWithin = [[self.switchStatus objectAtIndex:HirRootSetSwith_Notification]boolValue];
    [HirUserInfo shareUserInfo].isNotificationForVoiceMemo = [[self.switchStatus objectAtIndex:HirRootSetSwith_VoiceMemo]boolValue];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.switchStatus forKey:@"theHiremoteSettingStatus"];
    [userDefaults synchronize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    NSLog(@"rooot view dealloc:%@",[NSThread currentThread]);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.outTimer invalidate];
    self.outTimer = nil;
    
    self.switchStatus = nil;
    self.showDeviceScrollView = nil;
    self.changeIndicator = nil;
    self.preButton = nil;
    self.nextButton = nil;
    self.pageControl = nil;
    self.segControl = nil;
    self.mainMenuScrollView = nil;
    self.mainMenuTableView = nil;
    self.deviceShowArray = nil;
    self.deviceInfoArray = nil;
    NSLog(@"rooott ddddalloc222");
}

@end
