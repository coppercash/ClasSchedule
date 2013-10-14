//
//  DFControlAccessory.m
//  ScheduleBoundaryManager
//
//  Created by DreamerMac on 12-5-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DFDragerAccessory.h"
#import "DFScheduleBoundaryManagerCell.h"

@implementation DFDragerAccessory
@synthesize superCellView,touchYInCellWhenTouchBegan;

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    touchYInCellWhenTouchBegan = [touch locationInView:superCellView].y;
    return [superCellView drager:self beginTrackingWithTouch:touch withEvent:event];
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    return [superCellView drager:self continueTrackingWithTouch:touch withEvent:event];
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [superCellView drager:self endTrackingWithTouch:touch withEvent:event];
    touchYInCellWhenTouchBegan = 0.0f;
}

- (void)cancelTrackingWithEvent:(UIEvent *)event{
    [superCellView drager:self cancelTrackingWithEvent:event];
    touchYInCellWhenTouchBegan = 0.0f;
}

- (void)dealloc{
    superCellView = nil;
    [super dealloc];
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self setNeedsDisplay];
}

#pragma mark - Draw
- (CGGradientRef)newGradientWithColors:(UIColor**)colors locations:(CGFloat*)locations count:(int)count 
{
	CGFloat* components = malloc(sizeof(CGFloat)*4*count);
	for (int i = 0; i < count; ++i) {
		UIColor* color = colors[i];
		size_t n = CGColorGetNumberOfComponents(color.CGColor);
		const CGFloat* rgba = CGColorGetComponents(color.CGColor);
		if (n == 2) {
			components[i*4] = rgba[0];
			components[i*4+1] = rgba[0];
			components[i*4+2] = rgba[0];
			components[i*4+3] = rgba[1];
		} else if (n == 4) {
			components[i*4] = rgba[0];
			components[i*4+1] = rgba[1];
			components[i*4+2] = rgba[2];
			components[i*4+3] = rgba[3];
		}
	}
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGColorSpaceRef space = CGBitmapContextGetColorSpace(context);
	CGGradientRef _gradient = CGGradientCreateWithColorComponents(space, components, locations, count);
	free(components);
	return _gradient;
}

void contextAddRoundCornerRect(CGContextRef context, CGRect rect,CGFloat radius)
{
    CGFloat minx = CGRectGetMinX(rect) , midx = CGRectGetMidX(rect), maxx = CGRectGetMaxX(rect) ;
	CGFloat miny = CGRectGetMinY(rect) , midy = CGRectGetMidY(rect) , maxy = CGRectGetMaxY(rect) ;
    CGContextMoveToPoint(context, minx, midy);
	CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
	CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
	CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
	CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
    
}

- (void)drawRect:(CGRect)rect{
    CGRect theRect = CGRectInset(rect, 3.0f, 3.0f);
    
    CGFloat barHeight = theRect.size.width * 0.236 ;
    CGFloat marginHeight = 0.5 * theRect.size.width;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor* colors[] = {
        [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.5f],
        [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.1f]
    };
    CGGradientRef gradient = [self newGradientWithColors:colors locations:nil count:2];
    
    
    CGFloat frameX = CGRectGetMinX(theRect);
    CGFloat frameY = CGRectGetMinY(theRect);
    if (theRect.size.height < 2 * marginHeight) {
        NSLog(@"%f",theRect.size.height);
        
        CGRect frame = CGRectMake(frameX, frameY + (theRect.size.height - barHeight) / 2, theRect.size.width, barHeight);
        
        CGContextSaveGState(context);
        contextAddRoundCornerRect(context, frame, barHeight / 2);
        CGContextClosePath(context);
        CGContextClip(context);
        CGContextDrawLinearGradient(context, gradient, frame.origin, CGPointMake(frame.origin.x, frame.origin.y + frame.size.height), kCGGradientDrawsAfterEndLocation);
        CGContextRestoreGState(context);
        
    }else{
        CGRect topFrame = CGRectMake(frameX, frameY + theRect.size.height / 2 - marginHeight, theRect.size.width, barHeight);
        CGRect middleFrame = CGRectMake(frameX, frameY + (theRect.size.height - barHeight) / 2, theRect.size.width, barHeight);
        CGRect bottomFrame = CGRectMake(frameX, frameY + theRect.size.height / 2 + marginHeight - barHeight, theRect.size.width, barHeight);
        
        CGContextSaveGState(context);
        contextAddRoundCornerRect(context, topFrame, barHeight / 2);
        CGContextClosePath(context);
        CGContextClip(context);
        CGContextDrawLinearGradient(context, gradient, topFrame.origin, CGPointMake(topFrame.origin.x, topFrame.origin.y + topFrame.size.height), kCGGradientDrawsAfterEndLocation);
        CGContextRestoreGState(context);
        
        CGContextSaveGState(context);
        contextAddRoundCornerRect(context, middleFrame, barHeight / 2);
        CGContextClosePath(context);
        CGContextClip(context);
        CGContextDrawLinearGradient(context, gradient, middleFrame.origin, CGPointMake(middleFrame.origin.x, middleFrame.origin.y + middleFrame.size.height), kCGGradientDrawsAfterEndLocation);
        CGContextRestoreGState(context);
        
        CGContextSaveGState(context);
        contextAddRoundCornerRect(context, bottomFrame, barHeight / 2);
        CGContextClosePath(context);
        CGContextClip(context);
        CGContextDrawLinearGradient(context, gradient, bottomFrame.origin, CGPointMake(bottomFrame.origin.x, bottomFrame.origin.y + bottomFrame.size.height), kCGGradientDrawsAfterEndLocation);
        CGContextRestoreGState(context);
        
    }
    
    CGGradientRelease(gradient);
}

@end
