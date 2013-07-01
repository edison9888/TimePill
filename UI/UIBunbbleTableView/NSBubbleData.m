//
//  NSBubbleData.m
//
//  Created by yanyu
//

#import "NSBubbleData.h"

@implementation NSBubbleData

@synthesize headImage = _headImage;
@synthesize weiboName = _weiboName;
@synthesize text = _text;
@synthesize text_image = _text_image;
@synthesize origin_text = _origin_text;
@synthesize origin_text_image = _origin_text_image;
@synthesize date = _date;
@synthesize from = _from;
@synthesize type = _type;
@synthesize comments = _comments;
@synthesize tucao = _tucao;

+ (id)dataWithHeadImage:(UIImage *)headImage andName:(NSString *)name andText:(NSString *)text andTextImage:(UIImage *)textImage andOriginText:(NSString *)originText andOriginTextImage:(UIImage *)originTextImage andDate:(NSDate *)date andFrom:(NSString *)from andType:(NSBubbleType)type andComments:(NSArray *)comments andTucao:(NSDictionary *)tucao{
    
    return [[[NSBubbleData alloc] initWithHeadImage:headImage andName:name andText:text andTextImage:textImage andOriginText:originText andOriginTextImage:originTextImage andDate:date andFrom:from andType:type andComments:comments andTucao:tucao] autorelease];
}

- (id)initWithHeadImage:(UIImage *)headImage andName:(NSString *)name andText:(NSString *)text andTextImage:(UIImage *)textImage andOriginText:(NSString *)originText andOriginTextImage:(UIImage *)originTextImage andDate:(NSDate *)date andFrom:(NSString *)from andType:(NSBubbleType)type andComments:(NSArray *)comments andTucao:(NSDictionary *)tucao{
    self = [super init];
    if(self){
        //consider it is nil type
        _headImage = [headImage retain];
        _weiboName = [name retain];
        _text = [text retain];
        _text_image = [textImage retain];
        _origin_text = [originText retain];
        _origin_text_image = [originTextImage retain];
        _date = [date retain];
        _from = from;
        _type = type;
        _comments = [comments retain];
        _tucao = [tucao retain];
    }
    return self;
}

- (void)dealloc
{
    [_date release];
	_date = nil;
    [_headImage release];
    _headImage = nil;
    [_weiboName release];
    _weiboName = nil;
	[_text release];
	_text = nil;
    [_text_image release];
    _text_image = nil;
    [_origin_text release];
    _origin_text = nil;
    [_origin_text_image release];
    _origin_text_image = nil;
    [_from release];
    _from = nil;
    [_comments release];
    _comments = nil;
    [super dealloc];
}

@end
