//
//  DayCell.m
//  ClasSchedule
//
//  Created by DreamerMac on 12-2-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DayCell.h"
#import "Header.h"

@implementation DayCell

@synthesize schedule,isFocused,isWeekdayFocused;

#pragma mark - Frames
#define kFocusedHeight  150.0f
#define kNotFocusedHeight   100.0f

#define kShadowVerticalOffsetWhenFocused    30.0f
#define kShadowVerticalOffsetWhenNotFocused 7.0f

+ (CGFloat)heightWhenFocused
{
    return kFocusedHeight;
}

+ (CGFloat)heightWhenNotFocused
{
    return kNotFocusedHeight;
}

- (CGRect)gradientBackgroundFrame
{
    CGFloat shrinkX = 10.0f;
    CGFloat shrinkY = 10.0f;
    CGRect rect = CGRectInset(self.bounds, shrinkX, shrinkY);
    return rect;
}

#pragma mark - loadSubviews
- (void)loadSubviews
{
    UIView* contentView = self.contentView;
    while ([contentView.subviews count]) {
        [contentView.subviews.lastObject removeFromSuperview];
    }
    if (self.isFocused) {
        [self loadFocusedSubviews];
    }else{
        [self loadNotFocusedSubviews];
    }
}

- (void)loadFocusedSubviews
{
    UIView* xibView = [[[NSBundle mainBundle] loadNibNamed:@"DayCellFocused" owner:self options:nil] objectAtIndex:0];
    [self.contentView addSubview:xibView];
    
    Course* theCourse = schedule.course;

    UIColor* tintColor = [CSDataCenter getColorFromCourseExtensionInfo:theCourse.courseExtension];
    [_IconView setTintColor:tintColor];
    [_IconView setSendTouchToSuperview:YES];
    
    [_CourseName setText:theCourse.name];
    //[_CourseName setAdjustsFontSizeToFitWidth:YES];

    [_LocationLabel setText:theCourse.room];
    [_LocationLabel setAdjustsFontSizeToFitWidth:YES];
   
    [_InstructorName setText:theCourse.teacher];
    [_InstructorName setAdjustsFontSizeToFitWidth:YES];

    NSString* numberOfNotesString = [[NSString alloc] initWithFormat:@"%d",[theCourse.notes count]];
    [_NotesLabel setText:numberOfNotesString];
    [numberOfNotesString release];
    
    float firstProgress = 0.0;
    if(isWeekdayFocused){
        firstProgress = [self progressDuringClassByRowInfo:schedule.rowInfo];
        classProgressUpdater = [self newClassProgressUpdater];
    }    
    [_ClassProgress setProgress:firstProgress];

}

- (void)loadNotFocusedSubviews
{
    UIView* xibView = [[[NSBundle mainBundle] loadNibNamed:@"DayCellNotFocused" owner:self options:nil] objectAtIndex:0];
    [self.contentView addSubview:xibView];
    
    Course* theCourse = schedule.course;

    UIColor* tintColor = [CSDataCenter getColorFromCourseExtensionInfo:theCourse.courseExtension];
    [_IconView setTintColor:tintColor];
    [_IconView setSendTouchToSuperview:YES];
    
    [_CourseName setAdjustsFontSizeToFitWidth:YES];
    [_CourseName setText:theCourse.name];
    
    //NSString* path = [[NSBundle mainBundle] pathForResource:@"Location" ofType:@"png"];
    //UIImage* image = [[UIImage alloc] initWithContentsOfFile:path];
    //[_LocationIcon setImage:image];
    //[image release];
    
    [_LocationLabel setText:theCourse.room];
    [_LocationLabel setAdjustsFontSizeToFitWidth:YES];
}

#pragma mark - Shadow
- (void)setShadowOffset:(CGSize)aShadowOffset{
    if (CGSizeEqualToSize(aShadowOffset, CGSizeZero)) {
        [self.layer setShadowPath:NULL];
        [self.layer setShadowOffset:CGSizeMake(0.0f, -0.3f)];
        [self.layer setShadowRadius:3.0f];
        [self.layer setShadowOpacity:0.0f];
        [self.layer setShadowColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f].CGColor];
    }else {
        [self.layer setShadowPath:[self shadowPath]];
        [self.layer setShadowOffset:aShadowOffset];
        [self.layer setShadowRadius:10.0f];
        [self.layer setShadowOpacity:1.0f];
        [self.layer setShadowColor:[UIColor blackColor].CGColor];
    }
    /*
     Move shadow to the top of layers
     */
    if (aShadowOffset.height == kShadowVerticalOffsetWhenFocused) {
        [self.layer retain];
        CALayer* superLayer = self.layer.superlayer;
        [self.layer removeFromSuperlayer];
        [superLayer addSublayer:self.layer];
        [self.layer release];
    }
}

- (CGPathRef)shadowPath
{
    CGRect shadowRect = [self gradientBackgroundFrame];
    return [UIBezierPath bezierPathWithRect:shadowRect].CGPath;
}

#pragma mark - Progress
- (NSTimer*)newClassProgressUpdater
{
    
    NSTimeInterval timeInterval = 1.0;
    if (classProgressUpdater) {
        [classProgressUpdater invalidate];
        [classProgressUpdater release];
    }
    
    NSDate* firstFireDate = [[NSDate alloc] initWithTimeIntervalSinceNow:timeInterval];
    NSTimer* newTimer = [[NSTimer alloc] initWithFireDate:firstFireDate interval:timeInterval target:self selector:@selector(updateClassProgressByTimer:) userInfo:nil repeats:YES];
    
    NSRunLoop* currentRunRoop = [NSRunLoop currentRunLoop];
    [currentRunRoop addTimer:newTimer forMode:NSDefaultRunLoopMode];
    
    [firstFireDate release];
    
    return newTimer;
}

- (float)progressDuringClassByRowInfo:(RowsInfo*)aRowInfo
{
    NSDate* now = [[NSDate alloc] init];
    NSDate* standardNow = [CSDataCenter getStandardDateFromDate:now];
    [now release];
    
    NSDate* startTime = aRowInfo.startTime;
    NSDate* endTime = aRowInfo.endTime;
    
    NSTimeInterval classContinuation = [endTime timeIntervalSinceDate:startTime];
    NSTimeInterval finishContinuation = [standardNow timeIntervalSinceDate:startTime];
    
    float result = finishContinuation / classContinuation;
    /*
     if (result < 0.0) {
     result = 0.0;
     }else if(result > 1.0){
     result = 1.0;
     }*/
    return result;
}

- (void)updateClassProgressByTimer:(NSTimer*)theTimer
{
    float progress = [self progressDuringClassByRowInfo:schedule.rowInfo];
    [_ClassProgress setProgress:progress];
}

#pragma mark - Gradient Background
- (void)drawGradientBackground:(CGRect)aRect
{
    /*Configure Here*/
    CGFloat roundSize = 10.0f;
    
    UIColor* colors[] = {[UIColor whiteColor], [UIColor lightGrayColor]};
    
    /*Start to draw*/
    CGRect theRect = [self gradientBackgroundFrame];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
	CGFloat minx = CGRectGetMinX(theRect) , midx = CGRectGetMidX(theRect), maxx = CGRectGetMaxX(theRect) ;
	CGFloat miny = CGRectGetMinY(theRect) , midy = CGRectGetMidY(theRect) , maxy = CGRectGetMaxY(theRect) ;
	
	CGContextMoveToPoint(context, minx, midy);
	CGContextAddArcToPoint(context, minx, miny, midx, miny, roundSize);
	CGContextAddArcToPoint(context, maxx, miny, maxx, midy, roundSize);
	CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, roundSize);
	CGContextAddArcToPoint(context, minx, maxy, minx, midy, roundSize);
	
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

- (void)drawRect:(CGRect)rect {
    [self drawGradientBackground:rect];

}

#pragma mark - Memory Management
- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSUInteger numberOfSubviews = [self.subviews count];
    
    UIView *delAccessory = nil;
    UIView *delButton = nil;
    if (self.editing) {
        if (self.showingDeleteConfirmation) {
            if (numberOfSubviews == 2) {
                delButton = [self.subviews objectAtIndex:1];
            }else if (numberOfSubviews == 3) {
                delAccessory = [self.subviews objectAtIndex:1];
                delButton = [self.subviews objectAtIndex:2];
            }
        }else{
            delAccessory = [self.subviews objectAtIndex:1];
        }
    }
    [delAccessory setFrame:CGRectOffset(delAccessory.frame, 10.0f, 0.0f)];
    [delButton setFrame:CGRectOffset(delButton.frame, -10.0f, 0.0f)];

    
    if (self.isFocused) {
        [self setShadowOffset:CGSizeMake(0.0f, kShadowVerticalOffsetWhenFocused)];
    }else{
        //[self setShadowOffset:CGSizeMake(0.0f, kShadowVerticalOffsetWhenNotFocused)];
        [self setShadowOffset:CGSizeZero];
    }
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // Initialization code
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        isFocused = NO;
    }
    return self;
}

- (void)dealloc{
    
    [schedule release];
    schedule = nil;
    
    [_IconView removeFromSuperview];
    [_IconView release];
    _IconView = nil;

    [_CourseName removeFromSuperview];
    [_CourseName release];
    _CourseName = nil;
    
    [_InstructorIcon removeFromSuperview];
    [_InstructorIcon release];
    _InstructorIcon = nil;
    
    [_InstructorName removeFromSuperview];
    [_InstructorName release];
    _InstructorName = nil;
    
    [_LocationIcon removeFromSuperview];
    [_LocationIcon release];
    _LocationIcon = nil;
    
    [_LocationLabel removeFromSuperview];
    [_LocationLabel release];
    _LocationLabel = nil;
    
    [_ClassProgress removeFromSuperview];
    [_ClassProgress release];
    _ClassProgress = nil;
    
    [super dealloc];
    
}

@end
