//
//  FriendsListViewController.m
//  Timeline
//
//  Created by 04 developer on 12-10-24.
//  Copyright (c) 2012年 Sun Yat-sen University. All rights reserved.
//

#import "FriendsListViewController.h"


@implementation FriendsListViewController

@synthesize FriendsListTableView;
@synthesize searchBar;
@synthesize friends;
@synthesize type;
@synthesize userId;
@synthesize searchResults;
@synthesize queue;

-(void)viewWillAppear:(BOOL)animated
{
    [self.FriendsListTableView setDelegate:nil];
    [self.FriendsListTableView setDataSource:nil];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.FriendsListTableView.scrollEnabled = YES;
    // [self.searchDisplayController setDelegate:self];
    self.queue=[[NSOperationQueue alloc] init];
    searchResults=[[NSMutableArray alloc] init];
    /*     if(self.type == @"renren"){
     [[[DataManager sharedDataManager] renrenData] ToLogin];
     [[DataManager sharedDataManager] getRenrenFriendList];
     }
     else{
     //
     
     [[DataManager sharedDataManager] getSinaFriendList];
     }*/
    
    if([self.type isEqualToString:@"renren"])
        [[DataManager sharedDataManager] friendsInfo:2];
    else{
        [[DataManager sharedDataManager] friendsInfo:1];
    }
    
    
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"choosefriend_bg.png"]]];
    UINavigationBar *bar=[[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [bar setBackgroundImage:[UIImage imageNamed:@"xuanzehaoyou.png"] forBarMetrics:UIBarMetricsDefault];
    //导航item
    UINavigationItem *item=[[UINavigationItem alloc] initWithTitle:nil];
    [bar pushNavigationItem:item animated:YES];
    
    
    UIButton *returnBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    returnBtn.frame=CGRectMake(0, 0, 40, 40);
    [returnBtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [returnBtn setImage:[UIImage imageNamed:@"backclick.png"] forState:UIControlEventTouchUpInside];
    [returnBtn addTarget:self action:@selector(ReturnTo) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:returnBtn];
    item.leftBarButtonItem=leftBarButtonItem;
    [item release];
    [returnBtn release];
    [self.view addSubview:bar];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showFriends:) name:@"weibo_friends" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showFriends:) name:@"renren_friends" object:nil];
    
    
    
}

- (void)resetSearch {
    [self.searchResults removeAllObjects];
    //  [self.FriendsListTableView reloadData];
    
	[self.searchResults addObjectsFromArray:self.friends];
    [self.FriendsListTableView reloadData];
    //NSLog(@"%d,%d",[friends count], [searchResults count]);
}

- (void)handleSearchForTerm:(NSString *)searchTerm
{
    [self.searchResults removeAllObjects];
    
    if (searchTerm == nil) {
        [self resetSearch];
    }
    else
        for (NSDictionary *key in self.friends) {
            
            
            if ([[key valueForKey:@"name"]  rangeOfString:searchTerm
                                                  options:NSCaseInsensitiveSearch].location != NSNotFound)
            {
                [searchResults addObject:key];
                //NSLog(@"%@  %@",[key valueForKey:@"name"],[key valueForKey:@"idstr"]);
            }
        }
   // NSLog(@"here here %d",[self.searchResults count]);
    
    [self.FriendsListTableView reloadData];
}



- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchTerm
{
    //    if ([searchTerm length] == 0)
    //    {
    //    //    [self resetSearch];
    //    //    [self.FriendsListTableView reloadData];
    //        return;
    //    }
    [self handleSearchForTerm:searchTerm];
    
}
- (void)viewDidUnload
{
    [self setFriendsListTableView:nil];
    // [self setSearchDisplayController:nil];
    [self setSearchBar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(void)showFriends:(NSNotification *)note
{
    self.friends = note.object;
    NSLog(@"friends=%d",[self.friends count]);
    [self.searchResults addObjectsFromArray:self.friends];
    [self.FriendsListTableView setDelegate:self];
    [self.FriendsListTableView setDataSource:self];
    [self.FriendsListTableView reloadData];
}

#pragma mark -
#pragma mark table view delegate method

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger rows = 0;
    
    rows = [self.searchResults count];
    return rows;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"here%d",[self.searchResults count]);
    
    static NSString *identifier = @"friendCell";
    FriendCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        cell = [[FriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if([self.type isEqualToString:@"renren"]){
        
        NSString *string = [[NSString alloc] initWithString:[[searchResults objectAtIndex:indexPath.row] valueForKey:@"tinyurl"]];
        
        UIImage *image = [UIImage imageNamed:@"picLoading.png"];
        [cell.headView setImage:image];
        
        HeadPicDownloader *downloader=[[HeadPicDownloader alloc] initWithURLString:string];
        downloader.delegate=self;
        downloader.indexpath=indexPath;
        [self.queue addOperation:downloader];
        
        cell.headView.frame=CGRectMake(10, 5, 50, 50);
        cell.headView.layer.cornerRadius=8.0;
        cell.headView.layer.masksToBounds=YES;
        cell.nameLabel.text = [[searchResults objectAtIndex:indexPath.row] valueForKey:@"name"];
        cell.nameLabel.font=[UIFont systemFontOfSize:18];
        
    }
    if([self.type isEqualToString:@"sina"]){
        NSString *string = [[NSString alloc] initWithString:[[searchResults objectAtIndex:indexPath.row] valueForKey:@"profile_image_url"]];
        UIImage *image = [UIImage imageNamed:@"picLoading.png"];
        [cell.headView setImage:image];
        
        HeadPicDownloader *downloader=[[HeadPicDownloader alloc] initWithURLString:string];
        downloader.delegate=self;
        downloader.indexpath=indexPath;
        [self.queue addOperation:downloader];
        
        cell.headView.frame=CGRectMake(10, 5, 50, 50);
        cell.headView.layer.cornerRadius=8.0;
        cell.headView.layer.masksToBounds=YES;
        cell.nameLabel.text = [[searchResults objectAtIndex:indexPath.row] valueForKey:@"screen_name"];
        NSLog(@"%@",cell.nameLabel.text);
        cell.nameLabel.font=[UIFont systemFontOfSize:18];
    }
    
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"selectedType" object:self.type];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"friendName" object:[self.friends objectAtIndex:indexPath.row]];
    
    /*选择了一个好友之后*/
    if([self.type isEqualToString:@"sina"])
    {
        /*为userId赋值*/
        userId=[[self.searchResults objectAtIndex:indexPath.row] objectForKey:@"idstr"];
        /*将该人物存入数据库*/
        NSString *imageUrl=[[self.searchResults objectAtIndex:indexPath.row] objectForKey:@"profile_image_url"];
        NSString *name=[[self.searchResults objectAtIndex:indexPath.row] objectForKey:@"screen_name"];
        NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
        [dic setValue:userId forKey:@"userId"];
        [dic setValue:type forKey:@"type"];
        [dic setValue:imageUrl forKey:@"imageUrl"];
        [dic setValue:name forKey:@"name"];
        [dic setValue:[NSNumber numberWithInt:1] forKey:@"times"];
        [[DataClient shareClient] addRecentContacts:dic];
        
    }
    else {
        NSDecimalNumber * temp=[[self.searchResults objectAtIndex:indexPath.row] objectForKey:@"id"];
        userId=[NSString stringWithFormat:@"%@",temp];
        NSLog(@"userId renren %@ %@",temp,userId);
        /*将该人物存入数据库*/
        NSString *imageUrl=[[self.searchResults objectAtIndex:indexPath.row] objectForKey:@"headurl"];
        NSString *name=[[self.searchResults objectAtIndex:indexPath.row] objectForKey:@"name"];
        NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
        [dic setValue:userId forKey:@"userId"];
        [dic setValue:type forKey:@"type"];
        [dic setValue:imageUrl forKey:@"imageUrl"];
        [dic setValue:name forKey:@"name"];
        [dic setValue:[NSNumber numberWithInt:1] forKey:@"times"];
        [[DataClient shareClient] addRecentContacts:dic];
    }
    [self performSegueWithIdentifier:@"ToDisplayFromFriend" sender:self];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqual:@"ToDisplayFromFriend"])
    {
        id destination=segue.destinationViewController;
        [destination setValue:self.type forKey:@"type"];
        [destination setValue:self.userId forKey:@"userId"];
    }
}

/*---------------------
 委托方法
 ---------------------*/
- (void)imageDidFinished:(UIImage *)image para:(NSIndexPath *)indexpath
{
    FriendCell *cell=(FriendCell *)[self.FriendsListTableView cellForRowAtIndexPath:indexpath];
    cell.headView.image=image;
    [cell setNeedsDisplay];
}


-(void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope{
    NSLog(@"friend  %@",searchText);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", searchText];
    self.searchResults =
    [NSMutableArray arrayWithArray:[self.friends filteredArrayUsingPredicate:predicate]];
    [self.FriendsListTableView reloadData];
    NSLog(@"%@",self.searchResults);
}




-(void)ReturnTo{
    [SVProgressHUD dismiss];
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
