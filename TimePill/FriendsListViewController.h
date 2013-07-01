//
//  FriendsListViewController.h
//  Timeline
//
//  Created by 04 developer on 12-10-24.
//  Copyright (c) 2012年 Sun Yat-sen University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "FriendCell.h"
#import "WhereToAddFriendViewController.h"
#import "HeadPicDownloader.h"

@interface FriendsListViewController : UIViewController
<UITableViewDelegate, UITableViewDataSource, UISearchDisplayDelegate,imageDownloaderDelegate>

@property (strong, nonatomic) IBOutlet UITableView *FriendsListTableView;

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *userId;

@property (nonatomic, retain) NSArray *friends;
@property (nonatomic, retain) NSMutableArray *searchResults;
@property (nonatomic, retain) NSOperationQueue *queue;

-(void)getResults;
-(void)ReturnTo;
-(void)didLogin;
@end