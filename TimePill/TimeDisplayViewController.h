//
//  TimeDisplayViewController.h
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

@interface TimeDisplayViewController : UIViewController

@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *userId;

@property (strong, nonatomic) NSDate *start;
@property (strong, nonatomic) NSDate *end;
@property (retain, nonatomic) DisplayTableView *tableView;

@property(nonatomic, retain) NSOperationQueue *queue;

@property(nonatomic, retain) UIView *searchBackground;

@property (nonatomic, strong) PMCalendarController *pmCC; /*日历*/
@property (nonatomic, strong) UIButton *startButton;
@property (nonatomic, strong) UIButton *endButton;

@property(nonatomic, retain) NSURLConnection *connection;
@property(nonatomic, retain) NSMutableData *bigImageData;
@property(nonatomic, retain) NSMutableDictionary *bigImageCache;
@property(nonatomic, retain) BigImageView *bigImageView;
@property(nonatomic, assign) int currentBigImageIndex;

@property(nonatomic, retain) NSMutableArray *listData;

@end
