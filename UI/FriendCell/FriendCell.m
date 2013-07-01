//
//  FriendCell.m
//  Timeline
//
//  Created by yongry on 12-11-12.
//  Copyright (c) 2012年 Sun Yat-sen University. All rights reserved.
//

#import "FriendCell.h"

@implementation FriendCell

@synthesize headView = _headView;
@synthesize nameLabel = _nameLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
