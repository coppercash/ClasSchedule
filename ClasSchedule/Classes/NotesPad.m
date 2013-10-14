//
//  NotesPad.m
//  ClasSchedule
//
//  Created by DreamerMac on 12-4-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NotesPad.h"
#import "CSDataCenter.h"
#import "NotePaper.h"
#import "Note.h"
#import "Course.h"

@implementation NotesPad
@synthesize enteringPaperStageView,delegate,firstDirectionCellLength,firstDirectionMargin,secondDirectionMargin,secondDirectionCellCount,course;

#pragma mark - Frames
- (CGRect)locateNotePaper:(NotePaper*)aNotePaper byIndex:(NSUInteger)anIndex ofCount:(NSUInteger)aCount
{
    CGFloat width = 100.0f;
    CGFloat height = width;
    
    NotePaper* theNotePaper = aNotePaper;
    [theNotePaper setBounds:CGRectMake(0.0f, 0.0f, width, height)];
    [theNotePaper setCenter:[self notePaperCenterByIndex:anIndex ofCount:aCount] withAnimation:NO];
    
    CGRect rect = theNotePaper.frame;
    return rect;
}

- (CGFloat)firstContentLengthWithCount:(NSUInteger)aCount
{
    NSUInteger count = aCount + 1;
    NSUInteger secondCount = secondDirectionCellCount;
    CGFloat firstCellLength = firstDirectionCellLength;
    CGFloat theFirstDirectionMargin = firstDirectionMargin;
    
    NSUInteger firstCount = ceilf( (float)count / (float)secondCount );
    CGFloat firstContentLength = firstCellLength * firstCount + 2 * theFirstDirectionMargin;
    
    return firstContentLength;
}

- (CGPoint)notePaperCenterByIndex:(NSUInteger)anIndex ofCount:(NSUInteger)aCount
{
    NSUInteger modelIndex = anIndex;
    NSUInteger modelCount = aCount;
    
    //NSUInteger graphicCount = modelCount + 1;
    NSUInteger graphicIndex = 0;
    /*
    if (modelIndex == NSUIntegerMax) graphicIndex = 0;
    else graphicIndex = modelCount - modelIndex;
    */
    if (modelIndex == NSUIntegerMax) modelIndex = modelCount;
    graphicIndex = modelCount - modelIndex;
    
    CGPoint point = [self notePaperGraphicCenterByIndex:graphicIndex];
    
    return point;
}

- (CGPoint)notePaperGraphicCenterByIndex:(NSUInteger)anIndex
{
    /*Localize Parameters*/
    NSUInteger index = anIndex;
    
    NSUInteger secondCount = secondDirectionCellCount;
    CGFloat firstCellLength = firstDirectionCellLength;
    CGFloat theFirstDirectionMargin = firstDirectionMargin;
    CGFloat theSecondDirectionMargin = secondDirectionMargin;
    
    /*Graphic Math*/
    CGFloat secondPadLength = self.contentSize.height - 2 * theSecondDirectionMargin;  
    //CGFloat secondPadLength = self.contentSize.width - 2 * secondDirectionMargin;
    CGFloat secondCellLength = secondPadLength / secondCount;
    
    NSUInteger firstIndex = index / secondCount;
    NSUInteger secondIndex = index % secondCount;
    
    NSUInteger firstCoordinate = theFirstDirectionMargin + 0.5 * firstCellLength + firstIndex * firstCellLength;
    NSUInteger secondCoordinate = theSecondDirectionMargin  + 0.5 * secondCellLength + secondIndex * secondCellLength;
    
    CGPoint point = CGPointZero;
    point = CGPointMake(firstCoordinate, secondCoordinate);
    //point = CGPointMake(secondCoordinate, firstCoordinate);
    return point;
}

#pragma mark - Subviews
- (void)loadSubviews
{
    
    NotesPad* theNotesPad = self;
    
    CSDataCenter* dataCenter = [CSDataCenter sharedDataCenter];
    NSArray* sortedContent = [dataCenter sortedNotesOfCourse:course];
    NSUInteger notesCount = [sortedContent count]; 
    [theNotesPad setShowsHorizontalScrollIndicator:YES];
    
    NotePaper* pNotePaper = nil;
    NSUInteger index = 0;
    for (index = 0; index <= notesCount; index++) {
        if (index != notesCount) {
            pNotePaper = [[NotePaper alloc] initWithNote:[sortedContent objectAtIndex:index]];
        }else{
            pNotePaper = [[NotePaper alloc] initWithNote:nil];
        }
        [theNotesPad addSubview:pNotePaper];
        //[pNotePaper release];
        [self locateNotePaper:pNotePaper byIndex:index ofCount:notesCount];
        //[pNotePaper setIndex:index];
        [pNotePaper setNotesPad:self];
        
        if (index != notesCount) {
            [notePapers addObject:pNotePaper];
            [pNotePaper release];
        }else{            
            additonNotePaper = pNotePaper;
            //additonNotePaper = [pNotePaper retain];
            //[pNotePaper loadSubviewsAdditionType];
        }
        [pNotePaper loadSubviews];
    }

}

#pragma mark - Manamge NotePaper
- (void)insertNewNotePaperWithNote:(Note*)aNote
{
    Note* theNote = aNote;
    NotesPad* theNotesPad = self;
    
    NotePaper* newNotePaper = [[NotePaper alloc] initWithNote:theNote];
    [notePapers addObject:newNotePaper];
    [newNotePaper release];
    [theNotesPad addSubview:newNotePaper];
    
    [self locateNotePaper:newNotePaper byIndex:NSUIntegerMax ofCount:0];    //NSUIntegerMax for Additon Button
    [newNotePaper setNotesPad:theNotesPad];
    
    [newNotePaper loadSubviews];
    
    [self performSelector:@selector(locateNotePapersAnimation) withObject:self afterDelay:0.7f];
    
    [self autoFitContentSize];
}

- (void)removeNotePaper:(NotePaper*)aNotePaper
{
    NotePaper* theNotePaper = aNotePaper;
    
    [[CSDataCenter sharedDataCenter] deleteCoreDataObject:theNotePaper.note];
    [course removeNotesObject:theNotePaper.note];

    [notePapers removeObject:theNotePaper];
    [theNotePaper removeFromSuperview];
    
    [self performSelector:@selector(locateNotePapersAnimation) withObject:self afterDelay:0.7f];

    [self autoFitContentSize];
}

- (void)removeAlertingNotePaper
{
    [self removeNotePaper:_alertingNotePaper];
}

- (void)locateNotePapersAnimation
{
    NSUInteger index = 0;
    NSUInteger count = [notePapers count];
    NotePaper* pNotePaper = nil;
    for (index = 0; index < count; index++) {
        pNotePaper = [notePapers objectAtIndex:index];
        [pNotePaper setCenter:[self notePaperCenterByIndex:index ofCount:count] withAnimation:YES];
    }
}

- (void)notePaperTapped:(NotePaper*)aNotePaper
{
    [self expandEnteringNotePaper:aNotePaper];
}

#pragma mark - Aniamtion
- (void)shrinkEnteringNotePaperAndSave:(BOOL)aSave
{
    if (aSave) {
        [self save];
        [_alertingNotePaper reloadData];
    }
    
    if ([delegate respondsToSelector:@selector(enteringNotePaperWillShrink:)]) {
        [delegate enteringNotePaperWillShrink:enteringNotePaper];
    }
    
    for (UIView* pSubview in enteringNotePaper.subviews) {
        [pSubview setAlpha:0.0f];
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:@"shrinkEnteringNotePaperAndSave:" context:context];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	[UIView setAnimationDuration:0.5f]; 
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	
    [enteringNotePaper setFrame:[enteringPaperStageView convertRect:_alertingNotePaper.frame fromView:self]];
    
	[UIView commitAnimations];
    
    if ([delegate respondsToSelector:@selector(enteringNotePaperDidShrink:)]) {
        [delegate enteringNotePaperDidShrink:enteringNotePaper];
    }
    
    _alertingNotePaper = nil;
}

- (void)expandEnteringNotePaper:(NotePaper*)aNotePaper
{
    if (![delegate respondsToSelector:@selector(enteringNotePaperExpandedFrame)]) return;    
    
    _alertingNotePaper = aNotePaper;
    
    if (enteringNotePaper) {
        [enteringNotePaper removeFromSuperview];
        [enteringNotePaper release];
    }
    enteringNotePaper = [[NotePaper alloc] initWithNote:aNotePaper.note];
    [enteringNotePaper setNotesPad:self];
    [enteringNotePaper setConditon:NotePaperConditionExpanded];
    
    if ([delegate respondsToSelector:@selector(enteringNotePaperWillExpand:)]) {
        [delegate enteringNotePaperWillExpand:enteringNotePaper];
    }
    
    CGRect goalRect = [delegate enteringNotePaperExpandedFrame];
    [enteringNotePaper expendFromRect:[enteringPaperStageView convertRect:aNotePaper.frame fromView:self] toRect:goalRect inView:enteringPaperStageView];

    if ([delegate respondsToSelector:@selector(enteringNotePaperDidExpand:)]) {
        [delegate enteringNotePaperDidExpand:enteringNotePaper];
    }
}

- (void)enterringNotepaperDidExpand
{
    [enteringNotePaper loadSubviews];
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{
	if ([animationID isEqualToString:@"shrinkEnteringNotePaperAndSave:"]) {
		[enteringNotePaper removeFromSuperview];
        [enteringNotePaper release];
        enteringNotePaper = nil;
	}
    
    else if([animationID isEqualToString:@"removeNotePaper:"]){
        
    }
}

#pragma mark - Content Size
- (void)autoFitContentSize
{
    [self setContentSize:CGSizeMake(0.0f, self.contentSize.height)];
}

- (void)setContentSize:(CGSize)contentSize{
    CGFloat minWidth = self.frame.size.width;
    
    //NSUInteger notesCount = [notePapers count];  
    NSUInteger notesCount = [course.notes count];  

    CGFloat contentWidth = [self firstContentLengthWithCount:notesCount];
    
    
    if (contentWidth < minWidth) {
        contentWidth = minWidth;
    }
    
    
    CGFloat contentHeight = contentSize.height;
    CGSize realSize = CGSizeMake(contentWidth, contentHeight);
    
    [super setContentSize:realSize];
}

#pragma mark - Other Event
- (NotePaper*)enteringNotePaper
{
    return enteringNotePaper;
}

- (void)save
{
    NotePaper* theEnterPaper = enteringNotePaper;
    
    NSString* saveText = theEnterPaper.text;
    Note* saveNote = theEnterPaper.note;
    if (saveText) {
        if (saveNote) {
            [saveNote setContent:saveText];
        }else{
            /*Create new note element*/
            CSDataCenter* dataCenter = [CSDataCenter sharedDataCenter];
            Note* newNote = [dataCenter insertNoteWithContent:saveText intoCourse:course];
            
            [self insertNewNotePaperWithNote:newNote];
        }
    }
}

- (BOOL)isAddingNotePaper
{
    BOOL isAddingNotePaper = (_alertingNotePaper == additonNotePaper);
    return isAddingNotePaper;
}

#pragma mark - Memory Management
- (id)init{
    if (self = [super init]) {
        enteringPaperFrame = CGRectZero;
        
        firstDirectionCellLength = 0.0f;
        firstDirectionMargin = 0.0f;
        secondDirectionMargin = 0.0f;
        secondDirectionCellCount = 0;
    }
    return self;
}

- (id)initWithCourse:(Course*)aCourse
{
    if (self = [self init]) {
        course = aCourse;
        
        NSMutableArray* newNotePapers = [[NSMutableArray alloc] init];
        if (notePapers) [notePapers release];
        notePapers = newNotePapers;
    }
    return self;
}

- (void)dealloc{
    notesPadDelegate = nil;
    
    [enteringNotePaper removeFromSuperview];
    [enteringNotePaper release];
    enteringNotePaper = nil;
    
    //[_alertingNotePaper removeFromSuperview];
    //[_alertingNotePaper release];
    //_alertingNotePaper = nil;

    enteringPaperStageView = nil;
    
    [additonNotePaper release];
    additonNotePaper = nil;
    
    [notePapers release];
    notePapers = nil;
    
    course = nil;
    
    [super dealloc];
}
@end
