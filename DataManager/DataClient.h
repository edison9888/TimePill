//
//  DataClient.h
//  Timeline
//
//  Created by yongry on 12-10-30.
//  Copyright (c) 2012年 Sun Yat-sen University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface DataClient : NSObject<NSFetchedResultsControllerDelegate>

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


+ (DataClient *)shareClient;
- (void)saveContext;

- (NSURL *)applicationDocumentsDirectory;

-(void)addItem:(NSDictionary *)dic  withImage:(UIImage *)image withRepostImage:(UIImage *)repostImage withType:(int)type;
-(void)deleteItem:(NSString *)ID;

- (void)deleteAllFriendItem:(NSIndexPath *)indexPath withID:(NSString *)FriendID;
- (void)deleteAll;
- (void)deleteSinaAll;
- (void)deleteRenrenAll;

/*长微博*/
- (void)addLong:(NSData *)data andAbstract:(NSData *)aData;
- (NSArray *)getLong;
-(void)deleteALong:(int)index;

/*最近联系人*/
-(void)addRecentContacts:(NSMutableDictionary *)item;
-(NSArray *)getRecentContacts;

/*读取数据库的所有微博状态*/
-(NSArray *)getAllWeibo;

/*评论吐槽*/
-(NSArray *)getCommentsWithID:(NSString *)ID;
- (void)addComments:(NSDictionary *)dic withType:(int)type andWeiboID:(NSString *)weiboID andImage:(UIImage *)image;
- (void)deleteCommentWithWeiboID:(NSString *)ID;
- (void)deleteCommentWithID:(NSString *)ID;
-(void)deleteAllComment;
@end
