#import "EnterHelper.h"

#import "RefreshView.h"
#import "HtmTdParser.h"

#import "EnterHelperCell.h"
#import "EnterHelperTableCell.h"
#import "EHFloatingView.h"

#import "Header.h"

@implementation EnterHelper
@synthesize state,stringsTableView,refreshView,garbageBin,floatingView,dismissingView,fileList,stringsList;
@synthesize managedObjectContext,delegate,accessedTextFields;
@synthesize fetchedResultsController;
static float usualWidth = 140.0f;
//static float readingWidth = 140.0f;

static NSString* coreDataKey = @"EnterHelperCell";
static NSString* requestKey = @"allEnterHelperCells";

#pragma mark - Frame
- (CGRect)frameOfWillShow
{
    if (!self.superview) {
        return CGRectZero;
    }
    UIView* superview = self.superview;
    CGRect frame = CGRectZero;
    float x = 0.0f;
    float y = 0.0f;
    float theWidth = 0.0f;
    float height = 0.0f;
    
    x = superview.frame.size.width;
    y = 0.0f;
    theWidth = usualWidth;
    height = superview.frame.size.height;
    
    frame = CGRectMake(x, y, theWidth, height);
    return frame;
}

- (CGRect)frameOfShowing
{
    if (!self.superview) {
        return CGRectZero;
    }
    UIView* superview = self.superview;
    CGRect frame = CGRectZero;
    float x = 0.0f;
    float y = 0.0f;
    float theWidth = 0.0f;
    float height = 0.0f;
    
    x = superview.frame.size.width - usualWidth;
    y = 0.0f;
    theWidth = usualWidth;
    height = superview.frame.size.height;
    
    frame = CGRectMake(x, y, theWidth, height);
    return frame;
}

- (CGRect)frameOfReading
{
    if (!self.superview) {
        return CGRectZero;
    }
    UIView* superview = self.superview;
    CGRect frame = CGRectZero;
    float x = 0.0f;
    float y = 0.0f;
    float theWidth = 0.0f;
    float height = 0.0f;
    
    x = 0.0f;
    y = 0.0f;
    theWidth = superview.frame.size.width;
    height = superview.frame.size.height;
    
    frame = CGRectMake(x, y, theWidth, height);
    return frame;
}

- (CGRect)selfFrame
{
    CGRect frame = CGRectZero;
    switch (state) {
        case EnterHelperWillShow:
            return [self frameOfWillShow];
            break;
        case EnterHelperShowing:
            return [self frameOfShowing];
            break;
        case EnterHelperReading:
            return [self frameOfReading];
            break;
        default:
            break;
    }
    return frame;
}

- (CGRect)stringsTableFrame
{
    /*
     float x = 0.0f;
     float y = 0.0f;
     float theWidth = 0.0f;
     float height = 0.0f;
     */
    return self.bounds;
}

#pragma mark - Load Subviews
- (void)loadSubviews
{
    if (!stringsTableView) {
        stringsTableView = [[UITableView alloc] initWithFrame:[self stringsTableFrame] style:UITableViewStylePlain];
        [self addSubview:stringsTableView];
    }
    [self configureStringTableView:stringsTableView];
    
    if (!dismissingView) {
        dismissingView = [[UIControl alloc] init];
        [self.superview insertSubview:dismissingView atIndex:[self.superview.subviews count] - 1];
    }
    [self configureDismissingView:dismissingView];
    
    if (!floatingView) {
        floatingView = [[EHFloatingView alloc] initWithStageView:self.superview];
    }
    [self configureFloatingView:floatingView];
}

- (void)configureFloatingView:(EHFloatingView*)aFloatingView
{
    EHFloatingView* theFloatingView = aFloatingView;
    [theFloatingView setDelegate:self];
    
    NSMutableArray* array = [[NSMutableArray alloc] initWithCapacity:[accessedTextFields count] + 1];
    
    UIView* tempGarbageBin = [[UIView alloc] init];
    [tempGarbageBin setBounds:CGRectMake(0.0f, 0.0f, GARBAGE_BIN_SIZE, GARBAGE_BIN_SIZE)];
    [tempGarbageBin setCenter:CGPointMake(self.frame.size.width / 2, GARBAGE_VERTICAL_LOCATION + 20.0f)];
    [tempGarbageBin setFrame:[self.superview convertRect:tempGarbageBin.frame fromView:self]];
    [array addObject:tempGarbageBin];
    [tempGarbageBin release];
    
    [array addObjectsFromArray:accessedTextFields];
    
    [theFloatingView setAccessedViews:array];
    
    [array release];
}

- (void)configureStringTableView:(UITableView*)aStringTableView
{
    UITableView* theStingTableView = aStringTableView;
    [theStingTableView setDelegate:self];
    [theStingTableView setDataSource:self];
    [theStingTableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    
    if (!refreshView) {
        refreshView = [[RefreshView alloc] initWithOwner:stringsTableView delegate:self];
    }
}

- (void)configureDismissingView:(UIControl*)aDismissingView
{
    UIControl* theDismissingView = aDismissingView;
    
    [theDismissingView setBackgroundColor:[UIColor clearColor]];
    
    float width = self.superview.frame.size.width - self.frame.size.width;
    float height = self.superview.frame.size.height;
    float x = 0.0f;
    float y = 0.0f;
    [theDismissingView setFrame:CGRectMake(x, y, width, height)];
    
    [theDismissingView addTarget:self action:@selector(dismissFromSuperview) forControlEvents:UIControlEventTouchUpInside];
}

- (void)configureGarbageBin:(UIImageView*)aGarbageBin
{
    UIImageView* theGarbageBin = aGarbageBin;
    
    [theGarbageBin setBounds:CGRectMake(0.0f, 0.0f, GARBAGE_BIN_SIZE, GARBAGE_BIN_SIZE)];
    [theGarbageBin setCenter:CGPointMake(self.frame.size.width / 2, GARBAGE_VERTICAL_LOCATION)];
    [theGarbageBin setAlpha:0.0f];
    
    UIImage* image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"TrashBin" ofType:@"png"]];
    [theGarbageBin setImage:image];
    [image release];
    
    //[theGarbageBin setBackgroundColor:[UIColor blackColor]];
}

#pragma mark - Float View & Protocol
- (void)touchBegan:(UITouch*)aTouch
{
    //DLog(@"Began\tx:%f\ty:%f",[aTouch locationInView:self.view].x,[aTouch locationInView:self.view].y);
    
    [self enterFloatingState];
    
    EnterHelperTableCell* selectedCell = (EnterHelperTableCell*)[stringsTableView cellForRowAtIndexPath:[stringsTableView indexPathForSelectedRow]];
    EnterHelperCell* selectedEnterHelpCell = (EnterHelperCell*)[fetchedResultsController objectAtIndexPath:[stringsTableView indexPathForSelectedRow]];
    [floatingView takeOffInRect:[self.superview convertRect:selectedCell.frame fromView:stringsTableView] withUserInfo:selectedEnterHelpCell];
}

- (void)touchMoved:(UITouch*)aTouch
{
    //DLog(@"Moved\tx:%f\ty:%f",[aTouch locationInView:self.view].x,[aTouch locationInView:self.view].y);
    
    CGPoint origin = [aTouch locationInView:self.superview];
    [floatingView setCenter:origin];
}

- (void)touchEnded:(UITouch*)aTouch
{
    //DLog(@"Ended\tx:%f\ty:%f",[aTouch locationInView:self.view].x,[aTouch locationInView:self.view].y);
    
    [self cancelFloatingState];
    [floatingView land];
}

- (void)touchCancelled:(UITouch*)aTouch
{
    [self cancelFloatingState];
}

- (void)floatingView:(DFFloatingView *)aFloatingView landedInViewAtIndex:(NSUInteger)anIndex withUserInfo:(id)anUserInfo
{
    EnterHelperCell* theUserInfo = (EnterHelperCell*)anUserInfo;
    
    if (anIndex == 0) {
        [managedObjectContext deleteObject:theUserInfo];
    }else{
        NSUInteger realIndex = anIndex - 1;
        UITextView* theTextView = [accessedTextFields objectAtIndex:realIndex];
        [theTextView setText:theUserInfo.content];
    }
}

- (BOOL)floatingView:(DFFloatingView*)aFloatingView stuckByViewAtIndex:(NSUInteger)anIndex inRect:(CGRect)aRect{
    if (anIndex == 0) {
        [UIView beginAnimations:@"stuckInGarbageBin" context:UIGraphicsGetCurrentContext()];
        [UIView setAnimationDuration:0.2f]; 
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [aFloatingView setFrame:CGRectInset(aRect, aRect.size.width / 2, aRect.size.height / 2)];
        [UIView commitAnimations];
        return NO;
    }else{
        return YES;
    }
}

#pragma mark - Core Data & File
- (void)cleanCoreData
{
    for (EnterHelperCell* cuCell in [fetchedResultsController fetchedObjects]) {
        [managedObjectContext deleteObject:cuCell];
    }
}

- (void)fillCoreDataWithStringsList:(NSMutableArray*)aMutableArray
{
    NSManagedObjectContext* context = managedObjectContext;  //Need rewrite this sentence when use this method in other environment
	EnterHelperCell* cuCell = nil;
    for (NSString* cuString in aMutableArray) {
        cuCell = [NSEntityDescription insertNewObjectForEntityForName:coreDataKey inManagedObjectContext:context];
        [cuCell setContent:cuString];
    }
}

- (void)loadFileListInDocuments
{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [documentPaths objectAtIndex:0];
    
    NSError *error = nil;
    fileList = [[fileManager contentsOfDirectoryAtPath:documentDir error:&error] retain];
    
    [fileManager release];
}

- (BOOL)isSupportedFileType:(NSString*)aFilePath
{
    BOOL isSupported = NO;
    NSString* extension = [aFilePath pathExtension];
    
    NSArray* supportedFileTypes = [[NSArray alloc] initWithObjects:@"htm",@"html", nil];
    
    for (NSString* cuType in supportedFileTypes) {
        if ([extension isEqualToString:cuType]) isSupported = YES;
    }
    
    [supportedFileTypes release];
    return isSupported;
}

#pragma mark - NSFetchedResultsControllerDelegate
- (NSFetchedResultsController*)configureFetchedResultsController
{
    if (fetchedResultsController) return fetchedResultsController;    
    //CSDataCenter* dataCenter = [CSDataCenter sharedDataCenter];
    
    NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"content" ascending:NO];
    NSArray* sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    NSEntityDescription* entity = [NSEntityDescription entityForName:@"EnterHelperCell" inManagedObjectContext:managedObjectContext];
    
    //NSPredicate* predicate = [NSPredicate predicateWithFormat:@"seq_week == %d",seqInWeek];
    
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setSortDescriptors:sortDescriptors];
    [fetchRequest setFetchBatchSize:10];
    //[fetchRequest setPredicate:predicate];
    
    NSFetchedResultsController* newFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    [newFetchedResultsController setDelegate:self];
    
    [fetchRequest release];
    [sortDescriptors release];
    [sortDescriptor release];
    
    return newFetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [stringsTableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [stringsTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                            withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [stringsTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                            withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = stringsTableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:(EnterHelperTableCell*)[tableView cellForRowAtIndexPath:indexPath]
                    atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [stringsTableView endUpdates];
}

#pragma mark - Presenting & Dismissing
- (void)showInView:(UIView*)aView
{
    [aView addSubview:self];
    [self setFrame:[self selfFrame]];
    state = EnterHelperShowing;
    
    //[self selfAnimationTransformIntoFrame:[self selfFrame]];
    [self animationOfTransform:[self selfFrame] named:@"showInView:"];
    [self loadSubviews];
    
}

- (void)dismissFromSuperview
{
    if ([delegate respondsToSelector:@selector(enterHelperWillBeDismissed)]) {
        [delegate enterHelperWillBeDismissed];
    }
    
    state = EnterHelperWillShow;
    
    [dismissingView removeFromSuperview];
    [dismissingView release];
    dismissingView = nil;
    
    //[self selfAnimationTransformIntoFrame:[self selfFrame]];
    [self animationOfTransform:[self selfFrame] named:@"dismissFromSuperview"];
    
    
}

- (void)enterReadingMode
{
    state = EnterHelperReading;
    
    [self loadFileListInDocuments];
    [stringsTableView reloadData];
    
    //[self selfAnimationTransformIntoFrame:[self selfFrame]];
    [self animationOfTransform:[self selfFrame] named:@"enterReadingMode"];
}

- (void)cancelReadingMode
{
    state = EnterHelperShowing;
    
    NSError* error;
    if (![fetchedResultsController performFetch:&error]) { DLog(@"%@",error.userInfo); }
    
    //[self selfAnimationTransformIntoFrame:[self selfFrame]];
    [self animationOfTransform:[self selfFrame] named:@"cancelReadingMode"];

    [fileList release];
    fileList = nil;
    
    [stringsTableView reloadData];
    
}

- (void)enterFloatingState
{
    [self setState:EnterHelperFloating];
    
    if (!garbageBin) {
        garbageBin = [[UIImageView alloc] init];
        [self addSubview:garbageBin];
    }
    [self configureGarbageBin:garbageBin];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:@"enterFloatState" context:context];
    [UIView setAnimationDuration:0.2f]; 
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    [stringsTableView setAlpha:0.0f];
    [garbageBin setAlpha:1.0f];
    
    [UIView commitAnimations];
}

- (void)cancelFloatingState
{
    [self setState:EnterHelperShowing];
    
    
    [UIView beginAnimations:@"cancelFloatState" context:UIGraphicsGetCurrentContext()];
	[UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    [UIView setAnimationDuration:0.2f]; 
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    //[UIView setAnimationBeginsFromCurrentState:YES];
    
    [stringsTableView setAlpha:1.0f];
    [garbageBin setAlpha:0.0f];
    
    [UIView commitAnimations];
}

#pragma mark - Animation Management
- (void)animationOfTransform:(CGRect)aNewFrame named:(NSString*)anAnimationName
{
    [UIView beginAnimations:anAnimationName context:UIGraphicsGetCurrentContext()];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	[UIView setAnimationDuration:0.5f]; 
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [self setFrame:aNewFrame];
	[UIView commitAnimations];
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{
    if ([animationID isEqualToString:@"cancelFloatState"]) {
        if (garbageBin) {
            [garbageBin removeFromSuperview];
            [garbageBin release];
            garbageBin = nil;
        }
    }else if ([animationID isEqualToString:@"dismissFromSuperview"]) {
        [self removeFromSuperview];
        
        if ([delegate respondsToSelector:@selector(enterHelperDidBeDismissed)]) {
            [delegate enterHelperDidBeDismissed];
        }
    }
}

#pragma mark - Protocols Of TableView
- (void)configureCell:(UITableViewCell*)aCell atIndexPath:(NSIndexPath *)indexPath
{
    NSString* cuString = nil;
    EnterHelperCell* cuCell = nil;
    switch (state) {
        case EnterHelperShowing:{
            cuCell = [fetchedResultsController objectAtIndexPath:indexPath];
            cuString = cuCell.content;
            
            [aCell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            //UIGestureRecognizer* gestureRecognizer = [[UIGestureRecognizer alloc] initWithTarget:self action:@selector()];
            //[aCell addGestureRecognizer:gestureRecognizer];
            // [gestureRecognizer release];
            
            [aCell.textLabel setText:cuString];
            break;
        }
        case EnterHelperReading:{
            /*
             if (indexPath.row < [fileList count]) {
             cuString = [fileList objectAtIndex:indexPath.row];
             }*/
            
            cuString = [fileList objectAtIndex:indexPath.row];
            [aCell.textLabel setText:cuString];
            
            if ([self isSupportedFileType:cuString]) {
                
            }else{
                [aCell.textLabel setTextColor:[UIColor grayColor]];
                //[aCell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [aCell setUserInteractionEnabled:NO];
            }
            break;
        }
        default:
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	EnterHelperTableCell* cell = [tableView dequeueReusableCellWithIdentifier:@"EnterHelperCell"];
	if (!cell) {
		cell = [[EnterHelperTableCell alloc] init];
        [cell setEnterHelper:self];
	}
    [self configureCell:cell atIndexPath:indexPath];
    return (UITableViewCell *)cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	NSUInteger count = 0;
    switch (state) {
        case EnterHelperShowing:
            count = [[fetchedResultsController sections] count];
            break;
        case EnterHelperReading:{
            count = 1;
            break;
        }
        default:
            break;
    }
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	NSUInteger count = 0;
    switch (state) {
        case EnterHelperShowing:
            count = [[fetchedResultsController fetchedObjects] count];
            break;
        case EnterHelperReading:{
            count = [fileList count];
            break;
        }
        default:
            break;
    }
    return count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (state) {
        case EnterHelperShowing:{
            break;
        }
        case EnterHelperReading:{
            
            NSString* path = [fileList objectAtIndex:indexPath.row];
            path = [CSDataCenter documentsDirectoryAppend:path];
            NSData* sourceData = [[NSData alloc] initWithContentsOfFile:path];
            NSMutableArray* goalArray = [[NSMutableArray alloc] init];
            [HtmTdParser parseAndSeparateByLineFrom:sourceData into:goalArray encoding:0];
            [self cleanCoreData];
            [self fillCoreDataWithStringsList:goalArray];
            [sourceData release];
            [goalArray release];
            
            //[self performSelector:@selector(cancelReadingMode) withObject:nil afterDelay:1.0f];
            [self cancelReadingMode];
            break;
        }
        default:
            break;
    }
}

#pragma mark - RefreshViewDelegate
- (void)refreshViewDidCallBack {
    switch (state) {
        case EnterHelperShowing:
            [self enterReadingMode];
            break;
        case EnterHelperReading:
            [self cancelReadingMode];
            
            break;
        default:
            break;
    }
}

// 刚拖动的时候
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [refreshView scrollViewWillBeginDragging:scrollView];
}
// 拖动过程中
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [refreshView scrollViewDidScroll:scrollView];
}
// 拖动结束后
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [refreshView scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

#pragma mark - Memory Managment

- (id)init{
    if (self = [super init]) {
        state = EnterHelperWillShow;
    }
    return self;
}

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)anManagedObjectContext
{
    if(self = [self init]){
        
        managedObjectContext = anManagedObjectContext;
        [self setFetchedResultsController:[self configureFetchedResultsController]];
        [fetchedResultsController performFetch:nil];
        
        [self setBackgroundColor:[UIColor whiteColor]];
		[self setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight];
    }
    return self;
}

- (void)dealloc
{
    if (state == EnterHelperReading) {
        [self cancelReadingMode];
    }
    if (state == EnterHelperFloating) {
        [self cancelFloatingState];
    }
    
    delegate = nil;
    
    [refreshView removeFromSuperview];
    [refreshView release];
    refreshView = nil;
    
    [stringsTableView removeFromSuperview];
    [stringsTableView release];
    stringsTableView = nil;
    
    [garbageBin removeFromSuperview];
    [garbageBin release];
    garbageBin = nil;
    
    [dismissingView removeFromSuperview];
    [dismissingView release];
    dismissingView = nil;
    
    [floatingView release];
    floatingView = nil;
    
    [accessedTextField release];
    accessedTextField = nil;
    
    [fileList release];
    fileList = nil;
    
    [stringsList release];
    stringsList = nil;
}

@end
