//
//  MaterialKitViewController.m
//  Timeline
//
//  Created by simon on 12-12-11.
//  Copyright (c) 2012年 Sun Yat-sen University. All rights reserved.
//

#import "MaterialKitViewController.h"

@interface MaterialKitViewController ()
{
    
}

@end

@implementation MaterialKitViewController
@synthesize tableView;
@synthesize myTable;
@synthesize queue;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initNavigationBar];   
    [self initMyself];
    [self initTableView];
    [self initData];
    
}

-(void)initData
{
    NSArray *contacts=[[DataClient shareClient] getRecentContacts];
    /*一定要这样才能用？*/
//    for(NSDictionary *dic in contacts)
//    {
//        [listData addObject:dic];
//    }
    int size=[contacts count];
    if(size>3)
    {
        NSDictionary *dic=[contacts objectAtIndex:size-1];
        [listData addObject:dic];
        dic=[contacts objectAtIndex:size-2];
        [listData addObject:dic];
        dic=[contacts objectAtIndex:size-3];
        [listData addObject:dic];
    }
    else
    {
        for(NSDictionary *dic in contacts)
        {
            [listData addObject:dic];
        }
    }
    
    self.queue=[[NSOperationQueue alloc] init];

}

#pragma mark table view delegate method
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if([tableView isEqual:self.tableView])
        return [listData count];
    else
        return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    /*--------------------------------
                最近联系人
     --------------------------------*/
    if([tableView isEqual:self.tableView]){
    static NSString *identifier = @"friendCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }   
    NSUInteger row = [indexPath row];

    UIFont *font = [UIFont systemFontOfSize:16];
    
    /*姓名*/
    cell.textLabel.text=[[listData objectAtIndex:row] valueForKey:@"name"];
    cell.textLabel.font=font;
    
    /*头像*/
    NSString *urlString=[[listData objectAtIndex:row] valueForKey:@"imageUrl"];
    /*异步下载图片*/
    HeadPicDownloader *downloader=[[HeadPicDownloader alloc] initWithURLString:urlString];
    downloader.indexpath=indexPath;
    downloader.delegate=self;
    [self.queue addOperation:downloader];
    /*静态图片*/
    UIImage *image = [UIImage imageNamed:@"picLoading.png"];
    [cell.imageView setImage:[self reSizeImage:image toSize:CGSizeMake(30, 30)]];
    cell.imageView.frame=CGRectMake(5, 5, 30, 30);
    //圆角
    cell.imageView.layer.cornerRadius=8.0;
    cell.imageView.layer.masksToBounds=YES;
    
    /*背景*/
    type=[[listData objectAtIndex:row] valueForKey:@"type"];
    if([type isEqualToString:@"sina"])
    {
        switch ([indexPath row]) {
            case 0:
                if([listData count]==1)
                    cell.contentView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"weibosingle.png"]];
                else
                    cell.contentView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"weibotop.png"]];
                break;
             case 1:
                if([listData count]==2)
                    cell.contentView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"weibobottom.png"]];
                else
                    cell.contentView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"weibomiddle.png"]];
                break;
             case 2:
                cell.contentView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"weibobottom.png"]];
                break;
            default:
                break;
        }
    }
    else
    {
        switch ([indexPath row]) {
            case 0:
                if([listData count]==1)
                    cell.contentView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"renrensingle.png"]];
                else
                    cell.contentView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"renrentop.png"]];
                break;
            case 1:
                if([listData count]==2)
                    cell.contentView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"renrenbottom.png"]];
                else
                    cell.contentView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"renrenmiddle.png"]];
                break;
            case 2:
                cell.contentView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"renrenbottom.png"]];
                break;
            default:
                break;
        }
    }

    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;
    }
    /*--------------------------------
                我的微博人人
     --------------------------------*/
    else {
        static NSString *identifier = @"myCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        }
        
        /*背景*/
        switch ([indexPath row]) {
            case 0:
            {
                cell.contentView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"minetop.png"]];
                cell.textLabel.text=@"我的新浪微博库";
                cell.textLabel.font=[UIFont systemFontOfSize:16];
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
                break;
            }
            case 1:
            {
                cell.contentView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"minebottom.png"]];
                cell.textLabel.text=@"我的人人状态库";
                cell.textLabel.font=[UIFont systemFontOfSize:16];
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
                break;
            }
            default:
                break;
        }

        return cell;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([tableView isEqual:self.tableView])
        return 41;  
    else
        return 42;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if([tableView isEqual:self.tableView]){
        [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
        type=[[listData objectAtIndex:[indexPath row]] valueForKey:@"type"];
        userId=[[listData objectAtIndex:[indexPath row]] valueForKey:@"userId"];
        [self performSegueWithIdentifier:@"ToDisplayFromMaterial" sender:self];
    }
    else {
        [self.myTable deselectRowAtIndexPath:indexPath animated:NO];
        switch ([indexPath row]) {
            case 0:
                if(![[DataManager sharedDataManager] isWeiboAuthValid])
                    [[[DataManager sharedDataManager] sinaWeiboData] ToLogin];
                else {
                    type=@"sina";
                    userId=nil;
                    [self performSegueWithIdentifier:@"ToDisplayFromMaterial" sender:self];
                }
                break;
            case 1:
                if(![[DataManager sharedDataManager] isRenRenAuthValid])
                    [[[DataManager sharedDataManager] renrenData] ToLogin];
                else {
                    type=@"renren";
                    userId=nil;
                    [self performSegueWithIdentifier:@"ToDisplayFromMaterial" sender:self];
                }
                break; 
            default:
                break;
        }
    }
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"ToDisplayFromMaterial"])
    {
        id destination=segue.destinationViewController;
        [destination setValue:type forKey:@"type"];
        [destination setValue:userId forKey:@"userId"];
    }
}
/*---------------------
 委托方法
 ---------------------*/
- (void)imageDidFinished:(UIImage *)image para:(NSIndexPath *)indexpath
{
    UITableViewCell *cell=[self.tableView cellForRowAtIndexPath:indexpath];
    cell.imageView.image=[self reSizeImage:image toSize:CGSizeMake(30, 30)];
    [cell setNeedsDisplay];
}

/*图片自定长宽*/
- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize
{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return reSizeImage;
}


#pragma mark 导航栏方法
-(void)ReturnTo
{
    [self performSegueWithIdentifier:@"returnBack" sender:self];
}
-(void)addFriends
{
    [self performSegueWithIdentifier:@"ToFriendList" sender:self];
}

#pragma mark 初始化UI
-(void)initMyself
{
    self.myTable=[[UITableView alloc] initWithFrame:CGRectMake(20, 100, 280, 86)];
    [self.view addSubview:self.myTable];
    self.myTable.dataSource=self;
    self.myTable.delegate=self;
    self.myTable.layer.cornerRadius=10.0;
    self.myTable.layer.masksToBounds=YES;
    self.myTable.backgroundColor=[UIColor clearColor];
    self.myTable.separatorColor=[UIColor clearColor];
    self.myTable.scrollEnabled=NO;

}
-(void)ClickMyself:(id)sender
{
    
}
-(void)initTableView
{
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(20, 230, 280, 125)];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    listData=[[NSMutableArray alloc] init];
    self.tableView.layer.cornerRadius=10.0;
    self.tableView.layer.masksToBounds=YES;
    self.tableView.backgroundColor=[UIColor clearColor];
    self.tableView.separatorColor=[UIColor clearColor];
    self.tableView.scrollEnabled=NO;
    
}

-(void)initNavigationBar
{
    //导航bar
    UINavigationBar *navBar=[[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [navBar setBackgroundImage:[UIImage imageNamed:@"sucaiku.png"] forBarMetrics:UIBarMetricsDefault];
    //导航item
    UINavigationItem *item=[[UINavigationItem alloc] initWithTitle:nil];
    [navBar pushNavigationItem:item animated:YES];
    //返回按钮
    UIButton *returnBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    returnBtn.frame=CGRectMake(0, 0, 40, 40);
    [returnBtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    //return to method?????
    [returnBtn addTarget:self action:@selector(ReturnTo) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:returnBtn];
    item.leftBarButtonItem=leftBarButtonItem;
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setBackgroundColor:[UIColor clearColor]];
    rightButton.frame = CGRectMake(0, 0, 40, 40);
    [rightButton setImage:[UIImage imageNamed:@"addafriend.png"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(addFriends) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    item.rightBarButtonItem = button;
    
    [self.view addSubview:navBar];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"sucaiku_bg.png"]]];
}
- (void)viewDidUnload
{
    [self setTableView:nil];
    [self setMyTable:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
