//
//  NSBubbleDataInternal.h
//
//  Created by yanyu
//

#import <Foundation/Foundation.h>

@class NSBubbleData;

@interface NSBubbleDataInternal : NSObject

@property (nonatomic, strong) NSBubbleData* data;

@property (nonatomic) BOOL shouldTucaoShow;  //判断吐槽框是否已经在

@property (nonatomic) float height;   //一个cell的高度

@property (nonatomic) CGSize labelSize;  //cell内本微博文的size
@property (nonatomic) CGSize originLabelSize;
@property (nonatomic) CGSize barButtonSize;

@property (nonatomic) CGSize commentsSize;
@property (nonatomic) CGSize tucaoSize; //吐槽是自己的，comment是别人的评论

@end
