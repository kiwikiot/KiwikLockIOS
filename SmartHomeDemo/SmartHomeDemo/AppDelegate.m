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

#define kAccessToken  @"kiwikAccessToken"
#define kClientId     @"gC62dG7sVdgvgKG2l5ZGydQO7lQIBSeC"  // 这个是测试用的

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
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setMinimumDismissTimeInterval:1.2f];
    [SVProgressHUD setMinimumSize:CGSizeMake(120, 120)];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    KIWIKDevicesViewController *listVC = [[KIWIKDevicesViewController alloc] initWithStyle:UITableViewStyleGrouped];
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:listVC];
    self.window.rootViewController = nav1;
    [self.window makeKeyAndVisible];
    
    //初始化SDK
    GKIWIKSDK.debug = YES;
    GKIWIKSDK.isTest = YES; // 正式版请设为NO
    GKIWIKSDK.clientId = kClientId;
    
    if ([NDSUD objectForKey:kAccessToken]) {
        NSDictionary *dict = [NDSUD objectForKey:kAccessToken];
        NSLog(@"%s oldToken %@",__func__, dict);
        KIWIKToken *token = [KIWIKToken mj_objectWithKeyValues:dict];
        if (token.isValid) {
            [self setToken:token];
        } else {
            [self refreshToken:token];
        }
    } else {
        [self login];
    }
    
    return YES;
}

-(void)setToken:(KIWIKToken *)token {
    __weak __typeof(self)weakSelf = self;
    [GKIWIKSDK setToken:token block:^(BOOL success, NSError *error) {
        if (success) {
            weakSelf.isLogin = YES;
            
            [NDSUD setObject:token.mj_keyValues forKey:kAccessToken];
            
            if (weakSelf.timer) {
                [weakSelf.timer invalidate];
                weakSelf.timer = nil;
            }
            NSTimeInterval interval = token.expires_at - [[NSDate date] timeIntervalSince1970] - 10 * 60;//提前10分钟刷新token
            weakSelf.timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(timeout) userInfo:nil repeats:NO];
            
            [GKIWIKLockService start];
        } else {
            NSLog(@"setToken error %@", error);
        }
    }];
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

-(void)logout {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    [GKIWIKLockService stop];
    [GKIWIKSDK clearToken];
    [NDSUD removeObjectForKey:kAccessToken];
    
    self.isLogin = NO;
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

@end
