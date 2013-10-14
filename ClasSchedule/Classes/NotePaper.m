#import "NotePaper.h"

#import "NotesPad.h"
#import "Note.h"

#import "Header.h"

@implementation NotePaper
@synthesize note,conditon,notesPad;

#pragma mark - Frame
+ (CGFloat)shrankConditionSize
{
    return 60.0f;
}

- (CGRect)locateContent:(UIView*)aView
{
    CGFloat horizontalMargin = 10.0f;
    
    CGFloat topMargin = 20.0f;
    CGFloat bottomMargin = 26.0f;
    
    CGRect sourceFrame = self.bounds;
    CGFloat x = horizontalMargin;
    CGFloat width = sourceFrame.size.width - 2 * horizontalMargin;
    CGFloat y = topMargin;
    CGFloat height = sourceFrame.size.height - topMargin - bottomMargin;
    
    CGRect frame = CGRectMake(x, y, width, height);
    [aView setFrame:frame];
    
    return frame;
}

- (CGRect)locateContentView:(UIView*)aView
{
    CGFloat horizontalMargin = 30.0f;
    CGFloat topMargin = 40.0f;
    CGFloat bottomMargin = 45.0f;

    CGRect bounds = self.bounds;
    CGFloat x = horizontalMargin;
    CGFloat width = bounds.size.width - 2 * horizontalMargin;
    CGFloat y = topMargin;
    CGFloat height = bounds.size.height - topMargin - bottomMargin;
    
    CGRect frame = CGRectMake(x, y, width, height);
    [aView setFrame:frame];
    return frame;
}

- (CGRect)locateNoteBornDate:(UIView*)aView
{
    CGFloat width = 0.0f;
    CGFloat height = 0.0f;
    
    CGRect bounds = self.bounds;
    CGRect frame = CGRectZero;
    switch (conditon) {
        case NotePaperConditionShrank:{
            width = 70.0f;
            height = 18.0f;
            CGFloat rightMargin = 15.0f;
            CGFloat bottomMargin = 10.0f;
            
            CGFloat x = bounds.size.width - width - rightMargin;
            CGFloat y = bounds.size.height - height - bottomMargin;
            frame = CGRectMake(x, y, width, height);
            break;
        }
        case NotePaperConditionExpanded:{
            width = 140.0f;
            height = 20.0f;
            CGFloat rightMargin = 20.0f;
            CGFloat topMargin = 20.0f;
            
            CGFloat x = bounds.size.width - width - rightMargin;
            CGFloat y = topMargin;
            frame = CGRectMake(x, y, width, height);
            break;  
        }
        default:
            break;
    }
    [aView setFrame:frame];
    return frame;
}
#pragma mark - Subviews
- (void)loadSubviews
{
    switch (conditon) {
        case NotePaperConditionShrank:
            [self loadSubviewsShrankCondition];
            break;
        case NotePaperConditionExpanded:
            [self loadSubviewsExpandedCondition];
            break;
        default:
            break;
    }
}

- (void)unloadSubviews
{
    [content removeFromSuperview];
    [content release];
    content = nil;
    
    [contentView removeFromSuperview];
    [contentView release];
    contentView = nil;
    
    [noteBirthDate removeFromSuperview];
    [noteBirthDate release];
    noteBirthDate = nil;
    
    //[resignButton removeFromSuperview];
    //[resignButton release];
    //resignButton = nil;
}

- (void)loadSubviewsShrankCondition
{
    UIView* theView = self;
    
    if (note) {
        if (!content) {
            content = [[UILabel alloc] init];
            [theView addSubview:content];
        }
        [self configureContent];
        
        if (!noteBirthDate) {
            noteBirthDate = [[UILabel alloc] init];
            [theView addSubview:noteBirthDate];
        }
        [self configureNoteBornDate];
    }
    
}

- (void)loadSubviewsExpandedCondition
{
    UIView* theView = self;
    
    if (!contentView) {
        contentView = [[UITextView alloc] init];
        [theView addSubview:contentView];
    }
    [self configureContentView];
    
    if (!noteBirthDate) {
        noteBirthDate = [[UILabel alloc] init];
        [theView addSubview:noteBirthDate];
    }
    [self configureNoteBornDate];
    
    //[self registerForKeyboardNotifications];
}

- (void)configureContent
{
    UILabel* theContent = content;
    
    [self locateContent:theContent];
    [theContent setText:note.content];
    [theContent setFont:[UIFont fontWithName:@"ChalkboardSE-Bold" size:18.0f]];
    [theContent setTextColor:[UIColor blackColor]];
    [theContent setBackgroundColor:[UIColor clearColor]];
    [theContent setNumberOfLines:2];
    //[theContent setBackgroundColor:[UIColor colorWithRed:0.3f green:0.5f blue:0.7f alpha:0.5f]];
}

- (void)configureContentView
{
    UITextView* theContentView = contentView;
    
    [self locateContentView:theContentView];
    [theContentView setText:note.content];
    [theContentView setFont:[UIFont fontWithName:@"ChalkboardSE-Bold" size:18.0f]];
    
    [theContentView setTextColor:[UIColor blackColor]];
    [theContentView setBackgroundColor:[UIColor clearColor]];
    //[theContentView setDelegate:self];
    [theContentView setDelegate:notesPad.delegate];
    
    //[theContentView setBackgroundColor:[UIColor colorWithRed:0.3f green:0.5f blue:0.7f alpha:0.5f]];

    [theContentView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
}

- (void)configureNoteBornDate
{
    UILabel* theNoteBornDate = noteBirthDate;
    
    [self locateNoteBornDate:theNoteBornDate];
    
    NSString* bornDateString = [CSDataCenter getStringFromDate:note.bornDate withFormat:@"MM.FF.yy"];
    [theNoteBornDate setText:bornDateString];
    
    switch (conditon) {
        case NotePaperConditionShrank:{
            [theNoteBornDate setFont:[UIFont fontWithName:@"ChalkboardSE-Bold" size:10.0f]];
            break;
        }
        case NotePaperConditionExpanded:{
            [theNoteBornDate setFont:[UIFont fontWithName:@"ChalkboardSE-Bold" size:16.0f]];
            break;
        }
        default:
            break;
    }
    
    [theNoteBornDate setTextColor:[UIColor grayColor]];
    [theNoteBornDate setTextAlignment:UITextAlignmentRight];
    [theNoteBornDate setBackgroundColor:[UIColor clearColor]];
    //[theNoteBornDate setBackgroundColor:[UIColor colorWithRed:0.5f green:0.5f blue:0.5f alpha:0.5f]];
    
    [theNoteBornDate setAutoresizingMask:63];
}

#pragma mark - Condition Event
- (BOOL)isAdditionType
{
    BOOL isAdditionType = NO;
    if (!note) {
        isAdditionType = YES;
    }
    return isAdditionType;
}

- (void)switchOfConditon
{
    switch (conditon) {
        case NotePaperConditionShrank:
            conditon = NotePaperConditionExpanded;
            [self enterExpandedCondition];
            break;
        case NotePaperConditionExpanded:
            conditon = NotePaperConditionShrank;
            [self returnShrankCondition];
            break;
        default:
            break;
    }
}

- (void)enterExpandedCondition
{
    
}

- (void)returnShrankCondition
{
    
}
#pragma mark - Other Event
- (UITextView*)contentView
{
    return contentView;
}

- (void)reloadData
{
    [content setText:note.content];
}

- (NSString*)text
{
    NSString* returnText = nil;
    NSString* contentViewText = contentView.text;
    
    if ([contentViewText length]) {
        returnText = contentViewText;
    }
    return returnText;
}

- (void)handleTap:(UITapGestureRecognizer *)sender{     
    if (sender.state == UIGestureRecognizerStateEnded){
        if (conditon == NotePaperConditionShrank) {
            [notesPad notePaperTapped:self];
        }
    } 
}

#pragma mark - Animation
- (void)expendFromRect:(CGRect)aOringinalRect toRect:(CGRect)aGoalRect inView:(UIView*)aView
{
    [aView addSubview:self];
    [self setFrame:aOringinalRect];
    conditon = NotePaperConditionExpanded;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:@"expendFromRect:toRect:inView:" context:context];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	[UIView setAnimationDuration:0.5f]; 
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	//[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self cache:YES];
    //[UIView setAnimationBeginsFromCurrentState:YES];
    [self setFrame:aGoalRect];

	[UIView commitAnimations];
}

- (void)setCenter:(CGPoint)center withAnimation:(BOOL)animation
{
    CGFloat rangleMax = 3.14159 / 24;
    CGFloat rangleMin = 0;

    CGFloat rangleInRadians = rangleMin + ( (float)arc4random() / ARC4RANDOM_MAX ) * rangleMax - rangleMax / 2;    

    CGAffineTransform rotation = CGAffineTransformMakeRotation(rangleInRadians);
    
    if (animation) {
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        [UIView beginAnimations:@"setCenter:withAnimation:" context:context];
        //[UIView setAnimationDelegate:self];
        //[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
        [UIView setAnimationDuration:0.5f]; 
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        
        [self setTransform:rotation];
        [super setCenter:center];
        
        [UIView commitAnimations];
    }else{
        [self setTransform:rotation];
        [super setCenter:center];    
    }
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{
	if ([animationID isEqualToString:@"expendFromRect:toRect:inView:"]) {
		[notesPad enterringNotepaperDidExpand];
	}
}
#pragma mark - Graphic
- (void)drawNotePaperWhenShrank:(CGRect)rect
{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"NotePaper_Shrank" ofType:@"png"];
    UIImage* image = [[UIImage alloc] initWithContentsOfFile:path];
    [image drawInRect:rect];
    [image release];

    CGFloat insetSize = 25.0f;
    if (!note) {
        path = [[NSBundle mainBundle] pathForResource:@"Addition" ofType:@"png"];
        image = [[UIImage alloc] initWithContentsOfFile:path];
        [image drawInRect:CGRectInset(rect, insetSize, insetSize)];
        [image release];
    }
}

- (void)drawNotePaperWhenExpanded:(CGRect)rect
{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"NotePaper_Expended" ofType:@"png"];
    UIImage* image = [[UIImage alloc] initWithContentsOfFile:path];
    
    [image drawInRect:rect];
    [image release];
}

- (void)drawRect:(CGRect)rect{
    switch (conditon) {
        case NotePaperConditionShrank:
            [self drawNotePaperWhenShrank:rect];
            break;
        case NotePaperConditionExpanded:
            [self drawNotePaperWhenExpanded:rect];
            break;
        default:
            break;
    }
}
#pragma mark - Memory Management
- (id)init{
    if (self = [super init]) {
        notesPad = nil;
        note = nil;
        
        conditon = NotePaperConditionShrank;
        
        content = nil;
        contentView = nil;
        shownKeyboardHeight = 0.0f;
        noteBirthDate = nil;
    }
    return self;
}

- (id)initWithNote:(Note*)aNote
{
    if (self = [self init]) {
        [self setNote:aNote];
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self addGestureRecognizer:gesture];
        [gesture release];
    }
    return self;
}

- (void)dealloc{
    notesPad = nil;
    
    [note release];
    note = nil;
    
    /*Views*/
    [self unloadSubviews];
    
    [super dealloc];
}

@end
