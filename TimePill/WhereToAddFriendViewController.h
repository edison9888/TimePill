//
//  WhereToAddFriendViewController.h
//  Timeline
//
//  Created by 04 developer on 12-10-24.
//  Copyright (c) 2012年 Sun Yat-sen University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
@interface WhereToAddFriendViewController : UIViewController

//@property (strong, nonatomic) IBOutlet UINavigationItem *navigationBar;
- (IBAction)loadWeiboFriends:(id)sender;
- (IBAction)loadRenrenFriends:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *sinaButton;

@end

