//
//  DFScheduleBoundaryButton.h
//  trapezium
//
//  Created by DreamerMac on 12-5-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    DFButtonTypeUp,
    DFButtonTypeDown,
    DFButtonTypeProlong,
    DFButtonTypeCurtail
}DFButtonType;

@interface DFScheduleBoundaryButton : UIButton {
    BOOL isLeftOrRight;
    DFButtonType buttonType;
    UIColor* tintColor;
}
@property(nonatomic,retain)UIColor* tintColor;

- (id)initWithButtonType:(DFButtonType)aButtonType direction:(BOOL)anILeftOrRight;
void PathAddUpSymbol(CGMutablePathRef path, CGRect rect);
void PathAddDownSymbol(CGMutablePathRef path, CGRect rect);
void PathAddCurtailSymbol(CGMutablePathRef path, CGRect rect);
void PathAddProlangSymbol(CGMutablePathRef path, CGRect rect);
void PathAddRoundCornerTrapezium(CGMutablePathRef path, CGRect rect, CGFloat difference, CGFloat cornerRadius, BOOL isLeft);
@end
