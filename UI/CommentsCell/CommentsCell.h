//
//  CommentsCell.h
//  Timeline
//
//  Created by simon on 12-12-1.
//  Copyright (c) 2012年 Sun Yat-sen University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageTextView.h"
@interface CommentsCell : UITableViewCell

@property (strong,nonatomic) UIImageView *headImage;
@property (strong,nonatomic) UILabel *nameLabel;
@property (strong,nonatomic) ImageTextView *commentsLabel;
@property (strong,nonatomic) UIButton *button;

@end
