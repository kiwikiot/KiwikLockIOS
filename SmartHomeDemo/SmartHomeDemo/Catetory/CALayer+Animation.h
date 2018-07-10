//
//  CALayer+Animation.h
//  SmartHome
//
//  Created by kiwik on 16/3/3.
//  Copyright © 2016年 几维信息科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CALayer(Animation)

-(void)begainScale;

//Rotate
-(BOOL)hasRotate;

-(void)removeRotate;

-(void)addRotateWithDuration:(NSTimeInterval)duration;

-(void)addRotateWithDuration:(NSTimeInterval)duration clockwise:(BOOL)clockwise;

-(void)addRotateWithDuration:(NSTimeInterval)duration delegate:(id)delegate;

-(void)addRotateWithDuration:(NSTimeInterval)duration clockwise:(BOOL)clockwise delegate:(id)delegate;

//Flash
-(BOOL)hasFlash;

-(void)removeFlash;

-(void)addFlashWithDuration:(NSTimeInterval)duration;

-(void)addFlashWithDuration:(NSTimeInterval)duration delegate:(id)delegate;
@end
