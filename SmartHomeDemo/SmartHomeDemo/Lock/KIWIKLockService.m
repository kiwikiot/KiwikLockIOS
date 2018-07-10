//
//  KIWIKLockService.m
//  KIWIKSDKDemo
//
//  Created by Levy Xu on 2018/6/22.
//  Copyright © 2018年 Levy Xu. All rights reserved.
//

#import "KIWIKLockService.h"
#import "KIWIKPasswordView.h"
#import "KIWIKUtils.h"
#import "KIWIKEvent+UI.h"

@interface KIWIKLockService()
@property(nonatomic, strong) KIWIKDevice *selectedDevice;
@property(nonatomic, strong) FRAlertController *alert;
@property(nonatomic, strong) KIWIKPasswordView *passwordView;
@end

@implementation KIWIKLockService

SingletonM(KIWIKLockService,)

-(void)start {
    [NNCDC addObserver:self selector:@selector(messageReceived:) name:kSocketMessageReceivedNotification object:nil];
}

- (void)stop {
    [NNCDC removeObserver:self];
}

-(void)messageReceived:(NSNotification *)notification {
    NSDictionary *msg = [notification object];
    NSLog(@"msg %@", msg);
    NSString *name = [msg objectForKey:@"name"];
    if ([name isEqualToString:KIWIKCtrlResponse]) {
        NSDictionary *payload = [msg objectForKey:@"payload"];
        NSString *did = [payload objectForKey:@"did"];
        KIWIKDevice *device = nil;
        for (KIWIKDevice *dev in GKIWIKSocket.deviceList) {
            NSLog(@"dev %@", dev.did);
            if ([dev.did isEqualToString:did]) {
                device = dev;
                break;
            }
        }
        if (!device) {
            NSLog(@"%@ is not exist", did);
            return;
        }
        NSString *data = [payload objectForKey:@"data"];
        KIWIKEvent *event = [[KIWIKEvent alloc] initWithString:data];
        NSLog(@"event %@", event.mj_keyValues);
        __weak __typeof(self)weakSelf = self;
        if (event.cmd == DoorLockCmdNotification && event.type == DoorLockTypeDoorLock) {
            if (event.status == DoorLockStatusRemoteUnlock) {//远程请求开锁
                if (_alert || [KIWIKPasswordView isShown] || ![event remoteRequestValid]) {
                    [self makeToast:event device:device];
                    return;
                }
                NSString *devName = device.name ? device.name : [NSString stringWithFormat:@"Lock%@", device.did];
                NSString *title = [NSString stringWithFormat:@"%@-%@", devName, [event title]];
                _alert = [KIWIKUtils alertWithTitle:title msg:@"请确认安全后输入密码进行开锁"cancel:^(FRAlertController *al) {
                    weakSelf.alert = nil;
                } ok:^(FRAlertController *al){
                    weakSelf.alert = nil;
                    [weakSelf unlock:device];
                }];
                [_alert show];
            } else if (event.status == DoorLockStatusUnlocked) {//开锁成功
                if ([KIWIKPasswordView isShown] && _selectedDevice == device) {
                    [_passwordView stopUnlock:^{
                        [SVProgressHUD showSuccessWithStatus:@"开锁成功"];
                        weakSelf.selectedDevice = nil;
                    }];
                } else {
                    [self makeToast:event device:device];
                }
            } else {
                [self makeToast:event device:device];
            }
        } else {
            NSLog(@"message ignored %@", msg);
        }
    }
}

-(void)unlock:(KIWIKDevice *)device {
    _selectedDevice = device;
    _passwordView = [KIWIKPasswordView showWithTimes:PasswordOnce pwdBlock:^(KIWIKPasswordView *pwdView, NSString *password) {
        [pwdView waitingWith:@"稍等..."];
        [device unlock:password state:YES block:^(id response, NSError *error) {
            if (!error) {
                [pwdView startUnlock];
            } else {
                [pwdView showErrorWith:@"开锁失败"];
            }
        }];
    }];
}

-(NSString *)userName:(KIWIKEvent *)event device:(KIWIKDevice *)device {
    NSString *userName = [@(event.userNo) stringValue];
    if ([GKIWIKSocket.userDict objectForKey:device.did]) {
        NSDictionary *users = [GKIWIKSocket.userDict objectForKey:device.did];
        if ([users objectForKey:userName]) {
            return [users objectForKey:userName];
        }
    }
    return [NSString stringWithFormat:@"%@:%@", NSLocalizedString(@"UserNo", nil), userName];
}

-(void)makeToast:(KIWIKEvent *)event device:(KIWIKDevice *)device {
    NSString *devName = device.name ? device.name : [NSString stringWithFormat:@"Lock%@", device.did];
    NSString *userName = [self userName:event device:device];
    NSString *message = [NSString stringWithFormat:@"%@\n%@-%@",[event title], [event userString], userName];
    
    FFToast *toast = [[FFToast alloc] initToastWithTitle:devName message:message iconImage:[event image]];
    toast.toastPosition = FFToastPositionBelowStatusBarWithFillet;
    toast.toastType = [event isLockWarning] ? FFToastTypeWarning : FFToastTypeDefault;
    toast.duration = 5.0f;
    [toast show];
}
@end
