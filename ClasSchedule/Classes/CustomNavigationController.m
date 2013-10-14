//
//  CustomNavigationController.m
//  ClasSchedule
//
//  Created by DreamerMac on 12-6-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CustomNavigationController.h"

@implementation UINavigationController (CustomNavigationController)

- (void)userDefaultBarBackground
{
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"WoodBottom" ofType:@"png"]];    
    if ([self.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]){
        [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
    [self.navigationBar setTintColor:[UIColor brownColor]];
    
    if ([self.toolbar respondsToSelector:@selector(setBackgroundImage:forToolbarPosition:barMetrics:)]) {
        [self.toolbar setBackgroundImage:image forToolbarPosition:UIToolbarPositionBottom barMetrics:UIBarMetricsDefault];
    }
    [image release];
}

@end
