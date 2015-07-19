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
#import "HirMsgPlaySound.h"
#import "MobClick.h"

@interface AppDelegate () <HIRWelcomeViewControllerDelegate,WXApiDelegate,WeiboSDKDelegate>{
    UIBackgroundTaskIdentifier bgTask;
    
    NSUInteger counter;
}
@property(nonatomic) HIRWelcomeViewController *welcomeVC;
@property(nonatomic) HIRRegisterViewController *registerVC;
@property(nonatomic) HIRScanningViewController *scanVC;
@property(nonatomic, strong)NSString *versionPath;


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
        [HIRCBCentralClass shareHIRCBcentralClass].theAddNewNeedToAvoidLastUuid = nil;
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
    
//#if DEBUG
//    [NSTimer scheduledTimerWithTimeInterval:1.0f
//     
//                                     target:self
//     
//                                   selector:@selector(task) userInfo:nil
//     
//                                    repeats:YES];
//#endif
    [MobClick setEncryptEnabled:YES];
    [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:BATCH   channelId:@""];
    
    return YES;
}


//-(void)OpenUMeng //打开友盟
//{
//    [MobClick setCrashReportEnabled:YES]; // 如果不需要捕捉异常，注释掉此行
//    //    [MobClick setLogEnabled:YES];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
//    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
//    //
//    [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:(ReportPolicy) REALTIME channelId:@"YunFeng"];
//    //   reportPolicy为枚举类型,可以为 REALTIME, BATCH,SENDDAILY,SENDWIFIONLY几种
//    //   channelId 为NSString * 类型，channelId 为nil或@""时,默认会被被当作@"App Store"渠道
//    
//    //    [MobClick checkUpdate];   //自动更新检查, 如果需要自定义更新请使用下面的方法,需要接收一个(NSDictionary *)appInfo的参数
//    [MobClick checkUpdateWithDelegate:self selector:@selector(updateMethod:)];
//    
//    [MobClick updateOnlineConfig];  //在线参数配置
//    
//}
//
//- (void)updateMethod:(NSDictionary *)appInfo {
//    NSLog(@"update info %@",appInfo);
//    if([[appInfo objectForKey:@"update"] isEqualToString:@"YES"]==YES)
//    {
//        NSString *newVersion = [[NSString alloc]initWithString:[appInfo objectForKey:@"version"]];
//        self.versionPath = [[NSString alloc]initWithString:[appInfo objectForKey:@"path"]];
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"有新版本V%@",newVersion] message:[NSString stringWithString:[appInfo objectForKey:@"update_log"]] delegate:self cancelButtonTitle:@"下次再说" otherButtonTitles:@"更新", nil];
//        [alert show];
//    }
//}
//
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if(buttonIndex==1)
//    {
//        NSURL *url = [NSURL URLWithString:@"www.baidu.com"];  [[UIApplication sharedApplication]openURL:url];
//    }
//}

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
//    BOOL backgroundAccepted = [[UIApplication sharedApplication] setKeepAliveTimeout:600 handler:^{ [self backgroundHandler]; }];
//    
//    if (backgroundAccepted)
//        
//    {
//        
//        NSLog(@"backgrounding accepted");
//        
//    }
//    
//    [self backgroundHandler];

//    　　bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
//        　　// 10分钟后执行这里，应该进行一些清理工作，如断开和服务器的连接等
//        　　// ...
//        　　// stopped or ending the task outright.
//        　　[application endBackgroundTask:bgTask];
//        　　bgTask = UIBackgroundTaskInvalid;
//        　　}];
//    　　if (bgTask == UIBackgroundTaskInvalid) {
//        　　NSLog(@"failed to start background task!");
//        　　}
//    　　// Start the long-running task and return immediately.
//    　　dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        　　// Do the work associated with the task, preferably in chunks.
//        　　NSTimeInterval timeRemain = 0;
//        　　do{
//            　　[NSThread sleepForTimeInterval:5];
//            　　if (bgTask!= UIBackgroundTaskInvalid) {
//                　　timeRemain = [application backgroundTimeRemaining];
//                　　NSLog(@"Time remaining: %f",timeRemain);
//                　　}
//            　　}while(bgTask!= UIBackgroundTaskInvalid && timeRemain > 0); // 如果改为timeRemain > 5*60,表示后台运行5分钟
//        　　// done!
//        　　// 如果没到10分钟，也可以主动关闭后台任务，但这需要在主线程中执行，否则会出错
//        　　dispatch_async(dispatch_get_main_queue(), ^{
//            　　if (bgTask != UIBackgroundTaskInvalid)
//                　　{
//                    　　// 和上面10分钟后执行的代码一样
//                    　　// ...
//                    　　// if you don't call endBackgroundTask, the OS will exit your app.
//                    　　[application endBackgroundTask:bgTask];
//                    　　bgTask = UIBackgroundTaskInvalid;
//                    　　}
//            　　});
//        　　});

    
}

//- (void)backgroundHandler {
//    
//    NSLog(@"### -->backgroundinghandler");
//    
//    UIApplication* app = [UIApplication sharedApplication];
//    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
//        
//        [app endBackgroundTask:bgTask];
//        
//        bgTask = UIBackgroundTaskInvalid;
//        
//    }];
//    
//    // Start the long-running task
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        if ([[UIApplication sharedApplication] backgroundTimeRemaining] < 61.0) {
////            HirMsgPlaySound *msgPlaySound = [[HirMsgPlaySound alloc]initSystemSoundWithName:@"sms-received4" SoundType:@"caf"];
////            [msgPlaySound play];
//
//            [[SoundTool sharedSoundTool]playBgMusic];
//            bgTask = [app beginBackgroundTaskWithExpirationHandler:nil];
//        }
//        
//        //        while (1) {
//        //            [self task];
//        //        }
//    });
//    
//}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    [HirUserInfo shareUserInfo].appIsEnterBackgroud = NO;
    
//    if (bgTask != UIBackgroundTaskInvalid){
//        [[UIApplication sharedApplication] endBackgroundTask:bgTask];
//        
//        bgTask = UIBackgroundTaskInvalid;
//    }

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
    [HIRCBCentralClass shareHIRCBcentralClass].theAddNewNeedToAvoidLastUuid = nil;
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
