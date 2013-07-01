//
//  FirstViewController.h
//  Timeline
//
//  Created by ddling on 12-11-15.
//  Copyright (c) 2012年 Sun Yat-sen University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomePageViewController.h"
#import "TimeMenuViewController.h"
#import "SettingViewController.h"
#import "PMCalendar.h"
#import "HallViewController.h"
#import "TimeSelectionMenu.h"
#import "PPRevealSideViewController.h"
@interface FirstViewController:UIViewController<PPRevealSideViewControllerDelegate>
@property (strong, nonatomic) TimeSelectionMenu *timeSelectionMenu;
@property (strong, nonatomic) TimeMenuViewController *timeMenuViewController;

@property (strong, nonatomic) PPRevealSideViewController *revealSideViewController;
@end
