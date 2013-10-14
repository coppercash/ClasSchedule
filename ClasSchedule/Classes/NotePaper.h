//
//  NotePaper.h
//  ClasSchedule
//
//  Created by DreamerMac on 12-4-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef enum {
    NotePaperConditionShrank,
    NotePaperConditionExpanded
}NotePaperCondition;

@class Note,Course,NotePaper,NotesPad;
@interface NotePaper : UIView <UITextViewDelegate> {
    NotesPad* notesPad;
    Note* note;
    
    NotePaperCondition conditon;
    
    /*Views*/
    UILabel* content;
    UITextView* contentView;
    CGFloat shownKeyboardHeight;
    UILabel* noteBirthDate;
}
@property(nonatomic,retain)Note* note;
@property(nonatomic)NotePaperCondition conditon;
@property(nonatomic,assign)NotesPad* notesPad;

#pragma mark - Frame
+ (CGFloat)shrankConditionSize;
- (CGRect)locateContent:(UIView*)aView;
- (CGRect)locateContentView:(UIView*)aView;
- (CGRect)locateNoteBornDate:(UIView*)aView;
#pragma mark - Subviews
- (void)loadSubviews;
- (void)unloadSubviews;
- (void)loadSubviewsShrankCondition;
- (void)loadSubviewsExpandedCondition;
- (void)configureContent;
- (void)configureContentView;
- (void)configureNoteBornDate;
#pragma mark - Condition Event
- (BOOL)isAdditionType;
- (void)switchOfConditon;
- (void)enterExpandedCondition;
- (void)returnShrankCondition;
#pragma mark - Other Event
- (UITextView*)contentView;
- (void)reloadData;
- (NSString*)text;
#pragma mark - Animation
- (void)expendFromRect:(CGRect)aOringinalRect toRect:(CGRect)aGoalRect inView:(UIView*)aView;
- (void)setCenter:(CGPoint)center withAnimation:(BOOL)animation;
#pragma mark - Graphic
- (void)drawNotePaperWhenShrank:(CGRect)rect;
- (void)drawNotePaperWhenExpanded:(CGRect)rect;
#pragma mark - Memory Management
- (id)initWithNote:(Note*)aNote;

@end

