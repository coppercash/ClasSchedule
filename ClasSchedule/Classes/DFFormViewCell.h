//
//  DFFormViewCell.h
//  ClasSchedule
//
//  Created by DreamerMac on 12-3-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DFFormView;
@interface DFFormViewCell : UIButton {
    DFFormView* superFormView;
    
    NSUInteger colIndex;
	NSUInteger rowIndex;
    
    BOOL isContentHidden;
    BOOL useCommonCellBackgroundImage;
}
@property(nonatomic,assign)DFFormView* superFormView;
@property(nonatomic)NSUInteger colIndex;
@property(nonatomic)NSUInteger rowIndex;
@property(nonatomic)BOOL isContentHidden;
@property(nonatomic)BOOL useCommonCellBackgroundImage;

#pragma mark - Animation
- (void)transformIntoFrame:(CGRect)aNewFrame;
#pragma mark - Content
- (void)hideContent;
- (void)showContent;
- (void)releaseContent;
- (void)reloadContent;
#pragma mark - Touch Event
- (void)beganTouch;
- (void)touchedUpInside;
- (void)touchedUpOutside;
- (void)loadSubviews;
@end
