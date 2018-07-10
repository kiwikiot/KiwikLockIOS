//
//  UITableView+KIWIK.m
//  SmartHome
//
//  Created by kiwik on 16/6/20.
//  Base on Tof Templates
//  Copyright © 2016年 几维信息科技有限公司. All rights reserved.
//

#import "UITableView+KIWIK.h"

#define kTipsLabelTag 9999

#pragma mark -
#pragma mark Category KIWIK for UITableView 
#pragma mark -

@implementation UITableView (KIWIK)

-(void)showTips:(NSString *)tips {
    [self showTips:tips centerY:0.3 * self.boundsHeight];
}

-(void)showTips:(NSString *)tips centerY:(CGFloat)centerY {
    UILabel *label = (UILabel *)[self viewWithTag:kTipsLabelTag];
    if (!label) {
        label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.boundsWidth, 30)];
        label.tag = kTipsLabelTag;
        label.textColor = [UIColor colorWithWhite:0.4 alpha:0.6];
        label.font = [UIFont systemFontOfSize:30];
        label.textAlignment = NSTextAlignmentCenter;
        label.center = CGPointMake(self.boundsWidth/2, centerY);
        [self addSubview:label];
        [self bringSubviewToFront:label];
    }
    label.hidden = NO;
    label.text = tips;
}

-(void)hideTips{
    UILabel *label = (UILabel *)[self viewWithTag:kTipsLabelTag];
    if (label && !label.isHidden) {
        label.hidden = YES;
    }
}

@end
