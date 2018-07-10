//
//  KIWIKHistoryCell.m
//  SmartHomeDemo
//
//  Created by Levy Xu on 2018/6/14.
//  Copyright © 2018年 Levy Xu. All rights reserved.
//

#import "KIWIKHistoryCell.h"
#import "KIWIKEvent+UI.h"

@implementation KIWIKHistoryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.textLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        self.textLabel.textColor = [UIColor colorWithWhite:0.2 alpha:0.8];
        
        self.detailTextLabel.font = [UIFont systemFontOfSize:14.0f];
        self.detailTextLabel.textAlignment = NSTextAlignmentRight;
        self.detailTextLabel.textColor = [UIColor colorWithWhite:0.4 alpha:0.8];
        
        self.userImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.userImageView];
        
        self.thirdLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.thirdLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-Light" size:14];
        self.thirdLabel.textColor = [UIColor colorWithWhite:0.4 alpha:0.8];
        [self.contentView addSubview:self.thirdLabel];
        
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 60 - PixelOne, SCREEN_WIDTH, PixelOne);
        layer.backgroundColor = [UIColor lightGrayColor].CGColor;
        [self.layer addSublayer:layer];
    }
    return self;
}

-(void)setEvent:(KIWIKEvent *)event {
    _event = event;
    
    self.imageView.image = [event image];
    self.textLabel.text = [event title];
    self.thirdLabel.text = [event timeString];
    self.userImageView.image = [event userImage];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(10, 10, 40, 40);
    self.textLabel.frame = CGRectMake(self.imageView.right + 10, 10, SCREEN_WIDTH - self.imageView.right - 10, 20);
    self.thirdLabel.frame = CGRectMake(self.imageView.right + 10, 35, SCREEN_WIDTH - self.imageView.right - 10, 20);
    
    if (self.event.type == DoorLockTypeDoorLock && (self.event.status == DoorLockStatusLocked || self.event.status == DoorLockStatusUnlocked || (self.event.status == DoorLockStatusAlarm && self.event.statusInfo == DoorLockAlarmThreatenUnlock))) {
        self.userImageView.hidden = NO;
        self.userImageView.frame = CGRectMake(SCREEN_WIDTH - 26, 10, 20, 20);
        
        self.detailTextLabel.hidden = NO;
        self.detailTextLabel.frame = CGRectMake(SCREEN_WIDTH - 110, 35, 100, 20);
    } else {
        self.userImageView.hidden = YES;
        self.detailTextLabel.hidden = YES;
    }
}

@end
