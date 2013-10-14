//
//  EHFloatingView.m
//  ClasSchedule
//
//  Created by DreamerMac on 12-3-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EHFloatingView.h"
#import "EnterHelperCell.h"

@implementation EHFloatingView
@synthesize contentString = _contentString, fontName = _fontName, fontSize = _fontSize;

#define kDefaultFontSize    20.0f
#define kDefaultFontName    @"Arial"

#pragma mark - Frames
- (CGRect)contentStringFrame
{
    CGFloat selfHeight = self.frame.size.height;
    CGFloat theHeight = self.fontSize;
    CGFloat theY = (selfHeight - theHeight) / 2;
    return CGRectMake(0.0f ,theY , self.frame.size.width, self.frame.size.height-10);
}

#pragma mark - Load Subviews
- (void)loadSubviews{
    [super loadSubviews];
    
    EnterHelperCell* theUserInfo = (EnterHelperCell*)self.userInfo;
    [self setContentString:theUserInfo.content];
}

#pragma mark - Draw Back
- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    
    CGFloat cornerRadius = (CGRectGetWidth(rect) + CGRectGetHeight(rect)) / 2 * 0.1;
    CGFloat minX = CGRectGetMinX(rect), midX = CGRectGetMidX(rect), maxX = CGRectGetMaxX(rect);
    CGFloat minY = CGRectGetMinY(rect), midY = CGRectGetMidY(rect), maxY = CGRectGetMaxY(rect);
    CGContextMoveToPoint(context, midX, minY);
    CGContextAddArcToPoint(context, maxX, minY, maxX, midY, cornerRadius);
    CGContextAddArcToPoint(context, maxX, maxY, midX, maxY, cornerRadius);
    CGContextAddArcToPoint(context, minX, maxY, minX, midY, cornerRadius);
    CGContextAddArcToPoint(context, minX, minY, midX, minY, cornerRadius);
    CGContextClosePath(context);
    
    CGFloat fillColor[4] = {0.0f, 0.0f, 0.0f, 0.7f};
    CGContextSetFillColor(context, fillColor);
    CGContextFillPath(context);
    
    CGContextRestoreGState(context);
    
    CGFloat textColor[4] = {1.0f, 1.0f, 1.0f, 1.0f};
    CGContextSetFillColor(context, textColor);
    UIFont* font = [UIFont fontWithName:self.fontName size:self.fontSize];
    [_contentString drawInRect:[self contentStringFrame] withFont:font lineBreakMode:UILineBreakModeMiddleTruncation alignment:UITextAlignmentCenter];
}

#pragma mark Getter
- (NSString*)fontName{
    if (_fontName) return _fontName;
    else return kDefaultFontName;
}

- (CGFloat)fontSize{
    if (_fontSize) return _fontSize;
    else return kDefaultFontSize;
}

- (NSString*)contentString{
    if (_contentString) return _contentString;
    else return @"None";
}

@end
