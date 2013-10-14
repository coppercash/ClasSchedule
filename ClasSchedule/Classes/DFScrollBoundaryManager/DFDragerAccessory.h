//
//  DFControlAccessory.h
//  ScheduleBoundaryManager
//
//  Created by DreamerMac on 12-5-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DFScheduleBoundaryManagerCell;
@interface DFDragerAccessory : UIControl{
    DFScheduleBoundaryManagerCell* superCellView;
    CGFloat touchYInCellWhenTouchBegan;
}
@property(nonatomic,assign)DFScheduleBoundaryManagerCell* superCellView;
@property(nonatomic,assign)CGFloat touchYInCellWhenTouchBegan;

- (CGGradientRef)newGradientWithColors:(UIColor**)colors locations:(CGFloat*)locations count:(int)count ;
void contextAddRoundCornerRect(CGContextRef context, CGRect rect,CGFloat radius);
@end
