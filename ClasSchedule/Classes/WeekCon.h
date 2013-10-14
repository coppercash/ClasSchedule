//
//  WeekCon.h
//  ClasSchedule
//
//  Created by Remaerd on 11-10-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DFFormView.h"
#import "DFScrollScheduleBoundaryView.h"
#import "DFInstructor.h"

typedef enum{
	EditingModeOn,
	EditingModeOff
}EditingMode;

@class CSDataCenter,ScheduleNvCon,DFScrollScheduleBoundaryView,DFBalloonView;

@interface WeekCon : UIViewController <DFFormViewDelegate,DFFormViewDataSource,DFScheduleBoundaryManagerDataSource,DFInstructorDelegate>{
	CSDataCenter* dataCenter;
	EditingMode editingMode;

    /*Views*/
    UILabel* topLabel;
    
    DFFormView* scheduleForm;
    DFScrollScheduleBoundaryView* scheduleBoundaryView;
    
	UILabel* sliderLabel;
	UISlider* slider;
	
	UILabel* weekendLabel;
	UISwitch* weekendSwitch;
    
    DFBalloonView* _emptyTip;
    
    IBOutlet UIImageView* _ImageB0;
    IBOutlet UIImageView* _ImageB1;
    IBOutlet UILabel* _LabelB0;
    IBOutlet UILabel* _LabelB1;

}

#pragma mark - Frames
- (CGRect)locateTopLabel;
- (CGRect)locateScheduleForm:(UIView*)aView;
- (CGRect)locateScheduleBoundaryView:(UIView*)aView;
- (CGRect)locateScheduleBoundaryViewUnderTimeDependentMode:(UIView*)aView;
- (CGRect)locateSlider:(UIView*)aView;
- (CGRect)sliderLabelFrame;
- (CGRect)locateWeekendSwitch:(UIView*)aView;
- (CGRect)locateWeekendLabel:(UIView*)aView;
- (CGRect)frameFromFrame:(CGRect)anOldFrame x:(float)aX y:(float)aY width:(float)aNewWidth height:(float)aNewHeight;
#pragma mark - Subviews
- (void)configureTopLabel;
- (void)configureScheduleBoundaryView;
- (void)configureScheduleForm:(DFFormView*)aScheduleForm;
- (void)configWeekendLabel:(UILabel*)aLabel;
- (void)configWeekendSwitch:(UISwitch*)aSwitch;
- (void)configSlider:(UISlider*)aSlider;
- (void)configSliderLabel:(UILabel*)aSliderLabel;
#pragma mark - Subviews Show Hide
- (void)createScheduleForm;
- (void)createConfigurationAccessory;
- (void)destroyConfigurationAccessory;
#pragma mark - DFFormViewDelegate,DFFormViewDataSource & Events
- (void)saveColAndRowCount;
#pragma mark - Tool Bar
- (void)setToolBarItems;
- (void)setToolBarItemsToEdit;
- (void)setToolBarItemsUnderScheduleBoundary;
- (void)done;
- (void)cancel;
- (void)doneOfScheduleBoundary;
- (void)cancelOfScheduleBoundary;
#pragma mark - Weekend Switch
- (void)weekendSwitchValueChange;
- (void)reformScheuleFormWithColCount:(NSInteger)aColCount;
#pragma mark - Slider
- (void)reformScheuleFormWithRowCount:(NSInteger)aRowCount;
- (void)sliderValueChange;
- (float)adhesionSlider:(UISlider*)aSlider asParts:(NSUInteger)aPartsCount act:(SEL)anAction at:(id)aTarget;
#pragma mark - Mode Convert
- (void)switchOfEditingMode;
- (void)cancelEditingMode;
- (void)enterEditingMode;
- (void)enterScheduleBoundaryMode;
- (void)cancelScheduleBoundaryMode;
#pragma mark - Focus
- (NSInteger)defaultFocusedWeekday;
#pragma mark - SuperController
- (void)toPushDayControllerWithSeqInWeek:(NSUInteger)aWeekday;

@end
