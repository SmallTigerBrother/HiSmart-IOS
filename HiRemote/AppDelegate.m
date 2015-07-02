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
#import "HPCoreLocationManger.h"
#import "SoundTool.h"

@interface AppDelegate () <HIRWelcomeViewControllerDelegate>{

    
}
@property(nonatomic, assign)UIBackgroundTaskIdentifier bgTask;
@property(nonatomic, assign)BOOL isBackground;
@property(nonatomic) HIRWelcomeViewController *welcomeVC;
@property(nonatomic) HIRRegisterViewController *registerVC;
@property(nonatomic) HIRScanningViewController *scanVC;
@property(nonatomic) HIRRootViewController *rootVC;
@property(nonatomic) HPCoreLocationManger *locManger;

@property (nonatomic, strong)NSTimer *myTimer;
@end

@implementation AppDelegate
@synthesize window;
@synthesize welcomeVC;
@synthesize registerVC;
@synthesize scanVC;
@synthesize rootVC;
@synthesize locManger;
@synthesize deviceInfoArray;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _isBackground = NO;
    self.deviceInfoArray = [NSMutableArray arrayWithCapacity:5];
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
        self.registerVC = [[HIRRegisterViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.registerVC];
        nav.navigationBar.tintColor = [UIColor colorWithRed:0.27 green:0.74 blue:0.55 alpha:1];
        nav.navigationBar.hidden = YES;
        nav.navigationBar.barTintColor = [UIColor colorWithRed:0.27 green:0.74 blue:0.55 alpha:1];
        self.window.rootViewController = nav;
    }
    
    [self.window makeKeyAndVisible];
    

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

static int aa = 0;
- (void)applicationDidEnterBackground:(UIApplication *)application {
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
}

- (void)welcomViewControllerNeedDisapear {
    [[self.window subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.welcomeVC = nil;
    
    self.registerVC = [[HIRRegisterViewController alloc] init];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.registerVC];
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
    [self.registerVC.navigationController popToRootViewControllerAnimated:NO];
    self.registerVC = nil;
}


- (void)addNewDevice {
    [[self.window subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.registerVC = [[HIRRegisterViewController alloc] init];
    self.registerVC.isNeedAutoPushScanVC = YES;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.registerVC];
    nav.navigationBar.tintColor = [UIColor colorWithRed:0.27 green:0.74 blue:0.55 alpha:1];
    nav.navigationBar.hidden = YES;
    nav.navigationBar.barTintColor = [UIColor colorWithRed:0.27 green:0.74 blue:0.55 alpha:1];
    self.window.rootViewController = nav;
    
    [self.rootVC.navigationController popToRootViewControllerAnimated:NO];
    self.rootVC = nil;
}

@end
