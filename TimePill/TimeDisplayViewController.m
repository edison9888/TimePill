//
//  TimeDisplayViewController.m
//  Timeline
//
//  Created by simon on 12-12-21.
//  Copyright (c) 2012年 Sun Yat-sen University. All rights reserved.
//

#import "TimeDisplayViewController.h"


@interface TimeDisplayViewController ()<UITableViewDataSource,UITableViewDelegate,DisPlayDataSource,imageDownloaderDelegate,PMCalendarControllerDelegate,NSURLConnectionDataDelegate,BigImageViewDelegate>

{
    Boolean isFirstLoad;
    int page;
    
    /*TableView的数据*/
    CGSize textSize1;  //原文
    CGSize textSize2;  //转发
    CGSize imageSize1;  //原图
    CGSize imageSize2;  //转发的图
    NSMutableDictionary *imageCache;
    NSMutableDictionary *repostImageCache;
    
    /*选中的数据*/
    NSMutableArray *returnData;
    /*真值表*/
    NSMutableArray *tagList;
    
    /*当前选择的是哪个日历*/
    int whichCalendar;
}
@end

@implementation TimeDisplayViewController
@synthesize type,userId,tableView,start,end,queue,searchBackground,pmCC,startButton,endButton;


- (void)viewDidLoad
{
    [super viewDidLoad];
	[self initNavigationBar];
    [self initTableView];
    [self initData];
    [self initNotification];
    [self initToolBar];
    [self initSearchBar];
    [self enableRefresh:NO];
    
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIView animateWithDuration:0.2f animations:^(void){
        self.searchBackground.frame=CGRectMake(0, self.view.bounds.size.height-39, 320, 39);
    }];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.searchBackground.frame=CGRectMake(320, self.view.bounds.size.height-39, 320, 39);
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [SVProgressHUD dismiss];
}
-(void)initData
{
    NSLog(@"type=%@,userId=%@",type,userId);
    page=1;
    isFirstLoad=YES;
    self.listData=[[NSMutableArray alloc] init];
    returnData=[[NSMutableArray alloc] init];
    tagList=[[NSMutableArray alloc] init];
    self.queue = [[NSOperationQueue alloc] init];
    imageCache=[[NSMutableDictionary alloc] init];
    repostImageCache=[[NSMutableDictionary alloc] init];

}

-(void)initNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weiboWithTimeInterval:) name:@"weiboWithTimeInterval" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusWithTimeInterval:) name:@"statusWithTimeInterval" object:nil];
}

#pragma mark 通知处理
-(void)weiboWithTimeInterval:(NSNotification *)note
{
    [self enableRefresh:NO];
    [self.listData addObjectsFromArray:note.object];
    NSLog(@"微博%d",[self.listData count]);
    /*构建真值表*/
    for(int i=0;i<[self.listData count];i++)
    {
        /*全部设为no*/
        [tagList addObject:[NSNumber numberWithBool:NO]];
    }
    [tableView reloadData];
    [self.queue cancelAllOperations];
    [SVProgressHUD dismiss];
}

-(void)statusWithTimeInterval:(NSNotification *)note
{
    [self enableRefresh:NO];
    [self.listData addObjectsFromArray:note.object];
    NSLog(@"人人%d",[self.listData count]);
    /*构建真值表*/
    for(int i=0;i<[self.listData count];i++)
    {
        /*全部设为no*/
        [tagList addObject:[NSNumber numberWithBool:NO]];
    }
    [tableView reloadData];
    [self.queue cancelAllOperations];
    [SVProgressHUD dismiss];
}

-(void)enableRefresh:(Boolean)Bool
{
    tableView.canLoadMore=Bool;
    tableView.pullToRefreshEnabled=Bool;
}
#pragma mark - Standard TableView delegates
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listData.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([tableView isEqual:self.tableView])
    {
        static NSString *CellIdentifier = @"DisplayCell";
        //NSLog(@"cell %d",[indexPath row]);
        
        DisplayCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[DisplayCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
        }
        
        NSString *content;  // 文本内容
        UIFont *font1 = [UIFont systemFontOfSize:16.0];
        UIFont *font2 = [UIFont systemFontOfSize:15.0];
        
        /*-----------------------------
         新浪
         -----------------------------*/
        if([type isEqualToString:@"sina"])
        {
            /*-----------------------------
             原文本
             -----------------------------*/
            content=[[self.listData objectAtIndex:indexPath.row] objectForKey:@"text"];
            textSize1 = [content sizeWithFont:font1 constrainedToSize:CGSizeMake(270, 1000.0f) lineBreakMode:UILineBreakModeWordWrap];
            
            cell.textView.text=content;
            cell.textView.frame=CGRectMake(cell.textView.frame.origin.x, cell.textView.frame.origin.y, cell.textView.frame.size.width, textSize1.height);        //更新它的frame
            
            /*-----------------------------
             原图
             -----------------------------*/
            NSURL *url=[NSURL URLWithString:[[self.listData objectAtIndex:[indexPath row]] valueForKey:@"thumbnail_pic"]];
            if(url==nil)
            {
                imageSize1=CGSizeZero;
                cell.imageView.image=nil;
                
                /*-----------------------------
                 没有原图-->处理转发部分
                 -----------------------------*/
                NSDictionary *retweeted=[[self.listData objectAtIndex:indexPath.row] objectForKey:@"retweeted_status"];
                /*有转发*/
                if(retweeted != nil)
                {
                    UIImage *repostBackgroundImage=[[UIImage imageNamed:@"zhuanfakuang.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:20];
                    
                    /*转发者*/
                    NSString *name=[[retweeted objectForKey:@"user"] objectForKey:@"screen_name"];
                    cell.repostName.text=[NSString stringWithFormat:@"%@:",name];
                    cell.repostName.font=[UIFont systemFontOfSize:15.0];
                    
                    content=[retweeted objectForKey:@"text"];
                    textSize2=[content sizeWithFont:font2 constrainedToSize:CGSizeMake(250, 1000.0f) lineBreakMode:UILineBreakModeWordWrap];
                    
                    /*转发文本*/
                    cell.repostView.frame=CGRectMake(50, textSize1.height+imageSize1.height+30+24, 250, textSize2.height);
                    cell.repostName.frame=CGRectMake(50, textSize1.height+imageSize1.height+30, 250, 15);
                    
                    cell.repostView.text=content;
                    cell.repostView.backgroundColor=[UIColor clearColor];
                    
                    /*转发图片*/
                    url=[NSURL URLWithString:[retweeted valueForKey:@"thumbnail_pic"]];
                    if(url==nil)
                    {
                        imageSize2=CGSizeZero;
                        cell.repostImage.image=nil;
                        cell.repostImage.userInteractionEnabled=NO;
                        
                    }
                    else {
                        UIImage *image=[repostImageCache objectForKey:indexPath];
                        //NSLog(@"转发图=%@",image);
                        if(image==nil) /*缓存没有，异步加载*/
                        {
                            //NSLog(@"cell %d",[indexPath row]);
                            cell.repostImage.image=[UIImage imageNamed:@"picLoading2.png"];
                            ImageDownloader *downloader = [[ImageDownloader alloc] initWithURLString:[retweeted valueForKey:@"thumbnail_pic"]];
                            downloader.delegate = self;
                            downloader.delPara = indexPath;
                            downloader.isRepost=YES;
                            downloader.displayTable=self.tableView;
                            downloader.imageCache=imageCache;
                            downloader.repostImageCache=repostImageCache;
                            [self.queue addOperation:downloader];
                            
                            imageSize2=CGSizeMake(100, 100);
                            
                        }
                        else { /*从缓存取*/
                            imageSize2=CGSizeMake(100, 100);
                            cell.repostImage.image =image;
                        }
                        cell.repostImage.frame=CGRectMake(cell.textView.frame.origin.x+10, textSize1.height+textSize2.height+34+30, imageSize2.width, imageSize2.height);
                        
                        /*点击事件*/
                        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(UesrClicked:)];
                        [cell.repostImage addGestureRecognizer:singleTap];
                        cell.repostImage.userInteractionEnabled=YES;
                        cell.repostImage.tag=[indexPath row];
                        
                    }
                    /*设置背景色块的frame*/
                    cell.repostBackgroundView.frame=CGRectMake(40, textSize1.height+12, 270, textSize2.height+imageSize2.height+34+20+8);
                    [cell.repostBackgroundView setImage:repostBackgroundImage];
                    
                    cell.timeLabel.frame=CGRectMake(40, cell.textView.frame.origin.y+textSize1.height+5+cell.repostBackgroundView.frame.size.height, 300, 20);
                    NSDate *date=[self fdateFromString:[[self.listData objectAtIndex:[indexPath row]] objectForKey:@"created_at"]];
                    cell.timeLabel.text=[[date description] substringToIndex:16];
                    
                }
                /*没有转发*/
                else {
                    cell.repostView.text=nil;
                    cell.repostImage.image=nil;
                    cell.repostName.text=nil;
                    cell.repostBackgroundView.image=nil;
                    cell.repostImage.userInteractionEnabled=NO;
                    cell.imageView.userInteractionEnabled=NO;
                    
                    cell.timeLabel.frame=CGRectMake(40, cell.textView.frame.origin.y+textSize1.height+5, 300, 20);
                    NSDate *date=[self fdateFromString:[[self.listData objectAtIndex:[indexPath row]] objectForKey:@"created_at"]];
                    cell.timeLabel.text=[[date description] substringToIndex:16];
                }
                
            }
            else {
                /*有原图*/
                UIImage *image=[imageCache objectForKey:indexPath];
                //NSLog(@"原图=%@",image);
                if(image==nil)  /*缓存没有，异步加载*/
                {
                    cell.imageView.image=[UIImage imageNamed:@"picLoading2.png"];
                    ImageDownloader *downloader = [[ImageDownloader alloc] initWithURLString:[[self.listData objectAtIndex:[indexPath row]] valueForKey:@"thumbnail_pic"]];
                    downloader.delegate = self;
                    downloader.delPara = indexPath;
                    downloader.isRepost=NO;
                    downloader.displayTable=self.tableView;
                    downloader.imageCache=imageCache;
                    downloader.repostImageCache=repostImageCache;
                    [self.queue addOperation:downloader];
                    
                    imageSize1=CGSizeMake(100, 100);
                }
                else { /*从缓存取*/
                    imageSize1=CGSizeMake(100, 100);
                    cell.imageView.image=image;
                }
                cell.imageView.frame=CGRectMake(cell.textView.frame.origin.x, cell.textView.frame.origin.y+textSize1.height+5, imageSize1.width, imageSize1.height);
                
                /*点击事件*/
                UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(UesrClicked:)];
                [cell.imageView addGestureRecognizer:singleTap];
                cell.imageView.userInteractionEnabled=YES;
                cell.imageView.tag=[indexPath row];
                
                /*没有转发，清空转发的cell*/
                cell.repostView.text=nil;
                cell.repostImage.image=nil;
                cell.repostName.text=nil;
                cell.repostBackgroundView.image=nil;
                
                cell.timeLabel.frame=CGRectMake(40, cell.textView.frame.origin.y+textSize1.height+10+cell.imageView.frame.size.height, 300, 20);
                NSDate *date=[self fdateFromString:[[self.listData objectAtIndex:[indexPath row]] objectForKey:@"created_at"]];
                cell.timeLabel.text=[[date description] substringToIndex:16];
            }
            
            
        }
        /*-----------------------------
         人人
         -----------------------------*/
        else {
            
            /*判断是否转发*/
            NSString *root_message=[[self.listData objectAtIndex:[indexPath row]] objectForKey:@"root_message"];
            // NSLog(@"forward_message%@",root_message);
            /*-----------------------------
             原创
             -----------------------------*/
            if(root_message==nil)
            {
                
                content=[[self.listData objectAtIndex:indexPath.row] objectForKey:@"message"];
                textSize1 = [content sizeWithFont:font1 constrainedToSize:CGSizeMake(270, 1000.0f) lineBreakMode:UILineBreakModeWordWrap];
                cell.textView.text=content;
                // 更新它的frame
                cell.textView.frame=CGRectMake(cell.textView.frame.origin.x, cell.textView.frame.origin.y, cell.textView.frame.size.width, textSize1.height);
                
                cell.repostView.text=nil;
                cell.repostName.text=nil;
                cell.repostBackgroundView.image=nil;
                
                /*时间*/
                cell.timeLabel.frame=CGRectMake(40, cell.textView.frame.origin.y+textSize1.height+8, 200, 20);
                cell.timeLabel.text=[[[self.listData objectAtIndex:[indexPath row]] objectForKey:@"time"] substringToIndex:16];
            }
            /*-----------------------------
             转发
             -----------------------------*/
            else {
                content=[[self.listData objectAtIndex:indexPath.row] objectForKey:@"forward_message"];
                textSize1 = [content sizeWithFont:font1 constrainedToSize:CGSizeMake(270, 1000.0f) lineBreakMode:UILineBreakModeWordWrap];
                textSize2=[root_message sizeWithFont:font2 constrainedToSize:CGSizeMake(250, 1000.0f) lineBreakMode:UILineBreakModeWordWrap];
                
                /*转发者*/
                NSString *nameStr=[[self.listData objectAtIndex:indexPath.row] objectForKey:@"root_username"];
                cell.repostName.text=[NSString stringWithFormat:@"%@:",nameStr];
                cell.repostName.frame=CGRectMake(50, textSize1.height+30, 270, 15);
                cell.repostName.backgroundColor=[UIColor clearColor];
                cell.repostName.font=[UIFont systemFontOfSize:15.0];
                
                /*转发抬头*/
                cell.textView.text=content;
                cell.textView.frame=CGRectMake(cell.textView.frame.origin.x, cell.textView.frame.origin.y, cell.textView.frame.size.width, textSize1.height);
                
                /*转发原文*/
                cell.repostView.frame=CGRectMake(50, textSize1.height+20+34, 250, textSize2.height);
                cell.repostView.text=root_message;
                cell.repostView.backgroundColor=[UIColor clearColor];
                
                /*转发背景框*/
                UIImage *repostBackgroundImage=[[UIImage imageNamed:@"zhuanfakuang.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:20];
                cell.repostBackgroundView.frame=CGRectMake(40, textSize1.height+12, 270, textSize2.height+34+20+8);
                [cell.repostBackgroundView setImage:repostBackgroundImage];
                
                /*时间*/
                cell.timeLabel.frame=CGRectMake(40, cell.repostBackgroundView.frame.origin.y+cell.repostBackgroundView.frame.size.height+8, 200, 20);
                cell.timeLabel.text=[[[self.listData objectAtIndex:[indexPath row]] objectForKey:@"time"] substringToIndex:16];
            }
        }
        
        cell.frame=CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, 200);
        /*按钮*/
        cell.radioButton.tag=[indexPath row];
        [cell.radioButton addTarget:self action:@selector(radioButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        /*修改button样式*/
        BOOL isOn=[[tagList objectAtIndex:[indexPath row]] boolValue];
        if(isOn==YES)
        {
            [cell.radioButton setImage:[UIImage imageNamed:@"check_selected.png"] forState:UIControlStateNormal];
            //[cell.contentView setBackgroundColor:[UIColor colorWithRed:229.0/255.0 green:238.0/255.0 blue:243.0/255.0 alpha:0.5]];
        }
        else if(isOn==NO)
        {
            [cell.radioButton setImage:[UIImage imageNamed:@"check_unselected.png"] forState:UIControlStateNormal];
            //[cell.contentView setBackgroundColor:[UIColor colorWithRed:0.99 green:0.99 blue:0.99 alpha:0.8]];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
}

/*-----------------------------
 高度
 -----------------------------*/
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([tableView isEqual:self.tableView])
    {
        CGFloat returnHeight=0.0;
        //NSLog(@"heightForRowAtIndexPath%d",[indexPath row]);
        // 該行要顯示的內容
        NSString *content1;  //原文文本
        NSString *content2;  //转发的文本
        
        UIFont *font1 = [UIFont systemFontOfSize:16.0];
        UIFont *font2 = [UIFont systemFontOfSize:15.0];
        
        if([type isEqualToString:@"sina"]) /*新浪*/
        {
            /*-----------------------------
             原文本
             -----------------------------*/
            content1 = [[self.listData objectAtIndex:indexPath.row] objectForKey:@"text"];
            textSize1 = [content1 sizeWithFont:font1 constrainedToSize:CGSizeMake(270, 1000.0f) lineBreakMode:UILineBreakModeWordWrap];
            returnHeight=textSize1.height+10;
            
            /*-----------------------------
             原图
             -----------------------------*/
            NSString *url=[[self.listData objectAtIndex:[indexPath row]] valueForKey:@"thumbnail_pic"];
            if(url!=nil)
            {
                imageSize1=CGSizeMake(100, 100);
                
                returnHeight=returnHeight+imageSize1.height+5;
            }
            
            else {
                
                /*-----------------------------
                 转发文本（转发状态没有原图）
                 -----------------------------*/
                NSDictionary *retweeted=[[self.listData objectAtIndex:indexPath.row] objectForKey:@"retweeted_status"];
                if(retweeted != nil)
                {
                    /*转发者姓名*/
                    returnHeight=returnHeight+44;
                    
                    /*转发文本*/
                    content2=[retweeted objectForKey:@"text"];
                    textSize2=[content2 sizeWithFont:font2 constrainedToSize:CGSizeMake(250, 1000.0f) lineBreakMode:UILineBreakModeWordWrap];
                    
                    returnHeight=returnHeight+textSize2.height;
                    
                    /*-----------------------------
                     转图
                     -----------------------------*/
                    url=[retweeted valueForKey:@"thumbnail_pic"];
                    if(url!=nil)
                    {
                        
                        imageSize2=CGSizeMake(100, 100);
                        
                        returnHeight=returnHeight+imageSize2.height;
                    }
                    returnHeight+=20;
                }
                
            }
        }
        else { /*人人*/
            
            NSString *root_message=[[self.listData objectAtIndex:[indexPath row]] objectForKey:@"root_message"];
            if(root_message==nil)  /*只有原创信息*/
            {
                content1 = [[self.listData objectAtIndex:indexPath.row] objectForKey:@"message"]; 
                // 計算出顯示完內容需要的最小尺寸  
                textSize1 = [content1 sizeWithFont:font1 constrainedToSize:CGSizeMake(270, 1000.0f) lineBreakMode:UILineBreakModeWordWrap];
                returnHeight=textSize1.height+10;
            }
            else {
                content1=[[self.listData objectAtIndex:indexPath.row] objectForKey:@"forward_message"];
                textSize1 = [content1 sizeWithFont:font1 constrainedToSize:CGSizeMake(270, 1000.0f) lineBreakMode:UILineBreakModeWordWrap];
                textSize2=[root_message sizeWithFont:font2 constrainedToSize:CGSizeMake(250, 1000.0f) lineBreakMode:UILineBreakModeWordWrap];
                returnHeight=textSize1.height+textSize2.height+40+34;
            }
        }
        //NSLog(@"height %d",[indexPath row]);
        // 這裏返回需要的高度
        //NSLog(@"cell %d %f",[indexPath row],returnHeight+10);
        return  returnHeight+30;
    }
    else
    {
        return 25;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int tag=[indexPath row];
    DisplayCell *cell=(DisplayCell *)[tableView cellForRowAtIndexPath:indexPath];
    UIButton *button=cell.radioButton;
    NSLog(@"%d",tag);
    if([[tagList objectAtIndex:tag] boolValue]==NO)
    {
        /*修改选中逻辑*/
        [tagList replaceObjectAtIndex:tag withObject:[NSNumber numberWithBool:YES]];
        /*修改button样式*/
        [button setImage:[UIImage imageNamed:@"check_selected.png"] forState:UIControlStateNormal];
        /*修改cell的背景色*/
    }
    else if([[tagList objectAtIndex:tag] boolValue]==YES)
    {
        /*修改选中逻辑*/
        [tagList replaceObjectAtIndex:tag withObject:[NSNumber numberWithBool:NO]];
        /*修改button样式*/
        [button setImage:[UIImage imageNamed:@"check_unselected.png"] forState:UIControlStateNormal];
    }
}
-(NSDate *)fdateFromString:(NSString *)string {
    //Wed Mar 14 16:40:08 +0800 2012
    if (!string)
        return nil;
    struct tm tm;
    time_t t;
    string=[string substringFromIndex:4];
    strptime([string cStringUsingEncoding:NSUTF8StringEncoding], "%b %d %H:%M:%S %z %Y", &tm);
    tm.tm_isdst = -1;
    t = mktime(&tm);
    return [NSDate dateWithTimeIntervalSince1970:t];
    
    
}

#pragma mark TapGesture
-(void)UesrClicked:(UIGestureRecognizer *)sender
{
    self.currentBigImageIndex=sender.view.tag;
    NSLog(@"pass %d",self.currentBigImageIndex);
    NSString *urlString=[[self.listData objectAtIndex:self.currentBigImageIndex] objectForKey:@"original_pic"];
    if(urlString==nil)
        urlString=[[[self.listData objectAtIndex:self.currentBigImageIndex] objectForKey:@"retweeted_status"] objectForKey:@"original_pic"];
    NSLog(@"%@",urlString);
    
    NSIndexPath *indexpath=[NSIndexPath indexPathForRow:self.currentBigImageIndex inSection:0];
    UIImage *image=[self.bigImageCache objectForKey:indexpath];
    
    self.bigImageView=[[BigImageView alloc] initWithFrame:CGRectMake(0, 0, 320, [[UIApplication sharedApplication] keyWindow].frame.size.height)];
    
    self.bigImageView.delegate=self;
    
    if(image!=nil)
    {
        /*直接从缓存取*/
        [[[UIApplication sharedApplication] keyWindow] addSubview:self.bigImageView];
        [self.bigImageView startWithImage:image];
        [self.bigImageView stopAndHide];
    }
    else
    {
        NSLog(@"aaa");
        /*先获取缩略图显示*/
        image=[imageCache objectForKey:indexpath];
        if(image==nil)
            image=[repostImageCache objectForKey:indexpath];
        if(image==nil)
            image=[UIImage imageNamed:@"picLoading2.png"];
        /*从网上download*/
        [[[UIApplication sharedApplication] keyWindow] addSubview:self.bigImageView];
        [self.bigImageView startWithImage:image];
        
        NSURLRequest *request=[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
        
        self.connection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
        //self.connection=[NSURLConnection connectionWithRequest:request delegate:self];
        [self.connection start];
    }
    
}
#pragma mark NSURLConnection Delegate
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //NSLog(@"didReceiveResponse");
    if(self.bigImageData==nil)
        self.bigImageData=[[NSMutableData alloc] init];
    
    /*得到下载图片的总字节数*/
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if(httpResponse && [httpResponse respondsToSelector:@selector(allHeaderFields)]){
        NSDictionary *httpResponseHeaderFields = [httpResponse allHeaderFields];
        
        long total_ = [[httpResponseHeaderFields objectForKey:@"Content-Length"] longLongValue];
        
        //NSLog(@"%ld", total_);
        self.bigImageView.total_Bytes=total_;
    }
    
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //NSLog(@"didReceiveData%d",[data length]);
    [self.bigImageData appendData:data];
    self.bigImageView.current_Bytes=[data length];
    [self.bigImageView AddProgress];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //NSLog(@"connectionDidFinishLoading");
    
    UIImage *bigImage=[UIImage imageWithData:self.bigImageData];
    /*把大图缓存*/
    NSIndexPath *indexpath=[NSIndexPath indexPathForRow:self.currentBigImageIndex inSection:0];
    [self.bigImageCache setObject:bigImage forKey:indexpath];
    /*重绘清晰图*/
    [self.bigImageView ResetImage:bigImage];
    self.bigImageData=nil;
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self.bigImageView downloadFail];
}

-(void)DidTapToCancle
{
    [self.connection cancel];
    self.connection=nil;
    self.bigImageView=nil;
    self.bigImageData=nil;
}
#pragma mark - UIScrollViewDelegate
- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.tableView beginScroll];
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.tableView Scrolling:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.tableView endScroll:scrollView];
}

-(void)radioButtonClicked:(id)sender
{
    UIButton *button=(UIButton *)sender;
    
    int tag=button.tag;
    NSLog(@"%d",tag);
    if([[tagList objectAtIndex:tag] boolValue]==NO)
    {
        /*修改选中逻辑*/
        [tagList replaceObjectAtIndex:tag withObject:[NSNumber numberWithBool:YES]];
        /*修改button样式*/
        [button setImage:[UIImage imageNamed:@"check_selected.png"] forState:UIControlStateNormal];
        /*修改cell的背景色*/
    }
    else if([[tagList objectAtIndex:tag] boolValue]==YES)
    {
        /*修改选中逻辑*/
        [tagList replaceObjectAtIndex:tag withObject:[NSNumber numberWithBool:NO]];
        /*修改button样式*/
        [button setImage:[UIImage imageNamed:@"check_unselected.png"] forState:UIControlStateNormal];
    }
}

#pragma mark 导航栏方法
-(void)returnToMaterialKit
{
    [SVProgressHUD dismiss];
    //NSLog(@"pass");
    UIStoryboard *story=[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UIViewController *MaterialKitViewController=[story instantiateViewControllerWithIdentifier:@"MaterialKitViewController"];
    [self presentModalViewController:MaterialKitViewController animated:YES];
}

-(void)returnToHomePage
{
    [SVProgressHUD dismiss];
    /*把数据传回去*/
    for(int i=0;i<[tagList count];i++)
    {
        BOOL isOn=[[tagList objectAtIndex:i] boolValue];
        if(isOn==YES)  /*分不同情况存到数据库*/
        {
            if([self.type isEqualToString:@"sina"])
            {
                /*--------------
                 新浪个人
                 ------------*/
                if(self.userId==nil)
                {
                    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:i inSection:0];
                    NSLog(@"repostImageCache %@",[repostImageCache objectForKey:indexPath]);
                    [[DataClient shareClient] addItem:[self.listData objectAtIndex:i] withImage:[imageCache objectForKey:indexPath] withRepostImage:[repostImageCache objectForKey:indexPath] withType:1];
                }
                /*--------------
                 新浪好友
                 ------------*/
                else
                {
                    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:i inSection:0];
                    [[DataClient shareClient] addItem:[self.listData objectAtIndex:i] withImage:[imageCache objectForKey:[NSIndexPath indexPathWithIndex:i]] withRepostImage:[repostImageCache objectForKey:indexPath] withType:2];
                }
            }
            else
            {
                /*--------------
                 人人个人
                 ------------*/
                if(self.userId==nil)
                {
                    [[DataClient shareClient] addItem:[self.listData objectAtIndex:i] withImage:nil withRepostImage:nil withType:3];
                }
                /*--------------
                 人人好友
                 ------------*/
                else
                {
                    [[DataClient shareClient] addItem:[self.listData objectAtIndex:i] withImage:nil withRepostImage:nil withType:4];
                }
            }
        }
    }
    UIStoryboard *story=[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UIViewController *firstViewController=[story instantiateViewControllerWithIdentifier:@"FirstViewController"];
    [self presentModalViewController:firstViewController animated:YES];
}


#pragma mark 日历委托 methods
- (void)calendarController:(PMCalendarController *)calendarController didChangePeriod:(PMPeriod *)newPeriod
{
    NSString * text = [NSString stringWithFormat:@"%@ - %@"
                       , [newPeriod.startDate dateStringWithFormat:@"dd-MM-yyyy"]
                       , [newPeriod.endDate dateStringWithFormat:@"dd-MM-yyyy"]];
    NSLog(@"%@",text);
    if(whichCalendar==1)
    {
        self.start=newPeriod.startDate;
        /*显示在按钮*/
        [self.startButton setTitle:[newPeriod.startDate dateStringWithFormat:@"yyyy-MM-dd"] forState:UIControlStateNormal];
        [self.startButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.startButton setTitleEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
        self.startButton.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    }
    else
    {
        self.end=newPeriod.startDate;
        /*显示在按钮*/
        [self.endButton setTitle:[newPeriod.startDate dateStringWithFormat:@"yyyy-MM-dd"] forState:UIControlStateNormal];
        [self.endButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.endButton setTitleEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
        self.endButton.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    }
    
}
#pragma mark 取消全部线程
-(void)cancleOperations
{
    NSArray *operations= [self.queue operations];
    for(NSOperation *op in operations)
    {
        [op cancel];
    }
}

#pragma mark 搜索函数
- (IBAction)toSelectStratTime:(id)sender {
    whichCalendar=1;
    
    UIView *tempView=[[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-39, 100, 40)] ;
    [self.view insertSubview:tempView atIndex:0];
    [self initCalendar:tempView];
    tempView=nil;
}

- (IBAction)toSelectEndTime:(id)sender {
    whichCalendar=2;
    
    UIView *tempView=[[UIView alloc] initWithFrame:CGRectMake(150, self.view.bounds.size.height-39, 100, 40)] ;
    [self.view insertSubview:tempView atIndex:0];
    [self initCalendar:tempView];
    tempView=nil;
}

- (IBAction)toSearch:(id)sender {
    /*清空之前的结果和链接*/
    [self.listData removeAllObjects];
    [tagList removeAllObjects];

    [SVProgressHUD showWithStatus:@"加载中..."];
    if(start==nil || end==nil)
    {
        [SVProgressHUD showErrorWithStatus:@"请选择时段" duration:1.0];
    }
    else if([start compare:end] == 1)
    {
        [SVProgressHUD showErrorWithStatus:@"时段不科学" duration:1.0];
    }
    else
    {
        if([type isEqual:@"sina"])
        {
            [[DataManager sharedDataManager].sinaWeiboData stopWeiboWithTimeInterval];
            /*显示时间段的微博*/
            [[[DataManager sharedDataManager] sinaWeiboData] weiboWithTimeInterval:userId startTime:start endTime:end];
        }
        else
        {
            [[DataManager sharedDataManager].renrenData stopStatusWithTimeInterval];
            [[[DataManager sharedDataManager] renrenData] statusWithTimeInterval:userId startTime:start endTime:end];
        }
    }
}

#pragma mark 初始化UI
-(void)initCalendar:(id)sender
{
    self.pmCC = [[PMCalendarController alloc] init];
    self.pmCC.delegate = self;
    self.pmCC.mondayFirstDayOfWeek = YES;
    
    [self.pmCC presentCalendarFromView:sender 
              permittedArrowDirections:PMCalendarArrowDirectionDown 
                              animated:YES];
    [self calendarController:pmCC didChangePeriod:pmCC.period];
    
}

-(void)initSearchBar
{
    /*背景*/
    self.searchBackground=[[UIView alloc] init];
    self.searchBackground.frame=CGRectMake(320, self.view.bounds.size.height-39, 320, 39);
    [self.searchBackground setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"time_bg.png"]]];
    /*开始按钮*/
    self.startButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.startButton.frame=CGRectMake(29, 5, 95, 30);
    //[self.startButton setImage:[UIImage imageNamed:@"time_input.png"] forState:UIControlStateNormal];
    [self.startButton setBackgroundImage:[UIImage imageNamed:@"time_input.png"] forState:UIControlStateNormal];
    [self.startButton addTarget:self action:@selector(toSelectStratTime:) forControlEvents:UIControlEventTouchUpInside];
    [self.searchBackground addSubview:self.startButton];
    /*结束按钮*/
    self.endButton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.endButton.frame=CGRectMake(150, 5, 95, 30);
    //[self.endButton setImage:[UIImage imageNamed:@"time_input.png"] forState:UIControlStateNormal];
    [self.endButton setBackgroundImage:[UIImage imageNamed:@"time_input.png"] forState:UIControlStateNormal];
    [self.endButton addTarget:self action:@selector(toSelectEndTime:) forControlEvents:UIControlEventTouchUpInside];
    [searchBackground addSubview:self.endButton];
    /*搜索按钮*/
    UIButton *searchButton=[UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.frame=CGRectMake(253, 5, 61, 30);
    [searchButton setImage:[UIImage imageNamed:@"searchbutton.png"] forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(toSearch:) forControlEvents:UIControlEventTouchUpInside];
    [self.searchBackground addSubview:searchButton];
    
    [self.view addSubview:self.searchBackground];
}

-(void)initToolBar
{
    /*搜索框*/
    [self.searchBackground setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"time_bg.png"]]];
    [self.view addSubview:searchBackground]; 
}

-(void)initTableView
{
    self.tableView=[[DisplayTableView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height-44-50)];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    self.tableView.disPlayDataSource=self;
   // self.tableView.allowsSelection=NO;
    self.tableView.backgroundColor=[UIColor colorWithRed:0.99 green:0.99 blue:0.99 alpha:0.8];
    self.tableView.separatorColor=[UIColor colorWithRed:229.0/255.0 green:238.0/255.0 blue:243.0/255.0 alpha:1.0];
    [self.view addSubview:self.tableView];
}
-(void)initNavigationBar
{
    //导航bar
    UINavigationBar *navBar=[[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [navBar setBackgroundImage:[UIImage imageNamed:@"xuanzeweibo.png"] forBarMetrics:UIBarMetricsDefault];
    //导航item
    UINavigationItem *item=[[UINavigationItem alloc] initWithTitle:nil];
    [navBar pushNavigationItem:item animated:YES];
    //返回按钮
    UIButton *returnBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    returnBtn.frame=CGRectMake(0, 0, 40, 40);
    [returnBtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    //return to method?????
    [returnBtn addTarget:self action:@selector(returnToMaterialKit) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:returnBtn];
    item.leftBarButtonItem=leftBarButtonItem;
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setBackgroundColor:[UIColor clearColor]];
    rightButton.frame = CGRectMake(0, 0, 40, 40);
    [rightButton setImage:[UIImage imageNamed:@"done.png"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(returnToHomePage) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    item.rightBarButtonItem = button;
    
    [self.view addSubview:navBar];
    //[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"ourtimeline_bg.png"]]];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
