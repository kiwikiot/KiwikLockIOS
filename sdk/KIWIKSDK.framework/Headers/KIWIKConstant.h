//
//  KIWIKConstant.h
//  KIWIKSDK
//
//  Created by Levy Xu on 2018/6/20.
//  Copyright © 2018年 Levy Xu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    KIWIKNamepaceAPP,      //Iot.Application
    KIWIKNamepaceDevice,   //Iot.Device
    KIWIKNamepaceMessage,  //Iot.Message
} KIWIKNamepace;

extern NSString * const kTokenChangedNotification;

extern NSString * const kSocketMessageReceivedNotification;

extern NSString * const KIWIKErrorResponse;

extern NSString * const KIWIKGetDevices;
extern NSString * const KIWIKGetDevicesResponse;

extern NSString * const KIWIKSetDeviceName;
extern NSString * const KIWIKSetDeviceNameResponse;

extern NSString * const KIWIKSetDeviceSecurity;
extern NSString * const KIWIKSetDeviceSecurityResponse;

extern NSString * const KIWIKAddDevice;
extern NSString * const KIWIKAddDeviceResponse;

extern NSString * const KIWIKDeleteDevice;
extern NSString * const KIWIKDeleteDeviceResponse;

extern NSString * const KIWIKGetDeviceInfo;
extern NSString * const KIWIKGetDeviceInfoResponse;

extern NSString * const KIWIKCtrl;
extern NSString * const KIWIKCtrlResponse;

extern NSString * const KIWIKGetRecords;
extern NSString * const KIWIKGetRecordsResponse;

extern NSString * const KIWIKSetUserId;
extern NSString * const KIWIKSetUserIdResponse;

extern NSString * const KIWIKDeleteUserId;
extern NSString * const KIWIKDeleteUserIdResponse;

extern NSString * const KIWIKGetUserIds;
extern NSString * const KIWIKGetUserIdsResponse;
