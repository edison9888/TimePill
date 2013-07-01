//
//  ImageDownloader.h
//  Timeline
//
//  Created by simon on 12-12-15.
//  Copyright (c) 2012年 Sun Yat-sen University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DisplayTableView.h"
#import "DisplayCell.h"

@protocol imageDownloaderDelegate;

@interface ImageDownloader : NSOperation 
{
    NSURLRequest* _request;
    
    NSURLConnection* _connection;
    
    NSMutableData* _data;
    
    BOOL _isFinished; 
    
    id<imageDownloaderDelegate> delegate;
    
    NSObject *delPara;
}

- (id)initWithURLString:(NSString *)url;

@property (readonly) NSData *data;
@property(nonatomic, retain) id<imageDownloaderDelegate> delegate;
@property(nonatomic, retain) NSObject *delPara;
@property(nonatomic, assign) Boolean isRepost;

/*在线程内reloadTableView*/
@property(atomic, retain) DisplayTableView *displayTable;
@property(atomic, retain) NSMutableDictionary *imageCache;
@property(atomic, retain) NSMutableDictionary *repostImageCache;

@end

@protocol imageDownloaderDelegate

@optional

//图片下载完成的委托
- (void)imageDidFinished:(UIImage *)image para:(NSObject *)obj isRepost:(Boolean)isRepost;

@end
