//
//  ScheduleFormCell.m
//  ClasSchedule
//
//  Created by DreamerMac on 12-3-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ScheduleFormCell.h"
#import "DFFormView.h"
#import "AppDelegate.h"
#import "CSDataCenter.h"
#import "Course.h"
#import "CourseExtension.h"

@implementation ScheduleFormCell
@synthesize course;
@synthesize courseName;

#pragma mark - Frame
- (CGRect)topAreaFrame
{
    CGFloat heightRatio = 0.3f;
    
    CGRect shrinkBounds = [self effectiveBounds];
    return CGRectMake(shrinkBounds.origin.x, shrinkBounds.origin.y, shrinkBounds.size.width, heightRatio * shrinkBounds.size.height);
}

- (CGRect)effectiveBounds
{
    CGFloat shrinkX = 1.0f;
    CGFloat shrinkY = 1.0f;
    CGRect shrinkBounds = CGRectInset(self.bounds, shrinkX, shrinkY);
    return shrinkBounds;
}

- (CGRect)locateCourseName
{
    UILabel* theCourseName = courseName;
    CGRect effectiveRect = [self effectiveBounds];
    CGRect topAreaRect = [self topAreaFrame];
    CGFloat x = topAreaRect.origin.x;
    CGFloat y = topAreaRect.origin.y + topAreaRect.size.height;
    CGFloat width = topAreaRect.size.width;
    CGFloat height = effectiveRect.size.height - 1.3 * topAreaRect.size.height;

    
    CGRect rect = CGRectMake(x, y, width, height);
    
    //[theCourseName setCenter:CGPointMake(x + rect.size.width / 2, y + rect.size.height / 2)];
    //[theCourseName setBounds:CGRectInset(rect, 2.0f, 0.0f)];
    [theCourseName setFrame:CGRectInset(rect, 2.0f, 0.0f)];
    return theCourseName.frame;
}

#pragma mark - show & hide Content
- (void)showContent{
    [super showContent];
    [courseName setAlpha:1.0f];
    [self setNeedsDisplay];
}

- (void)hideContent{
    [super hideContent];
    [courseName setAlpha:0.0f];
    [self setNeedsDisplay];
    
}

- (void)releaseContent{
    [course release];
    course = nil;
}

- (void)reloadContent{
    [super reloadContent];
    [courseName setText:course.name];
}
#pragma mark - Subviews
- (void)loadSubviews
{
    [super loadSubviews];
    
    if (courseName) {
        [courseName removeFromSuperview];
        [courseName release];
    }
    courseName = [[UILabel alloc] init];
    [self addSubview:courseName];
    [self configureCourseName:courseName];
    
    
    if(superFormView.isContentHidden){
        [self hideContent];
    }
}

- (void)configureCourseName:(UILabel*)aCourseName
{
    UILabel* theCourseName = aCourseName;
    [self locateCourseName];
    [theCourseName setBackgroundColor:[UIColor clearColor]];
    //[theCourseName setBackgroundColor:[UIColor colorWithRed:0.3f green:0.3f blue:0.3f alpha:0.7f]];

    [theCourseName setText:course.name];
    [theCourseName setFont:[UIFont fontWithName:@"ChalkboardSE-Bold" size:17.0f]];
    [theCourseName setAdjustsFontSizeToFitWidth:YES];
    [theCourseName setTextAlignment:UITextAlignmentCenter];
    [theCourseName setAutoresizingMask:63];

    //[theCourseName setBackgroundColor:[UIColor blueColor]];
}

- (void)drawTopArea
{
    CGFloat alpha = 0.5f;
    CGFloat topRoundSize = 4.0f;
    
    CourseExtension* extensionInfo = course.courseExtension;
    CGFloat red = [extensionInfo.red floatValue];
    CGFloat green = [extensionInfo.green floatValue];
    CGFloat blue = [extensionInfo.blue floatValue];
    CGRect theRect = [self topAreaFrame];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(context, red, green, blue, alpha);
    CGFloat minx = CGRectGetMinX(theRect) , midx = CGRectGetMidX(theRect), maxx = CGRectGetMaxX(theRect) ;
	CGFloat miny = CGRectGetMinY(theRect) , midy = CGRectGetMidY(theRect) , maxy = CGRectGetMaxY(theRect) ;
	CGContextMoveToPoint(context, minx, midy);
	CGContextAddArcToPoint(context, minx, miny, midx, miny, topRoundSize);
	CGContextAddArcToPoint(context, maxx, miny, maxx, midy, topRoundSize);
	CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, 0.0f);
	CGContextAddArcToPoint(context, minx, maxy, minx, midy, 0.0f);
	
	CGContextClosePath(context);
    CGContextFillPath(context);
}

- (void)drawGradientBackground:(CGRect)aRect
{
    /*Configure Here*/
    CGFloat shrinkX = 1.0f;
    CGFloat shrinkY = 1.0f;
    CGFloat topRoundSize = 4.0f;
    CGFloat bottomRoundSize = 4.0f;

    CGFloat alpha = 0.3f;
    if (course && !superFormView.isContentHidden) alpha = 1.0f;
    
    UIColor* topColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:alpha];
    UIColor* bottomColor = [UIColor colorWithRed:0.5f green:0.5f blue:0.5f alpha:alpha];
    
    /*Start to draw*/
    UIColor* colors[] = {topColor, bottomColor};
    CGRect theRect = CGRectInset(aRect, shrinkX, shrinkY);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGFloat minx = CGRectGetMinX(theRect) , midx = CGRectGetMidX(theRect), maxx = CGRectGetMaxX(theRect) ;
	CGFloat miny = CGRectGetMinY(theRect) , midy = CGRectGetMidY(theRect) , maxy = CGRectGetMaxY(theRect) ;
	CGContextMoveToPoint(context, minx, midy);
	CGContextAddArcToPoint(context, minx, miny, midx, miny, topRoundSize);
	CGContextAddArcToPoint(context, maxx, miny, maxx, midy, topRoundSize);
	CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, bottomRoundSize);
	CGContextAddArcToPoint(context, minx, maxy, minx, midy, bottomRoundSize);
	
	CGContextClosePath(context);
    CGContextClip(context);
	
	CGGradientRef _gradient = [self newGradientWithColors:colors locations:nil count:2];
	CGContextDrawLinearGradient(context, _gradient, CGPointZero, CGPointMake(theRect.origin.x, theRect.origin.y+theRect.size.height), kCGGradientDrawsAfterEndLocation);
	CGGradientRelease(_gradient);
	
	CGContextRestoreGState(context);
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

- (void)drawRect:(CGRect)rect{
    [self drawGradientBackground:rect];
    if (course && !superFormView.isContentHidden) {
        [self drawTopArea];
    }

}
#pragma mark - Lifecycle
- (void)dealloc{
    
    [course release];
    course = nil;
    
    [courseName removeFromSuperview];
    [courseName release];
    courseName = nil;
    
    [super dealloc];
}
@end
