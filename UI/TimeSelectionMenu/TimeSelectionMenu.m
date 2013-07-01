//
//  TimeSelectionMenu.m
//  Timeline
//
//  Created by 04 developer on 12-10-31.
//  Copyright (c) 2012年 Sun Yat-sen University. All rights reserved.
//

#import "TimeSelectionMenu.h"

@implementation TimeSelectionMenu
@synthesize startTimeLabel;
@synthesize startTimeField;
@synthesize startTimeButton;
@synthesize endTimeLabel;
@synthesize endTimeField;
@synthesize endTimeButton;


- (id) initWithFrame:(CGRect)frame{
    if (self = [super init]) {
        self.frame = frame;
        /**
         * setting of the start time session
         */
        self.startTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.origin.x + 10, frame.origin.y + 10, 10, 10)];
        [self.startTimeLabel setText:@"开始日期"];
        
        /**
         * setting of the end time session
         */
        self.endTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.origin.x + 10, frame.origin.y + 50, 10, 10)];
        [self.endTimeLabel setText:@"结束日期"];
    }
    return self;
}
@end

