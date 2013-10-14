#import <UIKit/UIKit.h>

@class DFFloatingView;

@protocol DFFloatingViewDelegate <NSObject>
@optional
- (void)floatingViewLoadingSubviews:(DFFloatingView*)aFloatingView;
- (void)floatingView:(DFFloatingView*)aFloatingView landedInViewAtIndex:(NSUInteger)anIndex withUserInfo:(id)anUserInfo;
- (BOOL)floatingView:(DFFloatingView*)aFloatingView stuckByViewAtIndex:(NSUInteger)anIndex inRect:(CGRect)aRect;
@end

typedef enum {
    FloatingViewFree,
    FloatingViewStuck,
    FloatingViewUnused
}FloatingViewConditon;

@interface DFFloatingView : UIView
{
    BOOL removeSubviewsAfterLanding;
    
    FloatingViewConditon condition;
    CGRect oringinalRect;
    CGRect animationRect;
    CGRect stickingRect;
    CGPoint immediatePoint;
    NSUInteger indexOfStickingRect;
    
    NSArray* accessedViewsRect;
    id userInfo;
    
    UIView* stageView;
    id<DFFloatingViewDelegate> delegate;
}
@property(nonatomic)BOOL removeSubviewsAfterLanding;
@property(nonatomic,retain)NSArray* accessedViewsRect;
@property(nonatomic,retain)id userInfo;
@property(nonatomic,assign)UIView* stageView;
@property(nonatomic,assign)id<DFFloatingViewDelegate> delegate;
#pragma mark - Moving
- (BOOL)isTouchMovedIntoAccessedViews;
#pragma mark - Animation
- (void)transformSelfIntoRect:(CGRect)aRect;
- (void)transformSelfIntoOringinalShapeOnPoint:(CGPoint)aPoint;
- (void)takeOffInView:(UIView*)aView withUserInfo:(id)anUserInfo;
- (void)takeOffInRect:(CGRect)aRect withUserInfo:(id)anUserInfo;
- (void)land;
#pragma mark - Timer
- (void)scheduelTimer;
- (void)timerFireByTouchTrack:(NSTimer*)theTimer;
#pragma mark - Subviews
- (void)loadSubviews;
#pragma mark - Other
- (BOOL)isFloating;
#pragma mark - Memory Management
- (id)initWithStageView:(UIView*)aStageView;
- (void)setAccessedViews:(NSArray *)anAccessedViews;
//- (void)setAccessedViews:(NSArray *)anAccessedViews fromView:(UIView*)aSourceView;
//- (void)setAccessedViews:(NSArray *)anAccessedViews fromView:(UIView*)aSourceView toView:(UIView*)aTargetView;
@end
