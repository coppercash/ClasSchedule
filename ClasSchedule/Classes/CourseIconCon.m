//
//  CourseIconCon.m
//  ClasSchedule
//
//  Created by DreamerMac on 12-3-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CourseIconCon.h"
#import "Header.h"

@implementation CourseIconCon

#pragma mark - Frames
- (CGRect)locateIconView
{
    CGFloat size = 100.0f;
    CGFloat verticalLocation = 20.0f;
    
    DFCourseIconView* theIconView = iconView;
    [theIconView setBounds:CGRectMake(0.0f , 0.0f, size, size)];
    [theIconView setCenter:CGPointMake(self.view.center.x, verticalLocation + size / 2)];

    [theIconView setNeedsDisplay];
    return theIconView.frame;
}

- (CGRect)sliderFrameByIndex:(NSUInteger)anIndex
{
    CGFloat x = (self.view.frame.size.width - SLIDER_LENGTH) / 2;
    CGFloat y = FIRST_SLIDER_VERTICAL_LOCATION + anIndex * SLIDER_DISTANCE;
    CGFloat width = SLIDER_LENGTH;
    CGFloat height = 23.0f;
    
    return CGRectMake(x, y, width, height);
}

- (CGRect)colorSelectorFrame{
    DFFormView* theColorSelector = colorSelector;
    CGFloat cellWidth = COLOR_SELECTOR_WIDTH / theColorSelector.colCount;
    CGFloat cellHeight = COLOR_SELECTOR_HEIGHT / theColorSelector.rowCount;
    CGFloat cellSize = 0.0f;
    if (cellWidth <= cellHeight) {
        cellSize = cellWidth;
    }else{
        cellSize = cellHeight;
    }
    
    CGFloat width = cellSize * theColorSelector.colCount;
    CGFloat height = cellSize * theColorSelector.rowCount;
    CGFloat x = (self.view.frame.size.width - width) / 2;
    CGFloat y = COLOR_SELECTOR_VERTICAL_LOCATION;
    return CGRectMake(x, y, width, height);
}

#pragma mark - Subviews
- (void)loadSubviews
{
    UIView* theView = self.view;
    
    if (!iconView) {
        iconView = [[DFCourseIconView alloc] init];
        [theView addSubview:iconView];
    }
    [self configureIconView:iconView];
    
    if (!colorSelector) {
        colorSelector = [[DFFormView alloc] init];
        [theView addSubview:colorSelector];
    }
    [self configureColorSelector:colorSelector];
    [colorSelector createForm];
    
    if (!redSlider) {
        redSlider = [[UISlider alloc] init];
        [theView addSubview:redSlider];
    }
    [self configureSlider:redSlider];
    
    if (!greenSlider) {
        greenSlider = [[UISlider alloc] init];
        [theView addSubview:greenSlider];
    }
    [self configureSlider:greenSlider];
    
    if (!blueSlider) {
        blueSlider = [[UISlider alloc] init];
        [theView addSubview:blueSlider];
    }
    [self configureSlider:blueSlider];
    
}

- (void)configureIconView:(DFCourseIconView*)anIconView
{
    DFCourseIconView* theIconView = anIconView;
    [self locateIconView];
    
    CourseExtension* courseExtension = course.courseExtension;
    CGFloat red = [courseExtension.red floatValue];
    CGFloat green = [courseExtension.green floatValue];
    CGFloat blue = [courseExtension.blue floatValue];
    UIColor* theColor = [[UIColor alloc] initWithRed:red green:green blue:blue alpha:1.0];
    [theIconView setTintColor:theColor];
    [theColor release];
    
    [theIconView.layer setShadowPath:[UIBezierPath bezierPathWithRect:theIconView.bounds].CGPath];
    [theIconView.layer setShadowOffset:CGSizeMake(0.0f, 10.0f)];
    [theIconView.layer setShadowRadius:10.0f];
    [theIconView.layer setShadowOpacity:1.0f];
    [theIconView.layer setShadowColor:[UIColor blackColor].CGColor];
    
    
    [theIconView setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin];
}

- (void)configureColorSelector:(DFFormView*)aColorSlector
{
    DFFormView* theColorSelector = aColorSlector;
    [theColorSelector setColCount:8];
    [theColorSelector setRowCount:1];
    [theColorSelector setDelegate:self];
    [theColorSelector setDataSource:self];
    [theColorSelector setTouchingConditon:DFFormViewTouchingConditonCell];
    [theColorSelector setFrame:[self colorSelectorFrame]];
    
}

- (void)configureSlider:(UISlider*)aSlider
{
    UISlider* theSlider = aSlider;
    CourseExtension* info = course.courseExtension;
    
    [theSlider setValue:1.0f];
    if (theSlider == redSlider) {
        [theSlider setFrame:[self sliderFrameByIndex:0]];
        if (info.red) [theSlider setValue:[info.red floatValue]];
        [theSlider addTarget:self action:@selector(redSliderValueChanged) forControlEvents:UIControlEventValueChanged];
    }
    if (theSlider == greenSlider) {
        [theSlider setFrame:[self sliderFrameByIndex:1]];
        if (info.green) [theSlider setValue:[info.green floatValue]];
        [theSlider addTarget:self action:@selector(greenSliderValueChanged) forControlEvents:UIControlEventValueChanged];
        
    }
    if (theSlider == blueSlider) {
        [theSlider setFrame:[self sliderFrameByIndex:2]];
        if (info.blue) [theSlider setValue:[info.blue floatValue]];
        [theSlider addTarget:self action:@selector(blueSliderValueChanged) forControlEvents:UIControlEventValueChanged];
        
    }
}

- (void)unloadSubviews
{
    [self destroySubview:&iconView];
    [self destroySubview:&redSlider];
    [self destroySubview:&greenSlider];
    [self destroySubview:&blueSlider];
    [self destroySubview:&colorSelector];
}

#pragma mark - Navigation Bar
- (void)initNavigationBarButton
{

}

- (void)showDoneButton:(BOOL)isShow animated:(BOOL)isAnimated
{
    SEL navigationBarSave = @selector(navigationBarSave);
    if (isShow) {
        UIBarButtonItem* addNewCourseButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:navigationBarSave];
        [self.navigationItem setRightBarButtonItem:addNewCourseButton animated:isAnimated];
        [addNewCourseButton release];
    }else{
        if (self.navigationItem.rightBarButtonItem.action == navigationBarSave) {
            [self.navigationItem setRightBarButtonItem:nil animated:isAnimated];
        }
    }
}

- (void)navigationBarSave
{
    CourseExtension* extensionInfo = course.courseExtension;
    [extensionInfo setRed:[NSNumber numberWithFloat:redSlider.value]];
    [extensionInfo setGreen:[NSNumber numberWithFloat:greenSlider.value]];
    [extensionInfo setBlue:[NSNumber numberWithFloat:blueSlider.value]];
    [self callSuperNavigationControllerToPopSelf];
}

#pragma mark - SuperNvController
- (void)callSuperNavigationControllerToPopSelf
{
    UINavigationController* superCon = (UINavigationController*)self.navigationController;
    [superCon popViewControllerAnimated:YES];
}

#pragma mark - DFFormViewDataSource & Delegate
- (UIColor*)colorByColumnIndex:(NSUInteger)aColumnIndex
{
    UIColor* color = nil;
    switch (aColumnIndex) {
        case 0:
            color = [UIColor redColor];
            break;
        case 1:
            color = [UIColor greenColor];
            break;
        case 2:
            color = [UIColor blueColor];
            break;
        case 3:
            color = [UIColor cyanColor];
            break;
        case 4:
            color = [UIColor yellowColor];
            break;
        case 5:
            color = [UIColor magentaColor];
            break;
        case 6:
            color = [UIColor orangeColor];
            break;
        case 7:
            color = [UIColor purpleColor];
            break;
        default:
            break;
    }
    return color;
}

/*
- (DFFormViewCell*)formView:(DFFormView *)aFormView cellAtColumnIndex:(NSUInteger)aColIndex rowIndex:(NSUInteger)aRowIndex{
    DFFormViewCell* cell = [[DFFormViewCell alloc] init];
   
    return cell;
}*/

- (DFFormViewCell*)allocCellForFormView:(DFFormView *)aFormView{
    DFFormViewCell* cell = [[DFFormViewCell alloc] init];
    return cell;
}
- (void)configureCell:(DFFormViewCell*)aCell atColumnIndex:(NSUInteger)aColIndex rowIndex:(NSUInteger)aRowIndex{
    NSUInteger theColumnIndex = aColIndex;
    
    DFCourseIconView* selectorCell = [[DFCourseIconView alloc] init];
    [aCell addSubview:selectorCell];
    [selectorCell release];
    
    //[selectorCell setFrame:aCell.bounds];
    [selectorCell setFrame:CGRectInset(aCell.bounds, 1.0f, 1.0f)];

    UIColor* color = [self colorByColumnIndex:theColumnIndex];
    [selectorCell setTintColor:color];
    [selectorCell setUseIconImage:NO];
    [selectorCell setSendTouchToSuperview:YES];
}
- (void)touchedUpInsideCellAtColumn:(NSUInteger)aColumnIndex row:(NSUInteger)aRowIndex{
    //DLog(@"%d %d",aColumnIndex,aRowIndex);
    
    //UIColor* theColor = [[colorSelector cellAtColumn:aColumnIndex row:aRowIndex] backgroundColor];
    
    UIColor* theColor = [self colorByColumnIndex:aColumnIndex];
    const CGFloat* components = CGColorGetComponents(theColor.CGColor);
    CGFloat red = components[0],green = components[1],blue = components[2];

    [redSlider setValue:red animated:YES];
    [greenSlider setValue:green animated:YES];
    [blueSlider setValue:blue animated:YES];

    [iconView setTintColor:theColor];
}

#pragma mark - Slider Events
- (void)redSliderValueChanged
{
    //DLog(@"redSliderValueChanged");
    UIColor* sourceColor = [iconView tintColor];
    const CGFloat* components = CGColorGetComponents(sourceColor.CGColor);
    CGFloat red = components[0],green = components[1],blue = components[2];
    red = redSlider.value;
    UIColor* newColor = [UIColor colorWithRed:red green:green blue:blue alpha:0.5f];
    [iconView setTintColor:newColor];

}

- (void)greenSliderValueChanged
{
    //DLog(@"greenSliderValueChanged");
    UIColor* sourceColor = [iconView tintColor];
    const CGFloat* components = CGColorGetComponents(sourceColor.CGColor);
    CGFloat red = components[0],green = components[1],blue = components[2];
    green = greenSlider.value;
    UIColor* newColor = [UIColor colorWithRed:red green:green blue:blue alpha:0.5f];
    [iconView setTintColor:newColor];

}

- (void)blueSliderValueChanged
{
    //DLog(@"blueSliderValueChanged");
    UIColor* sourceColor = [iconView tintColor];
    const CGFloat* components = CGColorGetComponents(sourceColor.CGColor);
    CGFloat red = components[0],green = components[1],blue = components[2];
    blue = blueSlider.value;
    UIColor* newColor = [UIColor colorWithRed:red green:green blue:blue alpha:0.5f];
    [iconView setTintColor:newColor];
}

#pragma mark - Memory Management
- (void)loadView{
    [super loadView];
    [self loadSubviews];
}

- (void)viewDidUnload{
    [self unloadSubviews];
    [super viewDidUnload];
}

- (id)initWithCourse:(Course*)aCourse
{
	if (self = [self init]) {
		course = aCourse;
	}
    [self showDoneButton:YES animated:NO];

	return self;
}

- (void)dealloc{
    course = nil;
    
    [self destroySubview:&iconView];
    [self destroySubview:&redSlider];
    [self destroySubview:&greenSlider];
    [self destroySubview:&blueSlider];
    [self destroySubview:&colorSelector];
    
    [super dealloc];
}

@end
