//
//  xh_dotsLabel.h
//  xh_dotsWithLabel
//
//  Created by Xiaohe Hu on 5/30/14.
//  Copyright (c) 2014 Xiaohe Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol dotLabelDelegate
-(void)didSelectedItemAtIndex:(int)index;
@end

@interface xh_dotsLabel : UIView <UIGestureRecognizerDelegate>
{
    CGRect      viewFrame;
    float       x_Value;
    float       y_Value;
    float       radius_Value;
    float       space_Value;
    float       font_Size;
    int         numOfDots;
    BOOL        directionUP;
}
@property (nonatomic, strong) id<dotLabelDelegate>  delegate;

@property (nonatomic, strong) NSDictionary *dict_viewData;
@property (nonatomic, strong) NSString     *dot_image;
@property (nonatomic, readwrite) BOOL      tappable;
@end
