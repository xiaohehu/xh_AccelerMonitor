//
//  xhPanoramicView.m
//  xh_AccelerMonitor
//
//  Created by Xiaohe Hu on 6/2/14.
//  Copyright (c) 2014 Xiaohe Hu. All rights reserved.
//

#import "xhPanoramicView.h"
@interface xhPanoramicView ()

@property (nonatomic, strong) UIImage           *contentImage;
@end

@implementation xhPanoramicView
@synthesize uis_panoramic;
- (id)initWithFrame:(CGRect)frame andImageName:(NSString *)imageName
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _contentImage = [UIImage imageNamed:imageName];
        imageWidth = _contentImage.size.width;
        imageHeight = _contentImage.size.height;
        [self initScrollView];
        
        self.motionManager = [[CMMotionManager alloc] init];
        self.motionManager.accelerometerUpdateInterval = 0.0;
        self.motionManager.gyroUpdateInterval = 0.0;
        [self initControlBtns];
    }
    return self;
}

-(void)initScrollView {
    uis_panoramic = [[UIScrollView alloc] initWithFrame:self.bounds];
    uis_panoramic.backgroundColor = [UIColor whiteColor];
    uis_panoramic.contentSize = CGSizeMake(imageWidth, imageHeight);
    uis_panoramic.pagingEnabled = NO;
    uis_panoramic.clipsToBounds = YES;
    
    UIImageView *content = [[UIImageView alloc]initWithImage:_contentImage];
    content.frame = CGRectMake(0.0, 0.0, imageWidth, imageHeight);
    [uis_panoramic addSubview: content];
    
    [self addSubview: uis_panoramic];
}

#pragma mark - Init Control Buttons
-(void)initControlBtns {
    UIButton *uib_start = [UIButton buttonWithType:UIButtonTypeCustom];
    uib_start.frame = CGRectMake(140.0, 0.0, 100.0, 40.0);
    [uib_start setTitle:@"START" forState:UIControlStateNormal];
    [uib_start setBackgroundColor:[UIColor whiteColor]];
    [uib_start setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [uib_start addTarget:self action:@selector(startMotionManager) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *uib_stop = [UIButton buttonWithType:UIButtonTypeCustom];
    uib_stop.frame = CGRectMake(260.0, 0.0, 100.0, 40.0);
    [uib_stop setTitle:@"STOP" forState:UIControlStateNormal];
    [uib_stop setBackgroundColor:[UIColor whiteColor]];
    [uib_stop setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [uib_stop addTarget:self action:@selector(stopMotionManager) forControlEvents:UIControlEventTouchUpInside];
    
    [self insertSubview:uib_start aboveSubview:uis_panoramic];
    [self insertSubview:uib_stop aboveSubview:uis_panoramic];
}

#pragma mark - Motion Manger Controller
-(void)startMotionManager {
    
    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
        [self changeScrollViewOffset1:accelerometerData.acceleration];
        if (error) {
            NSLog(@"%@",error);
        }
    }];
    
    [self.motionManager startGyroUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMGyroData *gyrodata, NSError *error){
        [self changeScrollViewOffset2:gyrodata.rotationRate];
    }];
    
}
-(void)stopMotionManager {
    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
        //        [self changeScrollViewOffset1:accelerometerData.acceleration];
        nil;
        if (error) {
            NSLog(@"%@",error);
        }
    }];
    
    [self.motionManager startGyroUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMGyroData *gyrodata, NSError *error){
        //        [self changeScrollViewOffset2:gyrodata.rotationRate];
        nil;
    }];
    
    [self.motionManager stopAccelerometerUpdates];
    [self.motionManager stopAccelerometerUpdates];
    
}

-(void)changeScrollViewOffset1:(CMAcceleration)acceleration {
    CGPoint offset = uis_panoramic.contentOffset;
    NSLog(@"%f",acceleration.y);
    
    offset.x = offset.x+acceleration.y*5;
    
    if (offset.x < 0) {
        offset.x = 0;
    }
    if (offset.x > (imageWidth - self.frame.size.width)) {
        offset.x = (imageWidth - self.frame.size.width);
    }
    [uis_panoramic setContentOffset:offset];
}
-(void)changeScrollViewOffset2:(CMRotationRate)rotation {
    CGPoint offset = uis_panoramic.contentOffset;
    NSLog(@"%f",rotation.x);
    
    offset.x = offset.x+rotation.x*5;
    
    if (offset.x < 0) {
        offset.x = 0;
    }
    if (offset.x >  (imageWidth - self.frame.size.width)) {
        offset.x =  (imageWidth - self.frame.size.width);
    }
    
    [uis_panoramic setContentOffset:offset];
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
