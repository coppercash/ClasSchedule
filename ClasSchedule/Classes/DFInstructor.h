#import <UIKit/UIKit.h>
@class DFInstructor,DFInstructorButton;

@protocol DFInstructorDelegate <NSObject>
@optional
- (BOOL)instructorBeginTouchingReturnButton:(DFInstructor*)anInstructor;
- (void)instructorEndTouchingReturnButton:(DFInstructor*)anInstructor;

@required
- (void)instructorLoadingSubviews:(DFInstructor*)anInstructor;
@end

@interface DFInstructor : UIView {
    CGRect hollowFrame;
    DFInstructorButton* returnButton;
    id<DFInstructorDelegate> delegate;
    
    UIButton* callingButton;
    UIBarButtonItem* callingBarButtonItem;
}
@property(nonatomic,assign)id<DFInstructorDelegate> delegate;

#pragma mark - Return Button
- (BOOL)beginTouchingReturnButton:(DFInstructorButton*)aButton;
- (void)endTouchingReturnButton:(DFInstructorButton*)aButton;
#pragma mark - Show
- (void)showInView:(UIView*)aView;
#pragma mark - Hide
- (void)hide;
#pragma mark - Present
- (void)presentAtPoint:(CGPoint)aPoint inView:(UIView*)aView animated:(BOOL)animated;
- (void)presentInFrame:(CGRect)aFrame inView:(UIView*)aView animated:(BOOL)animated;
- (void)presentByButton:(UIButton*)aButton inView:(UIView*)aView animated:(BOOL)animated;
- (void)presentByUIBarButtonItem:(UIBarButtonItem*)aBarButtonItem touch:(UITouch*)aTouch inView:(UIView *)aView animated:(BOOL)animated;
#pragma mark - Dismiss
- (void)dismissAnimated:(BOOL)animated;
- (void)dismissWithAnimation;
#pragma mark - Draw
static CGGradientRef newGradientWithColors();
- (void)drawRect:(CGRect)rect;

@end
