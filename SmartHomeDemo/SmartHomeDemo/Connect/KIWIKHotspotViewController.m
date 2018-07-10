//
//  KIWIKHotspotViewController.m
//  SmartHomeDemo
//
//  Created by Levy Xu on 2018/6/20.
//  Copyright © 2018年 Levy Xu. All rights reserved.
//

#import "KIWIKHotspotViewController.h"
#import "KIWIKConnectViewController.h"
#import "MethodButton.h"

@interface KIWIKHotspotViewController ()
@property (nonatomic, strong) UILabel *wifiLabel;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation KIWIKHotspotViewController

-(BOOL)networkStateValid {
    NSString *ssid = [KIWIKUtils getSSID];
    if (ssid && [ssid hasPrefix:@"CloudHome"]) {
        _wifiLabel.text = [NSString stringWithFormat:@"以连接%@", ssid];
        return YES;
    }
    _wifiLabel.text = @"";
    return NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(networkStateValid) userInfo:nil repeats:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [_timer invalidate];
    _timer = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = NSLocalizedString(@"WifiAPLink", nil);
    self.tishiLabel.text = NSLocalizedString(@"tips_wifi_connect", nil);
    [self.tishiLabel kw_fitSize];
    
    MethodButton *step1 = [[MethodButton alloc] initWithFrame:CGRectMake(20, self.tishiLabel.bottom + 20, SCREEN_WIDTH - 40, 90)];
    [step1 setTitle:NSLocalizedString(@"ap_link_step_1", nil) forState:UIControlStateNormal];
    [step1 setImage:nil forState:UIControlStateNormal];
    step1.desc = NSLocalizedString(@"HotspotTips1", nil);
    [self.view addSubview:step1];
    
    MethodButton *step2 = [[MethodButton alloc] initWithFrame:CGRectMake(20, step1.bottom + 20, SCREEN_WIDTH - 40, 110)];
    [step2 setTitle:NSLocalizedString(@"ap_link_step_2", nil) forState:UIControlStateNormal];
    [step2 addTarget:self action:@selector(go2Wifi) forControlEvents:UIControlEventTouchUpInside];
    step2.desc = NSLocalizedString(@"HotspotTips2", nil);
    [self.view addSubview:step2];
    
    _wifiLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, step2.bottom + 10.0f, SCREEN_WIDTH - 40, 20)];
    _wifiLabel.font = [UIFont systemFontOfSize:16];
    _wifiLabel.textColor = [UIColor whiteColor];
    _wifiLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_wifiLabel];
}

-(void)go2Wifi {
    [KIWIKUtils go2Wifi];
}

-(void)nextAction:(id)sender {
    if (![self networkStateValid]) {
        [[KIWIKUtils alertWithTitle:@"请连接设备热点" msg:@"请进入‘设置’-‘Wi-Fi’，连接CloudHome开头的热点" ok:^(FRAlertController *al) {
            [KIWIKUtils go2Wifi];
        }] show];
        return;
    }
    
    KIWIKConnectViewController *addconnect = [[KIWIKConnectViewController alloc] init];
    [self.navigationController pushViewController:addconnect animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
