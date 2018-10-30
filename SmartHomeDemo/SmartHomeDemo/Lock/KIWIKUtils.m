//
//  KIWIKUtils.m
//  SmartHomeDemo
//
//  Created by Levy Xu on 2018/6/14.
//  Copyright © 2018年 Levy Xu. All rights reserved.
//

#import "KIWIKUtils.h"
#import <SystemConfiguration/CaptiveNetwork.h>

@implementation KIWIKUtils

// 正式版会被拒，请避开这个方法
+ (void)go2Wifi {
    NSURL *url = [NSURL URLWithString:@"App-Prefs:root=WIFI"];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

+ (NSString *)getSSID {
    NSArray *myArray = (id)CFBridgingRelease(CNCopySupportedInterfaces());
    if (myArray.count > 0) {
        NSDictionary *info = (id)CFBridgingRelease(CNCopyCurrentNetworkInfo((CFStringRef)([myArray firstObject])));
        if (info[@"SSID"]) {
            return [info valueForKey:@"SSID"];
        }
    }
    return nil;
}

+ (NSArray *)allSubviews:(UIView *)aView {
    NSArray *results = [aView subviews];
    for (UIView *eachView in aView.subviews) {
        NSArray *subviews = [self allSubviews:eachView];
        if (subviews)
            results = [results arrayByAddingObjectsFromArray:subviews];
    }
    return results;
}

+(FRAlertController *)alertWithTitle:(NSString *)title msg:(NSString *)msg ok:(void(^)(FRAlertController *al))ok {
    return [self alertWithTitle:title msg:msg cancel:nil ok:ok];
}

+(FRAlertController *)alertWithTitle:(NSString *)title msg:(NSString *)msg cancel:(void(^)(FRAlertController *al))cancel ok:(void(^)(FRAlertController *al))ok {
    FRAlertController *alert = [FRAlertController alertControllerWithTitle:title message:msg preferredStyle:FRAlertControllerStyleAlert];
    [alert addAction:[FRAlertAction actionWithTitle:@"取消" style:FRAlertActionStyleDefault color:[UIColor redColor] handler:^(FRAlertAction * _Nonnull action) {
        !cancel ?: cancel(alert);
    }]];
    [alert addAction:[FRAlertAction actionWithTitle:@"确定" style:FRAlertActionStyleDefault color:MAIN_THEME_COLOR handler:^(FRAlertAction * _Nonnull action) {
        !ok ?: ok(alert);
    }]];
    return alert;
}
@end
