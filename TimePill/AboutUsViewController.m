//
//  AboutUsViewController.m
//  时光胶囊
//
//  Created by Yongry on 13-3-9.
//  Copyright (c) 2013年 Sun Yat-sen University. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController
@synthesize titleView;
@synthesize bar;

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
    //[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"setbackground.png"]]];
    UIImageView *iv=[[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-20, self.view.frame.size.width, self.view.frame.size.height)];
    UIImage *image=[UIImage imageNamed:@"background_noline.png"];
    iv.image=[image stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    [self.view insertSubview:iv atIndex:0];
    [titleView setImage:[UIImage imageNamed:@"about.png"]];
    
    bar=[[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    // bar.backgroundColor = [UIColor clearColor];
    // bar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"nav-bar.png"]];
    [bar setBackgroundImage:[UIImage imageNamed:@"nav-bar.png"] forBarMetrics:UIBarMetricsDefault];
    //导航item
    UINavigationItem *item=[[UINavigationItem alloc] initWithTitle:nil];
    [bar pushNavigationItem:item animated:YES];
    // [item setTitle:@"关于"];
    
    
    
    UIButton *returnBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    returnBtn.frame=CGRectMake(0, 0, 40, 40);
    [returnBtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [returnBtn setImage:[UIImage imageNamed:@"backclick.png"] forState:UIControlEventTouchUpInside];
    [returnBtn addTarget:self action:@selector(ReturnTo) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:returnBtn];
    item.leftBarButtonItem=leftBarButtonItem;
    //item.title=@"关于";
    
    [self.view addSubview:bar];
    
}

- (void)viewDidUnload
{
    [self setTitleView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)ReturnTo{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)visitWeb:(id)sender {
    [SVProgressHUD showWithStatus:@"加载中......"];
    UIWebView *myWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height)];
    NSURL *url = [NSURL URLWithString:@"http://www.applesysu.com/blog/"];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    [myWebView loadRequest:req];
    [SVProgressHUD dismiss];
    
    
    [self.view addSubview:myWebView];
    [self.view addSubview:bar];
}
@end
