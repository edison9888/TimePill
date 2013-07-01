//
//  CreateDiaryViewController.h
//  Timeline
//
//  Created by 04 developer on 12-10-24.
//  Copyright (c) 2012年 Sun Yat-sen University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditContentView.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "KeyboardHeaderView.h"
#import "DataManager.h"
#import "PaintingViewController.h"
#import "CustomSwitch.h"
#import "SVProgressHUD.h"

@interface CreateDiaryViewController : UIViewController
<UIImagePickerControllerDelegate,CLLocationManagerDelegate,UIScrollViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate>
{
    /*----------地点----------*/
    CLLocationManager *lm;
    float latitude;  //纬度
    float longitude;  //经度
    Boolean isUsingPosition; //flag
    
    /*----------当前时间----------*/
    NSArray *weeks;
    
    /*----------表情栏----------*/
    UIView *emotionsBack;  //表情栏的background
    UIScrollView *emotionsView;  //表情栏的滚动视图
    UIPageControl *pageControl; //表情分页控制
    NSArray *weiboEmotions; //微博表情
    NSArray *weiboEmotions2; //微博表情2
    NSArray *renrenEmotions; //人人表情

    /*----------分享栏----------*/
    UIView *shareBack; //分享栏的背景
    Boolean isOpen; //判断是否展开
    
    CGFloat animDuration; //键盘退出需要的时间
}
@property (retain, nonatomic) IBOutlet EditContentView *textview;
@property (retain, nonatomic) IBOutlet UILabel *label_time;
@property (retain, nonatomic) IBOutlet UILabel *label_date;
@property (retain, nonatomic) IBOutlet UILabel *label_place;
@property (retain, nonatomic) IBOutlet UIButton *btn_position;
@property (retain, nonatomic) IBOutlet UIImageView *iv_Preview;
@property (retain, nonatomic) IBOutlet KeyboardHeaderView *keyboardHeader;

/*长微博时使用*/
@property (retain, nonatomic) UIImage *longWeibo;
@property (retain, nonatomic) NSString *type;

- (IBAction)shareTo:(id)sender;
- (IBAction)getPlace:(id)sender;
- (IBAction)getEmotions:(id)sender;
- (IBAction)getPhotos:(id)sender;
- (IBAction)ToDraw:(id)sender;

@end

