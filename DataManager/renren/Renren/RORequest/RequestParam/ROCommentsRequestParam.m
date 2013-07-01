//
//  ROCommentsRequestParam.m
//  Timeline
//
//  Created by simon on 12-11-30.
//  Copyright (c) 2012年 Sun Yat-sen University. All rights reserved.
//

#import "ROCommentsRequestParam.h"

@implementation ROCommentsRequestParam
@synthesize page,count,owner_id,status_id;

-(id)init
{
	if (self = [super init]) {
		self.method = [NSString stringWithFormat:@"status.getComment"];
		self.page = [NSString stringWithFormat:@"1"];
		self.count = [NSString stringWithFormat:@"50"];
	}
	
	return self;
}

-(void)addParamToDictionary:(NSMutableDictionary*)dictionary
{
	if (dictionary == nil) {
		return;
	}
	
	if (self.count != nil && ![self.count isEqualToString:@""]) {
		[dictionary setObject:self.count forKey:@"count"];
	}
	
	if (self.page != nil && ![self.page isEqualToString:@""]) {
		[dictionary setObject:self.page forKey:@"page"];
	}
    if (self.owner_id != nil && ![self.owner_id isEqualToString:@""]) {
		[dictionary setObject:self.owner_id forKey:@"owner_id"];
	}
	
	if (self.status_id != nil && ![self.status_id isEqualToString:@""]) {
		[dictionary setObject:self.status_id forKey:@"status_id"];
	}
    
}

-(ROResponse*)requestResultToResponse:(id)result
{
	id responseObject = nil;
	if ([result isKindOfClass:[NSArray class]]) {
        responseObject = [[NSMutableArray alloc] init];
		
		for (NSDictionary *item in result) {
			ROFriendResponseItem *responseItem = [[ROFriendResponseItem alloc] initWithDictionary:item] ;
			[(NSMutableArray*)responseObject addObject:responseItem];
		}
		
		return [ROResponse responseWithRootObject:responseObject];
	} else {
		if ([result objectForKey:@"error_code"] != nil) {
			responseObject = [ROError errorWithRestInfo:result];
			return [ROResponse responseWithError:responseObject];
		}
		
		return [ROResponse responseWithRootObject:responseObject];
	}
}

-(void)dealloc
{
	self.page = nil;
	self.count = nil;
}

@end
