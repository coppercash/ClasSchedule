//
//  DFScheduleBoundaryManagerCell.m
//  ScheduleBoundaryManager
//
//  Created by DreamerMac on 12-5-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DFScheduleBoundaryManagerCell.h"
#import "DFScheduleBoundaryManager.h"
#import "DFButtonsManager.h"
#import "DFDragerAccessory.h"
#import "DFStretcherAccessory.h"
#import "DFTime.h"

@implementation DFScheduleBoundaryManagerCell
@synthesize manager,beginTime,duration;

#define kShowHideAccessoryAnimationDuration 0.5
#define kBeginEndLabelFontSize 14.0f
#define kFontName @"ChalkboardSE-Bold"

#pragma mark - Frame
- (CGRect)locateDrager:(UIView*)aView
{
    CGFloat rightMargin = 20.0f;
    CGFloat dWidth = 30.0f;
    CGFloat dHeight = dWidth;
    
    
    CGFloat selfWidth = self.frame.size.width;
    CGFloat selfHeight = self.frame.size.height;
    
    CGFloat width = (selfWidth > dWidth) ? dWidth : selfWidth;
    CGFloat height = (selfHeight > dHeight) ? dHeight : selfHeight;
    
    CGFloat x = self.frame.size.width - width - rightMargin;
    CGFloat y = self.frame.size.height / 2 - height / 2;
    
    CGRect frame = CGRectMake(x, y, width, height);
    [aView setFrame:frame];
    return frame;
}

- (CGRect)locateStretcher:(UIView*)aView
{
    [aView setFrame:self.bounds];
    return self.bounds;
}

- (CGRect)locateBeginTimeLabel:(UIView*)aView
{
    CGFloat height = 12.0f;
    CGFloat width= 31.0f;
    CGFloat leftMargin = 2.0f;

    CGFloat x = leftMargin;
    
    CGFloat y = 0.0f;
    if (height < self.frame.size.height / 2) {
        y = 0.0f;
    }else{
        y = - height;
    }
    //height = minHeight;
    
    CGRect frame = CGRectMake(x, y, width, height);
    [aView setFrame:frame];
    return frame;
    
    
}

- (CGRect)locateEndTimeLabel:(UIView*)aView
{
    //CGFloat minHeight = 12.0f;

    CGRect beginTimeLabelFrame = [self locateBeginTimeLabel:nil];
    
    CGFloat x = beginTimeLabelFrame.origin.x;
    CGFloat width= beginTimeLabelFrame.size.width;
    CGFloat height = beginTimeLabelFrame.size.height;

    CGFloat y = 0.0f;
    if (beginTimeLabelFrame.origin.y >= 0) {
        y = self.frame.size.height - height;
    }else{
        y = self.frame.size.height;
    }
    
    CGRect frame = CGRectMake(x, y, width, height);
    [aView setFrame:frame];
    return frame;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self locateBeginTimeLabel:beginTimeLabel];
    [self locateEndTimeLabel:endTimeLabel];
}

#pragma mark - Subviews
- (void)loadSubiews
{
    UIView* theView = self;
    if (!beginTimeLabel) {
        beginTimeLabel = [[UILabel alloc] init];
        [theView addSubview:beginTimeLabel];
    }
    [self configureBeginTimeLabel];
    
    if (!endTimeLabel) {
        endTimeLabel = [[UILabel alloc] init];
        [theView addSubview:endTimeLabel];
    }
    [self configureEndTimeLabel];
    
    if (manager.timeDependenceMode == TimeDependenceModeDependent) {
        if (!stretcher) {
            stretcher = [[DFStretcherAccessory alloc] init];
            [theView addSubview:stretcher];
        }
        [self configureStretcher];
        
        if (!drager) {
            drager = [[DFDragerAccessory alloc] init];
            [theView addSubview:drager];
        }
        [self configureDrager];
    }
}

- (void)configureDrager
{
    DFDragerAccessory* theDrager = drager;
    [self locateDrager:theDrager];
    [theDrager setSuperCellView:self];
    [theDrager setBackgroundColor:[UIColor clearColor]];
    [theDrager setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin];
}

- (void)configureStretcher
{
    DFStretcherAccessory* theStretcher = stretcher;
    [self locateStretcher:theStretcher];
    [theStretcher setSuperCellView:self];
    [theStretcher setBackgroundColor:[UIColor clearColor]];
    [theStretcher setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
}

- (void)configureBeginTimeLabel
{
    UILabel* theLabel = beginTimeLabel;
    [self locateBeginTimeLabel:theLabel];
    
    [theLabel setText:[self.beginTime stringInFormat:@"HH:mm"]];
    [theLabel setTextColor:[UIColor whiteColor]];
    [theLabel setBackgroundColor:[UIColor clearColor]];
    [theLabel setFont:[UIFont fontWithName:kFontName size:kBeginEndLabelFontSize]];
    [theLabel setAdjustsFontSizeToFitWidth:YES];
}

- (void)configureEndTimeLabel
{
    UILabel* theLabel = endTimeLabel;
    [self locateEndTimeLabel:theLabel];
    
    [theLabel setText:[[self.beginTime timeByAddingTimeInterval:self.duration] stringInFormat:@"HH:mm"]];
    [theLabel setTextColor:[UIColor whiteColor]];
    [theLabel setBackgroundColor:[UIColor clearColor]];
    [theLabel setFont:[UIFont fontWithName:kFontName size:kBeginEndLabelFontSize]];
    [theLabel setAdjustsFontSizeToFitWidth:YES];
}
#pragma mark - Mode Convert
- (void)showStretcher
{
    UIView* theView = self;
    if (!stretcher) {
        stretcher = [[DFStretcherAccessory alloc] init];
        [theView addSubview:stretcher];
    }
    [self configureStretcher];
}

- (void)hideStretcher
{
    [stretcher removeFromSuperview];
    [stretcher release];
    stretcher = nil;
}

- (void)showDragerAnimated:(BOOL)animated
{
    UIView* theView = self;
    
    if (animated) {
        if (!drager) {
            drager = [[DFDragerAccessory alloc] init];
            [drager setAlpha:1.0f];
            [theView addSubview:drager];
        }
        [self configureDrager];
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        [UIView beginAnimations:@"showStretcherAnimated:" context:context];
        //[UIView setAnimationDelegate:self];
        //[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
        [UIView setAnimationDuration:kShowHideAccessoryAnimationDuration]; 
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        
        [drager setAlpha:1.0f];
        
        [UIView commitAnimations];
        
    }else{
        if (!drager) {
            drager = [[DFDragerAccessory alloc] init];
            [theView addSubview:drager];
        }
        [self configureDrager];
    }
}

- (void)hideDragerAnimated:(BOOL)animated
{
    if (animated) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        [UIView beginAnimations:@"hideDragerAnimated:" context:context];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
        [UIView setAnimationDuration:kShowHideAccessoryAnimationDuration]; 
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        
        [drager setAlpha:0.0f];
        
        [UIView commitAnimations];
    }else{
        [drager removeFromSuperview];
        [drager release];
        drager = nil;
    }
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{
    if ([animationID isEqualToString:@"hideDragerAnimated:"]) {
        [drager removeFromSuperview];
        [drager release];
        drager = nil;
    }
}
#pragma mark - Drager Event
- (BOOL)drager:(DFDragerAccessory*)aDrager beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [manager beginDragingCell:self];
    return YES;
}

- (BOOL)drager:(DFDragerAccessory*)aDrager continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGFloat touchYInSuperView = [touch locationInView:self.superview].y;
    CGFloat cellYInSuperView = touchYInSuperView - drager.touchYInCellWhenTouchBegan;
    [manager cell:self dragedToY:cellYInSuperView];
    
    return YES;
}

- (void)drager:(DFDragerAccessory*)aDrager endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [manager endDragingCell:self];
}

- (void)drager:(DFDragerAccessory*)aDrager cancelTrackingWithEvent:(UIEvent *)event
{
    [manager endDragingCell:self];
}

#pragma mark - Strecher Event
- (BOOL)stretcher:(DFStretcherAccessory*)aStretcher beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [manager beingStretchingCell:self];
    return YES;
}

- (BOOL)stretcher:(DFStretcherAccessory*)aStretcher continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGFloat touchYInCell = [touch locationInView:self].y;
    CGFloat difference = touchYInCell - stretcher.touchYInCellWhenPreviousTouch;
    [manager cell:self stretchedForDifference:difference];
    
    return YES;
}

- (void)stretcher:(DFStretcherAccessory*)aStretcher endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [manager endStretchingCell:self];
}

- (void)stretcher:(DFStretcherAccessory*)aStretcher cancelTrackingWithEvent:(UIEvent *)event
{
    
}

#pragma mark - Locaion & Length
- (CGFloat)topLocation
{
    CGFloat managerOffset = manager.frame.origin.y;
    return self.frame.origin.y - managerOffset;
}

- (CGFloat)length
{
    return self.frame.size.height;
}

- (CGFloat)bottomLocation
{
    CGFloat managerOffset = manager.frame.origin.y;
    return self.frame.origin.y + self.frame.size.height - managerOffset;
}
#pragma mark - Private Setter
- (void)setY:(CGFloat)aY
{
    [self setFrame:CGRectMake(self.frame.origin.x, aY, self.frame.size.width, self.frame.size.height)];
}

- (void)setHeight:(CGFloat)aHeight
{
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, aHeight)];
    [self locateDrager:drager];
    [self locateBeginTimeLabel:beginTimeLabel];
    [self locateEndTimeLabel:endTimeLabel];
}

#pragma mark - Public Setter
- (void)setBeginTime:(NSDate *)aBeginTime{
    [beginTime release];
    beginTime = [aBeginTime retain];
    
    [beginTimeLabel setText:[self.beginTime stringInFormat:@"HH:mm"]];
    [endTimeLabel setText:[[self.beginTime timeByAddingTimeInterval:self.duration] stringInFormat:@"HH:mm"]];
}

- (void)setDuration:(NSTimeInterval)aDuration{
    duration = aDuration;
    
    [endTimeLabel setText:[[self.beginTime timeByAddingTimeInterval:self.duration] stringInFormat:@"HH:mm"]];
}

- (void)setBeginTime:(NSDate *)aBeginTime animated:(BOOL)animated
{
    
    CGFloat newLocation = [manager locationFromTime:aBeginTime];
    
    if (animated) {
        [UIView animateWithDuration:0.1f animations:^{[self setLocation:newLocation];}];
    }else{
        [self setLocation:newLocation];
    }
    
    [self setBeginTime:aBeginTime];

    //[beginTimeLabel setText:[self.beginTime stringInFormat:@"HH:mm"]];
    //[endTimeLabel setText:[[self.beginTime timeByAddingTimeInterval:self.duration] stringInFormat:@"HH:mm"]];
}

- (void)setDuration:(NSTimeInterval)aDuration animated:(BOOL)animated
{
    
    CGFloat newLength = [manager lengthFromDuration:aDuration];
    
    if (animated) {
        [UIView animateWithDuration:0.1f animations:^{[self setLength:newLength];}];
    }else{
        [self setLength:newLength];
    }
    
    [self setDuration:aDuration];

    //[endTimeLabel setText:[[self.beginTime timeByAddingTimeInterval:self.duration] stringInFormat:@"HH:mm"]];
}

- (void)setLocation:(CGFloat)aLocation
{
    CGFloat y = aLocation + manager.frame.origin.y;
    [self setY:y];
    
    [beginTimeLabel setText:[[manager timeFromLocation:aLocation] stringInFormat:@"HH:mm"]];
    [endTimeLabel setText:[[[manager timeFromLocation:aLocation] timeByAddingTimeInterval:self.duration] stringInFormat:@"HH:mm"]];
}

- (void)setLength:(CGFloat)aLength
{
    [self setHeight:aLength];
    
    [endTimeLabel setText:[[self.beginTime timeByAddingTimeInterval:[manager durationFromLength:aLength]] stringInFormat:@"HH:mm"]];
}
/*
#pragma mark - Background
- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();

    BOOL isOdd = (([manager indexOfCell:self] % 2) == 0);
    if (isOdd) {
        CGContextSetRGBFillColor(context, 0.3, 0.4, 0.5, 0.7f);
    }else{
        CGContextSetRGBFillColor(context, 0.7, 0.6, 0.5, 0.7f);
    }
    
    CGContextFillRect(context, rect);
}
*/
#pragma mark - lifecycle
- (id)init{
    if (self = [super init]) {
        [self setAutoresizingMask:63];
    }
    return self;
}

- (void)dealloc{
    manager = nil;
    
    [beginTime release];
    
    [drager removeFromSuperview];
    [drager release];
    drager = nil;
    
    [stretcher removeFromSuperview];
    [stretcher release];
    stretcher = nil;
    
    [beginTimeLabel removeFromSuperview];
    [beginTimeLabel release];
    beginTimeLabel = nil;
    
    [endTimeLabel removeFromSuperview];
    [endTimeLabel release];
    endTimeLabel = nil;
    
    [super dealloc];
}
@end
