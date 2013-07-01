//
//  DataManager.m
//  sinaweibo_ios_sdk_demo
//
//  Created by 01 developer on 12-10-28.
//  Copyright (c) 2012年 SINA. All rights reserved.
//

#import "DataManager.h"

@implementation DataManager
@synthesize sinaWeiboData,renrenData,dataClient;
@synthesize resultsArray = _resultsArray;

static DataManager *sharedDataManager = nil;

-(DataClient *)dataClient
{
    return [DataClient shareClient]; 
}

-(id)init{
    if([super init])
    {
        sinaWeiboData=[[SinaWeiboData alloc] init];
        renrenData=[[RenRenData alloc] init];
    }
    return self;
}
//sington
+ (DataManager *)sharedDataManager {
    if (!sharedDataManager) {
        sharedDataManager = [[DataManager alloc] init];
    }
    return sharedDataManager;
}

#pragma mark 授权有效测试
-(Boolean)isWeiboAuthValid
{
    return [sinaWeiboData isAuthValid];
}

-(Boolean)isRenRenAuthValid
{
    return [renrenData isAuthValid];
}

#pragma mark 对外接口

-(void)userInfo:(int)type
{
    /*新线程,下载完数据不用保存，发送通知给VC*/
    if(type==1)
        [sinaWeiboData getUserInfo];
    else
        [renrenData getUserInfo];
}


-(void)friendsInfo:(int)type
{
    /*新线程,下载完数据后发送通知给VC*/
    if(type==1)
        [sinaWeiboData getFriends];
    else
        [renrenData getFriends];
}

-(void)deleteUserDiary:(NSArray*)deleteDiaryId andType:(int)type
{
    
}

-(void)deleteUserDiary:(NSArray*)deleteDiaryId
{
    
}

-(void)addNewDiary:(NSString *)text andImage:(UIImage *)image
{
    
}

/*长微博*/
-(void)deleteLong:(int)index
{
    [[sharedDataManager dataClient] deleteALong:index];
}
-(void)addLongWeibo:(NSData *)data andAbstract:(NSData *)aData
{
    [[sharedDataManager dataClient] addLong:data andAbstract:aData];
}


-(NSMutableArray *)getLongWeibo
{
    NSMutableArray *results = [[NSMutableArray alloc] initWithArray:[[sharedDataManager dataClient] getLong]];
    return results;
}

#pragma mark dealloc
-(void)dealloc{
    self.sinaWeiboData = nil;
    self.resultsArray = nil;
    self.renrenData = nil;
}

@end
