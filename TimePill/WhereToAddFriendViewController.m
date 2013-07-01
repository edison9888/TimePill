//
//  WhereToAddFriendViewController.m
//  Timeline
//
//  Created by 04 developer on 12-10-24.
//  Copyright (c) 2012年 Sun Yat-sen University. All rights reserved.
//

#import "WhereToAddFriendViewController.h"
#define kSCNavBarImageTag 10

@implementation WhereToAddFriendViewController
@synthesize sinaButton = _sinaButton;
//@synthesize navigationBar = _navigationBar;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *iv=[[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-20, self.view.frame.size.width, self.view.frame.size.height)];
    UIImage *image=[UIImage imageNamed:@"background_noline.png"];
    iv.image=[image stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    [self.view insertSubview:iv atIndex:0];
    
    UINavigationBar *bar=[[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [bar setBackgroundImage:[UIImage imageNamed:@"addfriend.png"] forBarMetrics:UIBarMetricsDefault];
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
    
}

-(void)ReturnTo
{
    [self dismissModalViewControllerAnimated:YES];
}
- (void)viewDidUnload
{
    
    [self setSinaButton:nil];
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    id segue2 = segue.destinationViewController;
    
    if([segue.identifier isEqual:@"loadFromSina" ])
    {
        [segue2 setValue:@"sina" forKey:@"type"];
        
    }
    else {
         [segue2 setValue:@"renren" forKey:@"type"];
       
        
    }
}
- (IBAction)loadWeiboFriends:(id)sender {
    if(![[DataManager sharedDataManager] isWeiboAuthValid])
        [[[DataManager sharedDataManager] sinaWeiboData] ToLogin];
    else {
        [self performSegueWithIdentifier:@"loadFromSina" sender:self];
    }
}

- (IBAction)loadRenrenFriends:(id)sender {
    if(![[DataManager sharedDataManager] isRenRenAuthValid])
        [[[DataManager sharedDataManager] renrenData] ToLogin];
    else {
        [self performSegueWithIdentifier:@"loadFromRenren" sender:self];
    }
}
@end
