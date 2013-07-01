//
//  ViewController.m
//  Timeline
//
//  Created by 01 developer on 12-11-1.
//  Copyright (c) 2012年 Sun Yat-sen University. All rights reserved.
//

#import "ViewController.h"
#import "DataManager.h"
#import "CustomSwitch.h"
@interface ViewController () <UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *listData;
}
@end

@implementation ViewController
@synthesize renren_login;
@synthesize renren_test;
@synthesize weibo_login;
@synthesize weibo_test;
@synthesize tableview;

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
	// Do any additional setup after loading the view.
    tableview.delegate=self;
    tableview.dataSource=self;
    listData=[[NSMutableArray alloc] init];
    //监听新浪微博的数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WeiboshowOutput:) name:@"weibo_userInfo" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WeiboshowOutput:) name:@"upDateWeibo" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WeiboshowOutput:) name:@"pullWeibo" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WeiboshowOutput:) name:@"weibo_friends_statuses" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WeiboshowOutput:) name:@"weibo_friends_lateststatuses" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WeiboshowOutput:) name:@"weibo_friends" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WeiboshowOutput:) name:@"weibo_comments" object:nil];
    //监听人人的数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RenRenshowOutput:) name:@"renren_user_info" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RenRenshowOutput:) name:@"renren_friends" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RenRenshowOutput:) name:@"renren_comments" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RenRenshowOutput:) name:@"renren_user_statuses" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RenRenshowOutput:) name:@"renren_friends_statuses" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RenRenshowOutput:) name:@"renren_user_lateststatuses" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RenRenshowOutput:) name:@"renren_friends_lateststatuses" object:nil];
    
    /*--------------添加手势-------------*/
    UISwipeGestureRecognizer *recognizer; 
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)]; 
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.tableview addGestureRecognizer:recognizer];
    
    

    
}


//新浪微博数据的处理
-(void) WeiboshowOutput:(NSNotification *)note
{
    NSDictionary *temp=note.object;
    NSArray *statuses=[temp objectForKey:@"statuses"];
    NSLog(@"statuses count=%d",[statuses count]);
    [listData addObjectsFromArray:statuses];
    [tableview reloadData];
}

#pragma mark 人人数据
//人人数据的处理
-(void) RenRenshowOutput:(NSNotification *)note
{
        listData=note.object;
        [tableview reloadData];
}

#pragma mark 手势
-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    
    //如果往左滑
    
    if(recognizer.direction==UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"pass");
        //[self performSegueWithIdentifier:@"ToOurTimeline" sender:self];
    }
}

- (void)viewDidUnload
{
    [self setRenren_login:nil];
    [self setRenren_test:nil];
    [self setWeibo_login:nil];
    [self setWeibo_test:nil];
    [self setTableview:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark 人人
- (IBAction)RenRenLogin:(id)sender {
    [[DataManager sharedDataManager].renrenData ToLogin];
}

- (IBAction)RenRenTest:(id)sender {
   // [[DataManager sharedDataManager].renrenData getuserStatus:nil];
     
}
- (IBAction)RenRenStatus:(id)sender {
    [[DataManager sharedDataManager].renrenData getComments:@"4230558618" andOwnerId:nil];
}


#pragma mark 微博
- (IBAction)WeiboLogin:(id)sender {

   [[DataManager sharedDataManager].sinaWeiboData ToLogin];
   
}
- (IBAction)WeiboTest:(id)sender {
    //[[DataManager sharedDataManager].sinaWeiboData getComments:@"3518078266323942"];
     //[[DataManager sharedDataManager].sinaWeiboData getFriends_Statuses:@"124420240"];
    //[[DataManager sharedDataManager] loadAllData:@"124420240" andType:1];
    [[DataManager sharedDataManager].sinaWeiboData pullWeibo:nil andSinceId:@"3518078266323942"];
}

- (IBAction)WeboStatus:(id)sender {
     [[DataManager sharedDataManager].sinaWeiboData upDateWeibo:nil andPage:@"2"];
}



#pragma mark UITableViewDelegate
//返回行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    return [listData count];
}

//返回一个cell，即每一行所要显示的内容
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identify=@"identify";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:identify];
    if(cell==nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identify];
    }
    NSUInteger row = [indexPath row];
    //int status_id=[[[listData objectAtIndex:row] valueForKey:@"status_id"] intValue];
    //NSLog(@"%@",[[listData objectAtIndex:row] objectForKey:@"status_id"]);
    cell.textLabel.text = [[listData objectAtIndex:row] objectForKey:@"text"];
   // NSLog(@"%@",[listData objectAtIndex:row] );
    //cell.textLabel.text =[NSString stringWithFormat:@"%@",[[listData objectAtIndex:row] objectForKey:@"status_id"]]; /*用于人人状态id*/
    
    return cell;
}


//设置列宽
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
@end
