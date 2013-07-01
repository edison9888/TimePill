//
//  DisplayMaterialViewController.m
//  Timeline
//
//  Created by simon on 12-12-11.
//  Copyright (c) 2012年 Sun Yat-sen University. All rights reserved.
//

#import "DisplayMaterialViewController.h"

@interface DisplayMaterialViewController ()
{
    OrderDisplayViewController *orderVC;
    TimeDisplayViewController *timeVC;
}
@end

@implementation DisplayMaterialViewController
@synthesize type,userId,searchBackground;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initViewController];
    [self initToolBar];
}

#pragma mark 分段控制change
- (void)valueChanged:(id)sender {
	STSegmentedControl *control = sender;
    if(control.selectedSegmentIndex == 0)
    {
       orderVC.view.frame=CGRectMake(0, 0, 320, self.view.bounds.size.height-50);
        [self.view addSubview:orderVC.view];
        [timeVC.view removeFromSuperview];

    }
    else 
    {
        timeVC.view.frame=CGRectMake(0, 0, 320, self.view.bounds.size.height-50);
        [self.view addSubview:timeVC.view];
        [orderVC.view removeFromSuperview];
    }
}
#pragma  makr 初始化UI
-(void)initViewController
{
    orderVC=[[OrderDisplayViewController alloc] init];
    timeVC=[[TimeDisplayViewController alloc] init];
    /*传参*/
    [orderVC setValue:self.type forKey:@"type"];
    [orderVC setValue:self.userId forKey:@"userId"];
    [timeVC setValue:self.type forKey:@"type"];
    [timeVC setValue:self.userId forKey:@"userId"];
}
-(void)initToolBar
{
    /*分段控制背景*/
    UIView *segmentBg=[[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-50, 320, 50)];
    [segmentBg setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"segment_bg.png"]]];
    [self.view addSubview:segmentBg];
    
    /*分段控制*/
    NSArray *objects = [NSArray arrayWithObjects:@" ", @" ", nil];
    STSegmentedControl *segment = [[STSegmentedControl alloc] initWithItems:objects];
	segment.frame = CGRectMake(53, 15, 214 , 30);
	[segment addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
	segment.selectedSegmentIndex = 0;
	segment.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	[segmentBg addSubview:segment];
    
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
