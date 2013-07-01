//
//  RenRenData.h
//  RenrenSDKDemo
//
//  Created by 01 developer on 12-10-30.
//  Copyright (c) 2012年 Sun Yat-sen University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Renren.h"
#import "SVProgressHUD.h"

@interface RenRenData : NSObject <RenrenDelegate>
{
    Renren *renren;
    NSMutableDictionary *userInfo;
    NSMutableArray *friends;
    NSMutableArray *user_status;
    NSMutableArray *friends_status;
    NSMutableArray *comments;
    
    //flag
    Boolean isFirstGetFriends;
    int page4friends;
    int cases;
    
    int timeIntervalPage; //按时间检索的页码标志
    Boolean shouldEnd; //是否该停止
    NSString *globleUserId; //方便循环调用 
}
@property (retain,nonatomic)Renren *renren;
@property (assign, nonatomic) Boolean shouldEnd;
@property (retain, nonatomic) NSDate *startTime;
@property (retain, nonatomic) NSDate *endTime;

/*登陆登出*/
-(void)ToLogin;  
-(void)ToLogout;  

/*个人信息*/
-(void)getUserInfo;  

/*按页码刷新微博*/
-(void)upDateStatus:(NSString *)userId andPage:(NSString *)page;

/*下拉刷新微博*/
-(void)pullStatus:(NSString *)userId ;

/*按时间段返回微博*/
-(void)statusWithTimeInterval:(NSString *)userId startTime:(NSDate *)start endTime:(NSDate *)end;
-(void)stopStatusWithTimeInterval;

/*全部好友*/
-(void)getFriends;

/*评论列表*/
-(void)getComments:(NSString *)statuId andOwnerId:(NSString *)ownerId;

/*发布状态*/
-(void)postStatus:(NSString *)text; 
-(void)postImageStatus:(NSString *)text andImage:(UIImage *)image; 

/*判断授权是否有效*/
-(Boolean)isAuthValid; 
@end
