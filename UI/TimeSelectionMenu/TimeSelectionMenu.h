//
//  TimeSelectionMenu.h
//  Timeline
//
//  Created by 04 developer on 12-10-31.
//  Copyright (c) 2012年 Sun Yat-sen University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeSelectionMenu : UIView

@property (strong, nonatomic) UILabel *startTimeLabel;
@property (strong, nonatomic) UITextField *startTimeField;
@property (strong, nonatomic) UIButton *endTimeButton;

@property (strong, nonatomic) UILabel *endTimeLabel;
@property (strong, nonatomic) UITextField *endTimeField;
@property (strong, nonatomic) UIButton *startTimeButton;

-(id)initWithFrame:(CGRect)frame;

@end
