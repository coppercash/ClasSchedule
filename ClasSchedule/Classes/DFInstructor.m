//
//  DFHollowView.m
//  trapezium
//
//  Created by DreamerMac on 12-5-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DFInstructor.h"
#import <QuartzCore/QuartzCore.h>
#import "DFInstructorButton.h"

@implementation DFInstructor
@synthesize delegate;

#define kAlpha 0.8f
#define kHollowSize 30.0f
#define kPopupAnimationDuration 0.3f
#define kDismissAnimationDuration 0.2f
#define kToolBarButtonItemSize 30.0f

#pragma mark - Return Button
- (BOOL)beginTouchingReturnButton:(DFInstructorButton*)aButton
{
    [callingButton setHighlighted:YES];
    if ([delegate respondsToSelector:@selector(instructorBeginTouchingReturnButton:)]) {
        [delegate instructorBeginTouchingReturnButton:self];
    }
    return YES;
}

- (void)endTouchingReturnButton:(DFInstructorButton*)aButton
{
    [callingButton setHighlighted:NO];
    
    if ([delegate respondsToSelector:@selector(instructorEndTouchingReturnButton:)]) {
        [delegate instructorEndTouchingReturnButton:self];
    }
}

#pragma mark - Animation
- (CAKeyframeAnimation*)getAlphaAnimationForPopup {
	
	CAKeyframeAnimation *alphaAnimation = [CAKeyframeAnimation	animationWithKeyPath:@"opacity"];
	alphaAnimation.removedOnCompletion = NO;
	alphaAnimation.values = [NSArray arrayWithObjects:
							 [NSNumber numberWithFloat:0],
							 [NSNumber numberWithFloat:0.7],
							 [NSNumber numberWithFloat:1],
							 nil];
	alphaAnimation.keyTimes = [NSArray arrayWithObjects:
							   [NSNumber numberWithFloat:0],
							   [NSNumber numberWithFloat:0.1],
							   [NSNumber numberWithFloat:1],
							   nil];
	return alphaAnimation;
}

- (CAKeyframeAnimation*)getPositionAnimationForPopup {
	
	CGFloat r1 = 0.1;
	CGFloat r2 = 1.4;
	CGFloat r3 = 1;
	CGFloat r4 = 0.8;
	CGFloat r5 = 1;
    
    CGFloat horizontalOffset = 0.0f;
    CGFloat verticalOffset =  0.0f;
    
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
	CATransform3D tm1, tm2, tm3, tm4, tm5;
	
    tm1 = CATransform3DMakeTranslation(horizontalOffset * (1 - r1), verticalOffset * (1 - r1), 0);
    tm2 = CATransform3DMakeTranslation(horizontalOffset * (1 - r2), verticalOffset * (1 - r2), 0);
    tm3 = CATransform3DMakeTranslation(horizontalOffset * (1 - r3), verticalOffset * (1 - r3), 0);
    tm4 = CATransform3DMakeTranslation(horizontalOffset * (1 - r4), verticalOffset * (1 - r4), 0);
    tm5 = CATransform3DMakeTranslation(horizontalOffset * (1 - r5), verticalOffset * (1 - r5), 0);
    
	tm1 = CATransform3DScale(tm1, r1, r1, 1);
	tm2 = CATransform3DScale(tm2, r2, r2, 1);
	tm3 = CATransform3DScale(tm3, r3, r3, 1);
	tm4 = CATransform3DScale(tm4, r4, r4, 1);
	tm5 = CATransform3DScale(tm5, r5, r5, 1);
	
	positionAnimation.values = [NSArray arrayWithObjects:
								[NSValue valueWithCATransform3D:tm1],
								[NSValue valueWithCATransform3D:tm2],
								[NSValue valueWithCATransform3D:tm3],
								[NSValue valueWithCATransform3D:tm4],
								[NSValue valueWithCATransform3D:tm5],
								nil];
	positionAnimation.keyTimes = [NSArray arrayWithObjects:
								  [NSNumber numberWithFloat:0.0],
								  [NSNumber numberWithFloat:0.2],
								  [NSNumber numberWithFloat:0.4],
								  [NSNumber numberWithFloat:0.7], 
								  [NSNumber numberWithFloat:1.0],
								  nil];
	return positionAnimation;
}

- (void)popupAnimation{
	
	CAKeyframeAnimation *positionAnimation = [self getPositionAnimationForPopup];
	CAKeyframeAnimation *alphaAnimation = [self getAlphaAnimationForPopup];
	
	CAAnimationGroup *group = [CAAnimationGroup animation];
	group.animations = [NSArray arrayWithObjects:positionAnimation, alphaAnimation, nil];
	group.duration = kPopupAnimationDuration;
	group.removedOnCompletion = YES;
	group.fillMode = kCAFillModeForwards;
	
	[self.layer addAnimation:group forKey:@"hoge"];
}

- (void)dismissAnimation{
	CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
	
	float r1 = 1.0;
	float r2 = 0.1;
	
    CGFloat horizontalOffset = 0.0f;
    CGFloat verticalOffset =  0.0f;
    
	CAKeyframeAnimation *alphaAnimation = [CAKeyframeAnimation	animationWithKeyPath:@"opacity"];
	alphaAnimation.removedOnCompletion = NO;
	alphaAnimation.values = [NSArray arrayWithObjects:
							 [NSNumber numberWithFloat:1],
							 [NSNumber numberWithFloat:0],
							 nil];
	alphaAnimation.keyTimes = [NSArray arrayWithObjects:
							   [NSNumber numberWithFloat:0],
							   [NSNumber numberWithFloat:1],
							   nil];
	
	CATransform3D tm1, tm2;
    
    tm1 = CATransform3DMakeTranslation(horizontalOffset * (1 - r1), verticalOffset * (1 - r1), 0);
    tm2 = CATransform3DMakeTranslation(horizontalOffset * (1 - r2), verticalOffset * (1 - r2), 0);
    
    tm1 = CATransform3DScale(tm1, r1, r1, 1);
	tm2 = CATransform3DScale(tm2, r2, r2, 1);
	
	positionAnimation.values = [NSArray arrayWithObjects:
								[NSValue valueWithCATransform3D:tm1],
								[NSValue valueWithCATransform3D:tm2],
								nil];
	positionAnimation.keyTimes = [NSArray arrayWithObjects:
								  [NSNumber numberWithFloat:0],
								  [NSNumber numberWithFloat:1.0],
								  nil];
	
	CAAnimationGroup *group = [CAAnimationGroup animation];
	group.animations = [NSArray arrayWithObjects:positionAnimation, alphaAnimation, nil];
	group.duration = kDismissAnimationDuration;
	group.removedOnCompletion = NO;
	group.fillMode = kCAFillModeForwards;
	group.delegate = self;
	
	[self.layer addAnimation:group forKey:@"hoge"];
}

#pragma mark - Show
- (void)showInView:(UIView*)aView
{
    [self setNeedsDisplay];
    [aView setFrame:aView.bounds];
    [aView addSubview:self];
}

#pragma mark - Hide
- (void)hide{
    hollowFrame = CGRectZero;
    //[returnButton setFrame:CGRectZero];

}

#pragma mark - Present

- (void)presentInView:(UIView*)aView animated:(BOOL)animated 
{
    [delegate instructorLoadingSubviews:self];
    [self showInView:aView];
    if (animated) [self popupAnimation];
}

- (void)presentAtPoint:(CGPoint)aPoint inView:(UIView*)aView animated:(BOOL)animated 
{
    [self presentInView:aView animated:animated];
    
    hollowFrame = CGRectMake(aPoint.x - kHollowSize / 2, aPoint.y - kHollowSize / 2, kHollowSize, kHollowSize);
    [returnButton setFrame:hollowFrame];
}


- (void)presentInFrame:(CGRect)aFrame inView:(UIView*)aView animated:(BOOL)animated 
{
    [self presentInView:aView animated:animated];

    CGRect frame = aFrame;
    CGPoint center = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
    CGFloat size = (frame.size.width > frame.size.height) ? frame.size.width : frame.size.height;
    hollowFrame = CGRectMake(center.x - size / 2, center.y - size / 2, size, size);
    [returnButton setFrame:hollowFrame];
}

- (void)presentByButton:(UIButton*)aButton inView:(UIView*)aView animated:(BOOL)animated 
{
    callingButton = aButton;
    CGRect frame = [self convertRect:aButton.frame fromView:aButton.superview];

    [self presentInFrame:frame inView:aView animated:animated];
}

- (void)presentByUIBarButtonItem:(UIBarButtonItem*)aBarButtonItem touch:(UITouch*)aTouch inView:(UIView *)aView animated:(BOOL)animated
{
    callingBarButtonItem = aBarButtonItem;
    [returnButton setShowsTouchWhenHighlighted:YES];

    [self presentInView:aView animated:animated];

    CGPoint center = [aTouch locationInView:self];
    hollowFrame = CGRectMake(center.x - kToolBarButtonItemSize / 2, center.y - kToolBarButtonItemSize / 2, kToolBarButtonItemSize, kToolBarButtonItemSize);
    [returnButton setFrame:hollowFrame];
}
#pragma mark - Dismiss
- (void)dismissAnimated:(BOOL)animated
{
    callingButton = nil;
    callingBarButtonItem = nil;
    if (animated) {
        [self hide];
        [self dismissAnimation];
    }else{
        [self hide];
        [self removeFromSuperview];
    }
}

- (void)dismissWithAnimation
{
    [self dismissAnimated:YES];
}

#pragma mark - Core Animation call back
- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
    UIView* pView = nil;
    while ([self.subviews count]) {
        pView = [self.subviews lastObject];
        [pView removeFromSuperview];
    }
    [self addSubview:returnButton];
    
    [self removeFromSuperview];
    [self setDelegate:nil];
}

#pragma mark - Draw
static CGGradientRef newGradientWithColors(void)
{
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    CGFloat colors[] =
	{
        0.0 / 255.0, 0.0 / 255.0, 0.0 / 255.0, 0.0,
        0.0 / 255.0, 0.0 / 255.0, 0.0 / 255.0, kAlpha
	};
    CGGradientRef gradient = CGGradientCreateWithColorComponents(rgb, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));
	CGColorSpaceRelease(rgb);
    
    return gradient;
}

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGGradientRef gradient = newGradientWithColors();
    CGPoint hollowCenter = CGPointMake(CGRectGetMidX(hollowFrame), CGRectGetMidY(hollowFrame));
    CGFloat radius = hollowFrame.size.width / 2;
    
    CGContextDrawRadialGradient(context, gradient, hollowCenter, radius, hollowCenter, radius + 30.0f, kCGGradientDrawsAfterEndLocation);
    CGGradientRelease(gradient);
}

#pragma mark - Lifecycle
- (id)init{
    if (self = [super init]) {
        [self setBackgroundColor:[UIColor clearColor]];
        //[self setFrame:[UIApplication sharedApplication].keyWindow.frame];
        [self setFrame:CGRectMake(0.0f, 0.0f, 320.0f, 480.0f)];
        
        returnButton = [[DFInstructorButton alloc] initWithInstructor:self];
        [self addSubview:returnButton];
        [returnButton addTarget:self action:@selector(dismissWithAnimation) forControlEvents:UIControlEventTouchUpInside];
        
        //[returnButton setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5]];
    }
    return self;
}

@end
