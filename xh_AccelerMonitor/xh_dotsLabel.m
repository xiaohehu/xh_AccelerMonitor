//
//  xh_dotsLabel.m
//  xh_dotsWithLabel
//
//  Created by Xiaohe Hu on 5/30/14.
//  Copyright (c) 2014 Xiaohe Hu. All rights reserved.
//

#import "xh_dotsLabel.h"
#define kBigDotSize  25.0

static float radius_0 = 1.0;
static float radius_1 = 3;
static float radius_2 = 4;
static float radius_3 = 6;

static float space_0 = 2.0;
static float space_1 = 4.0;
static float space_2 = 6.0;
static float space_3 = 21.0;

static float fontSize_0 = 18.0;
static float fontSize_1 = 22.0;
static float fontSize_2 = 28.0;
static float fontSize_3 = 38.0;

@interface xh_dotsLabel ()
@property (nonatomic, strong)   UIView          *uiv_bigDot;
@property (nonatomic, strong)   UITextView      *uitv_textView;
@property (nonatomic, strong)   UIButton        *uib_bigDot;
@end

@implementation xh_dotsLabel
@synthesize delegate;
@synthesize dict_viewData, dot_image, tappable;

-(void)setDict_viewData:(NSDictionary *)viewData {
    if (viewData == nil)
        return;
    else {
        dict_viewData = [[NSDictionary alloc] init];
        dict_viewData = viewData;
        [self initViewData];
    }
}

-(void)setDot_image:(NSString *)image {
    if (image == nil)
        return;
    else {
        dot_image = [[NSString alloc] initWithString:image];
        [self setBackgroundImage];
    }
}

-(void)setTappable:(BOOL)tap {
    tappable = tap;
    
    if (tappable) {
        self.userInteractionEnabled = YES;
        [self setBigDotTappable];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)initViewData {
    //Get X,Y postion
    NSString *str_position = [[NSString alloc] initWithString:[dict_viewData objectForKey:@"xy"]];
    NSRange range = [str_position rangeOfString:@","];
    NSString *str_x = [str_position substringWithRange:NSMakeRange(0, range.location)];
    NSString *str_y = [str_position substringFromIndex:(range.location + 1)];
    x_Value = [str_x floatValue];
    y_Value = [str_y floatValue];
    
    // Get Z value of the label
    NSNumber *zValue = [[NSNumber alloc] init];
    zValue = [dict_viewData objectForKey:@"zValue"];
    switch ([zValue intValue]) {
        case 0: {
            radius_Value = radius_0;
            space_Value = space_0;
            font_Size = fontSize_0;
            break;
        }
        case 1: {
            radius_Value = radius_1;
            space_Value = space_1;
            font_Size = fontSize_1;
            break;
        }
        case 2: {
            radius_Value = radius_2;
            space_Value = space_2;
            font_Size = fontSize_2;
            break;
        }
        case 3: {
            radius_Value = radius_3;
            space_Value = space_3;
            font_Size = fontSize_3;
            break;
        }
        default:
            break;
    }
    
//    //Get dots' radius
//    NSNumber *radiusNum = [[NSNumber alloc] init];
//    radiusNum = [dict_viewData objectForKey:@"radius"];
//    radius_Value = [radiusNum floatValue];
//    
//    //Get space between dots
//    NSNumber *spaceNum = [[NSNumber alloc] init];
//    spaceNum = [dict_viewData objectForKey:@"space"];
//    space_Value = [spaceNum floatValue];
    
    //Get num of dots
    NSNumber *dotsNum = [[NSNumber alloc] init];
    dotsNum = [dict_viewData objectForKey:@"num"];
    numOfDots = [dotsNum intValue];
    
    //Get direction
    directionUP = [[dict_viewData objectForKey:@"up"] boolValue];
    
    [self initDotsView];
}

-(void)initDotsView {
    
    self.frame = CGRectMake(x_Value, y_Value, kBigDotSize, kBigDotSize);
    self.clipsToBounds = NO;
    self.backgroundColor = [UIColor clearColor];
    
    //Create Dots
    if (directionUP) {
        self.frame = CGRectMake(x_Value, (y_Value - numOfDots * (space_Value + radius_Value*2)), kBigDotSize, numOfDots * (space_Value + radius_Value*2) + kBigDotSize);
        
        //Create big dot at bottom
        _uiv_bigDot = [[UIView alloc] init];
        _uiv_bigDot.backgroundColor = [UIColor whiteColor];
        _uiv_bigDot.frame = CGRectMake(0, numOfDots * (space_Value + radius_Value*2), kBigDotSize, kBigDotSize);
        CGPoint savedCenter = _uiv_bigDot.center;
        _uiv_bigDot.layer.cornerRadius = kBigDotSize/2.0;
        _uiv_bigDot.center = savedCenter;
        [self addSubview: _uiv_bigDot];
        
        CGSize dotSize = CGSizeMake(radius_Value*2, radius_Value*2);
        for (int i = 0; i < numOfDots; i++) {
            UIView *uiv_smallDots = [[UIView alloc] init];
            uiv_smallDots.backgroundColor = [UIColor whiteColor];
            
            uiv_smallDots.frame = CGRectMake(savedCenter.x - radius_Value, savedCenter.y - kBigDotSize/2 - 2 * radius_Value - space_Value - (space_Value + dotSize.height)*i, dotSize.width, dotSize.height);
            CGPoint smallCenter = uiv_smallDots.center;
            uiv_smallDots.layer.cornerRadius = radius_Value;
//            uiv_smallDots.layer.shouldRasterize = YES;
            uiv_smallDots.center = smallCenter;
            [self addSubview:uiv_smallDots];
        }
    }
    else {
        self.frame = CGRectMake(x_Value, y_Value, kBigDotSize, numOfDots * (space_Value + radius_Value*2) + kBigDotSize);
        
        //Create big dot at bottom
        _uiv_bigDot = [[UIView alloc] init];
        _uiv_bigDot.backgroundColor = [UIColor whiteColor];
        _uiv_bigDot.frame = CGRectMake(0, 0, kBigDotSize, kBigDotSize);
        CGPoint savedCenter = _uiv_bigDot.center;
        _uiv_bigDot.layer.cornerRadius = kBigDotSize/2.0;
        _uiv_bigDot.center = savedCenter;
        [self addSubview: _uiv_bigDot];
        
        CGSize dotSize = CGSizeMake(radius_Value*2, radius_Value*2);
        for (int i = 0; i < numOfDots; i++) {
            UIView *uiv_smallDots = [[UIView alloc] init];
            uiv_smallDots.backgroundColor = [UIColor whiteColor];
            
            
            uiv_smallDots.frame = CGRectMake(savedCenter.x - radius_Value, savedCenter.y + kBigDotSize/2 + space_Value + (space_Value + dotSize.height)*i, dotSize.width, dotSize.height);
            CGPoint smallCenter = uiv_smallDots.center;
            uiv_smallDots.layer.cornerRadius = radius_Value;
//            uiv_smallDots.layer.shouldRasterize = YES;
            uiv_smallDots.center = smallCenter;
            [self addSubview:uiv_smallDots];
        }
    }
    
    [self initText];
}

-(void)initText {
    if (directionUP) {
        _uitv_textView = [[UITextView alloc] initWithFrame:CGRectMake(0, -100, 500, 100)];
        _uitv_textView.backgroundColor = [UIColor clearColor];
        _uitv_textView.userInteractionEnabled = NO;
        NSString *textContent = [[NSString alloc] initWithString:[dict_viewData objectForKey:@"text"]];
        _uitv_textView.text = [textContent stringByReplacingOccurrencesOfString:@"+" withString:@"\n"];
        [_uitv_textView setFont:[UIFont fontWithName:@"Helvetica-Bold" size:font_Size]];
        [_uitv_textView setTextColor:[UIColor whiteColor]];
        [_uitv_textView setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:_uitv_textView];

        CGSize textFrame = [_uitv_textView sizeThatFits:CGSizeMake(_uitv_textView.frame.size.width, FLT_MAX)];
        _uitv_textView.frame = CGRectMake( - (textFrame.width - kBigDotSize)/2, - textFrame.height, textFrame.width, textFrame.height);
    }
    else {
        _uitv_textView = [[UITextView alloc] initWithFrame:CGRectMake(0, -100, 500, 100)];
        _uitv_textView.backgroundColor = [UIColor clearColor];
        _uitv_textView.userInteractionEnabled = NO;
        NSString *textContent = [[NSString alloc] initWithString:[dict_viewData objectForKey:@"text"]];
        _uitv_textView.text = [textContent stringByReplacingOccurrencesOfString:@"+" withString:@"\n"];
        [_uitv_textView setFont:[UIFont fontWithName:nil size:20]];
        [_uitv_textView setTextColor:[UIColor whiteColor]];
        [_uitv_textView setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:_uitv_textView];
#warning The following method only works in iOS 7
        CGSize textFrame = [_uitv_textView sizeThatFits:CGSizeMake(_uitv_textView.frame.size.width, FLT_MAX)];
        _uitv_textView.frame = CGRectMake( - (textFrame.width - kBigDotSize)/2, self.frame.size.height, textFrame.width, textFrame.height);
    }
}

-(void)setBackgroundImage {
    if (dot_image) {
        [_uib_bigDot setBackgroundImage:[UIImage imageNamed:dot_image] forState:UIControlStateNormal];
    }
}

-(void)setBigDotTappable {
    _uib_bigDot = [UIButton buttonWithType:UIButtonTypeCustom];
    _uib_bigDot.frame = CGRectMake(0.0, _uiv_bigDot.frame.origin.y, self.frame.size.width, kBigDotSize);
    _uib_bigDot.backgroundColor = [UIColor clearColor];
    _uib_bigDot.tag = self.tag;
    [_uib_bigDot addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchDown];
    [self addSubview: _uib_bigDot];
}

-(void)buttonTapped:(id)sender {
    UIButton *tmpButton = sender;
    [self didSelectedItemAtIndex:(int)tmpButton.tag];
}
#pragma mark - Delegate Method
-(void)didSelectedItemAtIndex:(int)index {
    [self.delegate didSelectedItemAtIndex:index];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
