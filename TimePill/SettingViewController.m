//
//  HallViewController.h
//  Timeline
//
//  Created by yongry on 12-12-15.
//  Copyright (c) 2012年 Sun Yat-sen University. All rights reserved.
//

#import "SettingViewController.h"
#import "TimeMenuViewController.h"
@implementation SettingViewController
@synthesize settableView;
@synthesize array;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];

    [self initNavigationBar];
    
    self.array = [[NSArray alloc] initWithObjects:@"更换账户",@"版本信息",@"推荐我们",@"意见反馈",nil];
    // self.settableView se
    self.settableView.delegate = self;
    self.settableView.dataSource = self;
    self.settableView.scrollEnabled=NO;
    
}

-(void)setTableScrollEnable:(Boolean)en
{
    
    
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)viewDidUnload
{

    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"";
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"settingCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell.textLabel setFont:[UIFont fontWithName:@"System Bold" size:17.0]];
    // cell.textLabel.textColor = [UIColor grayColor];
    cell.textLabel.text = [self.array objectAtIndex:indexPath.row];
    // Configure the cell...
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    [self.settableView deselectRowAtIndexPath:indexPath animated:NO];
    
    int row=[indexPath row];
    if(row==0)
    {

        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        static NSString *controllerId = @"LoginViewController";
        LoginViewController *l=[storyBoard instantiateViewControllerWithIdentifier:controllerId];        [self presentModalViewController:l animated:YES];
    }
    else if(row==1)
    {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        static NSString *controllerId = @"AboutUsViewController";
        AboutUsViewController *a = [storyBoard instantiateViewControllerWithIdentifier:controllerId];
        [self presentModalViewController:a animated:YES];
    }
    else if(row==2)
    {
        NSString *post=[NSString stringWithFormat:@"#时光胶囊#选取想要的微博,贴上有趣的评论,加上个性主题背景,做成一条精美的长微博！想晒甜蜜,po个性?一次性满足你!APPStore下载:https://itunes.apple.com/us/app/shi-guang-jiao-nang/id621917638?ls=1&mt=8"];
        if([[DataManager sharedDataManager] isWeiboAuthValid])
        {
            UIImage *image=[UIImage imageNamed:@"tuijianwomen.jpg"];
            [[DataManager sharedDataManager].sinaWeiboData postImageStatus:post andImage:image andLat:nil andLong:nil];
            //[SVProgressHUD dismiss];
        }
        else if ([[DataManager sharedDataManager] isRenRenAuthValid])
        {
            UIImage *image=[UIImage imageNamed:@"tuijianwomen.jpg"];
            [[DataManager sharedDataManager].renrenData postImageStatus:post andImage:image];
            //[SVProgressHUD dismiss];
        }
        else {
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
            static NSString *controllerId = @"LoginViewController";
            LoginViewController *l=[storyBoard instantiateViewControllerWithIdentifier:controllerId];        [self presentModalViewController:l animated:YES];
        }
    }
    else if(row==3)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto://simonyy@foxmail.com"]];
    }
   
    
}
#pragma mark 初始化UI
-(void)initNavigationBar
{
    //导航bar
    UINavigationBar *navBar=[[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [navBar setBackgroundImage:[UIImage imageNamed:@"nav-bar.png"] forBarMetrics:UIBarMetricsDefault];
    //导航item
    UINavigationItem *item=[[UINavigationItem alloc] initWithTitle:nil];
    [navBar pushNavigationItem:item animated:YES];
    //返回按钮
    UIButton *returnBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    returnBtn.frame=CGRectMake(0, 0, 40, 40);
    [returnBtn setImage:[UIImage imageNamed:@"change.png"] forState:UIControlStateNormal];
    //return to method?????
    [returnBtn addTarget:self action:@selector(showLeft) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:returnBtn];
    item.leftBarButtonItem=leftBarButtonItem;
    item.title=@"";
    [self.view addSubview:navBar];
    
    PPRevealSideInteractions inter = PPRevealSideInteractionNone;
    inter |= PPRevealSideInteractionContentView;
    self.revealSideViewController.panInteractionsWhenOpened = inter;
    self.revealSideViewController.panInteractionsWhenClosed = inter;
    self.revealSideViewController.tapInteractionsWhenOpened = PPRevealSideInteractionNone;
    
}

- (void) showLeft {
    TimeMenuViewController *c = [[TimeMenuViewController alloc] init];
    [self.revealSideViewController pushViewController:c onDirection:PPRevealSideDirectionLeft withOffset:100.0 animated:YES];
}
@end
