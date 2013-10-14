//
//  DFFormView.h
//  ClasSchedule
//
//  Created by DreamerMac on 12-3-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DFFormView,DFFormViewCell;

@protocol DFFormViewDataSource <NSObject>
@required
- (DFFormViewCell*)allocCellForFormView:(DFFormView *)aFormView;

@optional
- (void)configureCell:(DFFormViewCell*)aCell atColumnIndex:(NSUInteger)aColIndex rowIndex:(NSUInteger)aRowIndex;
- (void)topBoundaryView:(UIView*)aView onColumn:(NSUInteger)aColumnIndex;
- (void)relaodContentIntopBoundaryView:(UIView*)aView onColumn:(NSUInteger)aColumnIndex;
- (void)rihgtBoundaryView:(UIView*)aView onRow:(NSUInteger)aRowIndex;
- (void)fillFormWithContent:(DFFormView*)aForm;
@end


@protocol DFFormViewDelegate <NSObject>
@optional
- (void)touchedDownInsideCellAtColumn:(NSUInteger)aColumnIndex row:(NSUInteger)aRowIndex;
- (void)touch:(UITouch*)aTouch moveFromCellAtColumn:(NSUInteger)aColumnIndex row:(NSUInteger)aRowIndex inside:(BOOL)isInside;
- (void)touchedUpInside:(BOOL)isInside cellAtColumn:(NSUInteger)aColumnIndex row:(NSUInteger)aRowIndex;
- (void)touchedUpInsideCellAtColumn:(NSUInteger)aColumnIndex row:(NSUInteger)aRowIndex;
- (void)touchedUpInsideCellsAtColumn:(NSUInteger)aColumnIndex;
- (void)touchedUpInsideCellsAtRow:(NSUInteger)aRowIndex;
@end

typedef enum{
    DFFormViewTouchingConditonNone,
    DFFormViewTouchingConditonCell,
    DFFormViewTouchingConditonColumn,
    DFFormViewTouchingConditonRow
}DFFormViewTouchingConditon;

@interface DFFormView : UIView {
    NSUInteger colCount;
	NSUInteger rowCount;
    
    NSArray* cellsShouldBeConfigured;
    NSMutableArray* cellsGroupedByColumn;
    UIImage* commonCellBackgroundImage;
    
    BOOL isTopBoundaryViewsHidden;
	NSMutableArray* topBoundaryViews;
    
    DFFormViewTouchingConditon touchingConditon;
    
    BOOL isContentHidden;
    CGSize shadowOffset;
    
    id<DFFormViewDataSource> dataSource;
    BOOL canCellBeConfigured;
    id<DFFormViewDelegate> delegate;
}
@property(nonatomic)NSUInteger colCount;
@property(nonatomic)NSUInteger rowCount;
@property(nonatomic,retain)NSArray* cellsShouldBeConfigured;
@property(nonatomic,retain)UIImage* commonCellBackgroundImage;
@property(nonatomic)BOOL isTopBoundaryViewsHidden;
@property(nonatomic)DFFormViewTouchingConditon touchingConditon;
@property(nonatomic)BOOL isContentHidden;
@property(nonatomic)CGSize shadowOffset;
@property(nonatomic,assign)id<DFFormViewDataSource> dataSource;
@property(nonatomic,assign)id<DFFormViewDelegate> delegate;

- (CGRect)cellFrameByCol:(NSUInteger)aColumnIndex row:(NSUInteger)aRowIndex;
- (CGRect)cellFrameByCol:(NSUInteger)aColumnIndex row:(NSUInteger)aRowIndex colCount:(NSUInteger)aColCount rowCount:(NSUInteger)aRowCount;
- (CGRect)topBoundaryViewFrameWithHeight:(float)aHeight onColumn:(NSUInteger)aColumnIndex;
- (CGRect)topBoundaryViewFrameWithHeight:(float)aHeight onColumn:(NSUInteger)aColumnIndex inColCount:(NSUInteger)aColCount;
- (CGRect)rightBoundaryViewFrameWithWidth:(float)aWidth onRow:(NSUInteger)aRowIndex;
- (CGRect)rightBoundaryViewFrameWithWidth:(float)aWidth onRow:(NSUInteger)aRowIndex inRowCount:(NSUInteger)aRowCount;
#pragma mark - Animation
- (void)transformSelfIntoRect:(CGRect)aRect;
#pragma mark - Tracking Event
- (BOOL)beginTrackingWithTouch:(UITouch *)touch cellAtColumnIndex:(NSUInteger)aColumnIndex rowIndex:(NSUInteger)aRowIndex;
- (BOOL)continueTrackingWithTouch:(UITouch *)touch cellAtColumnIndex:(NSUInteger)aColumnIndex rowIndex:(NSUInteger)aRowIndex;
- (void)endTrackingWithTouch:(UITouch *)touch cellAtColumnIndex:(NSUInteger)aColumnIndex rowIndex:(NSUInteger)aRowIndex;
#pragma mark - Cell Management
- (DFFormViewCell*)getAllocedCellFromDataSourceAtColumnIndex:(NSUInteger)aColIndex rowIndex:(NSUInteger)aRowIndex;
- (NSArray*)cellsAtColumn:(NSUInteger)aColumnIndex;
- (NSArray*)cellsAtRow:(NSUInteger)aRowIndex;
- (DFFormViewCell*)cellAtColumn:(NSUInteger)aColumnIndex row:(NSUInteger)aRowIndex;
- (DFFormViewCell*)cellAtOneDimensionIndex:(NSUInteger)anIndex;
- (NSArray*)oneDimensionCellArray;
#pragma mark - Content
- (void)showContent;
- (void)hideContent;
- (void)reloadContent;
#pragma mark - TopBoundaryViews
- (void)createTopBoundaryViews;
- (void)destroyTopBoundaryViews;
#pragma mark - Form
- (void)createForm;
- (void)recreateCellsWithColCount:(NSUInteger)aColCount rowCount:(NSUInteger)aRowCount;
- (void)setColCount:(NSUInteger)aColCount rowCount:(NSUInteger)aRowCount;
@end
