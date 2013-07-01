//
//  UIBubbleTableViewDataSource.h
//
//  Created by yanyu
//

#import <Foundation/Foundation.h>

@class NSBubbleData;
@class UIBubbleTableView;
@protocol UIBubbleTableViewDataSource <NSObject>

@optional

@required

//返回数据的size
- (NSInteger)rowsForBubbleTable:(UIBubbleTableView *)tableView;
//返回具体数据
- (NSBubbleData *)bubbleTableView:(UIBubbleTableView *)tableView dataForRow:(NSInteger)row;
//下拉时更新的函数
- (void)upDate;
@end
