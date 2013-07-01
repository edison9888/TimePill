//
//  HeadPicDownloader.h
//  Timeline
//
//  Created by simon on 13-3-2.
//  Copyright (c) 2013年 Sun Yat-sen University. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol imageDownloaderDelegate;

@interface HeadPicDownloader : NSOperation
{
    NSURLRequest* _request;
    
    NSURLConnection* _connection;
    
    NSMutableData* _data;
    
    BOOL _isFinished;
    
    id<imageDownloaderDelegate> delegate;
    
    NSIndexPath *indexpath;
}

- (id)initWithURLString:(NSString *)url;

@property (readonly) NSData *data;
@property(nonatomic, retain) id<imageDownloaderDelegate> delegate;
@property(nonatomic, retain) NSIndexPath *indexpath;

@end

@protocol imageDownloaderDelegate

@optional

//图片下载完成的委托
- (void)imageDidFinished:(UIImage *)image para:(NSIndexPath *)indexpath;

@end
