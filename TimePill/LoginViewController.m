//
//  LoginViewController.m
//  Timeline
//
//  Created by 03 developer on 12-11-7.
//  Copyright (c) 2012年 Sun Yat-sen University. All rights reserved.
//

#import "LoginViewController.h"
#import "DataManager.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize weiboButton;
@synthesize renrenButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIImageView *iv=[[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-20, self.view.frame.size.width, self.view.frame.size.height)];
    UIImage *image=[UIImage imageNamed:@"background_noline.png"];
    iv.image=[image stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    [self.view insertSubview:iv atIndex:0];
    
    UINavigationBar *bar=[[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [bar setBackgroundImage:[UIImage imageNamed:@"denglu.png"] forBarMetrics:UIBarMetricsDefault];
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
    [self.view addSubview:bar];
    
    [[DataManager sharedDataManager].sinaWeiboData ToLogout];
    [[DataManager sharedDataManager].renrenData ToLogout];
    
    /*---------监听登陆成功的通知-----------*/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WeiboDidLogin:) name:@"weibologinsuccess" object:nil ];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RenRenDidLogin:) name:@"renrenloginsuccess" object:nil ];
}
-(void)ReturnTo
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)WeiboDidLogin:(NSNotification *)note
{
    /*微博登陆成功后隐藏登陆按钮，再检测如果人人也登陆了，就退出该页面*/
   [weiboButton setHidden:YES];
    if([[DataManager sharedDataManager] isRenRenAuthValid])
        [self dismissModalViewControllerAnimated:YES];
}

-(void)RenRenDidLogin:(NSNotification *)note
{
    [renrenButton setHidden:YES];
    if([[DataManager sharedDataManager] isWeiboAuthValid])
        [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [self setWeiboButton:nil];
    [self setRenrenButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)loginFromWeibo:(id)sender {
    //login
    //load data, maybe send a notification
    [[[DataManager sharedDataManager] sinaWeiboData] ToLogin];
}

- (IBAction)loginFromRenren:(id)sender {
    [[[DataManager sharedDataManager] renrenData] ToLogin];
}
@end
