//
//  AppDelegate.m
//  HiRemote
//
//  Created by parker on 6/25/15.
//  Copyright (c) 2015 hiremote. All rights reserved.
//

#import "AppDelegate.h"
#import "HIRWelcomeViewController.h"
#import "HIRRegisterViewController.h"
#import "HIRScanningViewController.h"

//#import "HIRRemoteData.h"
#import "SoundTool.h"
#import "WXApi.h"
#import "WeiboSDK.h"
#import "HirDataManageCenter+Perphera.h"

@interface AppDelegate () <HIRWelcomeViewControllerDelegate,WXApiDelegate,WeiboSDKDelegate>{
    
    
}
@property(nonatomic, assign)UIBackgroundTaskIdentifier bgTask;
@property(nonatomic, assign)BOOL isBackground;
@property(nonatomic) HIRWelcomeViewController *welcomeVC;
@property(nonatomic) HIRRegisterViewController *registerVC;
@property(nonatomic) HIRScanningViewController *scanVC;


@property (nonatomic, strong)NSTimer *myTimer;
@end

@implementation AppDelegate
@synthesize window;
@synthesize welcomeVC;
@synthesize registerVC;
@synthesize scanVC;
@synthesize rootVC;
@synthesize locManger;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"111111");
    _isBackground = NO;
    self.locManger = [[HPCoreLocationManger alloc] init];

    
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *lastVersion = [userDefault valueForKey:@"lastVersion"];
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    if (!lastVersion || ![lastVersion isEqualToString:currentVersion]) {
        if (currentVersion) {
            [userDefault setObject:currentVersion forKey:@"lastVersion"];
        }
        self.welcomeVC = [[HIRWelcomeViewController alloc] initWithNibName:nil bundle:nil];
        self.welcomeVC.delegate = self;
        
        [self.window addSubview:self.welcomeVC.view];
    }else {
        self.scanVC = [[HIRScanningViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.scanVC];
        //self.registerVC = [[HIRRegisterViewController alloc] init];
       // UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.registerVC];
        nav.navigationBar.tintColor = [UIColor colorWithRed:0.27 green:0.74 blue:0.55 alpha:1];
        nav.navigationBar.hidden = YES;
        nav.navigationBar.barTintColor = [UIColor colorWithRed:0.27 green:0.74 blue:0.55 alpha:1];
        self.window.rootViewController = nav;
    }
    
    [self.window makeKeyAndVisible];
    
    //注册微信API
    //  [WXApi registerApp:@"WXAPI_APPID"];
    
    //注册微博API
    //  [WeiboSDK registerApp:@"WeiboAppId"];
    
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"MyDatabase.sqlite"];

    [HirUserInfo shareUserInfo].deviceInfoArray = [HirDataManageCenter findAllPerphera];
    
    

    return YES;
}

-(void)locationNotification{
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    if (localNotification == nil) {
        return;
    }
//    //设置本地通知的触发时间（如果要立即触发，无需设置），这里设置为20妙后
//    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:20];
    //设置本地通知的时区
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    //设置通知的内容
    localNotification.alertBody = @"Your HiSmart bag is 90 feet away from you!";
    //设置通知动作按钮的标题
    localNotification.alertAction = @"Alert";
    //设置提醒的声音，可以自己添加声音文件，这里设置为默认提示声
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    
    //立即触发一个通知
    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];

}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    NSLog(@"Application did receive local notifications");
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hello" message:@"welcome" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

static int aa = 0;
- (void)applicationDidEnterBackground:(UIApplication *)application {
//    [HIRRemoteData saveHiRemoteData:self.deviceInfoArray];
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    
    ////以下代码用来处理后台运行
    _isBackground = YES;
    _bgTask = [application beginBackgroundTaskWithExpirationHandler: ^{
        // 如果超时这个block将被调用
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_bgTask != UIBackgroundTaskInvalid) {
                [application endBackgroundTask:_bgTask];
                _bgTask = UIBackgroundTaskInvalid;
            }
        });
    }];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while(_isBackground)
        {
            [NSThread sleepForTimeInterval:5];
            ////do something you want
            NSLog(@"backgroud do%d",aa++);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_bgTask != UIBackgroundTaskInvalid) {
                [application endBackgroundTask:_bgTask];
                _bgTask = UIBackgroundTaskInvalid;
            }
        });
    });
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self locationNotification];
    });
    
    //<<<<<<< Updated upstream
    //////
    //=======
    //
    //}
    ////
    //-(void)task{
    ////    sleep(1);
    //    NSLog(@"counter:%ld", counter++);
    ////    NSLog(@"backgroundTimeRemaining = %   f",[[UIApplication sharedApplication] backgroundTimeRemaining]);
    //>>>>>>> Stashed changes
}




- (void)applicationWillEnterForeground:(UIApplication *)application {
    ///进入前台，停止后台处理
    _isBackground = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_bgTask != UIBackgroundTaskInvalid) {
            [application endBackgroundTask:_bgTask];
            _bgTask = UIBackgroundTaskInvalid;
        }
    });
    /////
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [MagicalRecord cleanUp];
    
    //取消所有的本地通知
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

- (void)welcomViewControllerNeedDisapear {
    [[self.window subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.welcomeVC = nil;
    
    self.scanVC = [[HIRScanningViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.scanVC];
    
   // self.registerVC = [[HIRRegisterViewController alloc] init];
   // UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.registerVC];
    nav.navigationBar.hidden = YES;
    nav.navigationBar.tintColor = [UIColor colorWithRed:0.27 green:0.74 blue:0.55 alpha:1];
    nav.navigationBar.barTintColor = [UIColor colorWithRed:0.27 green:0.74 blue:0.55 alpha:1];
    self.window.rootViewController = nav;
}


- (void)connectSuccessToShowRootVC {
    [[self.window subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.rootVC = [[HIRRootViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self.rootVC];
    self.window.rootViewController = navigationController;
    
    ////移除老的界面
    [self.scanVC.navigationController popToRootViewControllerAnimated:NO];
    self.scanVC = nil;
    //[self.registerVC.navigationController popToRootViewControllerAnimated:NO];
   // self.registerVC = nil;
}


- (void)addNewDevice {
    [[self.window subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.scanVC = [[HIRScanningViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.scanVC];
    
    //self.registerVC = [[HIRRegisterViewController alloc] init];
    //self.registerVC.isNeedAutoPushScanVC = YES;
    //UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.registerVC];
    nav.navigationBar.tintColor = [UIColor colorWithRed:0.27 green:0.74 blue:0.55 alpha:1];
    nav.navigationBar.hidden = YES;
    nav.navigationBar.barTintColor = [UIColor colorWithRed:0.27 green:0.74 blue:0.55 alpha:1];
    self.window.rootViewController = nav;
    
    [self.rootVC.navigationController popToRootViewControllerAnimated:NO];
    self.rootVC = nil;
}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:self];
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [WXApi handleOpenURL:url delegate:self];
}

-(void)onReq:(BaseReq *)req
{
}

-(void)onResp:(BaseResp *)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        if(resp.errCode == WXSuccess)
        {
            //TODO 发送生成
        }
        else
        {
            //TODO 发送失败
        }
    }
}

-(void)sendWXMessageToWeChat
{
    SendMessageToWXReq* wxReq = [[SendMessageToWXReq alloc] init];
    wxReq.scene = WXSceneSession;
    wxReq.bText = NO;
    
    WXMediaMessage* message = [[WXMediaMessage alloc] init];
    message.title = @"标题";
    
    NSData* thumbData = [[NSData alloc] init];
    message.thumbData = thumbData;
    
    WXWebpageObject* webpageObject = [[WXWebpageObject alloc] init];
    webpageObject.webpageUrl = @"http://www.baidu.com";
    
    message.mediaObject = webpageObject;
    
    wxReq.message = message;
}

- (void)sendFileToWeChat
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"ML.3gp";
    message.description = @"Pro CoreData";
    [message setThumbImage:[UIImage imageNamed:@"res2.jpg"]];
    
    WXFileObject *ext = [WXFileObject object];
    ext.fileExtension = @"3gp";
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"ML" ofType:@"3gp"];
    ext.fileData = [NSData dataWithContentsOfFile:filePath];
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;
    
    [WXApi sendReq:req];
}

-(void)sendWXMessageToWeChatTimeline
{
    SendMessageToWXReq* wxReq = [[SendMessageToWXReq alloc] init];
    wxReq.scene = WXSceneTimeline;
    wxReq.bText = NO;
    
    WXMediaMessage* message = [[WXMediaMessage alloc] init];
    message.title = @"标题";
    
    NSData* thumbData = [[NSData alloc] init];
    message.thumbData = thumbData;
    WXWebpageObject* webpageObject = [[WXWebpageObject alloc] init];
    webpageObject.webpageUrl = @"http://www.baidu.com";
    
    message.mediaObject = webpageObject;
    
    wxReq.message = message;
}

- (void)sendFileToWeChatTimeLine
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"ML.3gp";
    message.description = @"Pro CoreData";
    [message setThumbImage:[UIImage imageNamed:@"res2.jpg"]];
    
    WXFileObject *ext = [WXFileObject object];
    ext.fileExtension = @"3gp";
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"ML" ofType:@"3gp"];
    ext.fileData = [NSData dataWithContentsOfFile:filePath];
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneTimeline;
    
    [WXApi sendReq:req];
}


-(void)sendMessageToWeibo
{
    WBMessageObject* message = [WBMessageObject message];
    WBWebpageObject* webpage = [[WBWebpageObject alloc] init];
    webpage.title = @"标题";
    
    NSData* thumbnailData = [[NSData alloc] init];
    webpage.thumbnailData = thumbnailData;
    
    webpage.webpageUrl = @"http://www.baidu.com";
    webpage.description = @"这里是description";
    
    message.mediaObject = webpage;
    
    WBSendMessageToWeiboRequest* request = [WBSendMessageToWeiboRequest requestWithMessage:message];
    
    [WeiboSDK sendRequest:request];
}

-(void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
}

-(void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        if(response.statusCode == WeiboSDKResponseStatusCodeSuccess)
        {
            //TODO 分享成功
        }
        else
        {
            //TODO 分享失败
        }
    }
}


@end
