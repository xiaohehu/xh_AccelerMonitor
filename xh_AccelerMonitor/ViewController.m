//
//  ViewController.m
//  xh_AccelerMonitor
//
//  Created by Xiaohe Hu on 5/7/14.
//  Copyright (c) 2014 Xiaohe Hu. All rights reserved.
//

#import "ViewController.h"
#import "xh_dotsLabel.h"
#import "xhPanoramicView.h"
@interface ViewController () <dotLabelDelegate>

@property (nonatomic, strong)   xhPanoramicView         *uiv_panoramicView;
@property (nonatomic, strong)   UIView                  *uiv_detail;
@property (nonatomic, strong)   UIButton                *uib_backButton;
@property (nonatomic, readwrite) BOOL                   tappable;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.view.frame = CGRectMake(0.0, 0.0, 1024.0, 768.0);
    
    [self initControlButton];
}

-(void)initControlButton {
    UIButton *tappable = [UIButton buttonWithType:UIButtonTypeCustom];
    tappable.frame = CGRectMake(412.0, 200.0, 200.0, 50.0);
    tappable.backgroundColor = [UIColor blackColor];
    [tappable setTitle:@"Tappable Labels" forState:UIControlStateNormal];
    [tappable setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [tappable addTarget:self action:@selector(loadTappable) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: tappable];
    
    UIButton *untappable = [UIButton buttonWithType:UIButtonTypeCustom];
    untappable.frame = CGRectMake(412.0, 380.0, 200.0, 50.0);
    untappable.backgroundColor = [UIColor blackColor];
    [untappable setTitle:@"Untappable Labels" forState:UIControlStateNormal];
    [untappable setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [untappable addTarget:self action:@selector(loadUntappable) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:untappable];
    
    _uib_backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _uib_backButton.frame = CGRectMake(0.0, 0.0, 60.0, 40.0);
    _uib_backButton.backgroundColor = [UIColor clearColor];
    [_uib_backButton addTarget:self action:@selector(backTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: _uib_backButton];
}

-(void)loadTappable {
    _uiv_panoramicView = [[xhPanoramicView alloc] initWithFrame:self.view.bounds andImageName:@"Seaport_Panorama.jpg"];
    [self.view insertSubview:_uiv_panoramicView belowSubview:_uib_backButton];
    _tappable = YES;
    [self initHotspot];
}

-(void)loadUntappable {
    _uiv_panoramicView = [[xhPanoramicView alloc] initWithFrame:self.view.bounds andImageName:@"Seaport_Panorama.jpg"];
    [self.view addSubview: _uiv_panoramicView];
    [self.view insertSubview:_uiv_panoramicView belowSubview:_uib_backButton];
    _tappable = NO;
    [self initHotspot];
}

-(void)backTapped {
    if (_uiv_panoramicView) {
        [_uiv_panoramicView removeFromSuperview];
        _uiv_panoramicView = nil;
    }
}
#pragma mark - Added Labels with dots
-(void)initHotspot {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"plist"];
    NSArray *totalData = [[NSArray alloc] initWithContentsOfFile:path];
    NSMutableArray *arr_labels = [[NSMutableArray alloc] init];
    for (int i = 0; i < totalData.count; i++) {
        NSDictionary *dotsData = [totalData objectAtIndex:i];
        xh_dotsLabel *dotView = [[xh_dotsLabel alloc] init];
        [dotView setDict_viewData:dotsData];
        dotView.tag = i;
        dotView.tappable = _tappable;
        dotView.delegate = self;
        if (_tappable) {
            [dotView setDot_image:@"slotmachine_surroundings_getting_button_opendata.png"];
        }
        [arr_labels addObject:dotView];
    }
    for (UIView *tmp in arr_labels) {
        [_uiv_panoramicView.uis_panoramic addSubview: tmp];
    }
}
#pragma mark dots label Delegate method
-(void)didSelectedItemAtIndex:(int)index {
    NSLog(@"The tapped one is %i", index);
    _uiv_detail = [[UIView alloc] initWithFrame:self.view.bounds];
    
    UIImageView *uiiv_detailImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"surrounding_image.jpg"]];
    uiiv_detailImage.frame = _uiv_detail.bounds;
    [_uiv_detail addSubview: uiiv_detailImage];
    
    UIButton *removeDetail = [UIButton buttonWithType:UIButtonTypeCustom];
    removeDetail.frame = CGRectMake(0.0, 0.0, 60.0, 40.0);
    removeDetail.backgroundColor = [UIColor clearColor];
    [removeDetail addTarget:self action:@selector(removeDetailImage) forControlEvents:UIControlEventTouchUpInside];
    [_uiv_detail addSubview: removeDetail];
    
    [self.view addSubview: _uiv_detail];
}

-(void)removeDetailImage {
    [_uiv_detail removeFromSuperview];
    _uiv_detail = nil;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
