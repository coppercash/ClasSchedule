//
//  DFView.m
//  ClasSchedule
//
//  Created by DreamerMac on 12-5-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DFView.h"

@implementation UIView (DFView)

- (void)offsetY:(CGFloat)offsetY
{
    [self setFrame:CGRectOffset(self.frame, 0.0f, offsetY)];
}

- (void)setHeight:(CGFloat)height
{
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height)];
}

- (void)setY:(CGFloat)y
{
    [self setFrame:CGRectMake(self.frame.origin.x, y, self.frame.size.width, self.frame.size.height)];
}

- (void)setY:(CGFloat)y height:(CGFloat)height
{
    [self setFrame:CGRectMake(self.frame.origin.x, y, self.frame.size.width, height)];
}

@end
