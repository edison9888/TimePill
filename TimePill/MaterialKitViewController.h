//
//  MaterialKitViewController.h
//  Timeline
//
//  Created by simon on 12-12-11.
//  Copyright (c) 2012年 Sun Yat-sen University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataClient.h"
#import "FriendCell.h"
#import "DataManager.h"
#import "HeadPicDownloader.h"

@interface MaterialKitViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,imageDownloaderDelegate>
{
    UIView *tableHeader;
    NSMutableArray *listData;
    NSString *type;
    NSString *userId;
}
@property (strong, nonatomic)  UITableView *tableView;
@property (strong, nonatomic)  UITableView *myTable;
@property (nonatomic, retain) NSOperationQueue *queue;

@end
