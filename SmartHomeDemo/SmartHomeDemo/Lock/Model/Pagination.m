//
//  Pagination.m
//  KIWIKSDKDemo
//
//  Created by Levy Xu on 2018/10/31.
//  Copyright © 2018 Levy Xu. All rights reserved.
//

#import "Pagination.h"

@implementation Pagination

- (instancetype)init
{
    self = [super init];
    if (self) {
        _start = 1;
        _limit = 30;
    }
    return self;
}

-(BOOL)hasMore {
    return _total > 0 &&  _start * _limit < _total;
}

@end
