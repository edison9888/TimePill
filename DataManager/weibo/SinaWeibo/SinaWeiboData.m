//
//  SinaWeiboData.m
//  sinaweibo_ios_sdk_demo
//
//  Created by 01 developer on 12-10-18.
//  Copyright (c) 2012年 SINA. All rights reserved.
//

#import "SinaWeiboData.h"
@implementation SinaWeiboData

@synthesize sinaweibo,shouldEnd,startTime,endTime;

-(id)init{
    self=[super init];
    if(self)
    {
        userInfo=[[NSMutableDictionary alloc] init];
        user_statuses=[[NSMutableArray alloc] init];
        friends_statuses=[[NSMutableArray alloc] init];
        friends=[[NSMutableArray alloc] init];
        isLast=NO;
        next_count=1;
        isFirstLoadingFriends= YES;
        
        [self initSinaWeibo];
    }
    return self;
}
-(void)initSinaWeibo
{
    //实例化SinaWeibo对象，指定它的delegate
    sinaweibo = [[SinaWeibo alloc] initWithAppKey:kAppKey appSecret:kAppSecret appRedirectURI:kAppRedirectURI andDelegate:self];
    //把登陆参数取出
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *sinaweiboInfo = [defaults objectForKey:@"SinaWeiboAuthData"];
    if ([sinaweiboInfo objectForKey:@"AccessTokenKey"] && [sinaweiboInfo objectForKey:@"ExpirationDateKey"] && [sinaweiboInfo objectForKey:@"UserIDKey"])
    {
        sinaweibo.accessToken = [sinaweiboInfo objectForKey:@"AccessTokenKey"];
        sinaweibo.expirationDate = [sinaweiboInfo objectForKey:@"ExpirationDateKey"];
        sinaweibo.userID = [sinaweiboInfo objectForKey:@"UserIDKey"];
    } 
}
- (void)removeAuthData
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SinaWeiboAuthData"];
}

- (void)storeAuthData
{    
    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                              sinaweibo.accessToken, @"AccessTokenKey",
                              sinaweibo.expirationDate, @"ExpirationDateKey",
                              sinaweibo.userID, @"UserIDKey",
                              sinaweibo.refreshToken, @"refresh_token", nil];
    [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"SinaWeiboAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(void)ToLogin
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    NSLog(@"%@", [keyWindow subviews]);
    
    userInfo = nil;
     user_statuses = nil;
    
    [sinaweibo logIn];  
}
-(void)ToLogout
{
    [sinaweibo logOut];  
}

-(Boolean)isAuthValid
{
    return sinaweibo.isAuthValid;
}

-(void)getUserInfo
{
    [sinaweibo requestWithURL:@"users/show.json"
                           params:[NSMutableDictionary dictionaryWithObject:sinaweibo.userID forKey:@"uid"]
                       httpMethod:@"GET"
                        delegate:self];
    
}
#pragma mark 全部好友
-(void)getFriends
{
    [SVProgressHUD showWithStatus:@"正在同步微博关注列表..." maskType:1];
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
    [params setValue:sinaweibo.userID forKey:@"uid"];
    [params setValue:@"200" forKey:@"count"];
    [sinaweibo requestWithURL:@"friendships/friends.json" params:params httpMethod:@"GET" delegate:self];
}

#pragma mark 微博评论
-(void)getComments:(NSString *) weiboId
{
    NSLog(@"getComments");
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
    [params setValue:weiboId forKey:@"id"];
    [params setValue:@"50" forKey:@"count"];
    [sinaweibo requestWithURL:@"comments/show.json" params:params httpMethod:@"GET" delegate:self];
}

#pragma mark 发布微博
-(void)postStatus:(NSString *)text andLat:(NSString *)latitude andLong:(NSString *)longitude
{
    [SVProgressHUD showWithStatus:@"同步到微博..."];
    NSMutableDictionary *param=[[NSMutableDictionary alloc] init];
    [param setValue:text forKey:@"status"];
    //设置地点经纬度
    if(latitude !=nil && longitude !=nil)
    {
        [param setValue:latitude forKey:@"lat"];
        [param setValue:longitude forKey:@"long"];
    }
    //发布状态
    [sinaweibo requestWithURL:@"statuses/update.json"
                       params:param
                   httpMethod:@"POST"
                     delegate:self];
}
-(void)postImageStatus:(NSString *)text andImage:(UIImage *)image andLat:(NSString *)latitude andLong:(NSString *)longitude
{
    [SVProgressHUD showWithStatus:@"同步到微博..."];
    NSMutableDictionary *param=[[NSMutableDictionary alloc] init];
    [param setValue:text forKey:@"status"];
    [param setValue:image forKey:@"pic"];
    //设置地点经纬度
    if(latitude !=nil && longitude !=nil)
    {
        [param setValue:latitude forKey:@"lat"];
        [param setValue:longitude forKey:@"long"];
    }

    //发布图片状态    
    [sinaweibo requestWithURL:@"statuses/upload.json"
                       params:param
                   httpMethod:@"POST"
                     delegate:self];
}
/*按页码刷新微博*/
-(void)upDateWeibo:(NSString *)userId andPage:(NSString *)page
{
    cases=1;
    
    //设置参数
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
    if(userId==nil)
    {
        [params setValue:sinaweibo.userID forKey:@"uid"];
        NSLog(@"我的id%@",sinaweibo.userID);
    }
    else
        [params setValue:userId forKey:@"uid"];
    
    [params setValue:@"25" forKey:@"count"];
    [params setValue:page forKey:@"page"];
    [sinaweibo requestWithURL:@"statuses/user_timeline.json"
                       params:params
                   httpMethod:@"GET"
                     delegate:self];
}

/*下拉刷新微博*/
-(void)pullWeibo:(NSString *)userId andSinceId:(NSString *)sinceId
{
    cases=2;
    
    //设置参数
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
    if(userId==nil)
        [params setValue:sinaweibo.userID forKey:@"uid"];
    else
        [params setValue:userId forKey:@"uid"];
    
    [params setValue:@"25" forKey:@"count"];
    [params setValue:sinceId forKey:@"since_id"];
    [sinaweibo requestWithURL:@"statuses/user_timeline.json"
                       params:params
                   httpMethod:@"GET"
                     delegate:self];
}

-(void)stopWeiboWithTimeInterval
{
    shouldEnd=YES;
    [timeIntervalRequest cancelConnection];
    
}

/*按时间段返回微博*/
-(void)weiboWithTimeInterval:(NSString *)userId startTime:(NSDate *)start endTime:(NSDate *)end
{
    /*初始化flag*/
    cases=3;
    timeIntervalPage=1;
    shouldEnd=NO;
    globleUserId=userId;
    self.startTime=start;
    self.endTime=end;

    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
    if(userId==nil)
        [params setValue:sinaweibo.userID forKey:@"uid"];
    else
        [params setValue:userId forKey:@"uid"];
    
    [params setValue:@"25" forKey:@"count"];
    [params setValue:[NSString stringWithFormat:@"%d",timeIntervalPage] forKey:@"page"];
    timeIntervalRequest =[sinaweibo requestWithURL:@"statuses/user_timeline.json"
                       params:params
                   httpMethod:@"GET"
                     delegate:self];
}

#pragma mark - 成功调用此方法 
//成功调用此方法
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    /*---------------------------------个人信息--------------------------------*/
    if ([request.url hasSuffix:@"users/show.json"])
    {

        userInfo=result;
        //数据加载完毕，发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"weibo_userInfo" object:userInfo];
    }
    else if ([request.url hasSuffix:@"statuses/user_timeline.json"])
    {
        switch (cases) {
            /*按页码刷新微博*/
            case 1:
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"upDateWeibo" object:result];
            }
            break;
            /*下拉刷新微博*/
            case 2:
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"pullWeibo" object:result];
            }
            break;
            /*按时间段返回微博*/
            case 3:
            {
                NSArray *statuses=[result objectForKey:@"statuses"];
                NSMutableArray *postArray=[[NSMutableArray alloc] init];
                for(NSDictionary *dic in statuses)
                {
                    /*取出时间并转换成NSDate格式*/
                    NSString* dateStr =[dic valueForKey:@"created_at"];
                    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
                    NSLocale* local =[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
                    [formater setLocale: local];
                    [formater setDateFormat:@"EEE MMM d HH:mm:ss zzzz yyyy"];
                    NSDate* time = [formater dateFromString:dateStr];
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
                [[NSNotificationCenter defaultCenter] postNotificationName:@"weiboWithTimeInterval" object:postArray];
                
                /*继续拉*/
                if(shouldEnd==NO)
                {
                    timeIntervalPage ++;
                    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
                    if(globleUserId==nil)
                        [params setValue:sinaweibo.userID forKey:@"uid"];
                    else
                        [params setValue:globleUserId forKey:@"uid"];
                    
                    [params setValue:@"25" forKey:@"count"];
                    [params setValue:[NSString stringWithFormat:@"%d",timeIntervalPage] forKey:@"page"];
                    timeIntervalRequest=[sinaweibo requestWithURL:@"statuses/user_timeline.json"
                                       params:params
                                   httpMethod:@"GET"
                                     delegate:self];
                }
                    
            }
            break;
            default:
            break;
        }
    }
    /*------------------------------全部关注-------------------------------*/
    else if ([request.url hasSuffix:@"friendships/friends.json"])
    {
        NSDictionary *dir=result;
        //NSString *total_number=[dir objectForKey:@"total_number"];
        //NSLog(@"total number is %@",total_number);
        //如果是重新拉取好友，就把数组清空
        if(isFirstLoadingFriends == YES)
            [friends removeAllObjects];
        //problem!?
        //在获取next_cursor后把该值传到下一个request时，无故报错
        //所以手动设置next_cursor，30一页起跳
        //如果设置50一页，只返回49个数据！？
        
        NSArray *temp=[dir objectForKey:@"users"];
        int count=[temp count];
        NSLog(@"count is %d",count);
        [friends addObjectsFromArray:temp];
        //如果不是最后一轮，就会继续发起request，读取下一页的好友
        if(count!=0)
        {
            isFirstLoadingFriends=NO;
            //手动递增next_cursor
            next_count=next_count+count;
            //SinaWeibo *sinaweibo = [self sinaweibo];
            NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
            [params setValue:sinaweibo.userID forKey:@"uid"];
            [params setValue:@"200" forKey:@"count"];
            [params setValue:[NSString stringWithFormat:@"%d",next_count] forKey:@"cursor"];
            [sinaweibo requestWithURL:@"friendships/friends.json" params:params httpMethod:@"GET" delegate:self];
        }
        else {
            isFirstLoadingFriends=YES;
            next_count=1;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"weibo_friends" object:friends];
            [SVProgressHUD dismissWithSuccess:@"同步微博关注成功"];
        }
    }
    /*------------------------------评论列表-------------------------------*/
    else if ([request.url hasSuffix:@"comments/show.json"])
    {
        NSDictionary *dir=result;
        NSString *total_number=[dir objectForKey:@"total_number"];
        NSLog(@"评论总数%@",total_number);
        
        /*init*/
        comments=[[NSMutableArray alloc] init];
        /*返回数据包中的评论数组*/
        NSArray *temp=[dir objectForKey:@"comments"];
        /*加到全局变量comments中*/
        [comments addObjectsFromArray:temp];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"weibo_comments" object:comments];
    }
    else if ([request.url hasSuffix:@"statuses/update.json"])
    {
        [SVProgressHUD dismissWithSuccess:@"同步微博成功"];
    }
    else if ([request.url hasSuffix:@"statuses/upload.json"])
    {
        [SVProgressHUD dismissWithSuccess:@"同步微博成功"];
    }
}

#pragma mark - 失败调用此方法 
//失败调用此方法
- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    if ([request.url hasSuffix:@"users/show.json"])
    {
        userInfo = nil;
    }
    else if ([request.url hasSuffix:@"statuses/user_timeline.json"])
    {
        if([[request.params objectForKey:@"uid"] isEqual:[self sinaweibo].userID]) //如果该请求是“获取用户状态”
            user_statuses = nil;
        else  //如果该请求是“获取好友状态”
            friends_statuses = nil;
        [SVProgressHUD dismissWithError:@"同步微博数据失败"];
    }
    else if([request.url hasSuffix:@"friendships/friends.json"])
    {
        friends = nil;
        [SVProgressHUD dismissWithError:@"同步微博关注失败"];
    }
    else if ([request.url hasSuffix:@"statuses/update.json"])
    {
        [SVProgressHUD dismissWithError:@"同步微博失败"];
    }
    else if ([request.url hasSuffix:@"statuses/upload.json"])
    {
        [SVProgressHUD dismissWithError:@"同步微博失败"];
    }
}

#pragma mark - SinaWeibo Delegate   
//登陆的委托函数
- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    NSLog(@"didlogin");
    NSLog(@"sinaweiboDidLogIn userID = %@ accesstoken = %@ expirationDate = %@ refresh_token = %@", sinaweibo.userID, sinaweibo.accessToken, sinaweibo.expirationDate,sinaweibo.refreshToken);
    
    [self storeAuthData];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"weibologinsuccess" object:nil];
    [SVProgressHUD showSuccessWithStatus:@"登陆微博成功" duration:1.0f];
}

- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboDidLogOut");
    [self removeAuthData];
}

- (void)sinaweiboLogInDidCancel:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboLogInDidCancel");
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo logInDidFailWithError:(NSError *)error
{
    NSLog(@"sinaweibo logInDidFailWithError %@", error);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"renrenloginfail" object:nil];
    [SVProgressHUD showErrorWithStatus:@"登陆微博失败" duration:1.0f];
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo accessTokenInvalidOrExpired:(NSError *)error
{
    NSLog(@"sinaweiboAccessTokenInvalidOrExpired %@", error);
    [self removeAuthData];
    
}
@end
