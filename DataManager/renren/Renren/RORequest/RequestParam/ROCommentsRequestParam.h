//
//  ROCommentsRequestParam.h
//  Timeline
//
//  Created by simon on 12-11-30.
//  Copyright (c) 2012年 Sun Yat-sen University. All rights reserved.
//

#import "RORequestParam.h"

@interface ROCommentsRequestParam : RORequestParam
{
    NSString *page;
	NSString *count;
    NSString *status_id;  //状态id
    NSString *owner_id;  //该状态的主人id
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
@property (copy,nonatomic)NSString *status_id;
@property (copy,nonatomic)NSString *owner_id;
@end
