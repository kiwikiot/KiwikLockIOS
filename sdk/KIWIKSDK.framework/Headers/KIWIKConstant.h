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
    KIWIKNamepaceMessage,  //Iot.Device.Message
    KIWIKNamepaceDeviceKV,   //Iot.Device.KV
} KIWIKNamepace;

extern NSString * const kEventNotifyNotification;

extern NSString * const KIWIKErrorResponse;

extern NSString * const KIWIKGetDevices;
extern NSString * const KIWIKGetDevicesResponse;

extern NSString * const KIWIKSetDeviceName;
extern NSString * const KIWIKSetDeviceNameResponse;

extern NSString * const KIWIKGetDevicesAbility;
extern NSString * const KIWIKGetDevicesAbilityResponse;

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


extern NSString * const KIWIKSetItem;
extern NSString * const KIWIKSetItemResponse;
extern NSString * const KIWIKDeleteItem;
extern NSString * const KIWIKDeleteItemResponse;
extern NSString * const KIWIKGetCollection;
extern NSString * const KIWIKGetCollectionResponse;
extern NSString * const KIWIKGetItem;
extern NSString * const KIWIKGetItemResponse;
