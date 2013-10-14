//
//  NotesPad.h
//  ClasSchedule
//
//  Created by DreamerMac on 12-4-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NotePaper,Course,Note;
@protocol NotesPadDelegate <NSObject,UIScrollViewDelegate,UITextViewDelegate>
@optional
- (void)notePaperTapped:(NotePaper*)aNotePaper;
- (void)enteringNotePaperWillExpand:(NotePaper*)aNotePaper;
- (void)enteringNotePaperDidExpand:(NotePaper*)aNotePaper;
- (void)enteringNotePaperWillShrink:(NotePaper*)aNotePaper;
- (void)enteringNotePaperDidShrink:(NotePaper*)aNotePaper;
- (CGRect)enteringNotePaperExpandedFrame;
@end

@interface NotesPad : UIScrollView{
    id<NotesPadDelegate> notesPadDelegate;
    
    NotePaper* enteringNotePaper;   //The reference to memery of the expanded notepaper.
    NotePaper* _alertingNotePaper;  //Just the reference to shrank notepaper which is being expanded,no memery.
    CGRect enteringPaperFrame;
    UIView* enteringPaperStageView;
    
    NotePaper* additonNotePaper;
    NSMutableArray* notePapers; //Doesn't contains the addition notepaper.
    Course* course;
    
    CGFloat firstDirectionCellLength;
    CGFloat firstDirectionMargin;
    CGFloat secondDirectionMargin;
    NSUInteger secondDirectionCellCount;
}
@property(nonatomic,assign)UIView* enteringPaperStageView;
@property(nonatomic,assign)id<NotesPadDelegate> delegate;
@property(nonatomic)CGFloat firstDirectionCellLength;
@property(nonatomic)CGFloat firstDirectionMargin;
@property(nonatomic)CGFloat secondDirectionMargin;
@property(nonatomic)NSUInteger secondDirectionCellCount;
@property(nonatomic,assign)Course* course;

#pragma mark - Frames
- (CGRect)locateNotePaper:(NotePaper*)aNotePaper byIndex:(NSUInteger)anIndex ofCount:(NSUInteger)aCount;
- (CGFloat)firstContentLengthWithCount:(NSUInteger)aCount;
- (CGPoint)notePaperCenterByIndex:(NSUInteger)anIndex ofCount:(NSUInteger)aCount;
- (CGPoint)notePaperGraphicCenterByIndex:(NSUInteger)anIndex;
#pragma mark - Subviews
- (void)loadSubviews;
#pragma mark - Manamge NotePaper
- (void)insertNewNotePaperWithNote:(Note*)aNote;
- (void)removeNotePaper:(NotePaper*)aNotePaper;
- (void)removeAlertingNotePaper;
- (void)locateNotePapersAnimation;
- (void)notePaperTapped:(NotePaper*)aNotePaper;
#pragma mark - Aniamtion
- (void)shrinkEnteringNotePaperAndSave:(BOOL)aSave;
- (void)expandEnteringNotePaper:(NotePaper*)aNotePaper;
- (void)enterringNotepaperDidExpand;
#pragma mark - Content Size
- (void)autoFitContentSize;
#pragma mark - Other Event
- (NotePaper*)enteringNotePaper;
- (void)save;
- (BOOL)isAddingNotePaper;
#pragma mark - Memory Management
- (id)initWithCourse:(Course*)aCourse;
@end
