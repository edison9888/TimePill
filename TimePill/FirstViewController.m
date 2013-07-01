//
//  FirstViewController.m
//  Timeline
//
//  Created by ddling on 12-11-15.
//  Copyright (c) 2012年 Sun Yat-sen University. All rights reserved.
//

#import "FirstViewController.h"
#import "ViewController.h"

@interface FirstViewController()
{
    int currentIndex;
}

@property (nonatomic, strong) PMCalendarController *pmCC;

@end

@implementation FirstViewController
@synthesize pmCC;
@synthesize timeSelectionMenu;
@synthesize timeMenuViewController;
@synthesize revealSideViewController = _revealSideViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView
 {
 }
 */


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //self.view.backgroundColor=[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeRootViewController:) name:@"timePassing" object:nil];
    
    HomePageViewController *homePageVC=[[HomePageViewController alloc] init];
    _revealSideViewController = [[PPRevealSideViewController alloc] initWithRootViewController:homePageVC];
    _revealSideViewController.delegate = self;
    
    [self.view addSubview:_revealSideViewController.view];
    
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"selected"];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"lastselected"];
    
    currentIndex=0;
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
  //  NSLog(@"First-viewDidAppear");
}
-(void)changeRootViewController:(NSNotification *)note{
    [SVProgressHUD dismiss];
    NSString *str = note.object;
    NSInteger index = [str intValue];
    
    if(index==currentIndex)
    {
        [_revealSideViewController popViewControllerAnimated:YES];
    }
    else
    {
        if(index == 0){
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
            static NSString *controllerId = @"homeController";
            HomePageViewController *homePageViewController = [storyBoard instantiateViewControllerWithIdentifier:controllerId];
            _revealSideViewController.rootViewController=homePageViewController;
            //[_revealSideViewController popViewControllerWithNewCenterController:homePageViewController animated:YES];
            currentIndex=0;

        }
        //时间画廊
        else if(index == 1){
            //类似view did load方法加入时间画廊的controller
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
            static NSString *hallControlelrId = @"hallViewController";
            HallViewController *hallViewController = [storyBoard instantiateViewControllerWithIdentifier:hallControlelrId];
            //_revealSideViewController.rootViewController=hallViewController;
            //[_revealSideViewController popViewControllerWithNewCenterController:hallViewController animated:YES];
            _revealSideViewController.rootViewController=hallViewController;
            currentIndex=1;
            
        }
        //设置页面
        else if(index == 2){
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
            static NSString *settingControlelrId = @"settingViewController";
            SettingViewController *settingViewController = [storyBoard instantiateViewControllerWithIdentifier:settingControlelrId];
            _revealSideViewController.rootViewController=settingViewController;
            //[_revealSideViewController popViewControllerWithNewCenterController:settingViewController animated:YES];
            currentIndex=2;
        }

    }
}
#pragma mark - PPRevealSideViewController delegate

- (void) pprevealSideViewController:(PPRevealSideViewController *)controller willPushController:(UIViewController *)pushedController {
    
}

- (void) pprevealSideViewController:(PPRevealSideViewController *)controller didPushController:(UIViewController *)pushedController {
    
}

- (void) pprevealSideViewController:(PPRevealSideViewController *)controller willPopToController:(UIViewController *)centerController {
    
}

- (void) pprevealSideViewController:(PPRevealSideViewController *)controller didPopToController:(UIViewController *)centerController {
    
}

- (void) pprevealSideViewController:(PPRevealSideViewController *)controller didChangeCenterController:(UIViewController *)newCenterController {
    
}

- (BOOL) pprevealSideViewController:(PPRevealSideViewController *)controller shouldDeactivateDirectionGesture:(UIGestureRecognizer*)gesture forView:(UIView*)view {
    return NO;
}

- (PPRevealSideDirection)pprevealSideViewController:(PPRevealSideViewController*)controller directionsAllowedForPanningOnView:(UIView*)view {
    
    // if ([view isKindOfClass:NSClassFromString(@"UIWebBrowserView")]) return PPRevealSideDirectionLeft | PPRevealSideDirectionRight;
    
    // return PPRevealSideDirectionLeft | PPRevealSideDirectionRight | PPRevealSideDirectionTop | PPRevealSideDirectionBottom;
    return  PPRevealSideDirectionLeft;
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



@end
