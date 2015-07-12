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
#import "HIRRootViewController.h"
//#import "HIRRemoteData.h"
#import "SoundTool.h"
#import "WXApi.h"
#import "WeiboSDK.h"
#import "HirDataManageCenter+Perphera.h"

@interface AppDelegate () <HIRWelcomeViewControllerDelegate,WXApiDelegate,WeiboSDKDelegate>{
    UIBackgroundTaskIdentifier bgTask;
    
    NSUInteger counter;
}
@property(nonatomic) HIRWelcomeViewController *welcomeVC;
@property(nonatomic) HIRRegisterViewController *registerVC;
@property(nonatomic) HIRScanningViewController *scanVC;
@property(nonatomic) HIRRootViewController *rootVC;

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

    self.locManger = [[HPCoreLocationManger alloc] init];
    [self.locManger startUpdatingUserLocation];
    
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
    
#if DEBUG
    [NSTimer scheduledTimerWithTimeInterval:1.0f
     
                                     target:self
     
                                   selector:@selector(task) userInfo:nil
     
                                    repeats:YES];
#endif
    
    return YES;
}

-(void)task{
    //    sleep(1);
    NSLog(@"counter:%ld", (unsigned long)counter++);
    NSLog(@"backgroundTimeRemaining = %f",[[UIApplication sharedApplication] backgroundTimeRemaining]);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
//    [HIRRemoteData saveHiRemoteData:self.deviceInfoArray];
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    
    [HirUserInfo shareUserInfo].appIsEnterBackgroud = YES;
    
    NSLog(@"%f",CGFLOAT_MAX);
    BOOL backgroundAccepted = [[UIApplication sharedApplication] setKeepAliveTimeout:600 handler:^{ [self backgroundHandler]; }];
    
    if (backgroundAccepted)
        
    {
        
        NSLog(@"backgrounding accepted");
        
    }
    
    [self backgroundHandler];

}

- (void)backgroundHandler {
    
    NSLog(@"### -->backgroundinghandler");
    
    UIApplication* app = [UIApplication sharedApplication];
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        
        [app endBackgroundTask:bgTask];
        
        bgTask = UIBackgroundTaskInvalid;
        
    }];
    
    // Start the long-running task
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([[UIApplication sharedApplication] backgroundTimeRemaining] < 61.0) {
            
            [[SoundTool sharedSoundTool]playSound:kBirdSound];
            bgTask = [app beginBackgroundTaskWithExpirationHandler:nil];
        }
        
        //        while (1) {
        //            [self task];
        //        }
    });
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    [HirUserInfo shareUserInfo].appIsEnterBackgroud = NO;
    
    if (bgTask != UIBackgroundTaskInvalid){
        [[UIApplication sharedApplication] endBackgroundTask:bgTask];
        
        bgTask = UIBackgroundTaskInvalid;
    }

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
