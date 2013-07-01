//
//  OrderDisplayViewController.h
//  Timeline
//
//  Created by simon on 12-12-21.
//  Copyright (c) 2012年 Sun Yat-sen University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DisplayTableView.h"
#import "DataManager.h"
#import "DisplayCell.h"
#import "ImageTextView.h"
#import "DataClient.h"
#import "ImageDownloader.h"
#import "STSegmentedControl.h"
#import "PMCalendar.h"
#import "SVProgressHUD.h"
#import "BigImageView.h"

@interface OrderDisplayViewController : UIViewController

@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *sinceId;

@property (retain, atomic) DisplayTableView *tableView;

@property(nonatomic, retain) NSOperationQueue *queue;

@property(nonatomic, retain) UISearchBar *searchBar;
@property(nonatomic, retain) UITableView *resultTableView;
@property(nonatomic, retain) NSMutableArray *searchResults;
@property(nonatomic, retain) NSMutableArray *listData;

@property(nonatomic, retain) NSURLConnection *connection;
@property(nonatomic, retain) NSMutableData *bigImageData;
@property(nonatomic, retain) NSMutableDictionary *bigImageCache;
@property(nonatomic, retain) BigImageView *bigImageView;
@property(nonatomic, assign) int currentBigImageIndex;


@end
