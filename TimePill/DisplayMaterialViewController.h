//
//  DisplayMaterialViewController.h
//  Timeline
//
//  Created by simon on 12-12-11.
//  Copyright (c) 2012年 Sun Yat-sen University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderDisplayViewController.h"
#import "TimeDisplayViewController.h"
#import "STSegmentedControl.h"


@interface DisplayMaterialViewController : UIViewController 


@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *userId;

@property(nonatomic, retain) UIView *searchBackground;

@end
