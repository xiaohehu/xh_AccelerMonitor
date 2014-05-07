//
//  ViewController.h
//  xh_AccelerMonitor
//
//  Created by Xiaohe Hu on 5/7/14.
//  Copyright (c) 2014 Xiaohe Hu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

@interface ViewController : UIViewController<UIScrollViewDelegate>


@property (strong, nonatomic) CMMotionManager *motionManager;

@end
