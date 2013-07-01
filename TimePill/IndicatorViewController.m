//
//  StartViewController.m
//  Timeline
//
//  Created by yongry on 12-11-25.
//  Copyright (c) 2012年 Sun Yat-sen University. All rights reserved.
//

#import "IndicatorViewController.h"


@implementation IndicatorViewController


@synthesize pageScroll;
@synthesize pageControl;
@synthesize imageView,gotoMainViewBtn;



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
    
    /*引导图*/
    NSArray *array = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"1.png"],[UIImage imageNamed:@"2.png"],[UIImage imageNamed:@"3.png"],[UIImage imageNamed:@"4.png"],[UIImage imageNamed:@"5.png"],nil];
    
    /*滚动视图*/
    pageScroll=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.bounds.size.height)];
     [self.view addSubview:pageScroll];
    
    self.pageScroll.contentSize = CGSizeMake(self.view.frame.size.width * 5, self.view.frame.size.height);
    self.pageScroll.showsHorizontalScrollIndicator = NO;
    self.pageScroll.pagingEnabled=YES;
    UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
    
    float button_y=self.view.bounds.size.height*(200.0/460.0);
    
    button.frame=CGRectMake(320*4+10,button_y,288,87.5);
    button.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"enter.png"]];
    [button addTarget:self action:@selector(gotoMainView:) forControlEvents:UIControlEventTouchUpInside];
 
    for(int i = 0; i < 5; i++)
    {
        UIImageView *image = [[UIImageView alloc] initWithImage:[array objectAtIndex:i]];
        image.frame = CGRectMake(320 * i, 0, 320, self.view.bounds.size.height);
        
        [pageScroll addSubview:image];
        
    }
    
    float pageControl_y=self.view.bounds.size.height*(424.0/460.0);

    /*分页控制*/
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(125, pageControl_y, 60, 36)];
    pageControl.numberOfPages = 5;
    pageControl.currentPage = 0;
    pageScroll.delegate = self;
    [self.view addSubview:pageControl];
    
    [self.pageScroll addSubview:button];
    
   

}

- (void)viewDidUnload
{

    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
}

-(void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if ([animationID isEqualToString:@"split"] && finished) {
        UIStoryboard *story=[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        UIViewController *FirstViewController=[story instantiateViewControllerWithIdentifier:@"FirstViewController"];
        
        [self presentModalViewController:FirstViewController animated:YES];
        
        
    }  
}

- (IBAction)gotoMainView:(id)sender {
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
   // [self.gotoMainViewBtn setHidden:YES];
    
   // HomePageViewController *controller = [[HomePageViewController alloc] init];
    
  //  [self.view addSubview:controller.view];
    [self.pageScroll setHidden:YES];
   // [self.pageControl setHidden:YES];

    
    [UIView beginAnimations:@"split" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:1];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    
    
    [UIView commitAnimations];
    
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{	
    CGFloat pageWidth = self.view.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
