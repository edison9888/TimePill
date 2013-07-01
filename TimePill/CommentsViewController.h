//
//  CommentsViewController.h
//  Timeline
//
//  Created by simon on 12-12-1.
//  Copyright (c) 2012年 Sun Yat-sen University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "CommentsCell.h"
#import "HeadPicDownloader.h"
@interface CommentsViewController : UIViewController
{
    BOOL isFirst;
    NSString *userId;
    NSString *type;
    NSString *statusId_or_weiboId;
}

@property(retain,nonatomic) UITableView *comments;
@property(retain,nonatomic) UIButton *rightButton;
@property(retain,nonatomic) UIButton *leftButton;
@property(retain,nonatomic) UINavigationBar *navBar;
@property(retain,nonatomic) NSOperationQueue *queue;
@property(retain,nonatomic) NSString *userId;
@property(retain,nonatomic) NSString *type;
@property(retain,nonatomic) NSString *statusId_or_weiboId;
@property(retain,nonatomic) NSMutableDictionary *cache;
@end
