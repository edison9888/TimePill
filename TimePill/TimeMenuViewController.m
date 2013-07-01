//
//  TimeMenuViewController.m
//  Timeline
//
//  Created by ddling on 12-11-15.
//  Copyright (c) 2012年 Sun Yat-sen University. All rights reserved.
//

#import "TimeMenuViewController.h"
#import "PMCalendar.h"
#include "HallViewController.h"

@interface TimeMenuViewController()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *slideTableview;
    NSArray *titles;
    int selected;
    int lastselected;
}
@end

@implementation TimeMenuViewController

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initBackground];
    [self initTableview];
    //NSLog(@"viewDidLoad");
    /*
    CGRect viewFrame = CGRectMake(self.view.frame.origin.x+20, self.view.frame.origin.y,
                                  180, self.view.frame.size.height);
    [self.view setFrame:viewFrame];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"date_bg.png"]]];
    timeChoice = [[NSArray alloc] initWithObjects:@"时间轴", @"时光画廊", @"系统设置", nil];
    UIButton *button;
    CGRect buttonFrame = CGRectMake(self.view.frame.origin.x+30, self.view.frame.size.height-180,
                                    self.view.frame.size.width-60, 50);
    for(int i = 0; i < [timeChoice count]; i++){
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=buttonFrame;
        [button setBackgroundImage:[UIImage imageNamed:@"date_click.png"] forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font=[UIFont fontWithName:@"Arial-BoldMT" size:22];
        //button.titleLabel.text=[self.timeChoice objectAtIndex:i];
        button.titleLabel.textAlignment=UITextAlignmentLeft;
        button.titleLabel.textColor=[UIColor whiteColor];
        [button setTitle:[self.timeChoice objectAtIndex:i] forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(timeSelected:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        [buttons addObject:button];
        [self.view addSubview:button];
        buttonFrame.origin.y += buttonFrame.size.height;
    }
     */
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark UITableviewDatasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"slideCell";
    
    UITableViewCell *cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    // label
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(20, 10, 100, 30)];
    [label setFont:[UIFont boldSystemFontOfSize:16.0]];
    [label setTextColor:[UIColor whiteColor]];
    label.text=[titles objectAtIndex:[indexPath row]];
    label.backgroundColor=[UIColor clearColor];
    [cell.contentView addSubview:label];
    
    // arrow
    UIImageView *arrow=[[UIImageView alloc] initWithFrame:CGRectMake(180, 16.25, 11, 17.5)];
    arrow.image=[UIImage imageNamed:@"arrowright.png"];
    [cell.contentView addSubview:arrow];
    
    // background
    if([indexPath row]==selected)
    {
        cell.contentView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"slidebar_clicked.png"]];
    }
    else
    {
        cell.contentView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"slidebar_unclicked.png"]];
    }

    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return  cell;
}
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 44;
//}
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *header=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
//    header.backgroundColor=[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
//    /*UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(20, 10, 100, 30)];
//    [label setFont:[UIFont boldSystemFontOfSize:15.0]];
//    [label setTextColor:[UIColor whiteColor]];
//    label.text=@"菜单:";
//    label.backgroundColor=[UIColor clearColor];
//    [header addSubview:label];*/
//    
//    return header;
//}
#pragma mark Dategate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selected=[indexPath row];
    [[NSUserDefaults standardUserDefaults] setInteger:selected forKey:@"selected"];
    UITableViewCell *cell=[slideTableview cellForRowAtIndexPath:indexPath];
    cell.contentView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"slidebar_clicked.png"]];
    if(selected!=lastselected)
    {
        NSIndexPath *indexpath=[NSIndexPath indexPathForRow:lastselected inSection:0];
        cell=[slideTableview cellForRowAtIndexPath:indexpath];
        cell.contentView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"slidebar_unclicked.png"]];
        lastselected=[indexPath row];
        [[NSUserDefaults standardUserDefaults] setInteger:lastselected forKey:@"lastselected"];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"timePassing" object:[NSString stringWithFormat:@"%d",selected]];
    
}
-(void)initBackground
{
    self.view.backgroundColor=[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
    float height=self.view.frame.size.height-124.0;
    UIImageView *katong=[[UIImageView alloc] initWithFrame:CGRectMake(-32, height, 160, 160)];
    katong.image=[UIImage imageNamed:@"jiaonangkatong.png"];
    [self.view addSubview:katong];
}
-(void)initTableview
{
    slideTableview=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 150)];
    slideTableview.delegate=self;
    slideTableview.dataSource=self;
    slideTableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    slideTableview.scrollEnabled=NO;
    [self.view addSubview:slideTableview];
    
    selected=[[NSUserDefaults standardUserDefaults] integerForKey:@"selected"];
    lastselected=[[NSUserDefaults standardUserDefaults] integerForKey:@"lastselected"];
    
    titles=[[NSArray alloc] initWithObjects:@"我的时间轴",@"时光画廊",@"设置", nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)timeSelected:(UIButton *)sender{
    //NSLog(@"this is the tag, %d",sender.tag);
    /*FirstViewController接受通知，然后跳转到响应controller*/
    [[NSNotificationCenter defaultCenter] postNotificationName:@"timePassing" object:[NSString stringWithFormat:@"%d",sender.tag]];

}

@end
