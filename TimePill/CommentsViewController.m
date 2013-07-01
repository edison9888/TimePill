//
//  CommentsViewController.m
//  Timeline
//
//  Created by simon on 12-12-1.
//  Copyright (c) 2012年 Sun Yat-sen University. All rights reserved.
//

#import "CommentsViewController.h"

@interface CommentsViewController () <UITableViewDelegate,UITableViewDataSource,imageDownloaderDelegate>
{
    /*服务器返回的数据*/
    NSMutableArray *listData;
    /*添加到吐槽的评论*/
    NSMutableArray *returnData;
    /*添加到吐槽的评论的index*/
    NSMutableArray *tagList;
}
@end

@implementation CommentsViewController

@synthesize leftButton,rightButton,comments,navBar,userId,type,statusId_or_weiboId,queue,cache;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpNavigationBar];
    [self setUpTableView];
    
    isFirst=YES;
    // weibo_id=[self valueForKey:@"weibo_id"];
    self.queue=[[NSOperationQueue alloc] init];
    self.cache=[[NSMutableDictionary alloc] init];
    
    /*评论通知*/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WeiboshowOutput:) name:@"weibo_comments" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RenRenshowOutput:) name:@"renren_comments" object:nil];
    
    /*测试数据*/
    [SVProgressHUD showWithStatus:@"加载中..." maskType:1];
    
    if([self.type isEqualToString:@"sina"])
        [[DataManager sharedDataManager].sinaWeiboData getComments:self.statusId_or_weiboId];
    else
        [[DataManager sharedDataManager].renrenData getComments:self.statusId_or_weiboId andOwnerId:self.userId];
    

}

#pragma mark 导航栏按钮事件
-(void)RightButtonClicked
{
    if(isFirst==YES)
    {
        isFirst=NO;
        /*TableView右移*/
        [UIView animateWithDuration:0.25f animations:^(void)
         {
             self.comments.frame=CGRectMake(0, self.comments.frame.origin.y, self.comments.frame.size.width, self.comments.frame.size.height);
         }];
        /*设置右按钮样式*/
        [self.rightButton setImage:[UIImage imageNamed:@"Notselected.png"] forState:UIControlStateNormal];
        /*设置右按钮不可点击*/
        self.rightButton.enabled=NO;
        /*改变navBar*/
        [self.navBar setBackgroundImage:[UIImage imageNamed:@"tianjiazhitucao.png"] forBarMetrics:UIBarMetricsDefault];
    }
    else {
        isFirst=YES;
        if(self.rightButton.enabled==YES)
        {
            /*把数据传回去*/
            for(int i=0;i<[tagList count];i++)
            {
                BOOL isOn=[[tagList objectAtIndex:i] boolValue];
                if(isOn==YES)
                {
                    [returnData addObject:[listData objectAtIndex:i]];
                    NSIndexPath *indexpath=[NSIndexPath indexPathForRow:i inSection:0];                    UIImage *image=[self.cache objectForKey:indexpath];
                    if(image==nil)
                        image=[UIImage imageNamed:@"picLoading.png"];
                    
                    if([self.type isEqual:@"sina"])
                        [[DataClient shareClient] addComments:[listData objectAtIndex:i] withType:1 andWeiboID:self.statusId_or_weiboId andImage:image];
                    else
                       [[DataClient shareClient] addComments:[listData objectAtIndex:i] withType:2 andWeiboID:self.statusId_or_weiboId andImage:image];
                        
                }
            }
            [self dismissModalViewControllerAnimated:YES];
        }

            
    }
}

-(void)LeftButtonClicked
{
    if(isFirst==YES)
    {
        isFirst=NO;
        [SVProgressHUD dismiss];
        //[self dismissModalViewControllerAnimated:YES];
        //[self dismissViewControllerAnimated:YES completion:^(void){}];
        [self dismissModalViewControllerAnimated:YES];
            }
    else {
        isFirst=YES;
        /*全部状态复原！！！*/
        [returnData removeAllObjects];
        [UIView animateWithDuration:0.25f animations:^(void)
         {
             self.comments.frame=CGRectMake(-50, self.comments.frame.origin.y, self.comments.frame.size.width, self.comments.frame.size.height);
         }];
        [self.rightButton setImage:[UIImage imageNamed:@"addtotucao.png"] forState:UIControlStateNormal];
        self.rightButton.enabled=YES;
        /*改变navBar*/
        [self.navBar setBackgroundImage:[UIImage imageNamed:@"chakanpinglun.png"] forBarMetrics:UIBarMetricsDefault];
    }
}

#pragma mark table view delegate method
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"numberOfRowsInSection listdata%d",[listData count]);
    return [listData count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identify=@"CommentsCell";
    CommentsCell *cell =[tableView dequeueReusableCellWithIdentifier:identify];
    if(cell==nil)
    {
        cell = [[CommentsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    NSUInteger row = [indexPath row];
    UIFont *font = [UIFont systemFontOfSize:15];
    
    [cell.contentView setBackgroundColor:[UIColor whiteColor]];
    if([self.type isEqualToString:@"sina"])
    {
        /*昵称*/
        cell.nameLabel.text = [[[listData objectAtIndex:row] objectForKey:@"user"] objectForKey:@"screen_name"];
        cell.nameLabel.frame=CGRectMake(65+50, 5, 320, 20);
    
        /*头像*/
        NSString *urlStr=[[[listData objectAtIndex:row] objectForKey:@"user"] objectForKey:@"profile_image_url"];
        HeadPicDownloader *downloader=[[HeadPicDownloader alloc] initWithURLString:urlStr];
        downloader.delegate=self;
        downloader.indexpath=indexPath;
        [queue addOperation:downloader];
        
        UIImage *image=[UIImage imageNamed:@"picLoading.png"];
        cell.headImage.image=image;
    
        /*评论内容*/
        NSString *content = [[listData objectAtIndex:row] objectForKey:@"text"];
        CGSize size = [content sizeWithFont:font constrainedToSize:CGSizeMake(245, 1000.0f) lineBreakMode:UILineBreakModeWordWrap];
        cell.commentsLabel.text = [[listData objectAtIndex:row] objectForKey:@"text"];
        cell.commentsLabel.frame=CGRectMake(65+50, 30, size.width, size.height);
    }
    else
    {
        /*昵称*/
        cell.nameLabel.text = [[listData objectAtIndex:row] objectForKey:@"name"];
        cell.nameLabel.frame=CGRectMake(65+50, 5, 320, 20);
        
        /*头像*/
        NSString *urlStr=[[listData objectAtIndex:row] objectForKey:@"tinyurl"];
        HeadPicDownloader *downloader=[[HeadPicDownloader alloc] initWithURLString:urlStr];
        downloader.delegate=self;
        downloader.indexpath=indexPath;
        [queue addOperation:downloader];
        
        UIImage *image=[UIImage imageNamed:@"picLoading.png"];
        cell.headImage.image=image;
        
        /*评论内容*/
        NSString *content = [[listData objectAtIndex:row] objectForKey:@"text"];
        CGSize size = [content sizeWithFont:font constrainedToSize:CGSizeMake(245, 1000.0f) lineBreakMode:UILineBreakModeWordWrap];
        cell.commentsLabel.text = [[listData objectAtIndex:row] objectForKey:@"text"];
        cell.commentsLabel.frame=CGRectMake(65+50, 30, size.width, size.height);
    }
    /*按钮*/
    cell.button.frame=CGRectMake(20, 15, 25, 25);
    cell.button.tag=[indexPath row];
    [cell.button addTarget:self action:@selector(CommentsSelected:) forControlEvents:UIControlEventTouchUpInside];
    /*修改button样式*/
    BOOL isOn=[[tagList objectAtIndex:[indexPath row]] boolValue];
    if(isOn==YES)
        [cell.button setImage:[UIImage imageNamed:@"check_selected.png"] forState:UIControlStateNormal];
    else if(isOn==NO)
        [cell.button setImage:[UIImage imageNamed:@"check_unselected.png"] forState:UIControlStateNormal];
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = [indexPath row];  
    // 用何種字體進行顯示  
    UIFont *font = [UIFont systemFontOfSize:15];
    // 該行要顯示的內容  
    NSString *content = [[listData objectAtIndex:row] objectForKey:@"text"];
    // 計算出顯示完內容需要的最小尺寸  
    CGSize size = [content sizeWithFont:font constrainedToSize:CGSizeMake(245, 1000.0f) lineBreakMode:UILineBreakModeWordWrap];  
    // 這裏返回需要的高度  
    return size.height+38;  
}

- (void)imageDidFinished:(UIImage *)image para:(NSIndexPath *)indexpath
{
    CommentsCell *cell=(CommentsCell *)[self.comments cellForRowAtIndexPath:indexpath];
    cell.headImage.image=image;
    [cache setObject:image forKey:indexpath];
    [cell setNeedsDisplay];
}

#pragma mark 多选按钮点击
-(void)CommentsSelected:(id)sender
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
    }
    else if([[tagList objectAtIndex:tag] boolValue]==YES)
    {
        /*修改选中逻辑*/
        [tagList replaceObjectAtIndex:tag withObject:[NSNumber numberWithBool:NO]];
        /*修改button样式*/
        [button setImage:[UIImage imageNamed:@"check_unselected.png"] forState:UIControlStateNormal];
    }

    /*如果有选中的条目，则让done按钮可点击*/
    for(int i=0;i<[tagList count];i++)
    {
        BOOL isOn=[[tagList objectAtIndex:i] boolValue];
        if(isOn==YES)
        {
            [self.rightButton setImage:[UIImage imageNamed:@"done.png"] forState:UIControlStateNormal];
            self.rightButton.enabled=YES;
            break;
        }
        else {
            [self.rightButton setImage:[UIImage imageNamed:@"Notselected.png"] forState:UIControlStateNormal];
            self.rightButton.enabled=NO;
        }
    }
}

#pragma mark 数据处理
//新浪微博数据的处理
-(void) WeiboshowOutput:(NSNotification *)note
{
    [SVProgressHUD dismiss];
    listData=note.object;
    NSLog(@"listdata%d",[listData count]);
    [self.comments reloadData];
    if ([listData count]>0) {
        [self.comments setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        //[self.comments setSeparatorColor:[UIColor co]];
        /*隐藏多余的分割线*/
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor clearColor];
        [self.comments setTableFooterView:view];
    }
    /*初始化tag数组*/
    for(int i=0;i<[listData count];i++)
    {
        /*全部设为no*/
        [tagList addObject:[NSNumber numberWithBool:NO]];
    }
}

//人人数据的处理
-(void) RenRenshowOutput:(NSNotification *)note
{
    [SVProgressHUD dismiss];
    listData=note.object;
    [self.comments reloadData];
    if ([listData count]>0) {
        [self.comments setSeparatorStyle:UITableViewCellSelectionStyleBlue];
        
        /*隐藏多余的分割线*/
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor clearColor];
        [self.comments setTableFooterView:view];
    }
    /*初始化tag数组*/
    for(int i=0;i<[listData count];i++)
    {
        /*全部设为no*/
        [tagList addObject:[NSNumber numberWithBool:NO]];
    }
}

#pragma mark TableView
-(void)setUpTableView
{
    UIImageView *iv=[[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-20, self.view.frame.size.width, self.view.frame.size.height)];
    UIImage *image=[UIImage imageNamed:@"background_noline.png"];
    iv.image=[image stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    [self.view insertSubview:iv atIndex:0];
    
    self.comments=[[UITableView alloc] initWithFrame:CGRectMake(-50, 44, 320+50, self.view.frame.size.height-44)];
    [self.view addSubview:self.comments];
    self.comments.delegate=self;
    self.comments.dataSource=self;
    
    self.comments.backgroundColor=[UIColor clearColor];
    
    listData=[[NSMutableArray alloc] init];
    
    [self.comments setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.comments.allowsSelection=NO;
    
    returnData=[[NSMutableArray alloc] init];
    tagList=[[NSMutableArray alloc] init];
}

#pragma mark 导航栏
-(void)setUpNavigationBar
{
    //导航bar
    self.navBar=[[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [self.navBar setBackgroundImage:[UIImage imageNamed:@"chakanpinglun.png"] forBarMetrics:UIBarMetricsDefault];
    [self.view addSubview:self.navBar];
    
    //导航item
    UINavigationItem* item=[[UINavigationItem alloc] init];
    [self.navBar pushNavigationItem:item animated:YES];
    
    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rightButton setBackgroundColor:[UIColor clearColor]];
    self.rightButton.frame = CGRectMake(0, 0, 40, 40);
    [self.rightButton setImage:[UIImage imageNamed:@"addtotucao.png"] forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(RightButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
    item.rightBarButtonItem = rightButtonItem;
    
    
    self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.leftButton setBackgroundColor:[UIColor clearColor]];
    self.leftButton.frame = CGRectMake(0, 0, 40, 40);
    [self.leftButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [self.leftButton addTarget:self action:@selector(LeftButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftButton];
    item.leftBarButtonItem = leftButtonItem;
    

}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
