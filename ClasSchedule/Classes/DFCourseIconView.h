//
//  DFCourseIconView.h
//  ClasSchedule
//
//  Created by DreamerMac on 12-4-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DFCourseIconView : UIView{
    UIColor* tintColor;
    
    BOOL isWithRoundCorner;
    CGFloat roundCornerRadius;
    
    BOOL useIconImage;
    UIImage* iconImage;
    
    BOOL sendTouchToSuperview;
}
@property(nonatomic,retain)UIColor* tintColor;
@property(nonatomic)BOOL isWithRoundCorner;
@property(nonatomic)CGFloat roundCornerRadius;
@property(nonatomic)BOOL useIconImage;
@property(nonatomic,retain)UIImage* iconImage;
@property(nonatomic)BOOL sendTouchToSuperview;
- (void)makePathCircleCornerRect:(CGRect)rect radius:(CGFloat)radius;
- (CGGradientRef)newGradientWithColors:(UIColor**)colors locations:(CGFloat*)locations count:(int)count;
@end
