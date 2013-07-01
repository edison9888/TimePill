//
//  DataClient.m
//  Timeline
//
//  Created by yongry on 12-10-30.
//  Copyright (c) 2012年 Sun Yat-sen University. All rights reserved.
//

#import "DataClient.h"



@implementation DataClient

@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

+ (DataClient *)shareClient
{
    static DataClient* shareClient;
    if (!shareClient) {
        shareClient = [[DataClient alloc] init];
    }
    return shareClient;
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            //NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark 删除
- (void)deleteItem:(NSString *)ID
{
    NSManagedObjectContext *context = self.managedObjectContext;
    NSFetchRequest * fetch = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PersonWeibo" inManagedObjectContext:self.managedObjectContext];
    [fetch setEntity: entity];
     NSPredicate *predicate = [NSPredicate predicateWithFormat: @"id == %@",ID];
    [fetch setPredicate:predicate];
    
    
    NSArray *results = [self.managedObjectContext executeFetchRequest:fetch error:nil];
    
    NSManagedObject *eventToDelete = [results objectAtIndex:0];
    [context deleteObject:eventToDelete];
    NSError *error = nil;if (![context save:&error]) {    
        //NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

- (void)deleteAllFriendItem:(NSIndexPath *)indexPath withID:(NSString *)FriendID
{
    NSManagedObjectContext *context = self.managedObjectContext;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type == total AND user == %@",FriendID];
    
    NSFetchRequest * fetch = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PersonWeibo" inManagedObjectContext:self.managedObjectContext];
    [fetch setEntity: entity];
    [fetch setPredicate: predicate];
    
    
    NSArray *results = [self.managedObjectContext executeFetchRequest:fetch error:nil];
    for (NSManagedObject *eventToDelete in results){
        [context deleteObject:eventToDelete];
    }
}

- (void)deleteAll
{
    NSManagedObjectContext *context = self.managedObjectContext;
    //  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type == total AND user == %@",FriendID];
    
    NSFetchRequest * fetch = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PersonWeibo" inManagedObjectContext:self.managedObjectContext];
    [fetch setEntity: entity];
    //   [fetch setPredicate: predicate];
    
    
    NSArray *results = [self.managedObjectContext executeFetchRequest:fetch error:nil];
    for (NSManagedObject *eventToDelete in results){
        [context deleteObject:eventToDelete];
    }
    
    /*漏了保存*/
    [self.managedObjectContext save:nil];
}

- (void)deleteRenrenAll
{
    NSManagedObjectContext *context = self.managedObjectContext;
    //  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type == total AND user == %@",FriendID];
    
    NSFetchRequest * fetch = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PersonWeibo" inManagedObjectContext:self.managedObjectContext];
    [fetch setEntity: entity];
    //   [fetch setPredicate: predicate];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"from =='renren'"];
    [fetch setPredicate:predicate];
    
    NSArray *results = [self.managedObjectContext executeFetchRequest:fetch error:nil];
    for (NSManagedObject *eventToDelete in results){
        [context deleteObject:eventToDelete];
    }
}

- (void)deleteSinaAll
{
    NSManagedObjectContext *context = self.managedObjectContext;
    //  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type == total AND user == %@",FriendID];
    
    NSFetchRequest * fetch = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PersonWeibo" inManagedObjectContext:self.managedObjectContext];
    [fetch setEntity: entity];
    //   [fetch setPredicate: predicate];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"from =='sina'"];
    [fetch setPredicate:predicate];
    
    
    NSArray *results = [self.managedObjectContext executeFetchRequest:fetch error:nil];
    for (NSManagedObject *eventToDelete in results){
        [context deleteObject:eventToDelete];
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil) {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil) {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"DataModel" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil) {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Timeline.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        //NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        //abort();
    }    
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark 微博状态
-(NSArray *)getAllWeibo
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PersonWeibo" inManagedObjectContext:self.managedObjectContext];
    NSArray *results = [[NSArray alloc] init];
    
    NSFetchRequest * fetch = [[NSFetchRequest alloc] init];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"created_at" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetch setSortDescriptors:sortDescriptors];
    [fetch setEntity: entity];
    
    results = [self.managedObjectContext executeFetchRequest:fetch error:nil];
    
    return results;
}

- (void)addItem:(NSDictionary *)dic  withImage:(UIImage *)image withRepostImage:(UIImage *)repostImage withType:(int)type
{
    NSError *error = nil;
    if(dic != nil)
    {
        switch(type){
            case 1:
            {
                
                NSManagedObjectContext *context = self.managedObjectContext;
                NSEntityDescription *entity = [NSEntityDescription entityForName:@"PersonWeibo" inManagedObjectContext:self.managedObjectContext];
                
                NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
                // Edit the entity name as appropriate.
                [fetchRequest setEntity:entity];
                
                // Set the batch size to a suitable number.
                
                
                // Edit the sort key as appropriate.
                
                //NSLog(@"%@",[dic valueForKey:@"id"]);
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"from == 'sina' AND id == %@",[dic valueForKey:@"id"]];
                [fetchRequest setPredicate:predicate];
                
                int tem = [context countForFetchRequest:fetchRequest error:&error];
                if(tem < 1){
                    
                    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
                    if(image != nil)
                    {
                        NSData *data1 = UIImageJPEGRepresentation(image, 1.0); 
                        
                        [newManagedObject setValue:data1 forKey:@"image"];
                    }
                    if(repostImage != nil){
                        NSData *data2 = UIImageJPEGRepresentation(repostImage, 1.0); 
                        [newManagedObject setValue:data2 forKey:@"repostImage"];
                    }
                    if([dic objectForKey:@"retweeted_status"] != nil)
                    {
                        [newManagedObject setValue:[[[dic objectForKey:@"retweeted_status"] objectForKey:@"user"] valueForKey:@"screen_name"] forKey:@"repost_username"];
                        [newManagedObject setValue:[[dic objectForKey:@"retweeted_status"] valueForKey:@"text"] forKey:@"repost_text"];
                        [newManagedObject setValue:[[dic objectForKey:@"retweeted_status"] valueForKey:@"created_at"] forKey:@"repost_time"];
                    }
                    if([dic valueForKey:@"bmiddle_pic"] != nil)
                        [newManagedObject setValue:[dic valueForKey:@"bmiddle_pic"] forKey:@"bmiddle_pic"];
                    else
                        [newManagedObject setValue:[dic valueForKey:@"bmiddle_pic"] forKey:@"bmiddle_pic"];
                    
                    
                    NSString* dateStr =[dic valueForKey:@"created_at"];
                    
                    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
                    
                    
                    
                    NSLocale* local =[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]  autorelease];
                    [formater setLocale: local];
                    [formater setDateFormat:@"EEE MMM d HH:mm:ss zzzz yyyy"];
                    NSDate* date = [formater dateFromString:dateStr];
                    
                    [newManagedObject setValue:date forKey:@"created_at"];
                    // if([dic valueForKey:@"geo"] != nil)
                    //  [newManagedObject setValue:[dic valueForKey:@"geo"] forKey:@"geo"];
                    //  else {
                    [newManagedObject setValue:@"no geo" forKey:@"geo"];
                    // }
                    if ([dic valueForKey:@"idstr"] != nil) {
                        [newManagedObject setValue:[dic valueForKey:@"idstr"] forKey:@"id"];
                    }
                    else {
                        [newManagedObject setValue:@"no value" forKey:@"id"];
                    }
                    if ([dic valueForKey:@"original_pic"] != nil) {
                        [newManagedObject setValue:[dic valueForKey:@"original_pic"] forKey:@"original_pic"]; 
                    }
                    else {
                        [newManagedObject setValue:[dic valueForKey:@"original_pic"]forKey:@"original_pic"]; 
                        
                    }
                    if ([dic valueForKey:@"text"]!=nil) {
                        
                        [newManagedObject setValue:[dic valueForKey:@"text"] forKey:@"text"]; 
                    }
                    else {
                        [newManagedObject setValue:@"no value" forKey:@"text"];
                    }
                    if ([dic valueForKey:@"source"]!=nil) {
                        [newManagedObject setValue:[dic valueForKey:@"source"] forKey:@"source"];
                    }
                    else {
                        [newManagedObject setValue:@"no value" forKey:@"source"];
                    }
                    if ([dic valueForKey:@"thumbnail_pic"]!=nil) {
                        [newManagedObject setValue:[dic valueForKey:@"thumbnail_pic"] forKey:@"thumbnail_pic"]; 
                    }
                    else {
                        [newManagedObject setValue:@"no value" forKey:@"thumbnail_pic"]; 
                    }
                    if([dic valueForKey:@"user"] !=nil)
                    {
                        NSString *uidStr = [[NSString alloc] initWithFormat:@"%d",[[dic valueForKey:@"user"] valueForKey:@"id"]];
                        
                        [newManagedObject setValue:uidStr forKey:@"user"]; 
                    }
                    else {
                        [newManagedObject setValue:[@"no value" valueForKey:@"id"] forKey:@"user"]; 
                    }
                    [newManagedObject setValue:[[dic objectForKey:@"user"] objectForKey:@"screen_name"] forKey:@"name"];
                    [newManagedObject setValue:@"sina" forKey:@"from"]; 
                    [newManagedObject setValue:@"person" forKey:@"type"]; 
                    
                    
                    
                    
                    
                    // Save the context.
                    
                    if (![context save:&error]){
                        // Replace this implementation with code to handle the error appropriately.
                        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
                        //NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                        abort();
                    }
                }
                break;
            }
                
            case 2:
            {
                NSManagedObjectContext *context = self.managedObjectContext;
                NSEntityDescription *entity = [NSEntityDescription entityForName:@"PersonWeibo" inManagedObjectContext:self.managedObjectContext];
                NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
                // Edit the entity name as appropriate.
                
                [fetchRequest setEntity:entity];
                
                // Set the batch size to a suitable number.
                
                
                // Edit the sort key as appropriate.
                
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"from == 'sina' AND id == %@",[dic valueForKey:@"id"]];
                [fetchRequest setPredicate:predicate];
                
                int tem = [context countForFetchRequest:fetchRequest error:&error];
                if(tem < 1){
                    
                    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
                    if(image != nil)
                    {
                        NSData *data1 = UIImageJPEGRepresentation(image, 1.0); 
                        
                        [newManagedObject setValue:data1 forKey:@"image"];
                    }
                    if(repostImage != nil){
                        NSData *data2 = UIImageJPEGRepresentation(repostImage, 1.0); 
                        [newManagedObject setValue:data2 forKey:@"repostImage"];
                    }
                    
                    if([dic valueForKey:@"bmiddle_pic"] != nil)
                        [newManagedObject setValue:[dic valueForKey:@"bmiddle_pic"] forKey:@"bmiddle_pic"];
                    else
                        [newManagedObject setValue:@"no value" forKey:@"bmiddle_pic"];
                    NSString* dateStr =[dic valueForKey:@"created_at"];
                    
                    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
                    
                    
                    
                    NSLocale* local =[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]  autorelease];
                    [formater setLocale: local];
                    [formater setDateFormat:@"EEE MMM d HH:mm:ss zzzz yyyy"];
                    NSDate* date = [formater dateFromString:dateStr];
                    
                    [newManagedObject setValue:date forKey:@"created_at"];                    // if([dic valueForKey:@"geo"] != nil)
                    //  [newManagedObject setValue:[dic valueForKey:@"geo"] forKey:@"geo"];
                    //  else {
                    [newManagedObject setValue:@"no geo" forKey:@"geo"];
                    // }
                    if ([dic valueForKey:@"idstr"] != nil) {
                        [newManagedObject setValue:[dic valueForKey:@"idstr"] forKey:@"id"];
                    }
                    else {
                        [newManagedObject setValue:@"no value" forKey:@"id"];
                    }
                    if ([dic valueForKey:@"original_pic"] != nil) {
                        [newManagedObject setValue:[dic valueForKey:@"original_pic"] forKey:@"original_pic"]; 
                    }
                    else {
                        [newManagedObject setValue:@"no value" forKey:@"original_pic"]; 
                        
                    }
                    if ([dic valueForKey:@"text"]!=nil) {
                        
                        [newManagedObject setValue:[dic valueForKey:@"text"] forKey:@"text"]; 
                    }
                    else {
                        [newManagedObject setValue:@"no value" forKey:@"text"];
                    }
                    if ([dic valueForKey:@"source"]!=nil) {
                        [newManagedObject setValue:[dic valueForKey:@"source"] forKey:@"source"];
                    }
                    else {
                        [newManagedObject setValue:@"no value" forKey:@"source"];
                    }
                    if ([dic valueForKey:@"thumbnail_pic"]!=nil) {
                        [newManagedObject setValue:[dic valueForKey:@"thumbnail_pic"] forKey:@"thumbnail_pic"]; 
                    }
                    else {
                        [newManagedObject setValue:@"no value" forKey:@"thumbnail_pic"]; 
                    }
                    if([dic valueForKey:@"user"] !=nil)
                    {
                        NSString *uidStr = [[NSString alloc] initWithFormat:@"%d",[[dic valueForKey:@"user"] valueForKey:@"id"]];
                        
                        [newManagedObject setValue:uidStr forKey:@"user"]; 
                    }
                    
                    else {
                        [newManagedObject setValue:[@"no value" valueForKey:@"id"] forKey:@"user"]; 
                    }
                    if([dic objectForKey:@"retweeted_status"] != nil)
                    {
                        //NSLog(@"%@",[[[dic objectForKey:@"retweeted_status"] objectForKey:@"user"] valueForKey:@"screen_name"]);
                        [newManagedObject setValue:[[[dic objectForKey:@"retweeted_status"] objectForKey:@"user"] valueForKey:@"screen_name"] forKey:@"repost_username"];
                        [newManagedObject setValue:[[dic objectForKey:@"retweeted_status"] valueForKey:@"text"] forKey:@"repost_text"];
                        [newManagedObject setValue:[[dic objectForKey:@"retweeted_status"] valueForKey:@"created_at"] forKey:@"repost_time"];
                    }
                    [newManagedObject setValue:[[dic objectForKey:@"user"] objectForKey:@"screen_name"] forKey:@"name"];
                    [newManagedObject setValue:@"sina" forKey:@"from"]; 
                    [newManagedObject setValue:@"total" forKey:@"type"]; 
                    // Save the context.
                    
                    if (![context save:&error]){
                        // Replace this implementation with code to handle the error appropriately.
                        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
                       // NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                        abort();
                        //             }
                    }
                    break;
                }
            case 3:
                {
                    NSManagedObjectContext *context = self.managedObjectContext;
                    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PersonWeibo" inManagedObjectContext:self.managedObjectContext];
                    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
                    // Edit the entity name as appropriate.
                    
                    [fetchRequest setEntity:entity];
                    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
                    
                    [dateFormatter1 setDateFormat: @"yyyy-MM-dd HH:mm:ss"]; 
                    
                    NSDate *destDate1= [dateFormatter1 dateFromString:[dic valueForKey:@"time"]];
                    
                    [dateFormatter1 release];
                    
                    // Set the batch size to a suitable number.
                    
                    /*--------------------------------------
                     它返回的是int，且是NSDemecalNumber指针类型
                     -------------------------------------*/
                    NSString *idstr = [[NSString alloc] initWithFormat:@"%@",[dic objectForKey:@"status_id"]];
                
                    //NSLog(@"状态ID %d",[dic valueForKey:@"status_id"]);
                    //   [self deleteRenrenAll];
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"from == 'renren' AND created_at == %@",destDate1];
                    [fetchRequest setPredicate:predicate];
                    
                    
                    int tem = [context countForFetchRequest:fetchRequest error:&error];
                    if(tem < 1){
                        
                        NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
                        
                        [newManagedObject setValue:[dic valueForKey:nil] forKey:@"bmiddle_pic"];
                        if(image != nil)
                        {
                            NSData *data1 = UIImageJPEGRepresentation(image, 1.0); 
                            
                            [newManagedObject setValue:data1 forKey:@"image"];
                        }
                        if(repostImage != nil){
                            NSData *data2 = UIImageJPEGRepresentation(repostImage, 1.0); 
                            [newManagedObject setValue:data2 forKey:@"repostImage"];
                        }
                        
                        
                        
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                        
                        [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"]; 
                        
                        NSDate *destDate= [dateFormatter dateFromString:[dic valueForKey:@"time"]];
                        
                        [dateFormatter release];
                        [newManagedObject setValue:destDate forKey:@"created_at"];
                        
                        
                        //[newManagedObject setValue:[dic objectForKey:@"name"] forKey:@"name"];
                        [newManagedObject setValue:[dic valueForKey:nil] forKey:@"geo"];
                        
                        [newManagedObject setValue:idstr forKey:@"id"];
                        //NSLog(@"保存的ID是%@",idstr);
                        [newManagedObject setValue:@"renren"  forKey:@"from"]; 
                        [newManagedObject setValue:@"person" forKey:@"type"]; 
                        [newManagedObject setValue:[dic valueForKey:nil] forKey:@"original_pic"]; 
                        [newManagedObject setValue:[dic valueForKey:@"source_url"] forKey:@"source"]; 
                        [newManagedObject setValue:[dic valueForKey:@"message"] forKey:@"text"]; 
                        [newManagedObject setValue:[dic valueForKey:nil] forKey:@"thumbnail_pic"];
                        /*--------------------------------------
                         它返回的是int，且是NSDemecalNumber指针类型
                         -------------------------------------*/
                        NSString *uidStr = [[NSString alloc] initWithFormat:@"%@",[dic objectForKey:@"uid"]];
                        //NSLog(@"用户ID %@",[dic objectForKey:@"uid"]);
                        [newManagedObject setValue:uidStr forKey:@"user"]; 
                        if([dic objectForKey:@"root_username"] != nil)
                        {
                            [newManagedObject setValue:[dic valueForKey:@"root_username"] forKey:@"repost_username"];
                            [newManagedObject setValue:[dic valueForKey:@"root_message"] forKey:@"repost_text"];
                            [newManagedObject setValue:[dic valueForKey:@"forward_message"] forKey:@"forward"];
                        }
                        // Save the context.
                        
                        if (![context save:&error]){
                            // Replace this implementation with code to handle the error appropriately.
                            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
                            //NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                            abort();
                        }
                    }
                    break;
                }
                
            case 4:
                {
                    NSManagedObjectContext *context = self.managedObjectContext;
                    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PersonWeibo" inManagedObjectContext:self.managedObjectContext];
                    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
                    // Edit the entity name as appropriate.
                    
                    [fetchRequest setEntity:entity];
                    
                    
                    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
                    
                    [dateFormatter1 setDateFormat: @"yyyy-MM-dd HH:mm:ss"]; 
                    
                    NSDate *destDate1= [dateFormatter1 dateFromString:[dic valueForKey:@"time"]];
                    
                    [dateFormatter1 release];
                    
                    // Set the batch size to a suitable number.
                    
                    NSString *idstr = [[NSString alloc] initWithFormat:@"%@",[dic objectForKey:@"status_id"]];
                    //   [self deleteRenrenAll];
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"from == 'renren' AND created_at == %@",destDate1];
                    [fetchRequest setPredicate:predicate];
                    
                    
                    
                    
                    int tem = [context countForFetchRequest:fetchRequest error:&error];
                    if(tem < 1){
                        
                        NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
                        if(image != nil)
                        {
                            NSData *data1 = UIImageJPEGRepresentation(image, 1.0); 
                            
                            [newManagedObject setValue:data1 forKey:@"image"];
                        }
                        if(repostImage != nil){
                            NSData *data2 = UIImageJPEGRepresentation(repostImage, 1.0); 
                            [newManagedObject setValue:data2 forKey:@"repostImage"];
                        }
                        
                        [newManagedObject setValue:[dic valueForKey:nil] forKey:@"bmiddle_pic"];
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                        
                        [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"]; 
                        
                        NSDate *destDate= [dateFormatter dateFromString:[dic valueForKey:@"time"]];
                        
                        [dateFormatter release];
                        [newManagedObject setValue:destDate forKey:@"created_at"];
                        
                        [newManagedObject setValue:[dic valueForKey:nil] forKey:@"geo"];
                        
                        [newManagedObject setValue:idstr forKey:@"id"]; 
                        [newManagedObject setValue:@"renren" forKey:@"from"]; 
                        [newManagedObject setValue:@"total" forKey:@"type"]; 
                        [newManagedObject setValue:[dic valueForKey:nil] forKey:@"original_pic"]; 
                        [newManagedObject setValue:[dic valueForKey:@"source_url"] forKey:@"source"]; 
                        [newManagedObject setValue:[dic valueForKey:@"message"] forKey:@"text"]; 
                        [newManagedObject setValue:[dic valueForKey:nil] forKey:@"thumbnail_pic"]; 
                        NSString *uidStr = [[NSString alloc] initWithFormat:@"%@",[dic objectForKey:@"uid"]];
                        
                        [newManagedObject setValue:uidStr forKey:@"user"];   
                        if([dic objectForKey:@"root_username"] != nil)
                        {
                            [newManagedObject setValue:[dic valueForKey:@"root_username"] forKey:@"repost_username"];
                            [newManagedObject setValue:[dic valueForKey:@"root_message"] forKey:@"repost_text"];
                            [newManagedObject setValue:[dic valueForKey:@"forward_message"] forKey:@"forward"];
                        }
                        
                        // Save the context.
                        
                        if (![context save:&error]){
                            // Replace this implementation with code to handle the error appropriately.
                            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
                           // NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                            abort();
                        }
                    }
                    break;
                }
                
            case 5:
                {
                    NSManagedObjectContext *context = self.managedObjectContext;
                    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PersonWeibo" inManagedObjectContext:self.managedObjectContext];
                    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
                    
                    [newManagedObject setValue:[dic valueForKey:@"picture"] forKey:@"bmiddle_pic"];
                    
                    [newManagedObject setValue:[NSDate date] forKey:@"created_at"];
                    [newManagedObject setValue:[dic valueForKey:@"idstr"] forKey:@"id"]; 
                    [newManagedObject setValue:@"zichuang" forKey:@"type"]; 
                    [newManagedObject setValue:[dic valueForKey:@"text"] forKey:@"text"]; 
                    
                    // Save the context.
                    
                    if (![context save:&error]){
                        // Replace this implementation with code to handle the error appropriately.
                        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
                        //NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                        abort();
                    }
                    
                    break;
                }
                
                
            default:break;
                
            }
                
        }
    }
}

#pragma mark 最近联系人
/*最近联系人*/
-(void)addRecentContacts:(NSMutableDictionary *)item
{
    NSError *error = nil;
    NSManagedObjectContext *context = self.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"RecentContacts" inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId == %@",[item valueForKey:@"userId"]];
    [fetchRequest setPredicate:predicate];
    
    NSArray *results = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    int tem = [context countForFetchRequest:fetchRequest error:&error];

    if(tem < 1){
        
        NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
        
        [newManagedObject setValue:[item valueForKey:@"userId"] forKey:@"userId"];
        [newManagedObject setValue:[item valueForKey:@"type"] forKey:@"type"];
        [newManagedObject setValue:[item valueForKey:@"imageUrl"] forKey:@"imageUrl"];
        [newManagedObject setValue:[item valueForKey:@"name"] forKey:@"name"];
        [newManagedObject setValue:[item valueForKey:@"times"] forKey:@"times"];
        // Save the context.
        if (![context save:&error]){
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            //NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    /*数据库已有的话，就更新它的times*/
    else {
        
    }
}
    
-(NSArray *)getRecentContacts
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"RecentContacts" inManagedObjectContext:self.managedObjectContext];
    //NSPredicate *predicate = [[NSPredicate alloc] init];
    NSArray *results = [[NSArray alloc] init];
        
    NSFetchRequest * fetch = [[NSFetchRequest alloc] init];
    //NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"created_at" ascending:NO];
    //NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    // [fetch setSortDescriptors:sortDescriptors];
    [fetch setEntity: entity];
    // [fetch setPredicate: predicate];
   
    results = [self.managedObjectContext executeFetchRequest:fetch error:nil];
    
    return results;
}



#pragma mark 评论吐槽
-(NSArray *)getCommentsWithID:(NSString *)ID
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Comments" inManagedObjectContext:self.managedObjectContext];
    NSArray *results = [[NSArray alloc] init];
    
    NSFetchRequest * fetch = [[NSFetchRequest alloc] init];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"created_at" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetch setSortDescriptors:sortDescriptors];
    [fetch setEntity: entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"weiboID == %@",ID];  [fetch setPredicate:predicate];
    results = [self.managedObjectContext executeFetchRequest:fetch error:nil];
    
    return results;     
}

- (void)addComments:(NSDictionary *)dic withType:(int)type andWeiboID:(NSString *)weiboID andImage:(UIImage *)image
{
    NSError *error = nil;
    if(dic != nil)
    {
        switch(type){
                //新浪评论
            case 1:
            {
                NSManagedObjectContext *context = self.managedObjectContext;
                NSEntityDescription *entity = [NSEntityDescription entityForName:@"Comments" inManagedObjectContext:self.managedObjectContext];
                
                NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
                // Edit the entity name as appropriate.
                [fetchRequest setEntity:entity];
                
                // Set the batch size to a suitable number.
                
                
                // Edit the sort key as appropriate.
                
                //NSLog(@"%@",[dic valueForKey:@"id"]);
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"from == 'sina' AND id == %@",[dic valueForKey:@"idstr"]];
                [fetchRequest setPredicate:predicate];
                
                int tem = [context countForFetchRequest:fetchRequest error:&error];
                if(tem < 1){
                    
                    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
                    
                    // [newManagedObject setValue:[dic valueForKey:@"id"] forKey:@"id"];
                    
                    
                    
                    NSString* dateStr =[dic valueForKey:@"created_at"];
                    
                    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
                    
                    NSLocale* local =[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]  autorelease];
                    [formater setLocale: local];
                    [formater setDateFormat:@"EEE MMM d HH:mm:ss zzzz yyyy"];
                    NSDate* date = [formater dateFromString:dateStr];
                    
                    [newManagedObject setValue:date forKey:@"created_at"];
                    
                    if ([dic valueForKey:@"idstr"] != nil) {
                        [newManagedObject setValue:[dic valueForKey:@"idstr"] forKey:@"id"];
                    }
                    else {
                        [newManagedObject setValue:@"no value" forKey:@"id"];
                    }
                    if ([dic valueForKey:@"text"]!=nil) {
                        
                        [newManagedObject setValue:[dic valueForKey:@"text"] forKey:@"text"];
                    }
                    else {
                        [newManagedObject setValue:@"no value" forKey:@"text"];
                    }
                    if([[dic valueForKey:@"user"] valueForKey:@"idstr"] !=nil)
                    {
                        NSString *uidStr = [[NSString alloc] initWithFormat:@"%d",[[dic valueForKey:@"user"] valueForKey:@"id"]];
                        
                        [newManagedObject setValue:uidStr forKey:@"user"];
                    }
                    else {
                        [newManagedObject setValue:[@"no value" valueForKey:@"id"] forKey:@"user"];
                    }
                    [newManagedObject setValue:[[dic valueForKey:@"user"] valueForKey:@"screen_name"] forKey:@"name"];
                    
                    NSData *imageData = UIImagePNGRepresentation(image);
                    if(imageData == nil)
                    imageData = UIImageJPEGRepresentation(image, 1.0);
                    [newManagedObject setValue:imageData forKey:@"headPicture"];
                    [newManagedObject setValue:@"sina" forKey:@"from"];
                    [newManagedObject setValue:@"comment" forKey:@"type"];
                    [newManagedObject setValue:weiboID forKey:@"weiboID"];
                    
                    // Save the context.
                    
                    if (![context save:&error]){
                        // Replace this implementation with code to handle the error appropriately.
                        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                       //NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                        abort();
                    }
                }
                break;
            }
                
            case 2:
            {
                NSManagedObjectContext *context = self.managedObjectContext;
                NSEntityDescription *entity = [NSEntityDescription entityForName:@"Comments" inManagedObjectContext:self.managedObjectContext];
                
                NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
                // Edit the entity name as appropriate.
                [fetchRequest setEntity:entity];
                
                // Set the batch size to a suitable number.
                
                
                // Edit the sort key as appropriate.
                
                NSString *comment_Id=[[NSString alloc] initWithFormat:@"%@",[dic valueForKey:@"comment_id"]];
                NSString *user_Id=[[NSString alloc] initWithFormat:@"%@",[dic valueForKey:@"uid"]];
                
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"from == 'renren' AND id == %@",comment_Id];
                [fetchRequest setPredicate:predicate];
                
                int tem = [context countForFetchRequest:fetchRequest error:&error];
                if(tem < 1){
                    
                    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
                    
                    // [newManagedObject setValue:[dic valueForKey:@"id"] forKey:@"id"];
                    
                    
                    
                    NSString* dateStr =[dic valueForKey:@"time"];
                    
                    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
                    
                    NSLocale* local =[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]  autorelease];
                    [formater setLocale: local];
                    [formater setDateFormat:@"EEE MMM d HH:mm:ss zzzz yyyy"];
                    NSDate* date = [formater dateFromString:dateStr];
                    
                    [newManagedObject setValue:date forKey:@"created_at"];
                    
                    if ([dic valueForKey:@"comment_id"] != nil) {
                        [newManagedObject setValue:comment_Id forKey:@"id"];
                    }
                    else {
                        [newManagedObject setValue:@"no value" forKey:@"id"];
                    }
                    if ([dic valueForKey:@"text"]!=nil) {
                        
                        [newManagedObject setValue:[dic valueForKey:@"text"] forKey:@"text"];
                    }
                    else {
                        [newManagedObject setValue:@"no value" forKey:@"text"];
                    }
                    if( user_Id!=nil)
                    {
                        
                        [newManagedObject setValue:user_Id forKey:@"user"];
                    }
                    else {
                        [newManagedObject setValue:[@"no value" valueForKey:@"id"] forKey:@"user"];
                    }
                    [newManagedObject setValue:[dic valueForKey:@"name"] forKey:@"name"];
                    
                    NSData *imageData = UIImagePNGRepresentation(image);
                    if(imageData == nil)
                        imageData = UIImageJPEGRepresentation(image, 1.0);
                    [newManagedObject setValue:imageData forKey:@"headPicture"];
                    [newManagedObject setValue:@"renren" forKey:@"from"];
                    [newManagedObject setValue:@"comment" forKey:@"type"];
                    [newManagedObject setValue:weiboID forKey:@"weiboID"];
                    
                    // Save the context.
                    
                    if (![context save:&error]){
                        // Replace this implementation with code to handle the error appropriately.
                        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                        //NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                        abort();
                    }
                }
                break;
            }
            case 3:
            {
                NSManagedObjectContext *context = self.managedObjectContext;
                NSEntityDescription *entity = [NSEntityDescription entityForName:@"Comments" inManagedObjectContext:self.managedObjectContext];
                
                NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
                // Edit the entity name as appropriate.
                [fetchRequest setEntity:entity];
                
                // Set the batch size to a suitable number.
                
                
                // Edit the sort key as appropriate.
                NSString *idStr = [[NSString alloc] initWithFormat:@"%d",[dic valueForKey:@"comment_id"]];
                //NSLog(@"%@",[dic valueForKey:@"id"]);
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"from == 'renren' AND id == %@",idStr];
                [fetchRequest setPredicate:predicate];
                
                int tem = [context countForFetchRequest:fetchRequest error:&error];
                if(tem < 1){
                    
                    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
                    
                    NSString* dateStr =[dic valueForKey:@"time"];
                    
                    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
                    
                    
                    
                    NSLocale* local =[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]  autorelease];
                    [formater setLocale: local];
                    [formater setDateFormat:@"EEE MMM d HH:mm:ss zzzz yyyy"];
                    NSDate* date = [formater dateFromString:dateStr];
                    
                    [newManagedObject setValue:date forKey:@"created_at"];
                    
                    
                    
                    
                    [newManagedObject setValue:idStr forKey:@"id"];
                    
                    if ([dic valueForKey:@"text"]!=nil) {
                        
                        [newManagedObject setValue:[dic valueForKey:@"text"] forKey:@"text"];
                    }
                    else {
                        [newManagedObject setValue:@"no value" forKey:@"text"];
                    }
                    NSString *uidStr = [[NSString alloc] initWithFormat:@"%d",[dic valueForKey:@"uid"]];
                    
                    [newManagedObject setValue:uidStr forKey:@"user"];
                    
                    [newManagedObject setValue:[dic valueForKey:@"tinyurl"] forKey:@"headPicture"];
                    [newManagedObject setValue:[dic valueForKey:@"name"] forKey:@"name"];
                    [newManagedObject setValue:@"renren" forKey:@"from"];
                    [newManagedObject setValue:@"comment" forKey:@"type"];
                    [newManagedObject setValue:weiboID forKey:@"weiboID"];
                    
                    
                    
                    
                    
                    // Save the context.
                    
                    if (![context save:&error]){
                        // Replace this implementation with code to handle the error appropriately.
                        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                        //NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                        abort();
                    }
                }
                break;
            }
                
                
                
            default:break;
                
        }
    }
}
-(void)deleteCommentWithID:(NSString *)ID
{
    NSManagedObjectContext *context = self.managedObjectContext;
    NSFetchRequest * fetch = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Comments" inManagedObjectContext:self.managedObjectContext];
    [fetch setEntity: entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %@",ID];
    [fetch setPredicate:predicate];
    
    NSArray *results = [self.managedObjectContext executeFetchRequest:fetch error:nil];
    
        NSManagedObject *eventToDelete = [results objectAtIndex:0];
        [context deleteObject:eventToDelete];
    
    NSError *error = nil;if (![context save:&error]) {
        //NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    /*漏了保存*/
    [self.managedObjectContext save:nil];
}

- (void)deleteCommentWithWeiboID:(NSString *)ID
{
    NSManagedObjectContext *context = self.managedObjectContext;
    NSFetchRequest * fetch = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Comments" inManagedObjectContext:self.managedObjectContext];
    [fetch setEntity: entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"weiboID == %@",ID];
    [fetch setPredicate:predicate];
    
    NSArray *results = [self.managedObjectContext executeFetchRequest:fetch error:nil];
    
    for (int i=0; i<[results count]; i++) {
        NSManagedObject *eventToDelete = [results objectAtIndex:i];
        [context deleteObject:eventToDelete];
    }
    
    NSError *error = nil;if (![context save:&error]) {
        //NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    /*漏了保存*/
    [self.managedObjectContext save:nil];

}
-(void)deleteAllComment
{
    NSManagedObjectContext *context = self.managedObjectContext;
    NSFetchRequest * fetch = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Comments" inManagedObjectContext:self.managedObjectContext];
    [fetch setEntity: entity];
    
    NSArray *results = [self.managedObjectContext executeFetchRequest:fetch error:nil];
    
    if([results count]!=0)
    {
        for(NSManagedObject *eventToDelete in results)
            [context deleteObject:eventToDelete];
    }
        
    NSError *error = nil;if (![context save:&error])
    {
        //NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    /*漏了保存*/
    [self.managedObjectContext save:nil];

}
#pragma mark 长微博
-(void)addLong:(NSData *)data andAbstract:(NSData *)aData
{
    NSError *error = nil;
    NSManagedObjectContext *context = self.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Longs" inManagedObjectContext:self.managedObjectContext];
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    [newManagedObject setValue:data forKey:@"longWeibo"];
    [newManagedObject setValue:aData forKey:@"abstract"];
    
    // Save the context.
    
    if (![context save:&error]){
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
       // NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    NSArray *results = [[NSArray alloc] init];
    
    NSFetchRequest * fetch = [[NSFetchRequest alloc] init];
    //NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"created_at" ascending:NO];
    //NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    // [fetch setSortDescriptors:sortDescriptors];
    [fetch setEntity: entity];
    // [fetch setPredicate: predicate];
    
    results = [self.managedObjectContext executeFetchRequest:fetch error:nil];
    //NSLog(@"Now has %d results.",[results count]);
    //NSLog(@"Add one picture.");
}



-(NSArray *)getLong
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Longs" inManagedObjectContext:self.managedObjectContext];
    //NSPredicate *predicate = [[NSPredicate alloc] init];
    NSArray *results = [[NSArray alloc] init];
    
    NSFetchRequest * fetch = [[NSFetchRequest alloc] init];
    //NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"created_at" ascending:NO];
    //NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    // [fetch setSortDescriptors:sortDescriptors];
    [fetch setEntity: entity];
    // [fetch setPredicate: predicate];
    
    results = [self.managedObjectContext executeFetchRequest:fetch error:nil];
    //NSLog(@"Now has %d results.",[results count]);
    return results;
}

-(void)deleteALong:(int)index
{
    NSManagedObjectContext *context = self.managedObjectContext;
    NSFetchRequest * fetch = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Longs" inManagedObjectContext:self.managedObjectContext];
    [fetch setEntity: entity];
    NSArray *results = [self.managedObjectContext executeFetchRequest:fetch error:nil];
    NSManagedObject *eventToDelete = [results objectAtIndex:index];
    [context deleteObject:eventToDelete];
    NSError *error = nil;if (![context save:&error]) {
        //NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
}
@end
