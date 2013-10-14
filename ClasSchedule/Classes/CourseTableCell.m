//
//  CourceTableCell.m
//  ClasSchedule
//
//  Created by DreamerMac on 12-2-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CourseTableCell.h"
#import "Header.h"

@implementation CourseTableCell

@synthesize course = _course,superController;

#pragma mark - Load Subviews
- (void)loadSubviews{
    UIView* contentView = self.contentView;
    while ([contentView.subviews count]) {
        [contentView.subviews.lastObject removeFromSuperview];
    }
    UIView* xibView = [[[NSBundle mainBundle] loadNibNamed:@"CourseTableCell" owner:self options:nil] objectAtIndex:0];
    [self.contentView addSubview:xibView];
    
    Course* course = _course;

    UIColor* tintColor = [CSDataCenter getColorFromCourseExtensionInfo:course.courseExtension];
    [_IconView setTintColor:tintColor];
    [_IconView setSendTouchToSuperview:YES];
    
    [_CourseName setText:course.name];
    [_CourseName setAdjustsFontSizeToFitWidth:YES];
    
    [_LocationLabel setText:course.room];
    [_LocationLabel setAdjustsFontSizeToFitWidth:YES];
    
    [_InstructorName setText:course.teacher];
    [_InstructorName setAdjustsFontSizeToFitWidth:YES];
    
    NSString* numberOfNotesString = [[NSString alloc] initWithFormat:@"%d",[course.notes count]];
    [_NotesLabel setText:numberOfNotesString];
    [numberOfNotesString release];
}

#pragma mark - Touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    switch (superController.condition) {
        case CourseTableControllerConditionAdd:{
            UITouch* touch = [touches anyObject];
            if (touch.tapCount == 2) {
                //[superController touchBegan:touch];
                [(UITableView*)self.superview setScrollEnabled:NO];
                [superController touchBegan:touch onCell:self];

            }else if (touch.tapCount == 1) {
                [super touchesBegan:touches withEvent:event];
            }
            break;
        }
        default:
            [super touchesBegan:touches withEvent:event];
            break;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    switch (superController.condition) {
        case CourseTableControllerConditionFloat:{
            [superController touchMoved:[touches anyObject]];
            break;
        }
        default:
            [super touchesMoved:touches withEvent:event];
            break;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    switch (superController.condition) {
        case CourseTableControllerConditionFloat:{
            [superController touchEnded:[touches anyObject]];
            [(UITableView*)self.superview setScrollEnabled:YES];

            break;
        }
        default:
            [super touchesEnded:touches withEvent:event];
            break;
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    switch (superController.condition) {
        case CourseTableControllerConditionFloat:{
            [superController touchCancelled:[touches anyObject]];
            [(UITableView*)self.superview setScrollEnabled:YES];

            break;
        }
        default:
            [super touchesCancelled:touches withEvent:event];
            break;
    }
}

#pragma mark - Others
- (void)setSchedule:(Schedule *)aSchedule{
    _course = [aSchedule.course retain];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
    
    if (selected) {
        [self setShadowOffset:CGSizeZero];
    }else{
        [self setShadowOffset:CGSizeMake(0.0f, 7.0f)];
    }
}

#pragma mark - Memory Management

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc{
    superController = nil;
    
    [_course release];
    _course = nil;
}

@end
