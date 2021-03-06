//
//  KIWIKEvent+UI.m
//  KIWIKSDKDemo
//
//  Created by Levy Xu on 2018/6/22.
//  Copyright © 2018年 Levy Xu. All rights reserved.
//

#import "KIWIKEvent+UI.h"

@implementation KIWIKEvent(UI)

-(BOOL)isLockWarning {
    return self.status == DoorLockStatusAlarm || self.status == DoorLockStatusWarning;
}

-(UIImage *)headerImage {
    if(self.type == DoorLockTypeDoorLock) {
        switch (self.status) {
            case DoorLockStatusWarning:
                if (self.statusInfo == DoorLockWarningLowVoltage) {
                    return [UIImage imageNamed:@"Door_LowVoltage"];
                } else {
                    return [UIImage imageNamed:@"Door_Warning"];
                }
            case DoorLockStatusAlarm:
                if (self.statusInfo == DoorLockAlarmThreatenUnlock) {
                    return [UIImage imageNamed:@"Door_ThreatenUnlock"];
                }else {
                    return [UIImage imageNamed:@"Door_Alarm"];
                }
            case DoorLockStatusUnlocked:
                return [UIImage imageNamed:@"Door_Unlock"];
            default:
                return [UIImage imageNamed:@"Door_Lock"];
        }
    }
    return nil;
}

-(UIColor *)headerColor {
    switch (self.status) {
        case DoorLockStatusWarning:
            return [UIColor colorWithHex:@"#F29700"];
        case DoorLockStatusAlarm:
            return [UIColor colorWithHex:@"#FF6633"];
        case DoorLockStatusUnlocked:
            return [UIColor colorWithHex:@"#FF3333"];
        default:
            return [UIColor colorWithHex:@"#2286F1"];
    }
}

-(UIImage*)image {
    if(self.type == DoorLockTypeDoorLock) {
        switch (self.status) {
            case DoorLockStatusUnlocked:
                return [UIImage imageNamed:@"doorStateUnlock"];
            case DoorLockStatusAlarm:
                if (self.statusInfo == DoorLockAlarmThreatenUnlock) {
                    return [UIImage imageNamed:@"doorStateThreatenUnlock"];
                }else {
                    return [UIImage imageNamed:@"doorStateAlarm"];
                }
            case DoorLockStatusRemoteUnlock:
                if (self.statusInfo == DoorLockWarningLowVoltage) {
                    return [UIImage imageNamed:@"doorStateLowVoltage"];
                } else {
                    return [UIImage imageNamed:@"doorStateRemoteUnlock"];
                }
            case DoorLockStatusWarning:
                return [UIImage imageNamed:@"doorStateWarning"];
            default:
                return [UIImage imageNamed:@"doorStateLocked"];
        }
    }
    return nil;
}

-(NSString *)title {
    if(self.type == DoorLockTypeDoorLock) {
        switch (self.status) {
            case DoorLockStatusUnlocked:
                return NSLocalizedString(@"DoorUnlock", nil);
            case DoorLockStatusAlarm:
                return [self alarmTitle];
            case DoorLockStatusRemoteUnlock:
                return NSLocalizedString(@"RemoteUnlockRequest", nil);
            case DoorLockStatusWarning:
                return [self warningTitle];
            default:
                return NSLocalizedString(@"DoorLocked", nil);;
        }
    }
    return nil;
}

-(NSString*)alarmTitle {
    switch (self.statusInfo) {
        case DoorLockAlarmDoorPry:
            return NSLocalizedString(@"LockPrying", nil);
        case DoorLockAlarmForceOpen:
            return NSLocalizedString(@"DoorForceOpen", nil);
        case DoorLockAlarmFreezeFingerPrint:
            return NSLocalizedString(@"FrozenFingerprint", nil);
        case DoorLockAlarmFreezePassword:
            return NSLocalizedString(@"FrozenPassword", nil);
        case DoorLockAlarmFreezeCard:
            return NSLocalizedString(@"FrozenCard", nil);
        case DoorLockAlarmFreezeKey:
            return NSLocalizedString(@"FrozenKeys", nil);
        case DoorLockAlarmFreezeRemote:
            return NSLocalizedString(@"FrozenRemoteControl", nil);
        case DoorLockAlarmThreatenUnlock:
            return NSLocalizedString(@"ThreatenUnlock", nil);
        case DoorLockAlarmLowVoltage:
            return NSLocalizedString(@"LowVoltageWarning", nil);
        case DoorLockAlarmTesla:
            return NSLocalizedString(@"TeslaWarning", nil);
        case DoorLockAlarmFreeze:
            return NSLocalizedString(@"FreezeWarning", nil);
        default:
            return nil;
    }
}

-(NSString*)warningTitle {
    switch (self.statusInfo) {
        case DoorLockWarningForgetKey:
            return NSLocalizedString(@"ForgetPullOutKey", nil);
        case DoorLockWarningLockDoor:
            return NSLocalizedString(@"LockDoorWarning", nil);
        case DoorLockWarningKnockDoor:
            return NSLocalizedString(@"KnockDoorWarning", nil);
        case DoorLockWarningSOS:
            return NSLocalizedString(@"SOSWarning", nil);
        case DoorLockWarningWrongClosed:
            return NSLocalizedString(@"DoorNotClosed", nil);
        case DoorLockWarningBackLocked:
            return NSLocalizedString(@"LockedOpposite", nil);
        case DoorLockWarningUnlocked:
            return NSLocalizedString(@"DoorUnlocked", nil);
        case DoorLockWarningAlwaysOpen:
            return NSLocalizedString(@"KeepUnlockOpen", nil);
        case DoorLockWarningLowVoltage:
            return NSLocalizedString(@"LowVoltageWarning", nil);
        case DoorLockWarningUserAdd:
            return NSLocalizedString(@"user_add", nil);
        case DoorLockWarningUserDelete:
            return NSLocalizedString(@"user_delete", nil);
        case DoorLockWarningUserInit:
            return NSLocalizedString(@"user_init", nil);
        case DoorLockWarningBell:
            return NSLocalizedString(@"DoorBellRing", nil);
        default:
            return nil;
    }
}

-(NSString *)userString {
    switch (self.userType) {
        case DoorLockUserTypeFinger:
            return NSLocalizedString(@"FingerprintUser", nil);
        case DoorLockUserTypePassword:
            return NSLocalizedString(@"PasswordUser", nil);
        case DoorLockUserTypeCard:
            return NSLocalizedString(@"CardUser", nil);
        case DoorLockUserTypeKey:
            return NSLocalizedString(@"KeyUser", nil);
        case DoorLockUserTypePhone:
            return NSLocalizedString(@"PhoneUser", nil);
        case DoorLockUserTypeFace:
            return NSLocalizedString(@"user_face", nil);
        case DoorLockUserTypePalmPrint:
            return NSLocalizedString(@"user_palmprint", nil);
        case DoorLockUserTypeIris:
            return NSLocalizedString(@"user_iris", nil);
        case DoorLockUserTypeTemp:
            return NSLocalizedString(@"user_temp", nil);
        default:
            return NSLocalizedString(@"DefaultUser", nil);
    }
}

- (UIImage *)userImage {
    switch (self.userType) {
        case DoorLockUserTypeFinger:
            return [UIImage imageNamed:@"User_Fingerprint"];
        case DoorLockUserTypePhone:
            return [UIImage imageNamed:@"User_Phone"];
        case DoorLockUserTypePassword:
            return [UIImage imageNamed:@"User_Password"];
        case DoorLockUserTypeCard:
            return [UIImage imageNamed:@"User_IC"];
        case DoorLockUserTypeKey:
            return [UIImage imageNamed:@"User_Key"];
        default:
            return [UIImage imageNamed:@"User_Default"];
    }
}

-(NSString *)timeString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"y-MM-d HH:mm ss"];
    return [formatter stringFromDate:[self dateTime]];
}

@end
