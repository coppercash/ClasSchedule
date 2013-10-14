#import <UIKit/UIKit.h>
@class DFScheduleBoundaryManager,DFScheduleBoundaryManagerCell,DFButtonsManager;

@protocol DFScheduleBoundaryManagerDataSource <NSObject>
@optional
@required
- (NSUInteger)numberOfCellsManagedByManager:(DFScheduleBoundaryManager*)aScheduleBoundaryManager;
- (NSDate*)scheduleBoundaryManager:(DFScheduleBoundaryManager*)aScheduleBoundaryManager startTimeForCellAtIndex:(NSUInteger)anIndex;
- (NSTimeInterval)scheduleBoundaryManager:(DFScheduleBoundaryManager*)aScheduleBoundaryManager durationForCellAtIndex:(NSUInteger)anIndex;
@end

typedef enum {
    TimeDependenceModeDependent,
    TimeDependenceModeIndependent
}TimeDependenceMode;

@interface DFScheduleBoundaryManager : NSObject{
    UIView* superview;
    
    NSMutableArray* cells;
    
    NSDate* beginTime;
    NSTimeInterval duration;
    NSTimeInterval minTimeScale;
    
    CGRect frame;
    
    DFButtonsManager* buttonsManager;
    
    TimeDependenceMode timeDependenceMode;
    
    id<DFScheduleBoundaryManagerDataSource> dataSource;
}
@property(nonatomic,assign)UIView* superview;
@property(nonatomic,retain)NSDate* beginTime;
@property(nonatomic)NSTimeInterval duration;
@property(nonatomic)NSTimeInterval minTimeScale;
@property(nonatomic)CGRect frame;
@property(nonatomic)TimeDependenceMode timeDependenceMode;
@property(nonatomic,assign)id<DFScheduleBoundaryManagerDataSource> dataSource;

#pragma mark - Frame
- (CGRect)locateCell:(DFScheduleBoundaryManagerCell*)aCell;
- (CGRect)locateCell:(DFScheduleBoundaryManagerCell*)aCell animated:(BOOL)animated;
#pragma mark - Alter
- (void)beingStretchingCell:(DFScheduleBoundaryManagerCell *)aCell;
- (void)cell:(DFScheduleBoundaryManagerCell*)aCell stretchedForDifference:(CGFloat)aDifference;
- (void)endStretchingCell:(DFScheduleBoundaryManagerCell*)aCell;
- (void)alterByCell:(DFScheduleBoundaryManagerCell*)aCell timeInterval:(NSTimeInterval)anInterval;
#pragma mark - Alter Test
- (CGFloat)lengthCellCanProlong:(DFScheduleBoundaryManagerCell *)aCell;
- (CGFloat)lengthCellCanCurtail:(DFScheduleBoundaryManagerCell *)aCell;
- (NSTimeInterval)intervalCellCanProlong:(DFScheduleBoundaryManagerCell *)aCell;
- (NSTimeInterval)intervalCellCanCurtail:(DFScheduleBoundaryManagerCell *)aCell;
- (BOOL)canCellProlongOrCurtail:(DFScheduleBoundaryManagerCell *)aCell timeInterval:(NSTimeInterval)anInterval;
#pragma mark - Move
- (void)beginDragingCell:(DFScheduleBoundaryManagerCell *)aCell;
- (void)cell:(DFScheduleBoundaryManagerCell*)aCell dragedToY:(CGFloat)aNewY;
- (void)endDragingCell:(DFScheduleBoundaryManagerCell*)aCell;
- (void)movedByCell:(DFScheduleBoundaryManagerCell*)aCell timeInterval:(NSTimeInterval)anInterval;
#pragma mark - Move Test
- (CGFloat)locationCellCanIncrease:(DFScheduleBoundaryManagerCell *)aCell;
- (CGFloat)locationCellCanDecrease:(DFScheduleBoundaryManagerCell *)aCell;
- (NSTimeInterval)intervalCellCanIncrease:(DFScheduleBoundaryManagerCell *)aCell;
- (NSTimeInterval)intervalCellCanDecrease:(DFScheduleBoundaryManagerCell *)aCell;
- (BOOL)canCellIncreaseOrDecrease:(DFScheduleBoundaryManagerCell *)aCell timeInterval:(NSTimeInterval)anInterval;
#pragma mark - Length<->Duration    Location<->Time
- (CGFloat)lengthFromDuration:(NSTimeInterval)aDuration;
- (CGFloat)durationFromLength:(CGFloat)aLength;
- (CGFloat)locationFromTime:(NSDate*)aTime;
- (NSDate*)timeFromLocation:(CGFloat)aLocation;
#pragma mark - Scale
- (NSTimeInterval)scaleTimeInterval:(NSTimeInterval)anInterval;
- (NSDate*)scaleTime:(NSDate*)aTime;
#pragma mark - Cells
- (DFScheduleBoundaryManagerCell*)cellAtIndex:(NSUInteger)anIndex;
- (NSUInteger)indexOfCell:(DFScheduleBoundaryManagerCell*)aCell;
- (void)createCells;
- (void)locateCellAtIndex:(NSUInteger)anIndex;
- (void)reloadData;
- (UIColor*)cellColorAtIndex:(NSUInteger)anIndex;
#pragma mark - Superview
- (void)addIntoView:(UIView*)aView;
- (void)removeFromSuperview;
#pragma mark - Setter
- (void)setBeginTimeWithHour:(NSInteger)anHour minute:(NSUInteger)aMinute second:(NSUInteger)aSecond;
- (void)setTimeDependenceMode:(TimeDependenceMode)aTimeDependenceMode animated:(BOOL)animated;

@end
