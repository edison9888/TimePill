//
//  CommentsCell.m
//  Timeline
//
//  Created by simon on 12-12-1.
//  Copyright (c) 2012年 Sun Yat-sen University. All rights reserved.
//

#import "CommentsCell.h"

@implementation CommentsCell
@synthesize commentsLabel,nameLabel,headImage,button;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.commentsLabel=[[ImageTextView alloc] init];
        self.commentsLabel.backgroundColor=[UIColor clearColor];
        self.commentsLabel.font=[UIFont systemFontOfSize:15.0];
        [self addSubview:self.commentsLabel];
        
        self.nameLabel=[[UILabel alloc] init];
        self.nameLabel.backgroundColor=[UIColor clearColor];
        self.nameLabel.font=[UIFont fontWithName:@"Verdana-Bold" size:16];
        [self addSubview:self.nameLabel];
        
        self.headImage=[[UIImageView alloc] initWithFrame:CGRectMake(10+50, 7, 40, 40)];
        self.headImage.layer.cornerRadius=8.0;
        self.headImage.layer.masksToBounds=YES;
        
        [self addSubview:self.headImage];
        
        self.button=[UIButton buttonWithType:UIButtonTypeCustom];
        
        ///[self addSubview:self.button];
        //NSLog(@"%d",[[self subviews] count]);
        [self insertSubview:self.button atIndex:5];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFrame:(CGRect)frame
{
    //frame.origin.x += 50;
    frame.size.width += 50;
    [super setFrame:frame];
}
@end
