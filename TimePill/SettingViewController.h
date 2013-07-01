//
//  HallViewController.h
//  Timeline
//
//  Created by yongry on 12-12-15.
//  Copyright (c) 2012年 Sun Yat-sen University. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DataManager.h"
#import "LoginViewController.h"
#import "AboutUsViewController.h"
@interface SettingViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *settableView;
@property (nonatomic,strong)NSArray *array;


@end
