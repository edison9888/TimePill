//
//  AppDelegate.m
//  TimePill
//
//  Created by yongry on 13-3-16.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) 
    { 
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"]; 
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"]; 
    }
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
        IndicatorViewController *indicatorViewController = [[IndicatorViewController alloc] init];
        self.window.rootViewController = indicatorViewController;
    }else {
        
        
        UIStoryboard *story=[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        UIViewController *firstViewController=[story instantiateViewControllerWithIdentifier:@"FirstViewController"];
        UIViewController *test=[story instantiateViewControllerWithIdentifier:@"testVC"];
        self.window.rootViewController=firstViewController;
        
        
    }
    
    [self.window makeKeyAndVisible];
    
    
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}


/*调用本地微博客户端来授权的时候必须加上下面的代码*/
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [[DataManager sharedDataManager].sinaWeiboData.sinaweibo handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [[DataManager sharedDataManager].sinaWeiboData.sinaweibo handleOpenURL:url];
}

@end
