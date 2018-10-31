//
//  KIWIKEvent.h
//  KIWIKSDK
//
//  Created by Levy Xu on 2018/6/19.
//  Copyright © 2018年 Levy Xu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, DoorLockCmd) {
    DoorLockCmdOpen = 0x080F,
    DoorLockCmdNotification = 0x1401,
};

typedef NS_ENUM(NSInteger, DoorLockType) {
    DoorLockTypeButton,//按键触发。status：低四位表示点击次数，高四位表示按钮号，0xff表示点击全部
    DoorLockTypeSuiXin,//随心开关。status：0-关闭，1打开
    DoorLockTypeDoorSensor,//门磁监测。status：0门关闭；statuInfo：电量
    DoorLockTypeDoorLock,//门锁监测。status：由DoorLockStatus定义
    DoorLockTypeCustomNotification,//任务的自定义消息，消息内容存在body中
};

typedef NS_ENUM(NSInteger, DoorLockStatus) {
    DoorLockStatusLocked,//已上锁。statuInfo：0
    DoorLockStatusUnlocked,//已打开.statuInfo：0
    DoorLockStatusAlarm,//报警。statuInfo：由DoorLockAlarm定义
    DoorLockStatusRemoteUnlock,//远程开锁触发
    DoorLockStatusWarning,//提醒。statuInfo：由DoorLockWarning定义
};

typedef NS_ENUM(NSInteger, DoorLockAlarm) {
    DoorLockAlarmDoorPry,//智能锁被撬
    DoorLockAlarmForceOpen,//强行开门
    DoorLockAlarmFreezeFingerPrint,//指纹尝试开锁被冻结
    DoorLockAlarmFreezePassword,//密码尝试开锁被冻结
    DoorLockAlarmFreezeCard,//卡尝试开锁被冻结
    DoorLockAlarmFreezeKey,//钥匙尝试开锁被冻结
    DoorLockAlarmFreezeRemote,//遥控尝试开锁被冻结
    DoorLockAlarmLowVoltage,//电量低压报警
    DoorLockAlarmThreatenUnlock,//胁迫开锁
};

typedef NS_ENUM(NSInteger, DoorLockWarning) {
    DoorLockWarningForgetKey,//忘拔钥匙
    DoorLockWarningLockDoor,//锁门提醒
    DoorLockWarningKnockDoor,//敲门提醒
    DoorLockWarningSOS,//SOS求救提醒
    DoorLockWarningWrongClosed,//门没关好
    DoorLockWarningBackLocked,//门已反锁
    DoorLockWarningUnlocked,//门已解锁
    DoorLockWarningAlwaysOpen,//常开已开启
    DoorLockWarningLowVoltage,//电量低压报警
    DoorLockWarningUserAdd,//添加用户
    DoorLockWarningUserDelete,//删除用户
    DoorLockWarningUserInit,//用户初始化
};

typedef NS_ENUM(NSInteger, DoorLockUserType) {
    DoorLockUserTypeDefault,//默认用户
    DoorLockUserTypeFinger,//指纹用户
    DoorLockUserTypePassword, //密码用户
    DoorLockUserTypeCard,//卡用户
    DoorLockUserTypeKey,//钥匙用户
    DoorLockUserTypePhone,//手机用户
    DoorLockUserTypeFace,//人脸
    DoorLockUserTypePalmPrint,//掌纹
    DoorLockUserTypeIris,//虹膜
};

@interface KIWIKEvent : NSObject

//由DoorLockCmd定义
@property(nonatomic, assign) NSInteger cmd;

//由DoorLockCmd定义
@property(nonatomic, assign) NSInteger length;

//版本0
@property(nonatomic, assign) NSInteger version;

//UTC时间
@property(nonatomic, assign) NSInteger time;

//传感器类型，DoorLockType
@property(nonatomic, assign) NSInteger type;

//由DoorLockStatus定义
@property(nonatomic, assign) NSInteger status;

//
@property(nonatomic, assign) NSInteger statusInfo;

//由DoorLockUserType定义
@property(nonatomic, assign) NSInteger userType;

//用户编号（0~65535）
@property(nonatomic, assign) NSInteger userNo;


-(instancetype)initWithString:(NSString *)string;


-(NSString *)generateData;


-(NSDate *)dateTime;

-(NSInteger)userId;

-(BOOL)remoteRequestValid;

@end
