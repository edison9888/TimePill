//
//  UIBubbleTableView.h
//
//  Created by yanyu
//

#import <UIKit/UIKit.h>

#import "UIBubbleTableView.h"
#import "UIBubbleTableViewCell.h"
#import "UIBubbleTableViewDataSource.h"
#import "NSBubbleData.h"

@interface UIBubbleTableView : UITableView <UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UIBubbleTableViewCell *bubbleCell;
    
}

@property (nonatomic, retain) UIView *headerView;

@property (nonatomic, assign) id<UIBubbleTableViewDataSource> bubbleDataSource;


@end
