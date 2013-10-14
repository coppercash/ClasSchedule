//
//  DFCourseIconView.m
//  ClasSchedule
//
//  Created by DreamerMac on 12-4-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DFCourseIconView.h"

@implementation DFCourseIconView
@synthesize tintColor;
@synthesize isWithRoundCorner,roundCornerRadius,useIconImage,iconImage,sendTouchToSuperview;

CGFloat alpha = 0.6f;
#define kAlpha  0.6f

- (void)setTintColor:(UIColor *)aTintColor
{
    [tintColor release];
    tintColor = [aTintColor retain];
    [self setNeedsDisplay];
}

- (UIColor*)defaultTintColor
{
    CGFloat theAlpha = kAlpha;
    UIColor* defaultColor = nil;
    if (tintColor) {
        const CGFloat* components = CGColorGetComponents(tintColor.CGColor);
        CGFloat red = components[0],green = components[1],blue = components[2];
        defaultColor = [UIColor colorWithRed:red green:green blue:blue alpha:theAlpha];
        
    }else{
        defaultColor = [UIColor colorWithRed:0.5f green:0.5f blue:0.5f alpha:theAlpha];
    }
    
    return defaultColor;
}

- (CGGradientRef)rayGradientColor
{
    //CGFloat theAlpha = alpha;
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
	CGFloat colors[] =
	{
		255.0 / 255.0, 255.0 / 255.0, 255.0 / 255.0, 1.0f,
		255.0 / 255.0, 255.0 / 255.0, 255.0 / 255.0, 0.0f,
	};
	CGGradientRef gradien =  CGGradientCreateWithColorComponents(rgb, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));
    CGColorSpaceRelease(rgb);
    return gradien;
}

- (CGGradientRef)topGradientColor
{
    CGFloat theAlpha = kAlpha;
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
	CGFloat colors[] =
	{
		155.0 / 255.0, 155.0 / 255.0, 155.0 / 255.0, theAlpha,
		70.0 / 255.0, 70.0 / 255.0, 70.0 / 255.0, theAlpha,
	};
	CGGradientRef gradien =  CGGradientCreateWithColorComponents(rgb, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));
    CGColorSpaceRelease(rgb);
    return gradien;
}

- (CGGradientRef)bottomGradientColor
{
    CGFloat theAlpha = kAlpha;
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    CGFloat colors2[] =
	{
		20.0 / 255.0, 20.0 / 255.0, 20.0 / 255.0, theAlpha,
		0.0 / 255.0, 0.0 / 255.0, 0.0 / 255.0, theAlpha,
	};
	CGGradientRef gradien = CGGradientCreateWithColorComponents(rgb, colors2, NULL, sizeof(colors2)/(sizeof(colors2[0])*4));
    CGColorSpaceRelease(rgb);
    return gradien;
}

- (void)drawGlassInRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self makePathCircleCornerRect:rect radius:self.roundCornerRadius];
	CGContextClip(context);
    
    CGGradientRef topGradient = [self topGradientColor];
    CGContextDrawLinearGradient(context, topGradient, CGPointMake(0, rect.origin.y), CGPointMake(0, rect.size.height / 2), 0);
    CGGradientRelease(topGradient);
    
    CGGradientRef bottomGradient = [self bottomGradientColor];
    CGContextDrawLinearGradient(context, bottomGradient, CGPointMake(0, rect.size.height / 2), CGPointMake(0, rect.size.height), 0);
    CGGradientRelease(bottomGradient);

    CGContextSaveGState(context);
}

- (void)drawBackgroudColorInRect:(CGRect)aRect
{
    CGFloat theAlpha = kAlpha;
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self makePathCircleCornerRect:aRect radius:self.roundCornerRadius];
    
    const CGFloat* components = CGColorGetComponents([self defaultTintColor].CGColor);
    CGFloat red = components[0],green = components[1],blue = components[2];
    CGContextSetRGBFillColor(context, red, green, blue, theAlpha);
    
    CGContextFillPath(context);
    //CGContextSaveGState(context);
}

- (void)makePathCircleCornerRect:(CGRect)rect radius:(CGFloat)radius
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect theRect = rect;
    CGFloat theRoundCornerRadius = radius;
    
    CGFloat minx = CGRectGetMinX(theRect) , midx = CGRectGetMidX(theRect), maxx = CGRectGetMaxX(theRect) ;
	CGFloat miny = CGRectGetMinY(theRect) , midy = CGRectGetMidY(theRect) , maxy = CGRectGetMaxY(theRect) ;
    
    CGContextMoveToPoint(context, minx, midy);
	CGContextAddArcToPoint(context, minx, miny, midx, miny, theRoundCornerRadius);
	CGContextAddArcToPoint(context, maxx, miny, maxx, midy, theRoundCornerRadius);
	CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, theRoundCornerRadius);
	CGContextAddArcToPoint(context, minx, maxy, minx, midy, theRoundCornerRadius);
	
	CGContextClosePath(context);
}




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

- (NSString*)iconPath
{
    NSString* iconPath = nil;
    iconPath = [[NSBundle mainBundle] pathForResource:@"DefaultCourseIcon" ofType:@"png"];
    return iconPath;
}

- (void)drawIconInRect:(CGRect)rect
{
    if (useIconImage) {
        UIImage* image = nil;
        if (iconImage) {
            image = iconImage;
            [image drawInRect:rect];
        }else{
            image = [[UIImage alloc] initWithContentsOfFile:[self iconPath]];
            [image drawInRect:rect];
            [image release];
        }
    }
}

- (void)drawRect:(CGRect)rect
{
    CGFloat iconInsetSize = 5.0f;
    //[self drawGlassInRect:rect];
    [self drawBackgroudColorInRect:rect];
    [self drawGlassInRect:rect];
    [self drawIconInRect:CGRectInset(rect, iconInsetSize, iconInsetSize)];

}
#pragma mark - Touch Event
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //UIView* view = self.superview;
    if(sendTouchToSuperview) [self.superview touchesBegan:touches withEvent:event];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    if(sendTouchToSuperview) [self.superview touchesMoved:touches withEvent:event];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if(sendTouchToSuperview) [self.superview touchesEnded:touches withEvent:event];
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    if(sendTouchToSuperview) [self.superview touchesCancelled:touches withEvent:event];
}
#pragma mark - Lifecycle
- (CGFloat)roundCornerRadius
{
    CGFloat theRoundCornerRadius = 0.0f;
    if (isWithRoundCorner) {
        if (roundCornerRadius) {
            theRoundCornerRadius = roundCornerRadius;
        }else{
            theRoundCornerRadius = self.bounds.size.width * 0.1;
        }
    }
    return theRoundCornerRadius;
}

- (id)init{
    if (self = [super init]) {
        [self setBackgroundColor:[UIColor clearColor]];
        
        tintColor = nil;
        
        isWithRoundCorner = YES;
        roundCornerRadius = 0.0f;
        
        useIconImage = YES;
        iconImage = nil;
        
        sendTouchToSuperview = NO;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        tintColor = nil;
        
        isWithRoundCorner = YES;
        roundCornerRadius = 0.0f;
        
        useIconImage = YES;
        iconImage = nil;
        
        sendTouchToSuperview = NO;
    }
    return self;
}

- (void)dealloc{
    [tintColor release];
    tintColor = nil;
    
    [iconImage release];
    iconImage = nil;
    
    [super dealloc];
}

@end
