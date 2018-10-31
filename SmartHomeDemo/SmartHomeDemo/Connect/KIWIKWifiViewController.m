//
//  KIWIKWifiViewController.m
//  SmartHomeDemo
//
//  Created by Levy Xu on 2018/6/20.
//  Copyright © 2018年 Levy Xu. All rights reserved.
//

#import "KIWIKWifiViewController.h"
#import "KIWIKSSID.h"
#import "WifiTextField.h"
#import "KIWIKConnectViewController.h"

@interface KIWIKWifiViewController ()
@property (nonatomic, strong) WifiTextField *textSsid;
@property (nonatomic, strong) WifiTextField *textKey;
@end

@implementation KIWIKWifiViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.titleLabel.text = @"请输入Wi-Fi密码";
    
    self.tishiLabel.text = @"隐藏的Wi-Fi请手动输入名字和密码";
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
    
    if (_ssid.length > 0) {
        self.textSsid.text = _ssid;
        self.textKey.text = [GKIWIKSSID getKeyBySsid:_ssid];
    }
}

-(void)nextAction:(id)sender {
    [self.view endEditing:YES];
    
    NSString *ssid = self.textSsid.text;
    NSString *key = self.textKey.text;
    
    if (ssid.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"Wi-Fi名字不能为空"];
        return;
    }
    
    NSData *ssidData = [ssid dataUsingEncoding:NSUTF8StringEncoding];
    if (ssidData.length > 32) {
        [SVProgressHUD showErrorWithStatus:@"WiFi名字过长，请更改Wi-Fi名字在英文32个字符，中文10个字符以内"];
        return;
    }
    
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    if (keyData.length > 64) {
        [SVProgressHUD showErrorWithStatus:@"WiFi密码过长，请缩短Wi-Fi密码在64个字符以内"];
        return;
    }
    
    NSLog(@"%s ssid length %lu key length %lu", __func__, (unsigned long)ssidData.length, (unsigned long)keyData.length);
    
    [GKIWIKSSID saveSsid:ssid andKey:key];
    
    if (![KIWIKUtils getLockAP]) {
        [[KIWIKUtils alertWithTitle:@"请连接设备热点" msg:NSLocalizedString(@"HotspotTips2", nil) ok:^(FRAlertController *al) {
            [KIWIKUtils go2Wifi];
        }] show];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"稍等..."];
    [KIWIKConnect settingWifi:ssid pwd:key block:^(KIWIKDevice_Add * _Nonnull dev, NSError * _Nonnull error) {
        NSLog(@"%s %@ %@", __func__, dev, error);
        if (dev) {
            [SVProgressHUD dismiss];
            
            [NSThread mainTask:^{
                KIWIKConnectViewController *conVC = [[KIWIKConnectViewController alloc] initWithDevice:dev];
                [self.navigationController pushViewController:conVC animated:YES];
            }];
        } else {
            [SVProgressHUD showErrorWithStatus:@"Error"];
        }
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.textSsid resignFirstResponder];
    [self.textKey resignFirstResponder];
}
@end
