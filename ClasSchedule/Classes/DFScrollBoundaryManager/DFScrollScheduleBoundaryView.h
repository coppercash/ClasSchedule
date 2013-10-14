//
//  DFScrollScheduleBoundaryView.h
//  ScheduleBoundaryManager
//
//  Created by DreamerMac on 12-5-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DFScheduleBoundaryManager.h"

@interface DFScrollScheduleBoundaryView : UIScrollView{
    DFScheduleBoundaryManager* scheduleBoundaryManager;
    NSArray* scaleLabels;
}

- (CGRect)locateScheduleBoundaryManager:(DFScheduleBoundaryManager*)aManager underMode:(TimeDependenceMode)aMode;
- (CGRect)locateScaleLabel:(UIView*)aView atIndex:(NSUInteger)anIndex;
#pragma mark - Subviews
- (void)configureScaleLabel:(UILabel*)aLabel atIndex:(NSUInteger)anIndex;
- (void)createScaleLabels;
- (void)destroyScaleLabels;
- (void)loadSubviews;
#pragma mark - Schedule Boundary Manager
- (void)reloadData;
- (DFScheduleBoundaryManagerCell*)cellAtIndex:(NSUInteger)anIndex;
- (void)setContentSize:(CGSize)contentSize;
- (void)setDataSource:(id<DFScheduleBoundaryManagerDataSource>)dataSource;
- (void)setBeginTime:(NSDate *)beginTime;
- (void)setDuration:(NSTimeInterval)duration;
- (void)setMinTimeScale:(NSTimeInterval)minTimeScale;
- (void)setBeginTimeWithHour:(NSInteger)anHour minute:(NSUInteger)aMinute second:(NSUInteger)aSecond;
- (void)setTimeDependenceMode:(TimeDependenceMode)timeDependenceMode;
- (void)setTimeDependenceMode:(TimeDependenceMode)aTimeDependenceMode animated:(BOOL)animated;

@end
