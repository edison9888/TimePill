//
//  StartViewController.h
//  Timeline
//
//  Created by yongry on 12-11-25.
//  Copyright (c) 2012年 Sun Yat-sen University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FirstViewController.h"

@interface IndicatorViewController : UIViewController<UIScrollViewDelegate>

@property (nonatomic,strong)  UIImageView *imageView;


@property (retain, nonatomic)  UIScrollView *pageScroll;
@property (retain, nonatomic)  UIPageControl *pageControl;

- (IBAction)gotoMainView:(id)sender;
@property (retain, nonatomic)  UIButton *gotoMainViewBtn;


@end
