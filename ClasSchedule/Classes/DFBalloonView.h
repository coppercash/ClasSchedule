//
//  DFBalloonView.h
//  trapezium
//
//  Created by DreamerMac on 12-5-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DFBalloonView : UIView{
    CGFloat _tailPosition;
    
    CGFloat _cornerRadius;
    CGFloat _lineWidth;
    UIColor* _strokeColor;
}
@property(nonatomic)CGFloat tailPosition;
@property(nonatomic)CGFloat cornerRadius;
@property(nonatomic)CGFloat lineWidth;
@property(nonatomic,retain)UIColor* strokeColor;



@end
