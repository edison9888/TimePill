//
//  LoginViewController.h
//  Timeline
//
//  Created by 03 developer on 12-11-7.
//  Copyright (c) 2012年 Sun Yat-sen University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *weiboButton;
@property (strong, nonatomic) IBOutlet UIButton *renrenButton;

- (IBAction)loginFromWeibo:(id)sender;
- (IBAction)loginFromRenren:(id)sender;

@end
