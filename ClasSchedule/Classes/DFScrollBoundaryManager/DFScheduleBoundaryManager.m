#import "DFScheduleBoundaryManager.h"
#import "DFScheduleBoundaryManagerCell.h"
#import "DFButtonsManager.h"
#import "DFTime.h"

@implementation DFScheduleBoundaryManager
@synthesize superview,beginTime,duration,minTimeScale,frame,timeDependenceMode,dataSource;

- (void)logAllCells
{
    for (DFScheduleBoundaryManagerCell* pCell in cells) {
        NSLog(@"%@  %f",pCell.beginTime,pCell.duration / 60);
    }
    printf("\n");
}

#pragma mark - Frame
- (CGRect)locateCell:(DFScheduleBoundaryManagerCell*)aCell
{
    if (CGRectEqualToRect(self.frame, CGRectZero)) {
        return CGRectZero;
    }
    CGFloat height = 0.0f;
    CGFloat y = 0.0f;
    switch (timeDependenceMode) {
        case TimeDependenceModeIndependent:{
            NSUInteger numberOfCells = [dataSource numberOfCellsManagedByManager:self];
            height = self.frame.size.height / numberOfCells;
            y = height * [cells indexOfObject:aCell];
            break;
        }
        case TimeDependenceModeDependent:{
            NSTimeInterval cellDuration = aCell.duration;
            NSDate* cellBeginTime = aCell.beginTime;
            
            height = [self lengthFromDuration:cellDuration];
            y = self.frame.origin.y + [self locationFromTime:cellBeginTime];
            break;
        }
        default:
            break;
    }
    
    CGFloat width = self.frame.size.width;
    CGFloat x = self.frame.origin.x;
    CGRect cellFrame = CGRectMake(x, y, width, height);
    [aCell setFrame:cellFrame];
    return cellFrame;
}

- (CGRect)locateCell:(DFScheduleBoundaryManagerCell*)aCell animated:(BOOL)animated
{
    CGRect theFrame = CGRectZero;
    if (animated) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        [UIView beginAnimations:@"locateCell:animated:" context:context];
        [UIView setAnimationDuration:0.5]; 
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        
        theFrame = [self locateCell:aCell];
        
        [UIView commitAnimations];
    }else{
        theFrame = [self locateCell:aCell];
    }
    return frame;
}
#pragma mark - Alter
- (void)beingStretchingCell:(DFScheduleBoundaryManagerCell *)aCell
{
    [buttonsManager setButtonsMask:ButtonsMaskAlterButtons];
    if (buttonsManager.linkingCell == aCell) {
        [buttonsManager recreateButtons];
    }else{
        [buttonsManager relinkToCell:aCell];
    }
}

- (void)cell:(DFScheduleBoundaryManagerCell*)aCell stretchedForDifference:(CGFloat)aDifference
{
    DFScheduleBoundaryManagerCell* theCell = aCell;
    CGFloat theDefference = aDifference;
    
    CGFloat maxAllowedLengthDifference = 0.0f;
    if (aDifference > 0) {
        maxAllowedLengthDifference = [self lengthCellCanProlong:aCell];
        theDefference = (theDefference < maxAllowedLengthDifference) ? theDefference : maxAllowedLengthDifference;
    }else{
        maxAllowedLengthDifference = [self lengthCellCanCurtail:aCell];
        theDefference = (-theDefference < -maxAllowedLengthDifference) ? theDefference : maxAllowedLengthDifference;
    }
    if (maxAllowedLengthDifference) {
        [theCell setLength:theCell.length + theDefference];
        if (theCell != [cells lastObject]) {
            NSUInteger index = 0;
            NSUInteger numberOfCells = [cells count];
            DFScheduleBoundaryManagerCell* pCell = nil;
            for (index = [cells indexOfObject:theCell] + 1; index < numberOfCells; index++) {
                pCell = [cells objectAtIndex:index];
                [pCell setLocation:pCell.topLocation + theDefference];
            }
        }
    }
}

- (void)endStretchingCell:(DFScheduleBoundaryManagerCell*)aCell
{
    DFScheduleBoundaryManagerCell* theCell = aCell;

    [theCell setDuration:[self scaleTimeInterval:[self durationFromLength:theCell.length]]];
    if (theCell != [cells lastObject]) {
        NSUInteger index = 0;
        NSUInteger numberOfCells = [cells count];
        DFScheduleBoundaryManagerCell* pCell = nil;
        NSDate* pScaledBeginTime = nil;
        for (index = [cells indexOfObject:theCell] + 1; index < numberOfCells; index++) {
            pCell = [cells objectAtIndex:index];
            pScaledBeginTime = [self scaleTime:[self timeFromLocation:pCell.topLocation]];
            [pCell setBeginTime:pScaledBeginTime];
        }
    }
}

- (void)alterByCell:(DFScheduleBoundaryManagerCell*)aCell timeInterval:(NSTimeInterval)anInterval
{
    BOOL canAlter = YES;
    DFScheduleBoundaryManagerCell* theCell = aCell;
    NSTimeInterval theInterval = anInterval;
    NSUInteger index = [cells indexOfObject:theCell];
    
    canAlter = [self canCellProlongOrCurtail:theCell timeInterval:theInterval];
    if (canAlter) {
        [theCell setDuration:theCell.duration + theInterval animated:YES];
        if (theCell != [cells lastObject]) {
            DFScheduleBoundaryManagerCell* nextCell = [cells objectAtIndex:index + 1];
            [self movedByCell:nextCell timeInterval:theInterval];
        }
    }
}

#pragma mark - Alter Test
- (CGFloat)lengthCellCanProlong:(DFScheduleBoundaryManagerCell *)aCell
{
    return [self locationCellCanIncrease:aCell];
}

- (CGFloat)lengthCellCanCurtail:(DFScheduleBoundaryManagerCell *)aCell
{
    CGFloat ditance = aCell.length - [self lengthFromDuration:self.minTimeScale];
    CGFloat lengthCellCanDecrease = (ditance < 0) ? 0 : ditance;
    return - lengthCellCanDecrease;
}

- (NSTimeInterval)intervalCellCanProlong:(DFScheduleBoundaryManagerCell *)aCell
{
    return [self intervalCellCanIncrease:aCell];
}

- (NSTimeInterval)intervalCellCanCurtail:(DFScheduleBoundaryManagerCell *)aCell
{
    NSTimeInterval difference = aCell.duration - self.minTimeScale;
    NSTimeInterval intervalCellCanCurtail = (difference < 0) ? 0 : difference ;
    return - intervalCellCanCurtail;
}

- (BOOL)canCellProlongOrCurtail:(DFScheduleBoundaryManagerCell *)aCell timeInterval:(NSTimeInterval)anInterval
{
    BOOL canMove = YES;
    if (anInterval > 0) {
        canMove = ([self intervalCellCanProlong:aCell] >= anInterval);
    }else{
        canMove = ([self intervalCellCanCurtail:aCell] <= anInterval);
    }
    return canMove;
}

#pragma mark - Move
- (void)beginDragingCell:(DFScheduleBoundaryManagerCell *)aCell
{
    [buttonsManager setButtonsMask:ButtonsMaskMoveButtons];
    if (buttonsManager.linkingCell == aCell) {
        [buttonsManager recreateButtons];
    }else{
        [buttonsManager relinkToCell:aCell];
    }
    //[buttonsManager hideAlterButton];
    //[buttonsManager showMoveButton];
}

- (void)cell:(DFScheduleBoundaryManagerCell*)aCell dragedToY:(CGFloat)aNewY
{
    CGFloat oldY = aCell.frame.origin.y;
    CGFloat locationDifference = aNewY - oldY;
    
    CGFloat maxAllowedLocationDifference = 0.0f;
    if (locationDifference > 0) {
        maxAllowedLocationDifference = [self locationCellCanIncrease:aCell];
        locationDifference = (locationDifference < maxAllowedLocationDifference) ? locationDifference : maxAllowedLocationDifference;
    }else{
        maxAllowedLocationDifference = [self locationCellCanDecrease:aCell];
        locationDifference = ( -locationDifference < -maxAllowedLocationDifference) ? locationDifference : maxAllowedLocationDifference;
    }

    if (maxAllowedLocationDifference) {
        NSUInteger numberOfCells = [cells count];
        NSUInteger index = 0;
        DFScheduleBoundaryManagerCell* pCell = nil;
        CGFloat pLocation = 0.0f;
        for (index = [cells indexOfObject:aCell]; index < numberOfCells; index++) {
            pCell = [cells objectAtIndex:index];
            pLocation = pCell.topLocation + locationDifference;
            [pCell setLocation:pLocation];
        }
    }
    [buttonsManager followLinkingCells];
}

- (void)endDragingCell:(DFScheduleBoundaryManagerCell*)aCell
{
    NSUInteger numberOfCells = [cells count];
    NSUInteger index = 0;
    DFScheduleBoundaryManagerCell* pCell = nil;
    NSDate* pScaledBeginTime = nil;
    for (index = [cells indexOfObject:aCell]; index < numberOfCells; index++) {
        pCell = [cells objectAtIndex:index];
        pScaledBeginTime = [self scaleTime:[self timeFromLocation:pCell.topLocation]];
        [pCell setBeginTime:pScaledBeginTime animated:YES];
        //NSLog(@"%@",[pCell.beginTime dateByAddingTimeInterval:8 * 60 * 60]);
    }
}

- (void)movedByCell:(DFScheduleBoundaryManagerCell*)aCell timeInterval:(NSTimeInterval)anInterval
{
    BOOL canMove = [self canCellIncreaseOrDecrease:aCell timeInterval:anInterval];
    if (canMove) {
        NSUInteger numberOfCells = [cells count];
        NSUInteger index = 0;
        DFScheduleBoundaryManagerCell* pCell = nil;
        NSTimeInterval pScaledTimeInterval = 0.0f;
        NSDate* pScaledBeginTime = nil;
        for (index = [cells indexOfObject:aCell]; index < numberOfCells; index++) {
            pCell = [cells objectAtIndex:index];
            pScaledTimeInterval = [self scaleTimeInterval:anInterval];
            pScaledBeginTime = [pCell.beginTime timeByAddingTimeInterval:pScaledTimeInterval];
            [pCell setBeginTime:pScaledBeginTime animated:YES];
        }
    }
    [buttonsManager followLinkingCells];
}

#pragma mark - Move Test
- (CGFloat)locationCellCanIncrease:(DFScheduleBoundaryManagerCell *)aCell
{
    NSUInteger currentCellIndex = [cells indexOfObject:aCell];
    
    CGFloat lastCellBottomLocation = aCell.bottomLocation;
    NSUInteger numberOfCells = [cells count];
    if ((currentCellIndex + 1) != numberOfCells) {
        DFScheduleBoundaryManagerCell* lastCell = [cells objectAtIndex:numberOfCells - 1];
        lastCellBottomLocation = lastCell.bottomLocation;
    }
    
    CGFloat maxBottomLocation = [self lengthFromDuration:self.duration];
    
    CGFloat locationCellCanIncrease = maxBottomLocation - lastCellBottomLocation;
    
    return locationCellCanIncrease;
}

- (CGFloat)locationCellCanDecrease:(DFScheduleBoundaryManagerCell *)aCell
{
    NSUInteger currentCellIndex = [cells indexOfObject:aCell];
    
    CGFloat currentCellTopLocation = aCell.topLocation;
    CGFloat minTopLocation = 0.0f;
    if (currentCellIndex) {
        DFScheduleBoundaryManagerCell* previousCell = [cells objectAtIndex:currentCellIndex - 1];
        minTopLocation = previousCell.bottomLocation;
    }
    
    CGFloat locationCellCanDecrease = minTopLocation - currentCellTopLocation;
    if (locationCellCanDecrease > 0) locationCellCanDecrease = minTopLocation - aCell.topLocation;
    
    return locationCellCanDecrease;
}

- (NSTimeInterval)intervalCellCanIncrease:(DFScheduleBoundaryManagerCell *)aCell
{
    NSUInteger currentCellIndex = [cells indexOfObject:aCell];
    
    NSTimeInterval lastCellEndTimeSinceManagerBeginTime = [aCell.beginTime timeIntervalSinceDate:self.beginTime] + aCell.duration;
    NSUInteger numberOfCells = [cells count];
    if ((currentCellIndex + 1) != numberOfCells) {
        DFScheduleBoundaryManagerCell* lastCell = [cells objectAtIndex:numberOfCells - 1];
        lastCellEndTimeSinceManagerBeginTime = [lastCell.beginTime timeIntervalSinceDate:self.beginTime] + lastCell.duration;
    }
    
    CGFloat intervalCellCanIncrease = duration - lastCellEndTimeSinceManagerBeginTime;
    
    return intervalCellCanIncrease;
}

- (NSTimeInterval)intervalCellCanDecrease:(DFScheduleBoundaryManagerCell *)aCell
{
    NSUInteger currentCellIndex = [cells indexOfObject:aCell];
    
    NSTimeInterval currentCellBeginTimeSinceManagerBeginTime = [aCell.beginTime timeIntervalSinceDate:self.beginTime];
    NSTimeInterval minIntevalSinceManagerBeginTime = 0.0f;
    if (currentCellIndex) {
        DFScheduleBoundaryManagerCell* previousCell = [cells objectAtIndex:currentCellIndex - 1];
        minIntevalSinceManagerBeginTime = [previousCell.beginTime timeIntervalSinceDate:self.beginTime] + previousCell.duration;
    }
    
    NSTimeInterval intervalCellCanDecrease = minIntevalSinceManagerBeginTime - currentCellBeginTimeSinceManagerBeginTime;
    
    return intervalCellCanDecrease;
}

- (BOOL)canCellIncreaseOrDecrease:(DFScheduleBoundaryManagerCell *)aCell timeInterval:(NSTimeInterval)anInterval
{
    BOOL canMove = YES;
    if (anInterval > 0) {
        canMove = ([self intervalCellCanIncrease:aCell] >= anInterval);
    }else{
        canMove = ([self intervalCellCanDecrease:aCell] <= anInterval);
    }
    return canMove;
}

#pragma mark - Length<->Duration    Location<->Time
- (CGFloat)lengthFromDuration:(NSTimeInterval)aDuration
{
    CGFloat length = aDuration / self.duration * self.frame.size.height;
    return length;
}

- (CGFloat)durationFromLength:(CGFloat)aLength
{
    CGFloat theDuration = aLength / self.frame.size.height * self.duration;
    return theDuration;
}

- (CGFloat)locationFromTime:(NSDate*)aTime
{
    NSTimeInterval intervalSinceBegin = [aTime timeIntervalSinceTime:self.beginTime];
    CGFloat location = [self lengthFromDuration:intervalSinceBegin];
    return location;
}

- (NSDate*)timeFromLocation:(CGFloat)aLocation
{
    CGFloat theDuration = [self durationFromLength:aLocation];
    NSDate* time = [NSDate timeWithTimeInterval:theDuration sinceTime:self.beginTime];
    return time;
}
#pragma mark - Scale
- (NSTimeInterval)scaleTimeInterval:(NSTimeInterval)anInterval
{
    NSTimeInterval scale = minTimeScale;
    double multiple = anInterval / scale;
    NSInteger roundedMultiple = 0;
    if (multiple > 0) {
        roundedMultiple = (NSInteger)(multiple + 0.5);
    }else{
        roundedMultiple = (NSInteger)(multiple - 0.5);
    }
    NSTimeInterval standardizedTimeInterval = roundedMultiple * scale;
    return standardizedTimeInterval;
}

- (NSDate*)scaleTime:(NSDate*)aTime
{
    NSTimeInterval intervalSinceBeginTime = [aTime timeIntervalSinceTime:self.beginTime];
    NSTimeInterval scaledInterval = [self scaleTimeInterval:intervalSinceBeginTime];
    NSDate* scaledTime = [NSDate timeWithTimeInterval:scaledInterval sinceTime:self.beginTime];
    return scaledTime;
}
#pragma mark - Cells
- (DFScheduleBoundaryManagerCell*)cellAtIndex:(NSUInteger)anIndex
{
    return [cells objectAtIndex:anIndex];
}

- (NSUInteger)indexOfCell:(DFScheduleBoundaryManagerCell*)aCell
{
    return [cells indexOfObject:aCell];
}

- (void)createCells
{
    NSUInteger numberOfCells = [dataSource numberOfCellsManagedByManager:self];
    NSMutableArray* cellsArray = [[NSMutableArray alloc] initWithCapacity:numberOfCells];
    cells = cellsArray;
    
    NSUInteger index = 0;
    DFScheduleBoundaryManagerCell* pCell = nil;
    NSDate* pBeginTime = nil;
    NSTimeInterval pDuration = 0.0f;
    for (index = 0; index < numberOfCells; index++) {
        pCell = [[DFScheduleBoundaryManagerCell alloc] init];
        [cellsArray addObject:pCell];
        [pCell release];

        pBeginTime = [dataSource scheduleBoundaryManager:self startTimeForCellAtIndex:index];
        [pCell setBeginTime:pBeginTime];
        pDuration = [dataSource scheduleBoundaryManager:self durationForCellAtIndex:index];
        [pCell setDuration:pDuration];
        [self locateCell:pCell];

        [pCell setManager:self];
        [pCell setBackgroundColor:[self cellColorAtIndex:index]];
        [pCell loadSubiews];
    }
}

- (void)locateCellAtIndex:(NSUInteger)anIndex
{
    DFScheduleBoundaryManagerCell* cell = [cells objectAtIndex:anIndex];
    [self locateCell:cell];
}

- (void)reloadData
{
    NSUInteger index = 0;
    DFScheduleBoundaryManagerCell* pCell = nil;
    NSDate* pBeginTime = nil;
    NSTimeInterval pDuration = 0.0f;
    for (index = 0; index < [cells count]; index++) {
        pCell = [cells objectAtIndex:index];
        
        pBeginTime = [dataSource scheduleBoundaryManager:self startTimeForCellAtIndex:index];
        [pCell setBeginTime:pBeginTime];
        
        pDuration = [dataSource scheduleBoundaryManager:self durationForCellAtIndex:index];
        [pCell setDuration:pDuration];
    }
}

- (UIColor*)cellColorAtIndex:(NSUInteger)anIndex
{
    BOOL isOdd = ((anIndex % 2) != 0);
    UIColor* backgroundColor = nil;
    if (isOdd) {
        backgroundColor = [UIColor colorWithRed:0.3f green:0.4f blue:0.5f alpha:0.7f]; 
    }else{
        backgroundColor = [UIColor colorWithRed:0.7f green:0.6f blue:0.5f alpha:0.7f]; 
    }
    return backgroundColor;
}
#pragma mark - Superview
- (void)addIntoView:(UIView*)aView
{
    [self createCells];
    [self setSuperview:aView];
    for (DFScheduleBoundaryManagerCell* pCell in cells) {
        [self.superview addSubview:pCell];
    }
    if (!buttonsManager) {
        buttonsManager = [[DFButtonsManager alloc] init];
    }
    [buttonsManager setSuperManager:self];
}

- (void)removeFromSuperview
{
    for (DFScheduleBoundaryManagerCell* pCell in cells) {
        [pCell removeFromSuperview];
    }
    [self setSuperview:nil];
    [cells removeAllObjects];
}

#pragma mark - Setter
- (void)setBeginTimeWithHour:(NSInteger)anHour minute:(NSUInteger)aMinute second:(NSUInteger)aSecond
{
    [self setBeginTime:[NSDate timeWithHour:anHour minute:aMinute second:aSecond]];
}

- (void)setDuration:(NSTimeInterval)aDuration{
    NSTimeInterval wholeDay = 24 * 60 * 60;
    if (aDuration <= 0 || wholeDay < aDuration ) {
    }else{
        duration = aDuration;
    }
}

- (void)setTimeDependenceMode:(TimeDependenceMode)aTimeDependenceMode animated:(BOOL)animated
{
    if (timeDependenceMode != aTimeDependenceMode) {
        [self setTimeDependenceMode:aTimeDependenceMode];
        [buttonsManager relinkToCell:nil];
        
        switch (timeDependenceMode) {
            case TimeDependenceModeIndependent:{
                DFScheduleBoundaryManagerCell* pCell = nil;
                for (pCell in cells) {
                    [self locateCell:pCell animated:animated];
                    [pCell hideStretcher];
                    [pCell hideDragerAnimated:animated];
                }
                break;
            }
            case TimeDependenceModeDependent:{
                DFScheduleBoundaryManagerCell* pCell = nil;
                for (pCell in cells) {
                    [self locateCell:pCell animated:animated];
                    [pCell showStretcher];
                    [pCell showDragerAnimated:animated];
                }
                break;
            }
            default:
                break;
        }
    }
}

#pragma mark - lifecycle
- (id)init{
    if (self = [super init]) {
        [self setFrame:CGRectZero];
        [self setDuration:24 * 60 * 60];
        [self setTimeDependenceMode:TimeDependenceModeIndependent];
    }
    return self;
}

- (void)dealloc{
    superview = nil;
    
    [cells release];
    cells = nil;
    
    [beginTime release];
    beginTime = nil;
    
    [buttonsManager release];
    buttonsManager = nil;
    
    dataSource = nil;
    
    [super dealloc];
}
@end
