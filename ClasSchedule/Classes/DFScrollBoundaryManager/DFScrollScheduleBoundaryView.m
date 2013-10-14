//
//  DFScrollScheduleBoundaryView.m
//  ScheduleBoundaryManager
//
//  Created by DreamerMac on 12-5-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DFScrollScheduleBoundaryView.h"
#import "DFScheduleBoundaryManager.h"
#import "DFTime.h"

@implementation DFScrollScheduleBoundaryView

#pragma mark - Frames
#define kScheduleBoundaryManagerOffset 30.0f

- (CGRect)locateScheduleBoundaryManager:(DFScheduleBoundaryManager*)aManager underMode:(TimeDependenceMode)aMode
{
    CGRect frame = CGRectZero;
    switch (aMode) {
        case TimeDependenceModeIndependent:{
            frame = CGRectMake(0.0f, 0.0f, self.contentSize.width, self.contentSize.height);
            [scheduleBoundaryManager setFrame:frame];
            break;
        }
        case TimeDependenceModeDependent:{
            CGRect labelFrame = [self locateScaleLabel:nil atIndex:0];
            CGFloat gapFromScaleLabel = 5.0f;
            CGFloat x = labelFrame.origin.x + labelFrame.size.width + gapFromScaleLabel;
            CGFloat width = self.contentSize.width - x;
            CGFloat y = kScheduleBoundaryManagerOffset;
            CGFloat height = self.contentSize.height - kScheduleBoundaryManagerOffset;
            frame = CGRectMake(x, y, width, height);
            [scheduleBoundaryManager setFrame:frame];
            break;
        } 
        default:
            break;
    }
    [aManager setFrame:frame];
    return frame;
}

- (CGRect)locateScaleLabel:(UIView*)aView atIndex:(NSUInteger)anIndex
{
    CGFloat width = 30.0f;
    CGFloat height = 20.0f;
    CGFloat x = 5.0f;
    
    NSDate* theTime = [NSDate timeWithTimeInterval:anIndex * 60 * 60 sinceTime:[NSDate timeWithHour:0 minute:0 second:0]];
    CGFloat y = [scheduleBoundaryManager locationFromTime:theTime] + kScheduleBoundaryManagerOffset - height / 2;
    
    CGRect frame = CGRectMake(x, y, width, height);
    [aView setFrame:frame];
    return frame;
}

#pragma mark - Subviews
- (void)configureScaleLabel:(UILabel*)aLabel atIndex:(NSUInteger)anIndex
{
    [self locateScaleLabel:aLabel atIndex:anIndex];
    
    [aLabel setAdjustsFontSizeToFitWidth:YES];
    [aLabel setFont:[UIFont fontWithName:@"ChalkboardSE-Bold" size:16.0f]];
    [aLabel setTextColor:[UIColor whiteColor]];
    [aLabel setBackgroundColor:[UIColor clearColor]];

    if (anIndex == 12) {
        [aLabel setText:@"Noon"];
    }else{
        NSDate* theTime = [NSDate timeWithTimeInterval:anIndex * 60 * 60 sinceTime:[NSDate timeWithHour:0 minute:0 second:0]];
        [aLabel setText:[theTime stringInFormat:@"HH:mm"]];
    }
}

- (void)createScaleLabels
{
    NSMutableArray* array = [[NSMutableArray alloc] initWithCapacity:24];
    
    NSUInteger index = 0;
    UILabel* pLabel = nil;
    for (index = 0; index < 24; index++) {
        pLabel = [[UILabel alloc] init];
        [array addObject:pLabel];
        [pLabel release];
        [self addSubview:pLabel];
        
        [self configureScaleLabel:pLabel atIndex:index];
    }
    scaleLabels = [[NSArray alloc] initWithArray:array];
    [array release];
}

- (void)destroyScaleLabels
{
    for (UILabel* pLabel in scaleLabels) {
        [pLabel removeFromSuperview];
    }
    
    [scaleLabels release];
    scaleLabels = nil;
}

- (void)loadSubviews
{
    [scheduleBoundaryManager addIntoView:self];
}

- (void)removeFromSuperview{
    [scheduleBoundaryManager removeFromSuperview];
    [super removeFromSuperview];
}

#pragma mark - Schedule Boundary Manager
- (void)reloadData
{
    [scheduleBoundaryManager reloadData];
}

- (DFScheduleBoundaryManagerCell*)cellAtIndex:(NSUInteger)anIndex
{
    return [scheduleBoundaryManager cellAtIndex:anIndex];
}

- (void)setContentSize:(CGSize)contentSize{
    [super setContentSize:contentSize];
    [self locateScheduleBoundaryManager:scheduleBoundaryManager underMode:scheduleBoundaryManager.timeDependenceMode];
}

- (void)setDataSource:(id<DFScheduleBoundaryManagerDataSource>)dataSource
{
    [scheduleBoundaryManager setDataSource:dataSource];
}

- (void)setBeginTime:(NSDate *)beginTime
{
    [scheduleBoundaryManager setBeginTime:beginTime];
}

- (void)setDuration:(NSTimeInterval)duration
{
    [scheduleBoundaryManager setDuration:duration];
}

- (void)setMinTimeScale:(NSTimeInterval)minTimeScale
{
    [scheduleBoundaryManager setMinTimeScale:minTimeScale];
}

- (void)setBeginTimeWithHour:(NSInteger)anHour minute:(NSUInteger)aMinute second:(NSUInteger)aSecond
{
    [scheduleBoundaryManager setBeginTimeWithHour:anHour minute:aMinute second:aSecond];
}

- (void)setTimeDependenceMode:(TimeDependenceMode)timeDependenceMode
{
    [scheduleBoundaryManager setTimeDependenceMode:timeDependenceMode];
}

- (void)setTimeDependenceMode:(TimeDependenceMode)aTimeDependenceMode animated:(BOOL)animated
{
    switch (aTimeDependenceMode) {
        case TimeDependenceModeIndependent:{
            [self locateScheduleBoundaryManager:scheduleBoundaryManager underMode:aTimeDependenceMode];
            [self destroyScaleLabels];
            break;
        }
        case TimeDependenceModeDependent:{
            [self locateScheduleBoundaryManager:scheduleBoundaryManager underMode:aTimeDependenceMode];
            [self createScaleLabels];   //Scale Labels' Location depend on scheduelBoundaryManager's frame. AKA previous sentence.
            break;
        } 
        default:
            break;
    }
    [scheduleBoundaryManager setTimeDependenceMode:aTimeDependenceMode animated:animated];
}

#pragma mark - Lifecycle
- (id)init{
    if (self = [super init]) {
        scheduleBoundaryManager = [[DFScheduleBoundaryManager alloc] init];
    }
    return self;
}

- (void)dealloc{

    [scheduleBoundaryManager removeFromSuperview];

    [scheduleBoundaryManager release];
    scheduleBoundaryManager = nil;
    
    [scaleLabels release];
    scaleLabels = nil;
}

@end
