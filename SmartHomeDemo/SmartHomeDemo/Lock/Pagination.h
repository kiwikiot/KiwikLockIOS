//
//  Pagination.h
//  KIWIKSDKDemo
//
//  Created by Levy Xu on 2018/10/31.
//  Copyright © 2018 Levy Xu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Pagination : NSObject

@property(nonatomic, assign) NSInteger start;
@property(nonatomic, assign) NSInteger limit;
@property(nonatomic, assign) NSInteger total;

-(BOOL)hasMore;

@end

NS_ASSUME_NONNULL_END
