#import <UIKit/UIKit.h>
@class DFScheduleBoundaryManager,DFDragerAccessory,DFStretcherAccessory;
@interface DFScheduleBoundaryManagerCell : UIView {
    
    DFScheduleBoundaryManager* manager;
    
    NSDate* beginTime;
    NSTimeInterval duration;
    
    DFDragerAccessory* drager;
    DFStretcherAccessory* stretcher;
    
    UILabel* beginTimeLabel;
    UILabel* endTimeLabel;
}
@property(nonatomic,retain)NSDate* beginTime;
@property(nonatomic)NSTimeInterval duration;
@property(nonatomic,assign)DFScheduleBoundaryManager* manager;

#pragma mark - Frame
- (CGRect)locateDrager:(UIView*)aView;
- (CGRect)locateStretcher:(UIView*)aView;
- (CGRect)locateBeginTimeLabel:(UIView*)aView;
- (CGRect)locateEndTimeLabel:(UIView*)aView;
#pragma mark - Subviews
- (void)loadSubiews;
- (void)configureDrager;
- (void)configureStretcher;
- (void)configureBeginTimeLabel;
- (void)configureEndTimeLabel;
#pragma mark - Drager Event
- (BOOL)drager:(DFDragerAccessory*)aDrager beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event;
- (BOOL)drager:(DFDragerAccessory*)aDrager continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event;
- (void)drager:(DFDragerAccessory*)aDrager endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event;
- (void)drager:(DFDragerAccessory*)aDrager cancelTrackingWithEvent:(UIEvent *)event;
#pragma mark - Strecher Event
- (BOOL)stretcher:(DFStretcherAccessory*)aStretcher beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event;
- (BOOL)stretcher:(DFStretcherAccessory*)aStretcher continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event;
- (void)stretcher:(DFStretcherAccessory*)aStretcher endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event;
- (void)stretcher:(DFStretcherAccessory*)aStretcher cancelTrackingWithEvent:(UIEvent *)event;
#pragma mark - Locaion
- (CGFloat)topLocation;
- (CGFloat)length;
- (CGFloat)bottomLocation;
- (void)setLocation:(CGFloat)aLocation;
- (void)setLength:(CGFloat)aLength;
#pragma mark - Mode Convert
- (void)showStretcher;
- (void)hideStretcher;
- (void)showDragerAnimated:(BOOL)animated;
- (void)hideDragerAnimated:(BOOL)animated;
- (void)setBeginTime:(NSDate *)aBeginTime animated:(BOOL)animated;
- (void)setDuration:(NSTimeInterval)aDuration animated:(BOOL)animated;

@end
