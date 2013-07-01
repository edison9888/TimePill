//
//  UIBubbleTableViewCell.h
//
//  Created by yanyu
//


#import <UIKit/UIKit.h>
#import "NSBubbleDataInternal.h"
#import "ImageTextView.h"
#import "ImageTextView.h"
@interface UIBubbleTableViewCell : UITableViewCell
<UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UIImageView *bubbleImage;   // 背景气泡框
    IBOutlet UILabel *timeLabel;  // 时间label
    IBOutlet UIImageView *timeImage;  //时间的背景图
    IBOutlet UIImageView *timeCircleImage;
    IBOutlet UIButton *editButton; //加号
    
    IBOutlet ImageTextView *imageText; //原文
    
    IBOutlet ImageTextView *repostText;
    
    IBOutlet UIImageView *imageForImageText; //原文图片
    IBOutlet UIImageView *imageForRepostTextView; //被转发图片
    
    IBOutlet UIImageView *repostBackgroundView;
    IBOutlet UILabel *WeiboName; //微博名字
    IBOutlet UIImageView *headImage; //头像
    
    
    IBOutlet UIImageView *tucaoBackgroundView;
    IBOutlet UITableView *tTableView;
}

@property (nonatomic, retain) UIView *editView;
@property (nonatomic, retain) UIImageView *editSubview;
@property (nonatomic, retain) UIButton *tucaoButton;
@property (nonatomic, retain) UIButton *deleteButton;
@property (nonatomic, retain) UIButton *commentsButton;
@property (nonatomic, strong) NSBubbleDataInternal *dataInternal;


-(void)addComment;
-(void)onDeleteDiaryButton;

@end
