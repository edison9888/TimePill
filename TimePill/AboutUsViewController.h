//
//  AboutUsViewController.h
//  时光胶囊
//
//  Created by Yongry on 13-3-9.
//  Copyright (c) 2013年 Sun Yat-sen University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutUsViewController : UIViewController
- (IBAction)visitWeb:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *titleView;
@property (strong, nonatomic)UINavigationBar *bar;

@end
