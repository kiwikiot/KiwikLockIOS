//
//  MethodButton.m
//  SmartHomeDemo
//
//  Created by Levy Xu on 2018/6/20.
//  Copyright © 2018年 Levy Xu. All rights reserved.
//

#import "MethodButton.h"

@interface MethodButton ()
@property(nonatomic, strong) UILabel *descLabel;
@end

@implementation MethodButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.borderWidth = 1.0f;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.cornerRadius = 10.0f;
        
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithWhite:0.9 alpha:1.0] forState:UIControlStateHighlighted];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        UIImage *image = [[UIImage imageNamed:@"arrow_right"] imageWithTintColor:[UIColor whiteColor]];
        [self setImage:image forState:UIControlStateNormal];
        
        _descLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _descLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _descLabel.textColor = [UIColor colorWithWhite:0.95 alpha:1.0];
        _descLabel.font = [UIFont systemFontOfSize:14];
        _descLabel.numberOfLines = 0;
        [self addSubview:_descLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(self.width - 32, 14, 22, 22);
    self.titleLabel.frame = CGRectMake(15, 16, self.width - 52, 22);
    self.descLabel.frame = CGRectMake(15, 45, self.width - 30, self.height - 45);
}

- (void)setDesc:(NSString *)desc {
    _desc = desc;
    self.descLabel.text = desc;
    [self setNeedsLayout];
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    if (highlighted) {
        _descLabel.textColor = [UIColor colorWithWhite:0.85 alpha:1.0];
    } else {
        _descLabel.textColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    }
}

@end
