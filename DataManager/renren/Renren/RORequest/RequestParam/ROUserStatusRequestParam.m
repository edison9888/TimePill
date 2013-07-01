//
//  ROUserStatusRequestParam.m
//  RenrenSDKDemo
//
//  Created by 01 developer on 12-10-31.
//  Copyright (c) 2012年 Sun Yat-sen University. All rights reserved.
//

#import "ROUserStatusRequestParam.h"

@implementation ROUserStatusRequestParam
@synthesize page,count,uid;

-(id)init
{
	if (self = [super init]) {
		self.method = [NSString stringWithFormat:@"status.gets"];
		self.page = [NSString stringWithFormat:@"1"];
		self.count = [NSString stringWithFormat:@"10"];
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
    
    if (self.uid != nil && ![self.uid isEqualToString:@""]) {
		[dictionary setObject:self.uid forKey:@"uid"];
	}
}

-(ROResponse*)requestResultToResponse:(id)result
{
	id responseObject = nil;
	if ([result isKindOfClass:[NSArray class]]) {
        responseObject = [[[NSMutableArray alloc] init] autorelease];
		
		for (NSDictionary *item in result) {
			ROFriendResponseItem *responseItem = [[[ROFriendResponseItem alloc] initWithDictionary:item] autorelease];
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
    self.uid = nil;
	[super dealloc];
}

@end
