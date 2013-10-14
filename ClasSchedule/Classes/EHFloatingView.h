//
//  EHFloatingView.h
//  ClasSchedule
//
//  Created by DreamerMac on 12-3-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DFFloatingView.h"

#define kFloatingNotificationBoundsOvalWidth 5
#define kFloatingNotificationBoundsOvalHeight 5
#define kFloatingNotificationBoundsSizeFactor 1.0

@interface EHFloatingView : DFFloatingView{
    NSString* _contentString;
    NSString* _fontName;
    CGFloat _fontSize;
}
@property(nonatomic,copy)NSString* contentString;
@property(nonatomic,copy)NSString* fontName;
@property(nonatomic)CGFloat fontSize;

#pragma mark - Frames
- (CGRect)contentStringFrame;

@end
