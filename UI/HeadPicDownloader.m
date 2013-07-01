//
//  HeadPicDownloader.m
//  Timeline
//
//  Created by simon on 13-3-2.
//  Copyright (c) 2013年 Sun Yat-sen University. All rights reserved.
//

#import "HeadPicDownloader.h"

@implementation HeadPicDownloader

@synthesize data=_data;
@synthesize delegate;
@synthesize indexpath;

- (id)initWithURLString:(NSString *)url
{
      
    self = [self init];
    if (self) {
        
        _request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
        
        _data = [NSMutableData data];
        
    }
    
    return self;
    
}

// 开始处理-本类的主方法

- (void)start {
 // NSLog(@"receive");
    if (![self isCancelled]) {
        
        [NSThread sleepForTimeInterval:0];
        // 以异步方式处理事件，并设置代理
        
        _connection=[NSURLConnection connectionWithRequest:_request delegate:self];
        
        while(_connection != nil) {
            
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            
        }
        
    }
    
}
#pragma mark NSURLConnection delegate Method

// 接收到数据（增量）时

- (void)connection:(NSURLConnection*)connection

    didReceiveData:(NSData*)data
{
    
    // 添加数据
    [_data appendData:data];
    
}

- (void)connectionDidFinishLoading:(NSURLConnection*)connection {
    
    _connection=nil;
    
    UIImage *img = [[UIImage alloc] initWithData:self.data];
    
    [self imageDidFinished:img];
    
}

/*成功后更新tableview*/
- (void)imageDidFinished:(UIImage *)image
{
    [delegate imageDidFinished:image para:indexpath];
}

-(void)connection: (NSURLConnection *) connection didFailWithError: (NSError *) error
{
    _connection=nil;
}

-(BOOL)isConcurrent
{
    //返回yes表示支持异步调用，否则为支持同步调用
    return YES;
    
}
- (BOOL)isExecuting
{
    return _connection == nil;
}
- (BOOL)isFinished
{
    return _connection == nil;
}
@end
