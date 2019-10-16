//
//  KIWIKLockService.m
//  KIWIKSDKDemo
//
//  Created by Levy Xu on 2018/6/22.
//  Copyright © 2018年 Levy Xu. All rights reserved.
//

#import "KIWIKLockService.h"
#import "KIWIKUtils.h"
#import "KIWIKEvent+UI.h"

@interface KIWIKLockService()
@property(nonatomic, strong) KIWIKDevice *selectedDevice;
@property(nonatomic, strong) NSTimer *timer;
@property(nonatomic, strong) FRAlertController *unlockAlert;
@end

@implementation KIWIKLockService

SingletonM(KIWIKLockService,)

-(void)start {
    [NNCDC addObserver:self selector:@selector(messageReceived:) name:kEventNotifyNotification object:nil];
}

- (void)stop {
    [NNCDC removeObserver:self];
}

-(void)messageReceived:(NSNotification *)notification {
    NSDictionary *msg = [notification object];
    NSLog(@"msg %@", msg);
    NSString *did = [msg objectForKey:@"did"];
    KIWIKDevice *device = nil;
    for (KIWIKDevice *dev in GKIWIKSDK.locks) {
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
    KIWIKEvent *event = [msg objectForKey:@"event"];
    NSLog(@"event %@", event.mj_keyValues);
    if (event.cmd == DoorLockCmdNotification && event.type == DoorLockTypeDoorLock) {
        
        [NNCDC postNotificationName:kLockEventReceivedNotification object:event userInfo:@{@"did": did}];
        
        if (event.status == DoorLockStatusRemoteUnlock) {//远程请求开锁
            NSLog(@"lockState %ld", (long)_lockState);
            if ([event remoteRequestValid] && _lockState == 0) {
                [self remoteUnlock:device event:event];
            } else {
                [self makeToast:event device:device];
            }
        } else if (event.status == DoorLockStatusUnlocked) {//开锁成功
            if (_lockState == 3 && _selectedDevice == device) {
                if (self.unlockAlert) {
                    [self.unlockAlert dismissViewControllerAnimated:YES completion:nil];
                    self.unlockAlert = nil;
                }
                [SVProgressHUD showSuccessWithStatus:@"开锁成功"];
                self.lockState = 0;
                [self.timer invalidate];
                self.timer = nil;
            } else {
                [self makeToast:event device:device];
            }
        } else {
            [self makeToast:event device:device];
        }
    }
}

-(void)remoteUnlock:(KIWIKDevice *)device event:(KIWIKEvent *)event {
    self.lockState = 1;

    __weak __typeof(self)weakSelf = self;
    NSString *devName = device.name.length ? device.name : [NSString stringWithFormat:@"Lock%@", device.did];
    NSString *title = [NSString stringWithFormat:@"%@-%@", devName, [event title]];
    self.unlockAlert = [KIWIKUtils alertWithTitle:title msg:@"点击确定马上开锁"cancel:^(FRAlertController *al) {
        weakSelf.lockState = 0;
    } ok:^(FRAlertController *al){
        weakSelf.lockState = 2;
        
        [SVProgressHUD showWithStatus:@"开锁中..."];
        [device unlock:YES block:^(id response, NSError *error) {
            if (!error) {
                weakSelf.lockState = 3;
                weakSelf.selectedDevice = device;
                weakSelf.timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(timeout) userInfo:nil repeats:NO];
            } else {
                [SVProgressHUD showErrorWithStatus:@"开锁失败"];
                weakSelf.lockState = 0;
            }
        }];
    }];
    [self.unlockAlert show];
}

-(void)timeout {
    [SVProgressHUD showSuccessWithStatus:@"开锁失败"];
    self.lockState = 0;
}

-(NSString *)userName:(KIWIKEvent *)event device:(KIWIKDevice *)device {
    NSInteger userId = [event userId];
    if ([device.userDict objectForKey:@(userId)]) {
        return [device.userDict objectForKey:@(userId)];
    }
    return [NSString stringWithFormat:@"%@:%ld", NSLocalizedString(@"UserNo", nil), (long)event.userNo];
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
