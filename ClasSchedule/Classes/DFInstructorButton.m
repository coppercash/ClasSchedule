//
//  DFInstructorButton.m
//  trapezium
//
//  Created by DreamerMac on 12-5-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DFInstructorButton.h"
#import "DFInstructor.h"

@implementation DFInstructorButton

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    return [instructor beginTouchingReturnButton:self];
}
/*
- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    
}*/

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    return [instructor endTouchingReturnButton:self];
}

- (void)cancelTrackingWithEvent:(UIEvent *)event{
    return [instructor endTouchingReturnButton:self];
}

- (id)initWithInstructor:(DFInstructor*)anInstructor
{
    if (self = [super init]) {
        instructor = anInstructor;
    }
    return self;
}

@end
