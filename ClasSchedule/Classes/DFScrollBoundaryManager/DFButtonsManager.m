//
//  DFButtonsManager.m
//  ScheduleBoundaryManager
//
//  Created by DreamerMac on 12-5-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DFButtonsManager.h"
#import "DFScheduleBoundaryManager.h"
#import "DFScheduleBoundaryManagerCell.h"
#import "DFScheduleBoundaryButton.h"

@implementation DFButtonsManager
@synthesize superManager,linkingCell,buttonsMask;

#define kShowHideAnimationDuration 0.2f
#define kButtonAlpha 1.0f

#pragma mark - Frames
- (CGRect)locateDownButton:(UIView*)aView
{
    CGFloat gap = 0.0f;
    CGFloat distanceFromRight = 40.0f;
    
    CGRect cellFrame = linkingCell.frame;
    CGFloat width = 40.0f;
    CGFloat x = cellFrame.origin.x + cellFrame.size.width - width - distanceFromRight;
    
    CGFloat height = width * 0.618;
    CGFloat y = cellFrame.origin.y - gap - height;
    
    CGRect frame = CGRectMake(x, y, width, height);
    [aView setFrame:frame];
    return frame;
}

- (CGRect)locateUpButton:(UIView*)aView
{
    CGFloat distanceFromDownButton = 1.0f;
    
    CGRect downButtonFrame = [self locateDownButton:nil];
    CGFloat width = downButtonFrame.size.width;
    CGFloat x = downButtonFrame.origin.x - downButtonFrame.size.width - distanceFromDownButton;
    
    CGFloat height = downButtonFrame.size.height;
    CGFloat y = downButtonFrame.origin.y;
    
    CGRect frame = CGRectMake(x, y, width, height);
    [aView setFrame:frame];
    return frame;
}

- (CGRect)locateProlongButton:(UIView*)aView
{
    CGFloat gap = 0.0f;
    CGFloat distanceFromLeft = 40.0f;
    
    CGRect cellFrame = linkingCell.frame;
    CGFloat width = 40.0f;
    CGFloat x = cellFrame.origin.x + distanceFromLeft;

    CGFloat height = width * 0.618;
    CGFloat y = cellFrame.origin.y - gap - height;
    
    CGRect frame = CGRectMake(x, y, width, height);
    [aView setFrame:frame];
    return frame;
}

- (CGRect)locateCurtailButton:(UIView*)aView
{
    //CGFloat gap = 0.0f;
    CGFloat distanceFromProlongButton = 1.0f;

    //CGRect cellFrame = linkingCell.frame;
    CGRect prolongButtonFrame = [self locateProlongButton:nil];
    CGFloat width = prolongButtonFrame.size.width;
    CGFloat x = prolongButtonFrame.origin.x + prolongButtonFrame.size.width + distanceFromProlongButton;

    CGFloat height = prolongButtonFrame.size.height;
    CGFloat y = prolongButtonFrame.origin.y;

    CGRect frame = CGRectMake(x, y, width, height);
    [aView setFrame:frame];
    return frame;
}

- (void)followLinkingCells
{
    switch (buttonsMask) {
        case ButtonsMaskMoveButtons:
            [self locateUpButton:upButton];
            [self locateDownButton:downButton];
            break;
        case ButtonsMaskAlterButtons:
            [self locateProlongButton:prolongButton];
            [self locateCurtailButton:curtailButton];
            break;
        default:
            break;
    }
}
#pragma mark -Configure Buttons
- (void)configureUpButton
{
    UIButton* theButton = upButton;
    [self locateUpButton:theButton];
    [theButton setTintColor:linkingCell.backgroundColor];
    [theButton addTarget:self action:@selector(upButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)configureDownButton
{
    UIButton* theButton = downButton;
    [self locateDownButton:theButton];
    [theButton setTintColor:linkingCell.backgroundColor];
    [theButton addTarget:self action:@selector(downButtonAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)configureProlongButton
{
    UIButton* theButton = prolongButton;
    [self locateProlongButton:theButton];
    [theButton setTintColor:linkingCell.backgroundColor];
    [theButton addTarget:self action:@selector(prolongButtonAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)configureCurtailButton
{
    UIButton* theButton = curtailButton;
    [self locateCurtailButton:theButton];
    [theButton setTintColor:linkingCell.backgroundColor];
    [theButton addTarget:self action:@selector(curtailButtonAction) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Actions
- (void)upButtonAction
{
    [superManager movedByCell:linkingCell timeInterval: -superManager.minTimeScale];
}

- (void)downButtonAction
{
    [superManager movedByCell:linkingCell timeInterval:superManager.minTimeScale];
}

- (void)prolongButtonAction
{
    [superManager alterByCell:linkingCell timeInterval:superManager.minTimeScale];
}

- (void)curtailButtonAction
{
    [superManager alterByCell:linkingCell timeInterval: -superManager.minTimeScale];
}

#pragma mark - Buttons Lifecycle
- (void)recreateButtons
{
    switch (buttonsMask) {
        case ButtonsMaskNone:
            [self hideMoveButton];
            [self hideAlterButton];
            break;
        case ButtonsMaskMoveButtons:
            [self showMoveButton];
            [self hideAlterButton];
            break;
        case ButtonsMaskAlterButtons:
            [self hideMoveButton];
            [self showAlterButton];
            break;
        default:
            break;
    }
}

- (void)relinkToCell:(DFScheduleBoundaryManagerCell*)aCell
{
    [self setLinkingCell:aCell];
    
    [self hideMoveButton];
    [self hideAlterButton];
    
    switch (buttonsMask) {
        case ButtonsMaskMoveButtons:
            [self performSelector:@selector(showMoveButton) withObject:nil afterDelay:kShowHideAnimationDuration];
            break;
        case ButtonsMaskAlterButtons:
            [self performSelector:@selector(showAlterButton) withObject:nil afterDelay:kShowHideAnimationDuration];
            break;
        default:
            break;
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:@"relinkToCell:" context:context];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	[UIView setAnimationDuration:kShowHideAnimationDuration]; 
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	
    [upButton setAlpha:0.0f];
    [downButton setAlpha:0.0f];
    [prolongButton setAlpha:0.0f];
    [curtailButton setAlpha:0.0f];
    
	[UIView commitAnimations];
    
    
}

- (void)showMoveButton
{
    UIView* theView = superManager.superview;
    if (!upButton) {
        //upButton = [[UIButton buttonWithType:UIButtonTypeDetailDisclosure] retain];
        upButton = [[DFScheduleBoundaryButton alloc] initWithButtonType:DFButtonTypeUp direction:YES];
        [upButton setAlpha:0.0f];
        [theView addSubview:upButton];
    }
    [self configureUpButton];
    
    if (!downButton) {
        //downButton = [[UIButton buttonWithType:UIButtonTypeInfoLight] retain];
        downButton = [[DFScheduleBoundaryButton alloc] initWithButtonType:DFButtonTypeDown direction:NO];
        [downButton setAlpha:0.0f];
        [theView addSubview:downButton];
    }
    [self configureDownButton];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:@"showMoveButton" context:context];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	[UIView setAnimationDuration:kShowHideAnimationDuration]; 
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	
    [upButton setAlpha:kButtonAlpha];
    [downButton setAlpha:kButtonAlpha];
    
	[UIView commitAnimations];
}

- (void)hideMoveButton
{
    CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:@"hideMoveButton" context:context];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	[UIView setAnimationDuration:kShowHideAnimationDuration]; 
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	
    [upButton setAlpha:0.0f];
    [downButton setAlpha:0.0f];

	[UIView commitAnimations];
}

- (void)releaseMoveButton
{
    if (upButton) {
        [upButton removeFromSuperview];
        [upButton release];
        upButton = nil;
    }
    if (downButton) {
        [downButton removeFromSuperview];
        [downButton release];
        downButton = nil;
    }
}

- (void)showAlterButton
{
    UIView* theView = superManager.superview;
    if (!prolongButton) {
        //prolongButton = [[UIButton buttonWithType:UIButtonTypeInfoDark] retain];
        prolongButton = [[DFScheduleBoundaryButton alloc] initWithButtonType:DFButtonTypeProlong direction:YES];
        [prolongButton setAlpha:0.0f];
        [theView addSubview:prolongButton];
    }
    [self configureProlongButton];
    
    if (!curtailButton) {
        //curtailButton = [[UIButton buttonWithType:UIButtonTypeContactAdd] retain];
        curtailButton = [[DFScheduleBoundaryButton alloc] initWithButtonType:DFButtonTypeCurtail direction:NO];
        [curtailButton setAlpha:0.0f];
        [theView addSubview:curtailButton];
    }
    [self configureCurtailButton];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:@"showAlterButton" context:context];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	[UIView setAnimationDuration:kShowHideAnimationDuration]; 
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	
    [prolongButton setAlpha:kButtonAlpha];
    [curtailButton setAlpha:kButtonAlpha];
    
	[UIView commitAnimations];
}

- (void)hideAlterButton
{
    CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:@"hideAlterButton" context:context];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	[UIView setAnimationDuration:kShowHideAnimationDuration]; 
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	
    [prolongButton setAlpha:0.0f];
    [curtailButton setAlpha:0.0f];

	[UIView commitAnimations];
}

- (void)releaseAlterButton
{
    if (prolongButton) {
        [prolongButton removeFromSuperview];
        [prolongButton release];
        prolongButton = nil;
    }
    if (curtailButton) {
        [curtailButton removeFromSuperview];
        [curtailButton release];
        curtailButton = nil;
    }
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{
    if ([animationID isEqualToString:@"hideMoveButton"]) {
        [self releaseMoveButton];
    }else if ([animationID isEqualToString:@"hideAlterButton"]) {
        [self releaseAlterButton];
    }else if ([animationID isEqualToString:@"relinkToCell:"]) {
        switch (buttonsMask) {
            case ButtonsMaskMoveButtons:{
                [self showMoveButton];
                [self releaseAlterButton];
                break;
            }
            case ButtonsMaskAlterButtons:{
                [self releaseMoveButton];
                [self showAlterButton];
                break;
            }
            case ButtonsMaskNone:{
                [self releaseMoveButton];
                [self releaseAlterButton];
                break;
            }
            default:
                break;
        }
    }
}

#pragma mark - Lifecycle
- (void)dealloc{
    superManager = nil;
    linkingCell = nil;
    
    [self releaseMoveButton];
    [self releaseAlterButton];
    
    [super dealloc];
}

@end
