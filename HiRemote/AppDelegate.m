//
//  AppDelegate.m
//  HiRemote
//
//  Created by parker on 6/25/15.
//  Copyright (c) 2015 hiremote. All rights reserved.
//

#import "AppDelegate.h"
#import "HIRWelcomeViewController.h"
#import "HirLoginViewController.h"
#import "HIRScanningViewController.h"
#import <AVFoundation/AVFoundation.h>
//#import "HIRRemoteData.h"
#import "SoundTool.h"
#import "WXApi.h"
#import "WeiboSDK.h"
#import "HirDataManageCenter+Perphera.h"
#import "HirMsgPlaySound.h"
#import "MobClick.h"
#import "HIRHttpRequest.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "EHAudioController.h"

@interface AppDelegate () <HIRWelcomeViewControllerDelegate,WXApiDelegate,WeiboSDKDelegate,AVAudioPlayerDelegate,UIAlertViewDelegate,EHAudioControllerDelegate>{
    UIBackgroundTaskIdentifier bgTask;
    
    NSUInteger counter;
    SystemSoundID _sound;
    
    NSString *updateAppUrl;
}
@property(nonatomic) HIRWelcomeViewController *welcomeVC;
@property(nonatomic) HirLoginViewController *loginViewController;
@property(nonatomic) HIRScanningViewController *scanVC;
@property(nonatomic, strong)NSString *versionPath;
@property(nonatomic, strong)AVAudioPlayer *audioPlayer;
@property(nonatomic, strong)UIAlertView *phoneSoundAlert;

@property (nonatomic, strong)NSTimer *myTimer;

@property(nonatomic, strong) NSString *updateAppUrl;
@property(nonatomic, strong) NSString *updateDes;

@end

@implementation AppDelegate

+ (void)initialize
{
    // Nib files require the type to have been loaded before they can do the wireup successfully.
    // http://stackoverflow.com/questions/1725881/unknown-class-myclass-in-interface-builder-file-error-at-runtime
    [FBSDKLoginButton class];
    [FBSDKProfilePictureView class];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.locManger = [[HPCoreLocationManger alloc] init];
    _updateStatus = 0;
    
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
        nav.navigationBar.tintColor = [UIColor colorWithRed:0.27 green:0.74 blue:0.55 alpha:1];
        nav.navigationBar.hidden = YES;
        nav.navigationBar.barTintColor = [UIColor colorWithRed:0.27 green:0.74 blue:0.55 alpha:1];
        self.window.rootViewController = nav;
        
        
//        self.loginViewController = [[HirLoginViewController alloc] init];
//        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:_loginViewController];
//        self.window.rootViewController = nav;
    }
    
    [self.window makeKeyAndVisible];
    
    //注册微信API
    //  [WXApi registerApp:@"WXAPI_APPID"];
    
    //注册微博API
    //  [WeiboSDK registerApp:@"WeiboAppId"];
    
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"MyDatabase.sqlite"];
    
    [HirUserInfo shareUserInfo].deviceInfoArray = [HirDataManageCenter findAllPerphera];
    
    [MobClick setEncryptEnabled:YES];
    [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:BATCH   channelId:@""];
    
    ///检测是否有新版本
    
    [self performSelector:@selector(checkTheNewApp) withObject:nil afterDelay:2];
   // [self checkTheNewApp];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(needIphoneAlertNotify:) name:NEED_IPHONE_ALERT_NOTIFICATION object:nil];
    
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];

    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];
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

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    [HirUserInfo shareUserInfo].appIsEnterBackgroud = NO;
    
    
    if (_isPhoneAlertPlaying) {
       
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSDKAppEvents activateApp];
    
    // Do the following if you use Mobile App Engagement Ads to get the deferred
    // app link after your app is installed.
    [FBSDKAppLinkUtility fetchDeferredAppLink:^(NSURL *url, NSError *error) {
        if (error) {
            NSLog(@"Received error while fetching deferred app link %@", error);
        }
        if (url) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }];


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
//    return [WXApi handleOpenURL:url delegate:self];
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation
            ];
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



    
- (void)needUpdateAppForce {
    if ([self.updateDes length] == 0) {
        self.updateDes = NSLocalizedString(@"updateForce", @"");
    }
    UIAlertView *updateAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"tips", @"") message:self.updateDes delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"ok", @""), nil];
    updateAlert.tag = 3;
    [updateAlert show];
}

#pragma mark uialertView delegater
-(void)needIphoneAlertNotify:(NSNotification *)notification{
    [self playPhoneAlertAudio];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (alertView.tag == 1) {
        if (buttonIndex == 0) {
            [self stopPhoneAlertAudio];
        }
    }else if(alertView.tag == 2) {///需要更新
        if (buttonIndex == 0) {
            NSString *downUrl = [NSString stringWithFormat:@"itms-services://?action=download-manifest&url=%@",self.updateAppUrl];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:downUrl]];
        }
    }else if (alertView.tag == 3) { ///强制更新
        NSString *downUrl = [NSString stringWithFormat:@"itms-services://?action=download-manifest&url=%@",self.updateAppUrl];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:downUrl]];
    }else if (alertView.tag == 4) { ///失效
        [UIView animateWithDuration:.4f animations:^{
            _window.alpha = 0;
            _window.frame = CGRectMake(0, _window.bounds.size.width, 0, 0);
        } completion:^(BOOL finished) {
            exit(0);
        }];
    }
}


static bool _isPhoneAlertPlaying;

-(void)playPhoneAlertAudio{
    if (_isPhoneAlertPlaying) {
        return;
    }

//    NSURL *url = [[NSBundle mainBundle]URLForResource:@"fkjb" withExtension:@"mp3"];
//    
//    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url,&_sound);
//    AudioServicesPlaySystemSound(_sound);
//    AudioServicesAddSystemSoundCompletion (_sound, NULL, NULL,
//                                           completionCallback,
//                                           NULL);
//
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];

    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSURL *url = [[NSBundle mainBundle]URLForResource:@"fkjb" withExtension:@"mp3"];
    EHAudioController * playAudio = [EHAudioController shareAudioController];
    playAudio.delegate = self;
    [playAudio audioPlayFire:[url absoluteString] duration:nil];
    _isPhoneAlertPlaying = YES;
    NSError *erro;
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];

    [session setActive:YES error:&erro];
    if(!self.phoneSoundAlert.visible){
        self.phoneSoundAlert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"tips", @"") message:NSLocalizedString(@"deviceCallIphone", @"") delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"ok", @""),nil];
        self.phoneSoundAlert.tag = 1;
        
        [self.phoneSoundAlert show];
    }
    NSLog(@"playing");
}

- (void)audioPlayFinish:(NSString *)destinationFilePath;
{
    _isPhoneAlertPlaying = NO;
}

void completionCallback (SystemSoundID  mySSID, void* data) {
    NSLog(@"completion Callback");
    AudioServicesRemoveSystemSoundCompletion (mySSID);
    _isPhoneAlertPlaying = NO;
    //the below line is not working
    //label.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
}


-(void) stopPhoneAlertAudio
{
    _isPhoneAlertPlaying = NO;
    
//    AudioServicesDisposeSystemSoundID(_sound);
    EHAudioController * playAudio = [EHAudioController shareAudioController];
    [playAudio audioStopPlay];
    NSLog(@"stopPlaying");
//    [self.audioPlayer stop];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag;
{
    _isPhoneAlertPlaying = NO;
}


- (void)checkTheNewApp {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://app.lepow.net:8080/lepow/api/apps"]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:60.0];
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"ios",@"system", nil];
    NSString *bunldeId = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    if ([bunldeId length] > 0) {
        [paraDic setObject:bunldeId forKey:@"appId"];
    }
    if ([appVersion length] > 0) {
        [paraDic setObject:appVersion forKey:@"appVersion"];
    }

    NSString *currentLanguage = nil;
    NSArray *languages = [NSLocale preferredLanguages];
    if ([languages count] > 0) {
        currentLanguage = [languages objectAtIndex:0];
    }else {
        currentLanguage = @"en";
    }
    [request addValue:currentLanguage forHTTPHeaderField:@"Accept-Language"];
    [request setHTTPMethod:@"POST"];

    NSMutableString *dataStr = [NSMutableString string];
    NSArray *keys = [paraDic allKeys];
    for (int i = 0; i< [keys count]; i++) {
        NSString *key = [keys objectAtIndex:i];
        [dataStr appendFormat:@"%@=%@",key,[paraDic valueForKey:key]];
        if (i+1 < [keys count]) {
            [dataStr appendString:@"&"];
        }
    }
    
    [request setHTTPBody:[dataStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [HIRHttpRequest sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!connectionError) {
            
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            if ([result count] > 0) {
                long code = [[result valueForKey:@"code"] integerValue];
                if (code == 0) {//成功
                    NSDictionary *infoDic = [result valueForKey:@"data"];
                    if (infoDic) {
                        NSLog(@"sosododododooddooddo:%@",infoDic);
                        long status = [[infoDic valueForKey:@"status"] integerValue];
                        _updateStatus = status;
                        NSString *des = [infoDic valueForKey:@"description"];
                        self.updateDes = des;
                        self.updateAppUrl = [infoDic valueForKey:@"plistUrl"];
                        if (status == 2) { //有效需要升级
                            UIAlertView *updateAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"tips", @"") message:des delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"ok", @""),NSLocalizedString(@"cancel", @""), nil];
                            updateAlert.tag = 2;
                            [updateAlert show];
                        }else if (status == 3){//失效需要强制升级
                            UIAlertView *updateAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"tips", @"") message:des delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"ok", @""), nil];
                            updateAlert.tag = 3;
                            [updateAlert show];
                        }else if (status == 4) {//失效了，不能用了
                            UIAlertView *updateAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"tips", @"") message:des delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"ok", @""), nil];
                            updateAlert.tag = 4;
                            [updateAlert show];
                        }
                    }
                }else {
                   
                }
            }
        }
    }];
}


@end
