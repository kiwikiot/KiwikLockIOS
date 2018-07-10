//
//  KIWIKHistoryViewController.h
//  SmartHomeDemo
//
//  Created by Levy Xu on 2018/6/14.
//  Copyright © 2018年 Levy Xu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    HistoryTypeUnlocking,
    HistoryTypeAlarm
} HistoryType;

@protocol KIWIKHistoryDelegate <NSObject>
-(void)eventListChanged:(NSDictionary *)list;
@end

@interface KIWIKHistoryViewController : UIViewController

@property(nonatomic, assign) id<KIWIKHistoryDelegate> delegate;

- (instancetype)initWithDevice:(KIWIKDevice *)device type:(HistoryType)type;

-(void)setEventList:(NSArray *)events;

-(void)reload;

@end
