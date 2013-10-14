//
//  DFFormView.m
//  ClasSchedule
//
//  Created by DreamerMac on 12-3-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DFFormView.h"
#import "DFFormViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation DFFormView
@synthesize colCount,rowCount;
@synthesize cellsShouldBeConfigured,commonCellBackgroundImage,isTopBoundaryViewsHidden,touchingConditon,isContentHidden,shadowOffset;
@synthesize dataSource,delegate;

#pragma mark - Frames
- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    NSUInteger colIndex = 0,rowIndex = 0;
    DFFormViewCell* pCell = nil;
    for (colIndex = 0; colIndex < colCount; colIndex++) {
        for (rowIndex = 0; rowIndex < rowCount; rowIndex++) {
            pCell = [self cellAtColumn:colIndex row:rowIndex];
            [pCell setFrame:[self cellFrameByCol:colIndex row:rowIndex]];
        }
    }
    
    UIView* pView = nil;
    for (colIndex = 0; colIndex < colCount; colIndex++) {
            pView = [topBoundaryViews objectAtIndex:colIndex];
            [pView setFrame:[self topBoundaryViewFrameWithHeight:20.0f onColumn:colIndex]];
    }
}

- (CGRect)cellFrameByCol:(NSUInteger)aColumnIndex row:(NSUInteger)aRowIndex
{
    return [self cellFrameByCol:aColumnIndex row:aRowIndex colCount:colCount rowCount:rowCount];
}

- (CGRect)cellFrameByCol:(NSUInteger)aColumnIndex row:(NSUInteger)aRowIndex colCount:(NSUInteger)aColCount rowCount:(NSUInteger)aRowCount
{
    float width = self.frame.size.width/aColCount;
	float height = self.frame.size.height/aRowCount;
	float x = aColumnIndex * width;
	float y = aRowIndex * height;
	return CGRectMake(x, y, width, height);
}

- (CGRect)topBoundaryViewFrameWithHeight:(float)aHeight onColumn:(NSUInteger)aColumnIndex
{
    return [self topBoundaryViewFrameWithHeight:aHeight onColumn:aColumnIndex inColCount:colCount];
}

- (CGRect)topBoundaryViewFrameWithHeight:(float)aHeight onColumn:(NSUInteger)aColumnIndex inColCount:(NSUInteger)aColCount
{
	float width = self.frame.size.width/aColCount;
	float height = aHeight;
	float x = aColumnIndex * width;
	float y = -height;
	return CGRectMake(x, y, width, height);
}

- (CGRect)rightBoundaryViewFrameWithWidth:(float)aWidth onRow:(NSUInteger)aRowIndex
{
	return [self rightBoundaryViewFrameWithWidth:aWidth onRow:aRowIndex inRowCount:rowCount];
}

- (CGRect)rightBoundaryViewFrameWithWidth:(float)aWidth onRow:(NSUInteger)aRowIndex inRowCount:(NSUInteger)aRowCount
{
    float width = aWidth;
	float height = self.frame.size.height/aRowCount;
	float x = self.frame.size.width;
	float y = aRowIndex * height;
	return CGRectMake(x, y, width, height);
}
#pragma mark - Animation
- (void)transformSelfIntoRect:(CGRect)aRect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:@"transformSelfIntoRect" context:context];
	[UIView setAnimationDuration:0.5f]; 
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationBeginsFromCurrentState:YES];
	[self setFrame:aRect];
	[UIView commitAnimations];
}

#pragma mark - Tracking Event
- (BOOL)beginTrackingWithTouch:(UITouch *)touch cellAtColumnIndex:(NSUInteger)aColumnIndex rowIndex:(NSUInteger)aRowIndex
{
	BOOL isContinue = YES;
    switch (self.touchingConditon) {
        case DFFormViewTouchingConditonNone:{
            isContinue = NO;
            break;
        }
        
        case DFFormViewTouchingConditonCell:{
            DFFormViewCell* cell = [self cellAtColumn:aColumnIndex row:aRowIndex];
            [cell beganTouch];
            if ([delegate respondsToSelector:@selector(touchedDownInsideCellAtColumn:row:)]) {
                [delegate touchedDownInsideCellAtColumn:aColumnIndex row:aRowIndex];
            }
            break;
        }
        
        case DFFormViewTouchingConditonColumn:{
            NSArray* cells = [self cellsAtColumn:aColumnIndex];
            DFFormViewCell* cell = nil;
            for (cell in cells) {
                [cell beganTouch];
            }
            break;
        }
        
        case DFFormViewTouchingConditonRow:{
            NSArray* cells = [self cellsAtRow:aRowIndex];
            DFFormViewCell* cell = nil;
            for (cell in cells) {
                [cell beganTouch];
            }
            break;
        }
        default:
            break;
    }
    return isContinue;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch cellAtColumnIndex:(NSUInteger)aColumnIndex rowIndex:(NSUInteger)aRowIndex
{
    NSUInteger theColumnIndex = aColumnIndex;
    NSUInteger theRowIndex = aRowIndex;
    CGPoint oringin = [touch locationInView:self];
    
    BOOL isInside = NO;
    switch (self.touchingConditon) {
        case DFFormViewTouchingConditonNone:
            break;
        case DFFormViewTouchingConditonCell:{
            DFFormViewCell* cell = [self cellAtColumn:aColumnIndex row:aRowIndex];
            if (CGRectContainsPoint(cell.frame, oringin)) isInside = YES;
            if ([delegate respondsToSelector:@selector(touch:moveFromCellAtColumn:row:inside:)]) {
                [delegate touch:touch moveFromCellAtColumn:theColumnIndex row:theRowIndex inside:isInside];
            }
            break;
        }
            
        case DFFormViewTouchingConditonColumn:{
             break;
        }
            
        case DFFormViewTouchingConditonRow:{
            break;
        }
        default:
            break;
    }
	return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch cellAtColumnIndex:(NSUInteger)aColumnIndex rowIndex:(NSUInteger)aRowIndex
{
    NSUInteger theColumnIndex = aColumnIndex;
    NSUInteger theRowIndex = aRowIndex;
    CGPoint oringin = [touch locationInView:self];
    
    BOOL isInside = NO;
    switch (self.touchingConditon) {
        case DFFormViewTouchingConditonNone:
            break;
        case DFFormViewTouchingConditonCell:{
            DFFormViewCell* cell = [self cellAtColumn:theColumnIndex row:theRowIndex];
            isInside = CGRectContainsPoint(cell.frame, oringin);
            if (isInside) {
                [cell touchedUpInside];
                if ([delegate respondsToSelector:@selector(touchedUpInsideCellAtColumn:row:)]) {
                    [delegate touchedUpInsideCellAtColumn:theColumnIndex row:theRowIndex];
                }
            }else{
                [cell touchedUpOutside];
            }
            if ([delegate respondsToSelector:@selector(touchedUpInside:cellAtColumn:row:)]) {
                [delegate touchedUpInside:isInside cellAtColumn:theColumnIndex row:theRowIndex];
            }
            break;
        }
        case DFFormViewTouchingConditonColumn:{
            NSArray* cells = [self cellsAtColumn:theColumnIndex];
            DFFormViewCell* cell = nil;
            
            for (cell in cells) {
                if (CGRectContainsPoint(cell.frame, oringin)){
                    isInside = YES;
                    break;
                }
            }
            if (isInside) {
                for (cell in cells) {
                    [cell touchedUpInside];
                }
                if ([delegate respondsToSelector:@selector(touchedUpInsideCellsAtColumn:)]) {
                    [delegate touchedUpInsideCellsAtColumn:theColumnIndex];
                }
            }else{
                for (cell in cells) {
                    [cell touchedUpOutside];
                }
            }
            break;
        }
        case DFFormViewTouchingConditonRow:{
            NSArray* cells = [self cellsAtRow:theRowIndex];
            DFFormViewCell* cell = nil;
            
            for (cell in cells) {
                if (CGRectContainsPoint(cell.frame, oringin)){
                    isInside = YES;
                    break;
                }
            }
            if (isInside) {
                for (cell in cells) {
                    [cell touchedUpInside];
                }
                if ([delegate respondsToSelector:@selector(touchedUpInsideCellsAtRow:)]) {
                    [delegate touchedUpInsideCellsAtRow:theRowIndex];
                }
            }else{
                for (cell in cells) {
                    [cell touchedUpOutside];
                }
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark - Cell Management
- (DFFormViewCell*)getAllocedCellFromDataSourceAtColumnIndex:(NSUInteger)aColIndex rowIndex:(NSUInteger)aRowIndex
{
    if (!dataSource) return nil;
    //DFFormViewCell* cell = [dataSource formView:self cellAtColumnIndex:aColIndex rowIndex:aRowIndex];
    DFFormViewCell* cell = [dataSource allocCellForFormView:self];
    
    [cell setFrame:[self cellFrameByCol:aColIndex row:aRowIndex]];
    [cell setSuperFormView:self];
    [cell setColIndex:aColIndex];
    [cell setRowIndex:aRowIndex];
    [cell setAutoresizingMask:63];
    
    if (canCellBeConfigured) [dataSource configureCell:cell atColumnIndex:aColIndex rowIndex:aRowIndex];
    
    //[cell loadSubviews];
    return  cell;
}

- (NSArray*)cellsAtColumn:(NSUInteger)aColumnIndex
{
    NSArray* array = [[[NSArray alloc] initWithArray:[cellsGroupedByColumn objectAtIndex:aColumnIndex]] autorelease];
    return array;
}

- (NSArray*)cellsAtRow:(NSUInteger)aRowIndex
{
    NSMutableArray* tempArray = [[NSMutableArray alloc] initWithCapacity:colCount];
    NSArray* pArray = nil;
    for (pArray in cellsGroupedByColumn) {
        [tempArray addObject:[pArray objectAtIndex:aRowIndex]];
    }
    
    NSArray* array = [[[NSArray alloc] initWithArray:tempArray] autorelease];
    
    [tempArray release];
    
    return array;
}

- (DFFormViewCell*)cellAtColumn:(NSUInteger)aColumnIndex row:(NSUInteger)aRowIndex
{
    DFFormViewCell* cell = nil;
    if (aColumnIndex < colCount && aRowIndex < rowCount) {
        cell = [[cellsGroupedByColumn objectAtIndex:aColumnIndex] objectAtIndex:aRowIndex];
    }
    return cell;
}

- (DFFormViewCell*)cellAtOneDimensionIndex:(NSUInteger)anIndex
{
    NSUInteger columnIndex = anIndex / rowCount;
    NSUInteger rowIndex = anIndex % rowCount;
    return [self cellAtColumn:columnIndex row:rowIndex];
}

- (NSArray*)oneDimensionCellArray
{
    NSMutableArray* mutableArray = [[NSMutableArray alloc] initWithCapacity:colCount * rowCount];
    for (NSArray* pColOfCells in cellsGroupedByColumn) {
        [mutableArray addObjectsFromArray:pColOfCells];
    }
    //NSArray* returnArray = [[NSArray alloc] initWithArray:mutableArray];
    NSArray* returnArray = [NSArray arrayWithArray:mutableArray];
    [mutableArray release];
    return returnArray;
}
#pragma mark - Shadow
- (void)setShadowOffset:(CGSize)aShadowOffset{
    if (CGSizeEqualToSize(aShadowOffset, CGSizeZero)) {
        [self.layer setShadowPath:NULL];
        [self.layer setShadowOffset:CGSizeMake(0.0f, -0.3f)];
        [self.layer setShadowRadius:3.0f];
        [self.layer setShadowOpacity:0.0f];
        [self.layer setShadowColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f].CGColor];
    }else{
        [self.layer setShadowPath:[UIBezierPath bezierPathWithRect:self.bounds].CGPath];
        [self.layer setShadowOffset:aShadowOffset];
        [self.layer setShadowRadius:10.0f];
        [self.layer setShadowOpacity:0.6f];
        [self.layer setShadowColor:[UIColor blackColor].CGColor];
    }
}

#pragma mark - Content
- (void)setIsContentHidden:(BOOL)anIsContentHidden{
    if (isContentHidden != anIsContentHidden) {
        if (anIsContentHidden) {
            [self hideContent];
        }else{
            [self showContent];
        }
    }
    isContentHidden = anIsContentHidden;
}

- (void)showContent
{
    NSArray* allCells = [self oneDimensionCellArray];
    DFFormViewCell* pCell = nil;
    for (pCell in allCells) {
        [pCell showContent];
    }
}

- (void)hideContent
{
    NSArray* allCells = [self oneDimensionCellArray];
    DFFormViewCell* pCell = nil;
    for (pCell in allCells) {
        [pCell hideContent];
    }
}



- (void)reloadContent
{
    NSUInteger pColIndex = 0;
    NSMutableArray* pColumn = nil;
    //NSUInteger pRowIndex = 0;
    DFFormViewCell* pCell = nil;
    
    /*
    for (pColIndex = 0; pColIndex < colCount; pColIndex ++) {
        pColumn = [cellsGroupedByColumn objectAtIndex:pColIndex];
        for (pRowIndex = 0; pRowIndex < rowCount; pRowIndex ++) {
            pCell = [pColumn objectAtIndex:pRowIndex];
            [pCell setColIndex:pColIndex];
            [pCell setRowIndex:pRowIndex];
            if (canCellBeConfigured) [dataSource configureCell:pCell atColumnIndex:pColIndex rowIndex:pRowIndex];
            
        }
    }*/
    
    for (pColumn in cellsGroupedByColumn) {
        for (pCell in pColumn) {
            [pCell releaseContent];        
        }
    }
    if ([dataSource respondsToSelector:@selector(fillFormWithContent:)]) {
        [dataSource fillFormWithContent:self];
    }
    for (pColumn in cellsGroupedByColumn) {
        for (pCell in pColumn) {
            [pCell reloadContent];
        }
    }
    
    if ([dataSource respondsToSelector:@selector(topBoundaryView:onColumn:)]) {
        UIView* pView = nil;
        for (pColIndex = 0; pColIndex < colCount; pColIndex ++) {
            pView = [topBoundaryViews objectAtIndex:pColIndex];
            [dataSource topBoundaryView:pView onColumn:pColIndex];
        }
    }
}
#pragma mark - TopBoundaryViews
- (void)setIsTopBoundaryViewsHidden:(BOOL)anIsTopBoundaryViewsHidden{
    if (self.isTopBoundaryViewsHidden == anIsTopBoundaryViewsHidden) return;
    CGFloat alpha = 1.0f;
    if (anIsTopBoundaryViewsHidden) {
        alpha = 0.0f;
    }
    
    UIView* pView = nil;
    for (pView in topBoundaryViews) {
        [pView setAlpha:alpha];
    }
    
    /*
    if (anIsTopBoundaryViewsHidden) {
        [self destroyTopBoundaryViews];
    }else{
        [self createTopBoundaryViews];
    }*/
    isTopBoundaryViewsHidden = anIsTopBoundaryViewsHidden;
    
}

- (void)createTopBoundaryViews
{
    if (!topBoundaryViews) {
        topBoundaryViews = [[NSMutableArray alloc] initWithCapacity:colCount];
    }
    NSUInteger pColumnIndex = 0;
    UIView* pView = nil;
    CGFloat height = 20.0f;
    
    for (pColumnIndex = 0; pColumnIndex < colCount; pColumnIndex++) {
        pView = [[UIView alloc] init];
        [topBoundaryViews addObject:pView];
        [pView release];
        [self addSubview:pView];

        [pView setAutoresizingMask:63];
        [pView setFrame:[self topBoundaryViewFrameWithHeight:height onColumn:pColumnIndex]];
        [dataSource topBoundaryView:pView onColumn:pColumnIndex];
    }
}

- (void)destroyTopBoundaryViews
{
    if (!topBoundaryViews) return;
    UIView* pView = nil;
    for (pView in topBoundaryViews) {
        [pView removeFromSuperview];
    }
    [topBoundaryViews release];
    topBoundaryViews = nil;
}

- (void)recreateTopBoundaryViewsWithColCount:(NSUInteger)aColCount
{
    CGFloat height = 20.0f;
    
    NSUInteger oldColCount = colCount;
	NSUInteger newColCount = aColCount;
	NSUInteger colIndex = 0;
    UIView* cuView = nil;
    if (newColCount == oldColCount) {
    }else if (newColCount < oldColCount) {
        //Remove useless views
        for (colIndex = oldColCount - 1; colIndex > newColCount - 1; colIndex--) {
            cuView = [topBoundaryViews objectAtIndex:colIndex];
            [topBoundaryViews removeObjectAtIndex:colIndex];
            [cuView removeFromSuperview];
            //[cuView release];
        }
        
        //Tansform useful views
        [UIView beginAnimations:@"TopViewReduce" context:nil];
        [UIView setAnimationDuration:0.5f]; 
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        for (colIndex = 0; colIndex <= newColCount - 1; colIndex++) {
            cuView = [topBoundaryViews objectAtIndex:colIndex];
            [cuView setFrame:[self topBoundaryViewFrameWithHeight:cuView.frame.size.height onColumn:colIndex inColCount:newColCount]];
        }
        [UIView commitAnimations];
        
    }else if (newColCount > oldColCount) {
        //Add new views
        for (colIndex = oldColCount; colIndex <= newColCount - 1; colIndex++) {
            cuView = [[UIView alloc] init];
            [topBoundaryViews addObject:cuView];
			[cuView release];
            [self addSubview:cuView];

            [cuView setFrame:[self topBoundaryViewFrameWithHeight:height onColumn:colIndex]];
			[cuView setAutoresizingMask:63];
            [dataSource topBoundaryView:cuView onColumn:colIndex];
            if (isTopBoundaryViewsHidden) {
                [cuView setAlpha:0.0f];
            }
            
            //[cuView release];
        }
        
        //Tansform useful views
        [UIView beginAnimations:@"TopViewIncrease" context:nil];
        [UIView setAnimationDuration:0.5f]; 
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        for (colIndex = 0; colIndex < newColCount; colIndex++) {
            cuView = [topBoundaryViews objectAtIndex:colIndex];
            [cuView setFrame:[self topBoundaryViewFrameWithHeight:cuView.frame.size.height onColumn:colIndex inColCount:newColCount]];
        }
        [UIView commitAnimations];
    }
}

#pragma mark - Form
- (void)createForm
{
    if (!cellsGroupedByColumn) {
        cellsGroupedByColumn = [[NSMutableArray alloc] initWithCapacity:colCount];
    }
    
    NSUInteger pColIndex = 0;
    NSMutableArray* pColumn = nil;
    NSUInteger pRowIndex = 0;
    DFFormViewCell* pCell = nil;
    
    for (pColIndex = 0; pColIndex < colCount; pColIndex ++) {
        pColumn = [[NSMutableArray alloc] initWithCapacity:rowCount];
        [cellsGroupedByColumn addObject:pColumn];
        [pColumn release];
        for (pRowIndex = 0; pRowIndex < rowCount; pRowIndex ++) {
            pCell = [self getAllocedCellFromDataSourceAtColumnIndex:pColIndex rowIndex:pRowIndex];
            [self insertSubview:pCell atIndex:0];
            [pColumn addObject:pCell];
            [pCell release];
        }
    }
    
    if ([dataSource respondsToSelector:@selector(fillFormWithContent:)]) {
        [dataSource fillFormWithContent:self];
    }
    
    for (pColumn in cellsGroupedByColumn) {
        for (pCell in pColumn) {
            [pCell loadSubviews];
        }
    }
    
    if (!isTopBoundaryViewsHidden) {
        [self createTopBoundaryViews];
    }
}

- (void)recreateCellsWithColCount:(NSUInteger)aColCount rowCount:(NSUInteger)aRowCount
{
	NSUInteger oldColCount = colCount;
	NSUInteger oldRowCount = rowCount;
	NSUInteger newColCount = aColCount;
    NSUInteger newRowCount = aRowCount;
    
    //colCount = aColCount;
    //rowCount = aRowCount;
    
	NSUInteger colIndex = 0;
	NSUInteger rowIndex = 0;
	
    NSMutableArray* theCells = cellsGroupedByColumn;
	NSMutableArray* cuColArray = nil;
	DFFormViewCell* cuCell;
    CGRect cuFrame = CGRectZero;
    
    NSMutableArray* reserveCells = [[NSMutableArray alloc] init];
    NSMutableArray* createdCells = [[NSMutableArray alloc] init];
    NSMutableArray* destroyedCells = [[NSMutableArray alloc] init];
    
    /*Includes 2 parts,PartA & PartB*/
    
    /*PartA,new form contrast with old form.Create the cell that new form include but old form does not.*/
    for (colIndex = 0; colIndex < newColCount; colIndex++) {
        if (colIndex < [theCells count]) {
            cuColArray = [theCells objectAtIndex:colIndex];
        } else {
            cuColArray = [[NSMutableArray alloc] initWithCapacity:newColCount];
            [theCells addObject:cuColArray];
            [cuColArray release];
        }
        
        for (rowIndex = 0; rowIndex < newRowCount; rowIndex++) {
            if (rowIndex < [cuColArray count]) {
                /*Alert reserved cells' frame*/
                cuCell = [cuColArray objectAtIndex:rowIndex];
                
                [reserveCells addObject:cuCell];
            } else {
                /*Create new cell*/
                cuFrame = [self cellFrameByCol:colIndex row:rowIndex colCount:newColCount rowCount:newRowCount];
                //cuCell = [[DFFormViewCell alloc] initWithFrame:CGRectZero manager:self col:colIndex row:rowIndex];
                cuCell = [self getAllocedCellFromDataSourceAtColumnIndex:colIndex rowIndex:rowIndex];
                [cuColArray addObject:cuCell];
                [cuCell release];
                
                [createdCells addObject:cuCell];
            }
        }
    }
    
    /*PartB,old form contrast with new form,destroy the cell that old form include but new form does not.*/
    for (colIndex = oldColCount - 1; colIndex < oldColCount; colIndex--) {
        cuColArray = [theCells objectAtIndex:colIndex];
        
        
        if (colIndex < newColCount) {
            /*Destroy cells in col*/
            for (rowIndex = oldRowCount - 1; rowIndex < oldRowCount; rowIndex--) {
                if (rowIndex < newRowCount) {
                    //Do nothing
                } else {
                    cuCell = [cuColArray objectAtIndex:rowIndex];
                    [destroyedCells addObject:cuCell];
                    [cuColArray removeObjectAtIndex:rowIndex];
                }
            }
        } else {
            /*Destroy col*/
            for (cuCell in cuColArray) {
                [destroyedCells addObject:cuCell];
            }
            [theCells removeObjectAtIndex:colIndex];
        }
    }
    
    for (cuCell in destroyedCells) {
        [cuCell removeFromSuperview];
    }
    
    for (cuCell in reserveCells) {
        cuFrame = [self cellFrameByCol:cuCell.colIndex row:cuCell.rowIndex colCount:newColCount rowCount:newRowCount];
        //[cuCell setFrame:cuFrame];
        [cuCell transformIntoFrame:cuFrame];
    }
    
    for (cuCell in createdCells) {
        [self insertSubview:cuCell atIndex:0];
        
        cuFrame = [self cellFrameByCol:cuCell.colIndex row:cuCell.rowIndex colCount:newColCount rowCount:newRowCount];
        //[cuCell setFrame:cuFrame];
        [cuCell transformIntoFrame:cuFrame];
    }
    
    [destroyedCells release];
    [reserveCells release];
    [createdCells release];
}

#pragma mark - Memory Management
- (id)init{
    if (self = [super init]) {
        colCount = 0;
        rowCount = 0;
        
        isTopBoundaryViewsHidden = YES;
        
        touchingConditon = DFFormViewTouchingConditonNone;
        
        isContentHidden = NO;
        shadowOffset = CGSizeMake(0.0f, 0.0f);
    }
    return self;
}
- (void)setDataSource:(id<DFFormViewDataSource>)aDdataSource
{
    dataSource = aDdataSource;
    canCellBeConfigured = [dataSource respondsToSelector:@selector(configureCell:atColumnIndex:rowIndex:)];
}
- (void)setColCount:(NSUInteger)aColCount{
    
    if (cellsGroupedByColumn) {
        if (colCount != aColCount) {
            [self recreateCellsWithColCount:aColCount rowCount:rowCount];
            [self recreateTopBoundaryViewsWithColCount:aColCount];
        }
    }
    colCount = aColCount;

}

- (void)setRowCount:(NSUInteger)aRowCount{
    if (cellsGroupedByColumn) {
        if (rowCount != aRowCount) {
            [self recreateCellsWithColCount:colCount rowCount:aRowCount];
        }
    }
    rowCount = aRowCount;
}

- (void)setColCount:(NSUInteger)aColCount rowCount:(NSUInteger)aRowCount
{
    [self recreateTopBoundaryViewsWithColCount:aColCount];
    [self recreateCellsWithColCount:aColCount rowCount:aRowCount];
    colCount = aColCount;
    rowCount = aRowCount;
}

- (void)dealloc{
    [cellsShouldBeConfigured release];
    cellsShouldBeConfigured = nil;
    
    /*
    for (NSMutableArray* pColumn in cellsGroupedByColumn) {
        for (DFFormViewCell* pCell in pColumn) {
            [pCell removeFromSuperview];
            [pCell release];
        }
        [pColumn removeAllObjects];
    }*/
    [cellsGroupedByColumn release];
    cellsGroupedByColumn = nil;
    
    [commonCellBackgroundImage release];
    commonCellBackgroundImage = nil;
    
	[topBoundaryViews release];
    topBoundaryViews = nil;
        
    dataSource = nil;
    delegate = nil;
    
    [super dealloc];
}

@end
