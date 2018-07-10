//
//  KIWIKSSID.m
//  SmartHomeDemo
//
//  Created by Levy Xu on 2018/6/20.
//  Copyright © 2018年 Levy Xu. All rights reserved.
//

#import "KIWIKSSID.h"

@implementation KIWIKSSID {
    NSMutableDictionary *mDiction;
    NSString *storeFile;
}

SingletonM(KIWIKSSID, [self initMethod];)

-(void)initMethod {
    storeFile = [DOC_DIR stringByAppendingPathComponent:@"kiwik_ssid_key.json"];
    NSString *jsonStr = [NSString stringWithContentsOfFile:storeFile encoding:NSUTF8StringEncoding error:NULL];
    NSDictionary *dic = [jsonStr mj_JSONObject];
    mDiction = [NSMutableDictionary dictionaryWithDictionary:dic];
}

-(void)saveSsid:(NSString *)ssid andKey:(NSString *)key {
    NSString *saved = [mDiction objectForKey:ssid];
    if (saved) {
        if ([saved isEqualToString:key])
            return;
    }
    [mDiction setObject:key forKey:ssid];
    [self save];
}

-(NSString *)getKeyBySsid:(NSString *)ssid {
    return [mDiction objectForKey:ssid];
}

-(NSArray *)getAllSsid {
    NSArray *array = [mDiction allKeys];
    return [array sortedArrayUsingSelector:@selector(compare:)];
}

#pragma mark - private functions
- (void)save {
    NSString *jsonStr = [mDiction mj_JSONString];
    [jsonStr writeToFile:storeFile atomically:TRUE encoding:NSUTF8StringEncoding error:NULL];
}

@end
