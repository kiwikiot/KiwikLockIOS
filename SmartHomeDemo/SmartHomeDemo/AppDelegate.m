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
#import <CoreLocation/CoreLocation.h>

#define kClientId     @"gC62dG7sVdgvgKG2l5ZGydQO7lQIBSeC"  // 这个是测试用的

@interface AppDelegate ()<CLLocationManagerDelegate>
@property(nonatomic, strong) CLLocationManager *locationManager;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setMinimumDismissTimeInterval:1.2f];
    [SVProgressHUD setMinimumSize:CGSizeMake(120, 120)];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    KIWIKDevicesViewController *listVC = [[KIWIKDevicesViewController alloc] initWithStyle:UITableViewStyleGrouped];
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:listVC];
    self.window.rootViewController = nav1;
    [self.window makeKeyAndVisible];
    
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    CGFloat version = [phoneVersion floatValue];
    // 如果是iOS13以上获取wifi名字需要开启地理位置权限
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined && version >= 13) {
       self.locationManager = [[CLLocationManager alloc] init];
       [self.locationManager requestWhenInUseAuthorization];
    }
    
    //初始化SDK
    GKIWIKSDK.debug = YES;  // 正式版请设为NO
    GKIWIKSDK.isTest = YES; // 正式版请设为NO
    GKIWIKSDK.clientId = kClientId;
    
    __weak __typeof(self)weakSelf = self;
    [GKIWIKSDK checkLogined:^(BOOL success, NSError *error) {
        if (success) {
            [GKIWIKLockService start];
        } else {
            [weakSelf login];
        }
    }];
    
    return YES;
}

-(void)login {
    __weak __typeof(self)weakSelf = self;
    [GKIWIKSDK openLoginWebPage:^(KIWIKToken *accessToken) {
        if (accessToken) {
            [weakSelf setToken:accessToken];
        } else {
            NSLog(@"登录失败");
        }
    }];
}

-(void)setToken:(KIWIKToken *)token {
    [GKIWIKSDK setToken:token block:^(BOOL success, NSError *error) {
        if (success) {
            [GKIWIKLockService start];
        } else {
            NSLog(@"setToken error %@", error);
        }
    }];
}

-(void)logout {
    [GKIWIKLockService stop];
    [GKIWIKSDK clearToken];
}

@end
