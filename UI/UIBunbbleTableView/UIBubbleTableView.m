//
//  UIBubbleTableView.m
//
//  Created by yanyu
//

#import "UIBubbleTableView.h"
#import "NSBubbleData.h"
#import "NSBubbleDataInternal.h"

#define DEFAULT_HEIGHT_OFFSET 52.0f

@interface UIBubbleTableView ()
@property (nonatomic, retain) NSMutableArray *bubbleArray;

@end

@implementation UIBubbleTableView

@synthesize bubbleDataSource = _bubbleDataSource;
@synthesize bubbleArray = _bubbleArray;

#pragma mark - Initializators

- (void)initializator
{
    // UITableView properties
    
    self.backgroundColor = [UIColor clearColor];
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    assert(self.style == UITableViewStylePlain);
    
    self.delegate = self;
    self.dataSource = self;   
}

- (id)init
{
    self = [super init];
    if (self) [self initializator];
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) [self initializator];
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) [self initializator];
    return self;
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:UITableViewStylePlain];
    if (self) [self initializator];
    return self;
}


- (void)dealloc
{
	_bubbleArray = nil;
	_bubbleDataSource = nil;
}

#pragma mark - Override

//tableView第一次显示的时候，我们需要调用其reloadData方法，强制刷新一次
- (void)reloadData  // 主要负责计算height
{
    // Cleaning up
	self.bubbleArray = nil;
    
    // Loading new data
    int count = 0;
    if (self.bubbleDataSource && (count = [self.bubbleDataSource rowsForBubbleTable:self]) > 0)
    {
        self.bubbleArray = [[NSMutableArray alloc] init];
        NSMutableArray *bubbleData = [[NSMutableArray alloc] initWithCapacity:count];
        //从bubbleDataSource的委托方法中返回NSBubbleData对象，全部加到bubbleData中
        for (int i = 0; i < count; i++)
        {
            NSObject *object = [self.bubbleDataSource bubbleTableView:self dataForRow:i];
            assert([object isKindOfClass:[NSBubbleData class]]);
            [bubbleData addObject:object];
        }
        
        UIImage *bianjikuangImage = [UIImage imageNamed:@"bianjikuang.png"];
        UIImage *editButtonImage = [UIImage imageNamed:@"bianji.png"];
        for (int i = 0; i < count; i++)
        {
            // 把之前得到的 NSBubbleData 封装成 NSBubbleDataInternal
            
            NSBubbleDataInternal *dataInternal = [[NSBubbleDataInternal alloc] init];
            dataInternal.data = (NSBubbleData *)[bubbleData objectAtIndex:i];
            
            // 计算height
            dataInternal.labelSize = [(dataInternal.data.text ? dataInternal.data.text : @"") sizeWithFont:[UIFont systemFontOfSize:16.0] constrainedToSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width - 110, 9999) lineBreakMode:UILineBreakModeWordWrap];
            
            dataInternal.originLabelSize = [(dataInternal.data.origin_text ? dataInternal.data.origin_text : @"") sizeWithFont:[UIFont systemFontOfSize:15.0] constrainedToSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width - 120, 9999) lineBreakMode:UILineBreakModeWordWrap];
            
            dataInternal.barButtonSize = CGSizeMake(editButtonImage.size.height - 20, editButtonImage.size.height - 20);
            
            float textImageHeight = 0.0f;
            if(dataInternal.data.text_image != nil){
                textImageHeight = dataInternal.data.text_image.size.height + 20.0f;
            }
            
            float originTextImageHeight = 0.0f;
            if(dataInternal.data.origin_text_image != nil){
                originTextImageHeight = dataInternal.data.origin_text_image.size.height + 20.0f;
            }
            
            float fourHeight = dataInternal.labelSize.height + dataInternal.originLabelSize.height + textImageHeight + originTextImageHeight;
            
            if(dataInternal.data.origin_text != nil){
                fourHeight += 30.0f;
            }
            if(dataInternal.data.origin_text_image != nil)
                fourHeight += 30.0f;
            float totalHeight = fourHeight > bianjikuangImage.size.height - 20 ? fourHeight : bianjikuangImage.size.height - 20;
            
            /*---------------------设置评论框高度----------------------------*/
            if(dataInternal.data.comments == nil)
                dataInternal.shouldTucaoShow = NO;
            else
                dataInternal.shouldTucaoShow = YES;
            CGFloat tucaoHeight = 0.0f;
            CGFloat commentsHeight = 0.0f;
            
            UIFont *commentFont=[UIFont systemFontOfSize:13.0];
            
            if(dataInternal.shouldTucaoShow){
                //设置评论高度
                if(dataInternal.data.comments != nil){
                    for(NSDictionary *comment in dataInternal.data.comments){
                        NSString *nameStr = [comment valueForKey:@"name"];
                        CGSize nameSize=[nameStr sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(110, 1000) lineBreakMode:UILineBreakModeWordWrap];
                        
                        NSString *commentStr = [comment valueForKey:@"text"];
                        CGSize commentSize=[commentStr sizeWithFont:commentFont constrainedToSize:CGSizeMake(110, 1000) lineBreakMode:UILineBreakModeWordWrap];
                        
                        //包括名字的！！！！
                        commentsHeight += nameSize.height+commentSize.height+15.0;
                    }
                }
            }
            dataInternal.commentsSize = CGSizeMake(150, commentsHeight);
            
            // 设置height，高度由5部分组成：原文，转发文，原图，转发图，加号; 55.0f代表加号,50.0f代表空隙
            // 后加上吐槽和评论的总高度
            dataInternal.height = totalHeight + 55.0f + 50.0f + dataInternal.tucaoSize.height + dataInternal.commentsSize.height;
            
            // 把封装好的NSBubbleDataInternal对象加到_bubbleArray中
            [self.bubbleArray addObject:dataInternal];
        }
    }
    [super reloadData];
}


#pragma mark - UITableViewDelegate implementation

#pragma mark - UITableViewDataSource implementation

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.bubbleArray count];
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSBubbleDataInternal *dataInternal = ((NSBubbleDataInternal *)[self.bubbleArray objectAtIndex:indexPath.row]);
    
    return dataInternal.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"cellForRowAtIndexPath");
    static NSString *cellId = @"tblBubbleCell";
    
    //从数组取出NSBubbleDataInternal
    NSBubbleDataInternal *dataInternal = ((NSBubbleDataInternal *)[self.bubbleArray objectAtIndex:indexPath.row]);
    
    UIBubbleTableViewCell *cell = (UIBubbleTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil)
    {
        [[NSBundle mainBundle] loadNibNamed:@"UIBubbleTableViewCell" owner:self options:nil];
        cell = bubbleCell;
    }
    cell.dataInternal = dataInternal;
    cell.tag=[indexPath row];
    return cell;
}

@end
