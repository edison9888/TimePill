//
//  HomePageViewController.h
//  Timeline
//
//  Created by 04 developer on 12-10-24.
//  Copyright (c) 2012年 Sun Yat-sen University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExpandingButtonBar.h"
#import "DataManager.h"
#import "AWActionSheet.h"
#import "UIBubbleTableViewDataSource.h"
#import "PMCalendar.h"
#import "UIBubbleTableViewCell.h"
#import "CommentsViewController.h"
#import "TimeMenuViewController.h"
@class UIBubbleTableView;

@interface HomePageViewController : UIViewController
<ExpandingButtonBarDelegate, UIBubbleTableViewDataSource>
{
    ExpandingButtonBar *_bar;
    UIView *lineView;
    UIImage *longWeibo;
    UIImage *longWeibo_big;
    CGFloat _offset;
    BOOL FirstViewDidAppear;
}

@property (strong, nonatomic) UINavigationBar *navBar;
@property (strong, nonatomic) UINavigationItem *item;
@property (strong, nonatomic) UIView *bubbleHeader;
@property (strong, nonatomic) ExpandingButtonBar *bar;

@property (retain, nonatomic) UIBubbleTableView *myBubbleDiaryTableView;
@property (strong, nonatomic) UIView *bigCircleTimeView;
@property (retain, nonatomic) NSMutableArray *diaries;
@property (retain, nonatomic) NSMutableArray *ACData;

@property (retain, nonatomic) AWActionSheet *sheet;
@property (retain, nonatomic) UIActionSheet *actionSheet;
@property (strong, nonatomic) UIButton *settingButton;
@property (strong, nonatomic) NSArray *colors;
@property (strong, nonatomic) UIImageView *headImageView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UIImageView *backgroundIV;

- (IBAction)selectTimeAnimation:(id)sender;
-(int)numberOfItemsInActionSheet;
-(void)DidTapOnItemAtIndex:(NSInteger)index;
-(AWActionSheetCell *)cellForActionAtIndex:(NSInteger)index;
-(void)showBlue;
-(void)showYellow;
-(void)showGrey;
-(void) onCreateDiary;
-(void) onShareDiary;
-(void) onLoadDataFromMicroBlog;

-(void)setTableScrollEnable:(Boolean)en;
@end
