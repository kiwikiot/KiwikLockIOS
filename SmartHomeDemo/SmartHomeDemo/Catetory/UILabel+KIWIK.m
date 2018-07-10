//
//  UILabel+KIWIK.m
//  SmartHome
//
//  Created by kiwik on 16/9/4.
//  Base on Tof Templates
//  Copyright © 2016年 几维信息科技有限公司. All rights reserved.
//

#import "UILabel+KIWIK.h"

#pragma mark -
#pragma mark Category KIWIK for UILabel 
#pragma mark -

@implementation UILabel (KIWIK)

-(void)kw_fitSize {
    self.height = [self.text sizeWithFont:self.font
                        constrainedToSize:self.size
                            lineBreakMode:self.lineBreakMode].height;
}

@end
