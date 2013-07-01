//
//  DataManager.h
//  sinaweibo_ios_sdk_demo
//
//  Created by 01 developer on 12-10-28.
//  Copyright (c) 2012年 SINA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SinaWeiboData.h"
#import "RenRenData.h"
#import "DataClient.h"

@interface DataManager : NSObject
{
    SinaWeiboData *sinaWeiboData;
    RenRenData *renrenData;
    DataClient *dataClient;
    
}

@property(retain, nonatomic) DataClient *dataClient;
@property(retain,nonatomic)  SinaWeiboData *sinaWeiboData;
@property(retain,nonatomic)  RenRenData *renrenData;
@property(strong, nonatomic) NSArray *resultsArray;


/*--------单例方法--------*/
+ (DataManager *)sharedDataManager;

/*-------判断授权是否有效-------*/
-(Boolean)isWeiboAuthValid;
-(Boolean)isRenRenAuthValid;

/*-------用户个人信息-------*/
-(void)userInfo:(int)type;

/*-------读取好友列表-------*/
-(void)friendsInfo:(int)type;

/*-------删除数据库中个人的状态记录------—*/
-(void)deleteUserDiary:(NSArray*)deleteDiaryId andType:(int)type;

/*-------删除数据库中好友的状态记录------—*/
-(void)deleteUserDiary:(NSArray*)deleteDiaryId;

/*-------增加一条本地记录-------*/
-(void)addNewDiary:(NSString *)text andImage:(UIImage *)image;

/*长微博*/
-(void)addLongWeibo:(NSData *)data andAbstract:(NSData *)aData;
-(NSMutableArray *)getLongWeibo;
-(void)deleteLong:(int)index;


@end
