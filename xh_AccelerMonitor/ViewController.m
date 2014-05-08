//
//  ViewController.m
//  xh_AccelerMonitor
//
//  Created by Xiaohe Hu on 5/7/14.
//  Copyright (c) 2014 Xiaohe Hu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong)   UIScrollView            *uis_imageContainer;
@property (nonatomic, strong)   NSArray                 *arr_images;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.view.frame = CGRectMake(0.0, 0.0, 1024.0, 768.0);
    _arr_images = [[NSArray alloc] initWithObjects:@"image_1.jpg", @"image_2.jpg", @"image_3.jpg", nil];
    
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.accelerometerUpdateInterval = 0.0;
    self.motionManager.gyroUpdateInterval = 0.0;
    
    [self initScrollView];
    [self initControlBtns];
}

#pragma mark - Init Control Buttons
-(void)initControlBtns {
    UIButton *uib_start = [UIButton buttonWithType:UIButtonTypeCustom];
    uib_start.frame = CGRectMake(40.0, 0.0, 100.0, 40.0);
    [uib_start setTitle:@"START" forState:UIControlStateNormal];
    [uib_start setBackgroundColor:[UIColor whiteColor]];
    [uib_start setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [uib_start addTarget:self action:@selector(startMotionManager) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *uib_stop = [UIButton buttonWithType:UIButtonTypeCustom];
    uib_stop.frame = CGRectMake(160.0, 0.0, 100.0, 40.0);
    [uib_stop setTitle:@"STOP" forState:UIControlStateNormal];
    [uib_stop setBackgroundColor:[UIColor whiteColor]];
    [uib_stop setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [uib_stop addTarget:self action:@selector(stopMotionManager) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view insertSubview:uib_start aboveSubview:_uis_imageContainer];
    [self.view insertSubview:uib_stop aboveSubview:_uis_imageContainer];
}

#pragma mark - Init Scroll View
-(void)initScrollView {
    _uis_imageContainer = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _uis_imageContainer.backgroundColor = [UIColor whiteColor];
    _uis_imageContainer.contentSize = CGSizeMake(1024*3, 768);
    _uis_imageContainer.pagingEnabled = NO;
    _uis_imageContainer.showsVerticalScrollIndicator = NO;
    _uis_imageContainer.clipsToBounds = YES;
    _uis_imageContainer.scrollsToTop = NO;
    //    _uis_bottomScrView.delegate = self;
    
    for (int i = 0; i < _arr_images.count; i++) {
        UIImageView *contentImge = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[_arr_images objectAtIndex:i]]];
        contentImge.frame = CGRectMake(1024*i, 0.0, 1024, 768);
        
        [_uis_imageContainer addSubview: contentImge];
    }
    [self.view addSubview:_uis_imageContainer];
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
    CGPoint offset = _uis_imageContainer.contentOffset;
    NSLog(@"%f",acceleration.y);

    offset.x = offset.x+acceleration.y*5;
        
    if (offset.x < 0) {
        offset.x = 0;
    }
    if (offset.x > 2048) {
        offset.x = 2048;
    }
    [_uis_imageContainer setContentOffset:offset];
}
-(void)changeScrollViewOffset2:(CMRotationRate)rotation {
    CGPoint offset = _uis_imageContainer.contentOffset;
    NSLog(@"%f",rotation.x);
    
    offset.x = offset.x+rotation.x*5;
        
    if (offset.x < 0) {
        offset.x = 0;
    }
    if (offset.x > 2048) {
        offset.x = 2048;
    }
    
    [_uis_imageContainer setContentOffset:offset];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
