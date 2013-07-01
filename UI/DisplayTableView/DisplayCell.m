//
//  DisplayCell.m
//  Timeline
//
//  Created by simon on 12-12-13.
//  Copyright (c) 2012年 Sun Yat-sen University. All rights reserved.
//

#import "DisplayCell.h"

@implementation DisplayCell
@synthesize radioButton,textView,repostView,imageView,repostImage,repostName,repostBackgroundView,timeLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        /*背景色块*/
        self.repostBackgroundView=[[UIImageView alloc] initWithFrame:CGRectZero];
        self.repostBackgroundView.alpha=0.5;
        [self addSubview:self.repostBackgroundView];
        /*选择按钮*/
        self.radioButton=[UIButton buttonWithType:UIButtonTypeCustom];
        self.radioButton.frame=CGRectMake(5, 10, 25, 25);
        [self addSubview:self.radioButton];
        /*文本*/
        self.textView=[[ImageTextView alloc] initWithFrame:CGRectMake(40, 10, 270, 30)];
        self.textView.backgroundColor=[UIColor clearColor];
        self.textView.font=[UIFont systemFontOfSize:16.0];
        [self addSubview:self.textView];
        /*转发文本*/
        self.repostView=[[ImageTextView alloc] init];
        self.repostView.backgroundColor=[UIColor clearColor];
        self.repostView.font=[UIFont systemFontOfSize:15.0];
        [self addSubview:self.repostView];
        /*原图*/
        self.imageView=[[UIImageView alloc] init];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.imageView];
        /*转发图*/
        self.repostImage=[[UIImageView alloc] init];
        self.repostImage.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.repostImage];
        /*转发者名字*/
        repostName=[[UILabel alloc] init];
        repostName.backgroundColor=[UIColor clearColor];
        repostName.textColor=[UIColor colorWithRed:81.0/255.0 green:108.0/255.0 blue:151.0/255.0 alpha:1.0];
        [self addSubview:self.repostName];
        self.timeLabel=[[UILabel alloc] init];
        self.timeLabel.font=[UIFont systemFontOfSize:12.0];
        self.timeLabel.textColor=[UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:1.0];
        self.timeLabel.textAlignment=UITextAlignmentLeft;
        self.timeLabel.backgroundColor=[UIColor clearColor];
        [self addSubview:self.timeLabel];

        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
