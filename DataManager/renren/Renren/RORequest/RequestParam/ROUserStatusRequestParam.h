//
//  ROUserStatusRequestParam.h
//  RenrenSDKDemo
//
//  Created by 01 developer on 12-10-31.
//  Copyright (c) 2012年 Sun Yat-sen University. All rights reserved.
//

#import "RORequestParam.h"

@interface ROUserStatusRequestParam : RORequestParam{
    NSString *page;
	NSString *count;
    NSString *uid;
}

/**
 *分页的页数
 */
@property (copy,nonatomic)NSString *page;

/**
 *分页后每页的个数
 */
@property (copy,nonatomic)NSString *count;

/**
 *查询用户的id
 */
@property (copy,nonatomic)NSString *uid;


@end
