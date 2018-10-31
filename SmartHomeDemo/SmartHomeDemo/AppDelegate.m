//
//  AppDelegate.m
//  SmartHomeDemo
//
//  Created by Levy Xu on 2018/6/14.
//  Copyright © 2018年 Levy Xu. All rights reserved.
//

#import "AppDelegate.h"
#import "KIWIKDevicesViewController.h"
#import "KIWIKLockService.h"
#import "KIWIKSettingsViewController.h"

#define kAccessToken  @"kiwikAccessToken"
#define kClientId     @"igxknDUbISY3XAcBYJT9SIegd31sPu7B"
#define kClientSecret @"your client secret"

@interface AppDelegate ()
@property(nonatomic, strong) NSTimer *timer;
@end

@implementation AppDelegate

- (void)dealloc {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    FTPopOverMenuConfiguration *configuration = [FTPopOverMenuConfiguration defaultConfiguration];
    configuration.backgroundColor = [UIColor whiteColor];
    configuration.textAlignment = NSTextAlignmentCenter;
    configuration.textFont = [UIFont systemFontOfSize:16];
    configuration.textAlignment = NSTextAlignmentCenter;
    configuration.textColor = [UIColor blackColor];
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setMinimumDismissTimeInterval:1.2f];
    [SVProgressHUD setMinimumSize:CGSizeMake(120, 120)];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    KIWIKDevicesViewController *listVC = [[KIWIKDevicesViewController alloc] init];
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:listVC];
    KIWIKSettingsViewController *settingsVC = [[KIWIKSettingsViewController alloc] initWithStyle:UITableViewStyleGrouped];
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:settingsVC];
    UITabBarController *tabVC = [[UITabBarController alloc] init];
    tabVC.viewControllers = @[nav1, nav2];
    UITabBarItem *item0 = [tabVC.tabBar.items objectAtIndex:0];
    [item0 setImage:[UIImage imageNamed:@"icon_settings"]];
    UITabBarItem *item1 = [tabVC.tabBar.items objectAtIndex:1];
    [item1 setImage:[UIImage imageNamed:@"icon_settings"]];
    self.window.rootViewController = tabVC;
    [self.window makeKeyAndVisible];
    
    //初始化SDK
    GKIWIKSDK.debug = YES;
    GKIWIKSDK.clientId = kClientId;
    
    if ([NDSUD objectForKey:kAccessToken]) {
        NSDictionary *dict = [NDSUD objectForKey:kAccessToken];
        KIWIKToken *token = [KIWIKToken mj_objectWithKeyValues:dict];
        if (token.isValid) {
            [self setToken:token];
            
            NSLog(@"%s oldToken %@",__func__, token.mj_keyValues);
        } else {
            [self refreshToken:token];
        }
    } else {
        [self login];
    }
    
    return YES;
}

-(void)setToken:(KIWIKToken *)token {
    GKIWIKSDK.accessToken = token;
    
    [NDSUD setObject:token.mj_keyValues forKey:kAccessToken];
    
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    NSTimeInterval timeInterval = token.expires_at - [[NSDate date] timeIntervalSince1970] - 10 * 60;//提前10分钟刷新token
    _timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(timeout) userInfo:nil repeats:NO];
}

-(void)login {
    __weak __typeof(self)weakSelf = self;
    [GKIWIKSDK openKIWIKLoginPage:^(KIWIKToken *accessToken) {
        if (accessToken) {
            [weakSelf setToken:accessToken];
        } else {
            NSLog(@"登录失败");
        }
    }];
}

-(void)refreshToken:(KIWIKToken *)accessToken  {
    __weak __typeof(self)weakSelf = self;
    [GKIWIKSDK refreshToken:accessToken block:^(KIWIKToken *newToken, NSError *error) {
        NSLog(@"%s newtoken %@ error %@",__func__, newToken.mj_keyValues, error.description);
        if (newToken) {
            [weakSelf setToken:newToken];
        } else {
            [NSThread mainTask:^{
                [weakSelf login];
            }];
        }
    }];
}

-(void)timeout {
    //由于GKIWIKSDK.accessToken已经设置，可以不用再传入token
    [self refreshToken:nil];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    [GKIWIKLockService stop];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [GKIWIKLockService start];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
