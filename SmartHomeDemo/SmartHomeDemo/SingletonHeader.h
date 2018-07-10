//
//  SingletonHeader.h
//  PhnixHome
//
//  Created by Levy Xu on 2017/8/16.
//  Copyright © 2017年 Levy Xu. All rights reserved.
//

#ifndef SingletonHeader_h
#define SingletonHeader_h

#define SingletonH(methodName) +(instancetype)shared##methodName;

#define SingletonM(methodName, initMethod)\
\
static id _instance = nil;\
+(instancetype)shared##methodName{\
return [[self alloc] init];\
}\
+(instancetype)allocWithZone:(struct _NSZone *)zone{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
_instance = [super allocWithZone:zone];\
});\
return _instance;\
}\
- (instancetype)init{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
_instance = [super init];\
initMethod\
});\
return _instance;\
}

#endif /* SingletonHeader_h */
