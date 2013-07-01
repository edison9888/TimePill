//
//  RenRenData.m
//  RenrenSDKDemo
//
//  Created by 01 developer on 12-10-30.
//  Copyright (c) 2012年 Sun Yat-sen University. All rights reserved.
//

#import "RenRenData.h"
#import "ROCommentsRequestParam.h"

@implementation RenRenData
@synthesize renren,startTime,endTime,shouldEnd;

-(id)init{
    if([super init])
    {
        self.renren=[Renren sharedRenren];
        userInfo=[[NSMutableDictionary alloc] init];
        friends=[[NSMutableArray alloc] init];
        user_status=[[NSMutableArray alloc] init];
        friends_status=[[NSMutableArray alloc] init];
        
        isFirstGetFriends=YES;
        page4friends=1;
    }
    return self;
}

-(void)ToLogin{
    if (![self.renren isSessionValid]) {
		NSArray *permissions = [NSArray arrayWithObjects:@"status_update",@"photo_upload",@"publish_feed",@"create_album",@"operate_like",@"read_user_status",nil];
		[self.renren authorizationWithPermisson:permissions andDelegate:self];
	} 
}

-(void)ToLogout{
    [self.renren logout:self];
}

-(Boolean)isAuthValid
{
    return [self.renren isSessionValid];
}

-(void)getUserInfo{
    //设置请求参数
	ROUserInfoRequestParam *requestParam = [[[ROUserInfoRequestParam alloc] init] autorelease];
	requestParam.fields = [NSString stringWithFormat:@"uid,name,sex,birthday,headurl"];
	//发送请求
	[self.renren getUsersInfo:requestParam andDelegate:self];
}

-(void)getFriends
{
    [SVProgressHUD showWithStatus:@"正在同步人人好友列表..." maskType:1];
    ROGetFriendsInfoRequestParam *requestParam = [[[ROGetFriendsInfoRequestParam alloc] init] autorelease];
	requestParam.page = @"1";
	requestParam.count = @"500";
    requestParam.fields = @"name,id,headurl";
	
	[self.renren getFriendsInfo:requestParam andDelegate:self];
}

#pragma mark 评论
-(void)getComments:(NSString *)statuId andOwnerId:(NSString *)ownerId
{
    NSLog(@"getComments");
    ROCommentsRequestParam *params=[[ROCommentsRequestParam alloc] init];
    params.status_id=statuId;

    //if(ownerId != nil)
        //[params setObject:statuId forKey:@"owner_id"];
        params.owner_id=ownerId;
//    else  //用户自己
//    {
//        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
//        NSString *owner_id=[defaults stringForKey:@"session_UserId"];
//        //[params setObject:owner_id forKey:@"owner_id"];
//       params.owner_id=owner_id;
//        NSLog(@"owner_id=%@",owner_id);
//   }
    [self.renren getUserComments:params andDelegate:self];
    //[self.renren requestWithParams:params andDelegate:self];
}

#pragma mark 用户状态
/*按页码刷新微博*/
-(void)upDateStatus:(NSString *)userId andPage:(NSString *)page
{
    cases=1;
    
    ROUserStatusRequestParam *requestParam = [[ROUserStatusRequestParam alloc] init];
	requestParam.page = [NSString stringWithFormat:@"%@",page];
	requestParam.count = @"25";
    /*如果是nil则默认为自己*/
    if(userId!=nil)
    {
        requestParam.uid = userId;
    }
	
	[self.renren getUserStatus:requestParam andDelegate:self];
}

/*下拉刷新微博*/
-(void)pullStatus:(NSString *)userId
{
    cases=2;

    ROUserStatusRequestParam *requestParam = [[ROUserStatusRequestParam alloc] init];
	requestParam.page = @"1";
	requestParam.count = @"20";
    /*如果是nil则默认为自己*/
    if(userId!=nil)
    {
        requestParam.uid = userId;
    }
	
	[self.renren getUserStatus:requestParam andDelegate:self];
}

/*按时间段返回微博*/
-(void)statusWithTimeInterval:(NSString *)userId startTime:(NSDate *)start endTime:(NSDate *)end;
{
    cases=3;
    
    /*初始化flag*/
    cases=3;
    timeIntervalPage=1;
    shouldEnd=NO;
    globleUserId=userId;
    self.startTime=start;
    self.endTime=end;
    
    ROUserStatusRequestParam *requestParam = [[ROUserStatusRequestParam alloc] init];
	requestParam.page = [NSString stringWithFormat:@"%d",timeIntervalPage];
	requestParam.count = @"25";
    /*如果是nil则默认为自己*/
    if(userId!=nil)
    {
        requestParam.uid = userId;
    }
	
	[self.renren getUserStatus:requestParam andDelegate:self];
}
-(void)stopStatusWithTimeInterval
{
    shouldEnd=YES;
}
#pragma mark 发表状态
-(void)postStatus:(NSString *)text
{
    [SVProgressHUD showWithStatus:@"同步到人人..."];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:10];
    [params setObject:@"status.set" forKey:@"method"];
    [params setObject:text forKey:@"status"];
    [self.renren requestWithParams:params andDelegate:self];
    [params release];
}
-(void)postImageStatus:(NSString *)text andImage:(UIImage *)image
{
    [SVProgressHUD showWithStatus:@"同步到人人..."];
    ROPublishPhotoRequestParam *param = [[ROPublishPhotoRequestParam alloc] init];
    param.imageFile = image;
    param.caption = text;
    [self.renren publishPhoto:param andDelegate:self];
    [param release];
}

#pragma mark 接口请求成功
/**
 * 接口请求成功，第三方开发者实现这个方法
 */
- (void)renren:(Renren *)renren requestDidReturnResponse:(ROResponse*)response
{
    if([response.param.method isEqual:@"users.getInfo"])
    {
        NSArray *usersInfo = (NSArray *)(response.rootObject);
        NSMutableDictionary *userInfoDic=[[NSMutableDictionary alloc] init];
        for (ROUserResponseItem *item in usersInfo) {
            [userInfoDic setValue:item.userId forKey:@"userId"];
            [userInfoDic setValue:item.name forKey:@"name"];
            [userInfoDic setValue:item.headUrl forKey:@"headUrl"];

            NSLog(@"UserID:%@\n Name:%@\n Sex:%@\n Birthday:%@\n HeadURL:%@\n",item.userId,item.name,item.sex,item.brithday,item.headUrl);
        }
        //发送一个通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"renren_user_info" object:userInfoDic];
    }
    /*----------------------全部好友-------------------------*/
    else if([response.param.method isEqual:@"friends.getFriends"])
    {
        //第一次清空数组
        if(isFirstGetFriends ==YES)
        {
            [friends removeAllObjects];
            isFirstGetFriends=NO;
        }
        
        NSArray *friendsInfo = (NSArray *)(response.rootObject);
        int count=[friendsInfo count];
        NSLog(@"本次数组大小为%d",count);
        for (ROFriendResponseItem *item in friendsInfo) {
            NSDictionary *dictionary = [item responseDictionary];
            [friends addObject:dictionary];
        }
        
        //如果没读完，继续读
        if(count==500)
        {
            page4friends++;
            ROGetFriendsInfoRequestParam *requestParam = [[[ROGetFriendsInfoRequestParam alloc] init] autorelease];
            requestParam.page = [NSString stringWithFormat:@"%d",page4friends];
            requestParam.count = @"500";
            requestParam.fields = @"name,id,headurl";
            
            [self.renren getFriendsInfo:requestParam andDelegate:self];
        }
        else {
            page4friends=1;
            isFirstGetFriends=YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"renren_friends" object:friends];
             [SVProgressHUD dismissWithSuccess:@"同步人人好友成功"];

        }
    }
    /*----------------------用户状态-------------------------*/
    else if([response.param.method isEqual:@"status.gets"])
    {
        NSArray *result = (NSArray *)(response.rootObject);
        switch (cases) {
                /*按页码刷新微博*/
            case 1:
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"upDateStatus" object:result];
            }
                break;
                /*下拉刷新微博*/
            case 2:
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"pullStatus" object:result];
            }
                break;
                /*按时间段返回微博*/
            case 3:
            {
                NSMutableArray *postArray=[[NSMutableArray alloc] init];
                for(ROResponseItem *item in result)
                {
                    NSDictionary *dic = [item responseDictionary];
                    /*取出时间并转换成NSDate格式*/
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"]; 
                    NSDate *time= [dateFormatter dateFromString:[dic valueForKey:@"time"]];
                    /*比较时间*/
                    NSComparisonResult s=[time compare:self.startTime];
                    NSComparisonResult e=[time compare:self.endTime];
                    NSLog(@"s=%d e=%d",s,e);
                    if( ( s==1 || s==0 ) && ( e==-1 || e==0 ) )
                    {
                        [postArray addObject:dic];
                    }
                    else if(s==-1)
                    {
                        shouldEnd=YES;
                        break;
                    }
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:@"statusWithTimeInterval" object:postArray];
                
                /*继续拉*/
                if(shouldEnd==NO)
                {
                    timeIntervalPage ++;
                    ROUserStatusRequestParam *requestParam = [[ROUserStatusRequestParam alloc] init];
                    requestParam.page = [NSString stringWithFormat:@"%@",timeIntervalPage];
                    requestParam.count = @"25";
                    /*如果是nil则默认为自己*/
                    if(globleUserId!=nil)
                    {
                        requestParam.uid = globleUserId;
                    }
                    
                    [self.renren getUserStatus:requestParam andDelegate:self];
                }

            }
                break;
            default:
                break;
        }

    }
    /*-----------------评论列表------------*/
    else if([response.param.method isEqual:@"status.getComment"])
    {
        /*接收返回的数据数组*/
        NSArray *temp = (NSArray *)(response.rootObject);
        int count=[temp count]; 
        NSLog(@"评论总数%d",count);
        /*init*/
        comments=[[NSMutableArray alloc] init];
        for (ROResponseItem *item in temp) {
            NSDictionary *dictionary = [item responseDictionary];
            [comments addObject:dictionary];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"renren_comments" object:comments];
    }
    else{
        NSLog(@"%@",[[response param] method]);
        [SVProgressHUD dismissWithSuccess:@"同步人人成功"];
    }
    
}

#pragma mark 接口请求失败
/**
 * 接口请求失败，第三方开发者实现这个方法
 */
- (void)renren:(Renren *)renren requestFailWithError:(ROError*)error
{
    if([[[[renren request] requestParamObject] method] isEqualToString:@"friends.getFriends"])
    {
        [SVProgressHUD dismissWithError:@"同步人人好友失败"];
    }
    else if([[[[renren request] requestParamObject] method] isEqualToString:@"status.gets"])
    {
        [SVProgressHUD dismissWithError:@"同步人人数据失败"];
    }
    else {
         [SVProgressHUD dismissWithError:@"同步人人失败"];
    }
    
}

-(void)renrenDidLogin:(Renren *)renren{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"renrenloginsuccess" object:nil];
    [SVProgressHUD showSuccessWithStatus:@"登陆人人成功" duration:1.0f];
}

- (void)renren:(Renren *)renren loginFailWithError:(ROError*)error{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"renrenloginfail" object:nil];
	[SVProgressHUD showErrorWithStatus:@"登陆人人失败" duration:1.0f];
}
@end
