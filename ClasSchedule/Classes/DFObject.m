//
//  DFView.m
//  ClasSchedule
//
//  Created by DreamerMac on 12-5-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DFObject.h"

@implementation NSObject (DFObject)
- (void)destroyMember:(NSObject**)aMember
{
    [*aMember release];
    *aMember = nil;
}

- (void)destroySubview:(UIView**)aViewRef
{
    [*aViewRef removeFromSuperview];
    [*aViewRef release];
    *aViewRef = nil;
}

@end
