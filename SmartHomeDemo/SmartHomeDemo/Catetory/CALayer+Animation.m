//
//  CALayer+Animation.m
//  SmartHome
//
//  Created by kiwik on 16/3/3.
//  Copyright © 2016年 几维信息科技有限公司. All rights reserved.
//

#import "CALayer+Animation.h"

@implementation CALayer(Animation)

-(void)begainScale{
    const float maxScale=2.0;
    if (self.transform.m11<maxScale) {
        if (self.transform.m11==1.0) {
            [self setTransform:CATransform3DMakeScale( 1.03, 1.03, 1.0)];
        }else{
            UIColor *color = [UIColor colorWithCGColor:self.borderColor];
            self.borderColor =[color colorWithAlphaComponent:maxScale-self.transform.m11].CGColor;
            [self setTransform:CATransform3DScale(self.transform, 1.03, 1.03, 1.0)];
        }
        [self performSelector:_cmd withObject:self afterDelay:0.05];
    } else {
        [self removeFromSuperlayer];
    }
}

-(BOOL)hasRotate {
    return [self animationForKey:@"kRotationAnimation"] != nil;
}

-(void)removeRotate {
    [self removeAnimationForKey:@"kRotationAnimation"];
}

-(void)addRotateWithDuration:(NSTimeInterval)duration {
    [self addRotateWithDuration:duration clockwise:YES];
}

-(void)addRotateWithDuration:(NSTimeInterval)duration clockwise:(BOOL)clockwise {
    [self addRotateWithDuration:duration clockwise:clockwise delegate:nil];
}

-(void)addRotateWithDuration:(NSTimeInterval)duration delegate:(id)delegate {
    [self addRotateWithDuration:duration clockwise:YES delegate:delegate];
}

-(void)addRotateWithDuration:(NSTimeInterval)duration clockwise:(BOOL)clockwise delegate:(id)delegate {
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = clockwise ? @(M_PI * 2.0) : @(-M_PI * 2.0);
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = NSIntegerMax;
    rotationAnimation.delegate = delegate;
    [self addAnimation:rotationAnimation forKey:@"kRotationAnimation"];
}

-(BOOL)hasFlash {
    return [self animationForKey:@"kFlashAnimation"] != nil;
}

-(void)removeFlash {
    [self removeAnimationForKey:@"kFlashAnimation"];
}

-(void)addFlashWithDuration:(NSTimeInterval)duration {
    [self addFlashWithDuration:duration delegate:nil];
}

-(void)addFlashWithDuration:(NSTimeInterval)duration delegate:(id)delegate {
    CABasicAnimation *flashAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    flashAnimation.fromValue = [NSNumber numberWithFloat:1.0f];
    flashAnimation.toValue = [NSNumber numberWithFloat:0.0f];
    flashAnimation.autoreverses = YES;
    flashAnimation.duration = duration;
    flashAnimation.repeatCount = MAXFLOAT;
    flashAnimation.removedOnCompletion = NO;
    flashAnimation.fillMode = kCAFillModeForwards;
    flashAnimation.delegate = delegate;
    flashAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self addAnimation:flashAnimation forKey:@"kFlashAnimation"];
}
@end
