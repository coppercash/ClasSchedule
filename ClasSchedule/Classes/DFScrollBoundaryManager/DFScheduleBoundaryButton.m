//
//  DFScheduleBoundaryButton.m
//  trapezium
//
//  Created by DreamerMac on 12-5-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DFScheduleBoundaryButton.h"

#define kGoldenRatio 0.618

@implementation DFScheduleBoundaryButton
@synthesize tintColor;

void PathAddUpSymbol(CGMutablePathRef path, CGRect rect)
{
    float heightRate = 0.7;
    float areaRate = 0.5;
    
    CGFloat realHeight = heightRate * rect.size.height;
    CGFloat topOrigin = rect.origin.y + (rect.size.height - realHeight) / 2;
    
    CGFloat x[3], y[4];
    for (NSUInteger index = 0; index < 3; index++) {
        x[index] = rect.size.width / 2 * index + rect.origin.x;
    }
    y[0] = topOrigin;
    y[1] = topOrigin + realHeight * (1 - areaRate);
    y[2] = topOrigin + realHeight * areaRate;
    y[3] = topOrigin + realHeight;
    
    const CGPoint points[] = {
        CGPointMake(x[1], y[0]), 
        CGPointMake(x[2], y[1]), 
        CGPointMake(x[2], y[3]),
        CGPointMake(x[1], y[2]), 
        CGPointMake(x[0], y[3]), 
        CGPointMake(x[0], y[1]),
        
        CGPointMake(x[0], y[1])
    };
    
    CGPathAddLines(path, NULL, points, 7);
}

void PathAddDownSymbol(CGMutablePathRef path, CGRect rect)
{
    float heightRate = 0.7;
    float areaRate = 0.5;
    
    CGFloat realHeight = heightRate * rect.size.height;
    CGFloat topOrigin = rect.origin.y + (rect.size.height - realHeight) / 2;
    
    CGFloat x[3], y[4];
    for (NSUInteger index = 0; index < 3; index++) {
        x[index] = rect.size.width / 2 * index + rect.origin.x;
    }
    y[0] = topOrigin;
    y[1] = topOrigin + realHeight * (1 - areaRate);
    y[2] = topOrigin + realHeight * areaRate;
    y[3] = topOrigin + realHeight;
    
    const CGPoint points[] = {
        CGPointMake(x[0], y[0]), 
        CGPointMake(x[1], y[1]), 
        CGPointMake(x[2], y[0]),
        CGPointMake(x[2], y[2]), 
        CGPointMake(x[1], y[3]), 
        CGPointMake(x[0], y[2]),
        
        CGPointMake(x[0], y[0])
    };
    
    CGPathAddLines(path, NULL, points, 7);
}

void PathAddProlangSymbol(CGMutablePathRef path, CGRect rect)
{
    CGFloat x[4],y[4];
    for (NSUInteger index = 0; index < 4; index++) {
        x[index] = rect.size.width / 3 * index + rect.origin.x;
        y[index] = rect.size.height / 3 * index + rect.origin.y;
    }
    const CGPoint points[] = {
        CGPointMake(x[1], y[0]), CGPointMake(x[2], y[0]), 
        CGPointMake(x[2], y[1]),
        CGPointMake(x[3], y[1]), CGPointMake(x[3], y[2]), 
        CGPointMake(x[2], y[2]),
        CGPointMake(x[2], y[3]), CGPointMake(x[1], y[3]), 
        CGPointMake(x[1], y[2]),
        CGPointMake(x[0], y[2]), CGPointMake(x[0], y[1]), 
        CGPointMake(x[1], y[1]),
        
        CGPointMake(x[1], y[0])
    };
    
    CGPathAddLines(path, NULL, points, 13);
}

void PathAddCurtailSymbol(CGMutablePathRef path, CGRect rect)
{
    float heightRate = 0.3;
        
    CGFloat height = rect.size.height * heightRate;
    CGFloat y = (rect.size.height - height) / 2 + rect.origin.y;

    CGPathAddRect(path, NULL, CGRectMake(rect.origin.x, y, rect.size.width, height));
}

void PathAddRoundCornerTrapezium(CGMutablePathRef path, CGRect rect, CGFloat difference, CGFloat cornerRadius, BOOL isLeft)
{
    CGFloat minx = CGRectGetMinX(rect), maxx = CGRectGetMaxX(rect) ;
	CGFloat miny = CGRectGetMinY(rect), maxy = CGRectGetMaxY(rect) ;

    if (isLeft) {
        CGPathMoveToPoint(path, NULL, difference, miny);
        CGPathAddLineToPoint(path, NULL, maxx, miny);
        CGPathAddLineToPoint(path, NULL, maxx, maxy);
        CGPathAddLineToPoint(path, NULL, minx, maxy);
        CGPathAddArcToPoint(path, NULL, difference, miny, maxx, miny, cornerRadius);
    }else{
        CGPathMoveToPoint(path, NULL, rect.size.width - difference, miny);
        CGPathAddLineToPoint(path, NULL, minx, miny);
        CGPathAddLineToPoint(path, NULL, minx, maxy);
        CGPathAddLineToPoint(path, NULL, maxx, maxy);
        CGPathAddArcToPoint(path, NULL, rect.size.width - difference, miny, minx, minx, cornerRadius);
    }
}

- (void)drawRect:(CGRect)rect{
    CGFloat difference = rect.size.width * (1 - kGoldenRatio);
    CGFloat radius = difference;
    BOOL isLeft = isLeftOrRight;

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGMutablePathRef path = CGPathCreateMutable();
    
    PathAddRoundCornerTrapezium(path, rect, difference, radius, isLeft);
    CGPathCloseSubpath(path);
    
    float rate = 0.5;
    CGFloat symbolSize = (rect.size.width > rect.size.height) ? (rect.size.height * rate) : (rect.size.width * rate);
    CGFloat leftRightOffset = isLeft ? (difference * rate / 2) : (-difference * rate / 2);
    CGFloat x = CGRectGetMidX(rect) + leftRightOffset - symbolSize / 2;
    CGFloat y = CGRectGetMidY(rect) + - symbolSize / 2;
    CGRect symbolFrame = CGRectMake(x, y, symbolSize, symbolSize);
    
    switch (buttonType) {
        case DFButtonTypeUp:
            PathAddUpSymbol(path, symbolFrame);
            break;
        case DFButtonTypeDown:
            PathAddDownSymbol(path, symbolFrame);
            break;
        case DFButtonTypeProlong:
            PathAddProlangSymbol(path, symbolFrame);
            break;
        case DFButtonTypeCurtail:
            PathAddCurtailSymbol(path, symbolFrame);
            break;
        default:
            break;
    }
    CGPathCloseSubpath(path);
    
    CGContextAddPath(context, path);
    CGContextSetFillColorWithColor(context, self.tintColor.CGColor);
    CGContextEOFillPath(context);
    
    CGPathRelease(path);
}

- (void)setTintColor:(UIColor *)aTintColor{
    [tintColor release];
    tintColor = [aTintColor retain];
    [self setNeedsDisplay];
}

- (UIColor*)tintColor{
    if (tintColor) {
        return tintColor;
    }else{
        return [UIColor colorWithRed:0.5f green:0.5f blue:0.5f alpha:0.5f];
    }
}

- (id)initWithButtonType:(DFButtonType)aButtonType direction:(BOOL)anILeftOrRight
{
    if (self = [super init]) {
        buttonType = aButtonType;
        isLeftOrRight = anILeftOrRight;
        [self setShowsTouchWhenHighlighted:YES];
    }
    return self;
}

- (void)dealloc{
    [tintColor release];
    tintColor = nil;
    
    [super dealloc];
}
@end
