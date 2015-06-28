//
//  AppDelegate.m
//  HiRemote
//
//  Created by parker on 6/25/15.
//  Copyright (c) 2015 hiremote. All rights reserved.
//

#import "AppDelegate.h"
#import "HIRWelcomeViewController.h"
#import "HIRScanningViewController.h"
#import "HIRRootViewController.h"
#import "HPCoreLocationManger.h"

@interface AppDelegate () <HIRWelcomeViewControllerDelegate,HIRScanningViewControllerDelegate>
@property(nonatomic) HIRWelcomeViewController *welcomeVC;
@property(nonatomic) HIRScanningViewController *scanVC;
@property(nonatomic) HIRRootViewController *rootVC;
@property(nonatomic) HPCoreLocationManger *locManger;
@end

@implementation AppDelegate
@synthesize window;
@synthesize welcomeVC;
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
        self.scanVC.delegate = self;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.scanVC];
        nav.navigationBar.tintColor = [UIColor colorWithRed:0.43 green:0.74 blue:0.55 alpha:1];
        nav.navigationBar.barTintColor = [UIColor colorWithRed:0.43 green:0.74 blue:0.55 alpha:1];
        self.window.rootViewController = nav;
    }
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
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
    
    self.scanVC = [[HIRScanningViewController alloc] init];
    self.scanVC.delegate = self;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.scanVC];
    nav.navigationBar.tintColor = [UIColor colorWithRed:0.43 green:0.74 blue:0.55 alpha:1];
    nav.navigationBar.barTintColor = [UIColor colorWithRed:0.43 green:0.74 blue:0.55 alpha:1];
    self.window.rootViewController = nav;
}


- (void)scanningFinishToShowRootVC {
    [[self.window subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.scanVC = nil;
    self.rootVC = [[HIRRootViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self.rootVC];
    self.window.rootViewController = navigationController;
}

@end
