#import "DFFloatingView.h"


@implementation DFFloatingView
@synthesize removeSubviewsAfterLanding;
@synthesize accessedViewsRect,userInfo,delegate,stageView;

#pragma mark - Moving
- (void)setCenter:(CGPoint)center{
    if (condition == FloatingViewFree) {
        [super setCenter:center];
    }
    immediatePoint = center;
    
    if (![self isTouchMovedIntoAccessedViews]) {
        if (condition == FloatingViewStuck) {
            condition = FloatingViewFree;
            [self transformSelfIntoOringinalShapeOnPoint:immediatePoint];
        }
        stickingRect = CGRectZero;
    }
}

- (BOOL)isTouchMovedIntoAccessedViews
{
    CGPoint origin = immediatePoint;
    
    BOOL isInAnyAccessedViews = NO;
    CGRect pRect = CGRectZero;
    NSValue* pValue = nil;
    
    for (pValue in accessedViewsRect) {
        pRect = [pValue CGRectValue];
        if (CGRectContainsPoint(pRect, origin)) {
            stickingRect = pRect;
            indexOfStickingRect = [accessedViewsRect indexOfObject:pValue];
            animationRect = pRect;
            isInAnyAccessedViews = YES;
            break;
        }
    }
    
    return isInAnyAccessedViews;
}

#pragma mark - Animation
- (void)stuckAnimation
{
    if ([delegate respondsToSelector:@selector(floatingView:stuckByViewAtIndex:inRect:)]) {
        if ([delegate floatingView:self stuckByViewAtIndex:indexOfStickingRect inRect:stickingRect]) {
            [self transformSelfIntoRect:stickingRect];
        }
    }else{
        [self transformSelfIntoRect:stickingRect];
    }
}

#pragma mark - Take Off & Land
- (void)transformSelfIntoRect:(CGRect)aRect
{
    if (CGRectEqualToRect(aRect, self.frame)) {
        return;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:@"transformSelfIntoRect" context:context];
	[UIView setAnimationDuration:0.2f]; 
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    //[UIView setAnimationBeginsFromCurrentState:YES];
    [self setFrame:aRect];
	[UIView commitAnimations];
}

- (void)transformSelfIntoOringinalShapeOnPoint:(CGPoint)aPoint
{
    CGFloat width = oringinalRect.size.width;
    CGFloat height = oringinalRect.size.height;
    CGFloat x = aPoint.x + width / 2;
    CGFloat y = aPoint.y + height / 2;
    [self transformSelfIntoRect:CGRectMake(x, y, width, height)];
}

- (void)takeOffInView:(UIView*)aView withUserInfo:(id)anUserInfo
{
    CGRect frame = [stageView convertRect:aView.frame fromView:aView.superview];
    [self takeOffInRect:frame withUserInfo:anUserInfo];
}

- (void)takeOffInRect:(CGRect)aRect withUserInfo:(id)anUserInfo
{
    condition = FloatingViewFree;
    oringinalRect = aRect;
    animationRect = CGRectZero;
    stickingRect = CGRectZero;
    immediatePoint = CGPointMake(CGRectGetMidX(aRect), CGRectGetMidY(aRect));
    
    [self setFrame:aRect];
    [self setUserInfo:anUserInfo];
    [self scheduelTimer];
    [stageView addSubview:self];
    
    [self loadSubviews];
    
}

- (void)land
{
    condition = FloatingViewUnused;
    
    if ([self isTouchMovedIntoAccessedViews]) {
        if ([delegate respondsToSelector:@selector(floatingView:landedInViewAtIndex:withUserInfo:)]) {
            [delegate floatingView:self landedInViewAtIndex:indexOfStickingRect withUserInfo:userInfo];
        }
    }
    
    if (userInfo) {
        [userInfo release];
        userInfo = nil;
    }
    [self removeFromSuperview];
    
    if (removeSubviewsAfterLanding) {
        for (UIView* pView in [self subviews]) {
            [pView removeFromSuperview];
        }
    }
    
    oringinalRect = CGRectZero;
    stickingRect = CGRectZero;
    animationRect = CGRectZero;
    immediatePoint = CGPointZero;
    indexOfStickingRect = 0;
    
    [self setNeedsDisplay];
}

#pragma mark - Timer
- (void)scheduelTimer
{
    NSTimeInterval timeInterval = 0.2f;
    NSUInteger checkTimes = 7;
    NSNumber* checkTimesNumber = [[NSNumber alloc] initWithUnsignedInteger:checkTimes];
    NSNumber* progressNumber = [[NSNumber alloc] initWithUnsignedInteger:1];
    NSMutableDictionary* theUserInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:checkTimesNumber,@"checkTimesNumber",progressNumber,@"progressNumber",nil];
    
    [NSTimer scheduledTimerWithTimeInterval:timeInterval / checkTimes target:self selector:@selector(timerFireByTouchTrack:) userInfo:theUserInfo repeats:YES];
    
    [progressNumber release];
    [checkTimesNumber release];
    [theUserInfo release];
}
- (void)timerFireByTouchTrack:(NSTimer*)theTimer
{
    NSMutableDictionary* theUserInfo = theTimer.userInfo;
    
    NSNumber* checkTimesNumber = [theUserInfo objectForKey:@"checkTimesNumber"];
    NSUInteger checkTimes = [checkTimesNumber unsignedIntegerValue];
    
    NSNumber* progressNumber = [theUserInfo objectForKey:@"progressNumber"];
    NSUInteger progress = [progressNumber unsignedIntegerValue];
    
    if (CGRectContainsPoint(stickingRect, immediatePoint)) {
        if (progress == checkTimes) {
            //DLog(@"Float View\t%d/%d\tEnter Join-In State",progress,checkTimes);
            [self stuckAnimation];
            condition = FloatingViewStuck;
        } else {
            //DLog(@"Float View\t%d/%d\tChecking ",progress,checkTimes);
            progress ++;
            progressNumber = [[NSNumber alloc] initWithUnsignedInteger:progress];
            [theUserInfo setObject:progressNumber forKey:@"progressNumber"];
            [progressNumber release];
        }
    }else {
        //DLog(@"Float View\tFree");
        if (progress != 1) {
            /*Reset the progress to initial value 1*/
            progressNumber = [[NSNumber alloc] initWithUnsignedInteger:1];
            [theUserInfo setObject:progressNumber forKey:@"progressNumber"];
            [progressNumber release];
        }
        
        if (CGPointEqualToPoint(immediatePoint, CGPointZero) && CGRectEqualToRect(stickingRect, CGRectZero)) {
            //DLog(@"Float View\tInvalidate Timer");
            [theTimer invalidate];
        }
    }
}
#pragma mark - Subviews
- (void)loadSubviews
{
    if ([delegate respondsToSelector:@selector(floatingViewLoadingSubviews:)]) {
        [delegate floatingViewLoadingSubviews:self];
    }
}

#pragma mark - Other
- (BOOL)isFloating
{
    BOOL isFloating = YES;
    if (condition == FloatingViewUnused) {
        isFloating = NO;
    }
    return isFloating;
}

#pragma mark - Memory Management

- (void)setAccessedViews:(NSArray *)anAccessedViews
{
    NSArray* theAccessedViews = anAccessedViews;
    UIView* theTargetView = stageView;
    
    NSMutableArray* mutableArray = [[NSMutableArray alloc] initWithCapacity:[theAccessedViews count]];
    
    UIView* pView = nil;
    NSValue* pValue = nil;
    CGRect pRect = CGRectZero;
    for (pView in theAccessedViews) {
        pRect = [theTargetView convertRect:pView.frame fromView:pView.superview];
        pValue = [NSValue valueWithCGRect:pRect];
        [mutableArray addObject:pValue];
    }
    
    [self setAccessedViewsRect:mutableArray];
    [mutableArray release];
    
}


- (id)init{
    if (self = [super init]) {
        removeSubviewsAfterLanding = YES;
        condition = FloatingViewUnused;
        
        oringinalRect = CGRectZero;
        animationRect = CGRectZero;
        stickingRect = CGRectZero;
        immediatePoint = CGPointZero;
        
        accessedViewsRect = nil;
        
    }
    return self;
}

- (id)initWithStageView:(UIView*)aStageView
{
    if (self = [self init]) {
        [self setStageView:aStageView];
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)dealloc{
    [accessedViewsRect release];
    accessedViewsRect = nil;

    stageView = nil;
    
    [super dealloc];
}

@end
