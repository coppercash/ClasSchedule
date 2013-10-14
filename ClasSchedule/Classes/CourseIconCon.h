//
//  CourseIconCon.h
//  ClasSchedule
//
//  Created by DreamerMac on 12-3-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#define ICON_BACK_Y 20.0f
#define ICON_BACK_ALPHA 0.5f
#define SLIDER_LENGTH 300.0f
#define FIRST_SLIDER_VERTICAL_LOCATION 200.0f
#define SLIDER_DISTANCE 50.0f

#define COLOR_SELECTOR_WIDTH 300.0f
#define COLOR_SELECTOR_HEIGHT 200.0f
#define COLOR_SELECTOR_VERTICAL_LOCATION 150.0f

#import <UIKit/UIKit.h>
#import "DFFormView.h"

@class CoursesNvCon,Course,DFFormView,DFCourseIconView;
@interface CourseIconCon : UIViewController <DFFormViewDataSource,DFFormViewDelegate>
{
    Course* course;
    
    /*Views*/
    DFCourseIconView* iconView;
    
    UISlider* redSlider;
    UISlider* greenSlider;
    UISlider* blueSlider;
    
    DFFormView* colorSelector;
}

#pragma mark - SuperNvController
- (void)callSuperNavigationControllerToPopSelf;

- (CGRect)locateIconView;
- (UIColor*)colorByColumnIndex:(NSUInteger)aColumnIndex;
- (CGRect)sliderFrameByIndex:(NSUInteger)anIndex;
- (void)configureIconView:(DFCourseIconView*)anIconView;
- (void)configureSlider:(UISlider*)aSlider;
- (void)configureColorSelector:(DFFormView*)aColorSlector;
#pragma mark - Slider Events
- (void)redSliderValueChanged;
- (void)blueSliderValueChanged;
- (void)greenSliderValueChanged;
#pragma mark - Memory Management
- (id)initWithCourse:(Course*)aCourse;
@end
