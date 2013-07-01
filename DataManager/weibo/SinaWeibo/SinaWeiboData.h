//
//  SinaWeiboData.h
//  sinaweibo_ios_sdk_demo
//
//  Created by 01 developer on 12-10-18.
//  Copyright (c) 2012年 SINA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SinaWeibo.h"
#import "SinaWeiboRequest.h"
#import "SVProgressHUD.h"

#import <UIKit/UIKit.h>
#import "SinaWeiboData.h"
#define kAppKey             @"1213792051"
#define kAppSecret          @"4fc6b43b7a6b7dd69aecf26204f7ff96"
#define kAppRedirectURI     @"https://api.weibo.com/oauth2/default.html"

#ifndef kAppKey
#error
#endif

#ifndef kAppSecret
#error
#endif

#ifndef kAppRedirectURI
#error
#endif

@interface SinaWeiboData : NSObject<SinaWeiboDelegate,SinaWeiboRequestDelegate>
{
    SinaWeibo *sinaweibo;  
    
    NSMutableDictionary *userInfo;  //用户个人信息
    NSMutableArray *user_statuses;  //用户个人状态
    NSMutableArray *friends_statuses;  //某个好友的状态
    NSMutableArray *friends;  //所有关注者
    NSMutableArray *comments; //评论列表
   
    /*拉好友的flag*/
    Boolean isLast; //读取好友时的标记，是否为最后一页
    NSInteger next_count;  //读取好友时的标记，0-30-60...
    Boolean isFirstLoadingFriends;  //判断是不是第一次拉好友
    
    /*刷新微博的Flag*/
    int cases;  //标志是三种刷新方式中的哪种
    int timeIntervalPage; //按时间检索的页码标志
    Boolean shouldEnd; //是否该停止
    NSString *globleUserId; //方便循环调用
    
    SinaWeiboRequest *timeIntervalRequest;
}

@property (readonly, nonatomic) SinaWeibo *sinaweibo;
@property (assign, nonatomic) Boolean shouldEnd;
@property (retain, nonatomic) NSDate *startTime;
@property (retain, nonatomic) NSDate *endTime;

-(void)ToLogin;
-(void)ToLogout;

/*个人信息*/
-(void)getUserInfo;

/*按页码刷新微博*/
-(void)upDateWeibo:(NSString *)userId andPage:(NSString *)page;

/*下拉刷新微博*/
-(void)pullWeibo:(NSString *)userId andSinceId:(NSString *)sinceId;

/*按时间段返回微博*/
-(void)weiboWithTimeInterval:(NSString *)userId startTime:(NSDate *)start endTime:(NSDate *)end;
-(void)stopWeiboWithTimeInterval;

/*全部关注者列表*/
-(void)getFriends;  

/*个人信息*/
-(void)getComments:(NSString *) weiboId;

/*发布一条微博，不带图片*/
-(void)postStatus:(NSString *)text andLat:(NSString *)latitude andLong:(NSString *)longitude;

/*发布一条微博，带图片*/
-(void)postImageStatus:(NSString *)text andImage:(UIImage *)image andLat:(NSString *)latitude andLong:
(NSString *)longitude; 

/*判断授权是否有效*/
-(Boolean)isAuthValid; //判断授权是否有效

@end
