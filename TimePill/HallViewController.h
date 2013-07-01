//
//  HallViewController.h
//  Timeline
//
//  Created by yongry on 12-12-15.
//  Copyright (c) 2012年 Sun Yat-sen University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "DataManager.h"

@interface HallViewController : UIViewController <iCarouselDataSource,iCarouselDelegate,UIActionSheetDelegate>
@property (nonatomic,assign) BOOL wrap;
@property (strong, nonatomic) IBOutlet iCarousel *carousel;
@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;
@property (strong, nonatomic) IBOutlet UINavigationItem *item;


//@property (strong, nonatomic) UINavigationItem *item;

@end
