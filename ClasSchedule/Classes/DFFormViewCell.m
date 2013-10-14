//
//  DFFormViewCell.m
//  ClasSchedule
//
//  Created by DreamerMac on 12-3-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DFFormViewCell.h"
#import "DFFormView.h"
#import <QuartzCore/QuartzCore.h>

@implementation DFFormViewCell
@synthesize superFormView;
@synthesize colIndex,rowIndex;
@synthesize isContentHidden,useCommonCellBackgroundImage;

#pragma mark - Animation
- (void)transformIntoFrame:(CGRect)aNewFrame
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:@"CellTransform" context:context];
	[UIView setAnimationDuration:0.5f]; 
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	//[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self cache:YES];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    [self setFrame:aNewFrame];
	[UIView commitAnimations];
	
}

#pragma mark - Content
- (void)setIsContentHidden:(BOOL)anIsContentHidden{
    if (anIsContentHidden == self.isContentHidden) return;
    BOOL theIsContentHidden = anIsContentHidden;
    
    if (theIsContentHidden) {
        [self hideContent];
    }else{
        [self showContent];
    }
    
    self.isContentHidden = anIsContentHidden;
}

- (void)hideContent
{
    
}

- (void)showContent
{
    
}

- (void)releaseContent
{
    
}

- (void)reloadContent
{
    [self setNeedsDisplay];
    [self loadSubviews];
}
#pragma mark - Subviews
- (void)loadSubviews
{
    if (useCommonCellBackgroundImage) {
        [self setBackgroundImage:superFormView.commonCellBackgroundImage forState:UIControlStateNormal];
    }
    
}

#pragma mark - Touch Event
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
	return [superFormView beginTrackingWithTouch:touch cellAtColumnIndex:self.colIndex rowIndex:self.rowIndex];
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
	return [superFormView continueTrackingWithTouch:touch cellAtColumnIndex:self.colIndex rowIndex:self.rowIndex];
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [superFormView endTrackingWithTouch:touch cellAtColumnIndex:self.colIndex rowIndex:self.rowIndex];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self beginTrackingWithTouch:[touches anyObject] withEvent:event];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    [self continueTrackingWithTouch:[touches anyObject] withEvent:event];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self endTrackingWithTouch:[touches anyObject] withEvent:event];
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    [self cancelTrackingWithEvent:event];
}

- (void)beganTouch
{
	[self setHighlighted:YES];
}

- (void)touchedUpInside
{
	[self setHighlighted:NO];
}

- (void)touchedUpOutside
{
	[self setHighlighted:NO];
}

#pragma mark - Memory Management
- (id)init{
    if (self = [super init]) {
        superFormView = nil;
        
        colIndex = 0;
        rowIndex = 0;
        
        isContentHidden = NO;
        useCommonCellBackgroundImage = NO;
        
        [self setShowsTouchWhenHighlighted:YES];
    }

    return self;
}

- (void)dealloc{
    superFormView = nil;
    
    [super dealloc];
}
@end
