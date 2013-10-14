//
//  DFStrecherAccessory.m
//  ScheduleBoundaryManager
//
//  Created by DreamerMac on 12-5-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DFStretcherAccessory.h"
#import "DFScheduleBoundaryManagerCell.h"

@implementation DFStretcherAccessory
@synthesize superCellView,touchYInCellWhenPreviousTouch;

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    touchYInCellWhenPreviousTouch = [touch locationInView:superCellView].y;
    return [superCellView stretcher:self beginTrackingWithTouch:touch withEvent:event];
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    BOOL continued = [superCellView stretcher:self continueTrackingWithTouch:touch withEvent:event];
    touchYInCellWhenPreviousTouch = [touch locationInView:superCellView].y;
    return continued;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [superCellView stretcher:self endTrackingWithTouch:touch withEvent:event];
    touchYInCellWhenPreviousTouch = 0.0f;
}

- (void)cancelTrackingWithEvent:(UIEvent *)event{
    [superCellView stretcher:self cancelTrackingWithEvent:event];
    touchYInCellWhenPreviousTouch = 0.0f;
}

- (void)dealloc{
    superCellView = nil;
    [super dealloc];
}
@end
