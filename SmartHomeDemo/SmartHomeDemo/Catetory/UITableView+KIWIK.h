//
//  UITableView+KIWIK.h
//  SmartHome
//
//  Created by kiwik on 16/6/20.
//  Base on Tof Templates
//  Copyright © 2016年 几维信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark -
#pragma mark Category KIWIK for UITableView 
#pragma mark -

@interface UITableView (KIWIK)

-(void)showTips:(NSString *)tips;

-(void)showTips:(NSString *)tips centerY:(CGFloat)centerY;

-(void)hideTips;

@end
