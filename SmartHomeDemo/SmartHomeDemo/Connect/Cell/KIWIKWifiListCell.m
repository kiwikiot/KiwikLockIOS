//
//  KIWIKWifiListCell.m
//  KIWIKSDKDemo
//
//  Created by Levy Xu on 2018/10/31.
//  Copyright © 2018 Levy Xu. All rights reserved.
//

#import "KIWIKWifiListCell.h"

@implementation KIWIKWifiListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.textLabel.textColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.textLabel.font = [UIFont systemFontOfSize:16];
    }
    return self;
}

-(UIImage *)imageWithRssi:(NSInteger)rssi {
    if (rssi > -60) {
        return [UIImage imageNamed:@"wifi-high"];
    } else if (rssi > -75) {
        return [UIImage imageNamed:@"wifi-mid"];
    } else {
        return [UIImage imageNamed:@"wifi-low"];
    }
}

- (void)setWifi:(KIWIKWifi *)wifi {
    self.textLabel.text = wifi.ssid;
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    iv.image = [self imageWithRssi:wifi.rssi];
    self.accessoryView = iv;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    self.imageView.image = selected ? [UIImage imageNamed:@"check"] : [UIImage imageNamed:@"uncheck"];
}

@end
