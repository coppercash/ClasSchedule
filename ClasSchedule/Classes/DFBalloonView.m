#import "DFBalloonView.h"

#define kTailSize   CGSizeMake(10, 10)
#define kTailPosition   0
#define kCornerRadiusScale 0.1
#define kLineWidth  2.0f

@implementation DFBalloonView
@synthesize tailPosition = _tailPosition,cornerRadius = _cornerRadius,lineWidth = _lineWidth,strokeColor = _strokeColor;

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat radius = self.cornerRadius;
    CGFloat lineWidth = self.lineWidth;
    CGRect frameRect = CGRectInset(rect, lineWidth / 2, lineWidth / 2);
    
    
    CGFloat bodyX1 = CGRectGetMinX(frameRect), bodyX4 = CGRectGetMaxX(frameRect), bodyX2 = bodyX1 + radius, bodyX3 = bodyX4 - radius;
    CGFloat bodyY1 = CGRectGetMinY(frameRect), bodyY4 = CGRectGetMaxY(frameRect) - kTailSize.height, bodyY2 = bodyY2 + radius, bodyY3 = bodyY4 - radius;
    
    CGContextMoveToPoint(context, bodyX2, bodyY4);
    CGContextAddArcToPoint(context, bodyX1, bodyY4, bodyX1, bodyY3, radius);
    CGContextAddLineToPoint(context, bodyX1, bodyY2);
    CGContextAddArcToPoint(context, bodyX1, bodyY1, bodyX2, bodyY1, radius);
    CGContextAddLineToPoint(context, bodyX3, bodyY1);
    CGContextAddArcToPoint(context, bodyX4, bodyY1, bodyX4, bodyY2, radius);
    CGContextAddLineToPoint(context, bodyX4, bodyY3);
    CGContextAddArcToPoint(context, bodyX4, bodyY4, bodyX3, bodyY4, radius);

    
    CGFloat tailCenterX = self.tailPosition;
    CGFloat tailMinX = tailCenterX - kTailSize.width / 2;
    CGFloat tailMaxX = tailCenterX + kTailSize.width / 2;
    CGFloat tailY = CGRectGetMaxY(frameRect);
    CGPoint points[] = {
        CGPointMake(bodyX3, bodyY4), 
        CGPointMake(tailMaxX, bodyY4),
        CGPointMake(tailCenterX, tailY),
        CGPointMake(tailMinX, bodyY4),
        CGPointMake(bodyX2, bodyY4),
    };
    CGContextAddLines(context, points, 5);
    
    
    CGContextSetStrokeColorWithColor(context, self.strokeColor.CGColor);
    CGContextSetLineWidth(context, lineWidth);
    CGContextStrokePath(context);
}


#pragma mark - setter & getter
- (UIColor*)strokeColor{
    UIColor* color = _strokeColor ? _strokeColor : [UIColor whiteColor];
    return color;
}

- (CGFloat)cornerRadius{
    CGFloat shorterEdge = (self.bounds.size.width < self.bounds.size.height) ? self.bounds.size.width : self.bounds.size.height;
    CGFloat radius = _cornerRadius ? _cornerRadius : kCornerRadiusScale * shorterEdge;
    return radius;
}

- (CGFloat)lineWidth{
    CGFloat lineWidth = _lineWidth ? _lineWidth : kLineWidth;
    return lineWidth;
}

- (void)setTailPosition:(CGFloat)tailPosition
{
    CGFloat radius = self.cornerRadius;
    CGFloat minPosition = CGRectGetMinX(self.bounds) + radius + kTailSize.width / 2 + self.lineWidth / 2;
    CGFloat maxPosition = CGRectGetMaxX(self.bounds) - radius - kTailSize.width / 2 - self.lineWidth / 2;
    if (tailPosition < minPosition) {
        _tailPosition = minPosition;
    }else if (maxPosition < tailPosition) {
        _tailPosition = maxPosition;
    }else{
        _tailPosition = tailPosition;
    }
}

- (CGFloat)tailPosition{
    if (!_tailPosition) {
        [self setTailPosition:kTailPosition];
    }
    CGFloat position = _tailPosition;
    return position;
}

#pragma mark - Liffecycle

- (id)init{
    if (self = [super init]) {
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)dealloc{
    
    [_strokeColor release];
    _strokeColor = nil;
    
    [super dealloc];
}

@end
