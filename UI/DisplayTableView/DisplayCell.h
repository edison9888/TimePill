//
//  DisplayCell.h
//  Timeline
//
//  Created by simon on 12-12-13.
//  Copyright (c) 2012年 Sun Yat-sen University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageTextView.h"

@interface DisplayCell : UITableViewCell

@property(retain,nonatomic) UIButton *radioButton;
@property(retain,nonatomic) ImageTextView *textView;
@property(retain,nonatomic) ImageTextView *repostView;
@property(retain,nonatomic) UIImageView *imageView;
@property(retain,nonatomic) UIImageView *repostImage;
@property(retain,nonatomic) UILabel *repostName;
@property(retain,nonatomic) UIImageView *repostBackgroundView;
@property(retain,nonatomic) UILabel *timeLabel;
@end
