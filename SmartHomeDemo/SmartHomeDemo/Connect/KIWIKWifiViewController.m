//
//  KIWIKWifiViewController.m
//  SmartHomeDemo
//
//  Created by Levy Xu on 2018/6/20.
//  Copyright © 2018年 Levy Xu. All rights reserved.
//

#import "KIWIKWifiViewController.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import "KIWIKSSID.h"
#import "WifiTextField.h"
#import "KIWIKHotspotViewController.h"
#import "KIWIKAddKit.h"
#import "Reachability.h"

@interface KIWIKWifiViewController ()
@property (nonatomic, strong) Reachability *reachability;
@property (nonatomic, strong) WifiTextField *textSsid;
@property (nonatomic, strong) WifiTextField *textKey;
@end

@implementation KIWIKWifiViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.reachability = [Reachability reachabilityForLocalWiFi];
        [self.reachability startNotifier];
        [NNCDC addObserver:self selector:@selector(checkWifi) name:kReachabilityChangedNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [self.reachability stopNotifier];
    [NNCDC removeObserver:self];
}

-(BOOL)checkWifi {
    NSString *ssid = [KIWIKUtils getSSID];
    if (ssid){
        self.textSsid.text = ssid;
        self.textKey.text = [GKIWIKSSID getKeyBySsid:ssid];
        return YES;
    } else {
        self.textSsid.text = @"";
        self.textKey.text = @"";
        return NO;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (![self checkWifi]) {
        [[KIWIKUtils alertWithTitle:@"请连接Wi-Fi" msg:@"暂不支持5G频段的热点，请使用2.4G频段的热点" ok:^(FRAlertController *al) {
            [KIWIKUtils go2Wifi];
        }] show];
    }
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.titleLabel.text = NSLocalizedString(@"ConnectWifi", nil);
    
    self.tishiLabel.text = NSLocalizedString(@"WifiTips", nil);
    [self.tishiLabel kw_fitSize];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(30, self.tishiLabel.bottom + 30, SCREEN_WIDTH - 60, 81)];
    bgView.layer.cornerRadius = 5.0f;
    bgView.layer.borderColor = [UIColor whiteColor].CGColor;
    bgView.layer.borderWidth = 1.0f;
    [self.view addSubview:bgView];
    
    self.textSsid = [[WifiTextField alloc]initWithFrame:CGRectMake(0, 0, bgView.width, 40)];
    self.textSsid.fieldType = WifiTextFieldTypeWifi;
    [bgView addSubview:self.textSsid];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 40, bgView.width, 1)];
    line.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:line];
    
    self.textKey = [[WifiTextField alloc]initWithFrame:CGRectMake(0, 41, bgView.width, 40)];
    self.textKey.fieldType = WifiTextFieldTypePassword;
    [bgView addSubview:self.textKey];
    
    UILabel *bandLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, bgView.bottom + 5, SCREEN_WIDTH - 20, 20)];
    bandLabel.textAlignment = NSTextAlignmentCenter;
    bandLabel.textColor = [UIColor whiteColor];
    bandLabel.font = [UIFont systemFontOfSize:14];
    bandLabel.adjustsFontSizeToFitWidth = YES;
    bandLabel.text = NSLocalizedString(@"WiFiBandTips", nil);
    [self.view addSubview:bandLabel];
}

-(void)nextAction:(id)sender {
    [self.view endEditing:YES];
    
    NSString *ssid = self.textSsid.text;
    NSString *key = self.textKey.text;
    
    if (ssid.length == 0) {
        [[KIWIKUtils alertWithTitle:@"请连接Wi-Fi" msg:@"暂不支持5G频段的热点，请使用2.4G频段的热点" ok:^(FRAlertController *al) {
            [KIWIKUtils go2Wifi];
        }] show];
        return;
    }
    
    if ([[ssid uppercaseString] rangeOfString:@"5G"].length > 0) {
        [[KIWIKUtils alertWithTitle:@"检测到你可能连接了5G的热点" msg:@"暂不支持5G频段的热点，请使用2.4G频段的热点" ok:^(FRAlertController *al) {
            [KIWIKUtils go2Wifi];
        }] show];
        return;
    }
    
    NSData *ssidData = [ssid dataUsingEncoding:NSUTF8StringEncoding];
    if (ssidData.length > 32) {
        [[KIWIKUtils alertWithTitle:@"WiFi名字过长" msg:@"请更改Wi-Fi名字在英文32个字符，中文10个字符以内" ok:^(FRAlertController *al) {
            [KIWIKUtils go2Wifi];
        }] show];
        return;
    }
    
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    if (keyData.length > 64) {
        [[KIWIKUtils alertWithTitle:@"WiFi密码过长" msg:@"请缩短Wi-Fi密码在64个字符以内" ok:^(FRAlertController *al) {
            [KIWIKUtils go2Wifi];
        }] show];
        return;
    }
    
    NSLog(@"%s ssid length %lu key length %lu", __func__, (unsigned long)ssidData.length, (unsigned long)keyData.length);
    
    GKIWIKAddKit.key = key;
    GKIWIKAddKit.ssid = ssid;
    
    [GKIWIKSSID saveSsid:ssid andKey:key];
    
    KIWIKHotspotViewController *addwifi = [[KIWIKHotspotViewController alloc] init];
    [self.navigationController pushViewController:addwifi animated:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.textSsid resignFirstResponder];
    [self.textKey resignFirstResponder];
}
@end
