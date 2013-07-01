//
//  NSBubbleData.h
//
//  Created by yanyu
//

#import <Foundation/Foundation.h>

typedef enum _NSBubbleType  //标记该记录的属性
{
    BubbleTypeMineInHomePage = 0,
    BubbleTypeSomeoneElse = 1
} NSBubbleType;

@interface NSBubbleData : NSObject

@property (readonly, nonatomic, strong) UIImage *headImage; //微博头像
@property (readonly, nonatomic, strong) NSString *weiboName; //微博名字
@property (readonly, nonatomic, strong) NSString *text;  //转发文本
@property (nonatomic, strong) UIImage *text_image; // 转发图片
@property (readonly, nonatomic, strong) NSString *origin_text; //原微博的文本
@property (nonatomic, strong) UIImage *origin_text_image; //原微博的图片
@property (readonly, nonatomic, strong) NSDate *date;  //该状态的时间标签
@property (readonly, nonatomic,strong) NSString *from; //是新浪还是人人
@property (readonly, nonatomic) NSBubbleType type;  // 标记是自己的还是好友的
@property (nonatomic, strong) NSArray *comments;   //评论
@property (nonatomic, strong) NSDictionary *tucao;  //吐槽

- (id)initWithHeadImage:(UIImage *)headImage andName:(NSString *)name andText:(NSString *)text andTextImage:(UIImage *)textImage andOriginText:(NSString *)originText andOriginTextImage:(UIImage *)originTextImage andDate:(NSDate *)date andFrom:(NSString *)from andType:(NSBubbleType)type andComments:(NSArray *)comments andTucao:(NSDictionary *)tucao;


+ (id)dataWithHeadImage:(UIImage *)headImage andName:(NSString *)name andText:(NSString *)text andTextImage:(UIImage *)textImage andOriginText:(NSString *)originText andOriginTextImage:(UIImage *)originTextImage andDate:(NSDate *)date andFrom:(NSString *)from andType:(NSBubbleType)type andComments:(NSArray *)comments andTucao:(NSDictionary *)tucao;

@end
