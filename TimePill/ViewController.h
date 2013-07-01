//
//  ViewController.h
//  Timeline
//
//  Created by 01 developer on 12-11-1.
//  Copyright (c) 2012年 Sun Yat-sen University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Palette.h"


@interface ViewController : UIViewController


@property (retain, nonatomic) IBOutlet UIButton *renren_login;
@property (retain, nonatomic) IBOutlet UIButton *renren_test;
@property (retain, nonatomic) IBOutlet UIButton *weibo_login;
@property (retain, nonatomic) IBOutlet UIButton *weibo_test;
@property (retain, nonatomic) IBOutlet UITableView *tableview;

- (IBAction)RenRenLogin:(id)sender;
- (IBAction)RenRenTest:(id)sender;
- (IBAction)WeiboLogin:(id)sender;
- (IBAction)WeiboTest:(id)sender;
- (IBAction)RenRenStatus:(id)sender;
- (IBAction)WeboStatus:(id)sender;



@end
