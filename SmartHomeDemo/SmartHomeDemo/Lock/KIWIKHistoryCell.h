//
//  KIWIKHistoryCell.h
//  SmartHomeDemo
//
//  Created by Levy Xu on 2018/6/14.
//  Copyright © 2018年 Levy Xu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KIWIKHistoryCell : UITableViewCell

@property (nonatomic, strong) UILabel *thirdLabel;

@property (nonatomic, strong) UIImageView *userImageView;

@property (nonatomic, strong) KIWIKEvent *event;

@end
