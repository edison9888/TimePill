//
//  UIBubbleTableViewCell.m
//
//  Created by yanyu
//


#import "UIBubbleTableViewCell.h"
#import "NSBubbleData.h"
#import "ImageTextView.h"

@interface UIBubbleTableViewCell ()
@property (nonatomic) BOOL isEditSubviewShow;
@property (nonatomic) CALayer *shadowLayer;
- (void) setupInternalData;
@end

@implementation UIBubbleTableViewCell

@synthesize dataInternal = _dataInternal;
@synthesize editSubview;
@synthesize tucaoButton;
@synthesize deleteButton;
@synthesize isEditSubviewShow;
@synthesize commentsButton;
@synthesize editView;
@synthesize shadowLayer;

//每实例化一次Cell就会调用一次此方法
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
	[self setupInternalData];
    
}

- (void) dealloc
{
	_dataInternal = nil;
    tucaoButton = nil;
    deleteButton = nil;
    commentsButton=nil;
    editSubview = nil;
    editButton = nil;
}


- (void)setDataInternal:(NSBubbleDataInternal *)value
{
	_dataInternal = value;
	[self setupInternalData];
}

//每当实例化一个cell，就会调用此方法，完成背景图和文本的设置
//时间的背景还没弄，在这里写
- (void) setupInternalData
{
    //NSLog(@"setupInternalData");
    NSUserDefaults *defalut=[NSUserDefaults standardUserDefaults];
    NSString * themechoose=[defalut objectForKey:@"themechoose"];
    UIImage *friendBubbleImage;
    UIImage *tucaoBackgroundImage;
    if(themechoose==nil || [themechoose isEqual:@"nomal"])
    {
        friendBubbleImage=[UIImage imageNamed:@"friendbubble.png"];
        tucaoBackgroundImage=[UIImage imageNamed:@"tucaokuang.png"];
    }
    else if ([themechoose isEqual:@"blue"])
    {
        friendBubbleImage=[UIImage imageNamed:@"friend_blue.png"];
        tucaoBackgroundImage=[UIImage imageNamed:@"tucao_blue.png"];
    }
    else if ([themechoose isEqual:@"yellow"])
    {
        friendBubbleImage=[UIImage imageNamed:@"friend_yellow.png"];
        tucaoBackgroundImage=[UIImage imageNamed:@"tucao_yellow.png"];
    }
    else if ([themechoose isEqual:@"grey"])
    {
        friendBubbleImage=[UIImage imageNamed:@"friend_grey.png"];
        tucaoBackgroundImage=[UIImage imageNamed:@"tucao_grey.png"];
    }

    //content文本部分的位置大小
    float x;
    x = 10.0f;
    float y = 5.0f;
    
    /*---------------------------头像以及微博名称--------------------------------------------------------------*/
    headImage.frame = CGRectMake(x + 15.0f, y + 15.0f, 40, 40);
    if(self.dataInternal.data.headImage != nil)
        headImage.image = self.dataInternal.data.headImage;
    
    NSString *name = self.dataInternal.data.weiboName;
    CGSize nameSize = [name sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(200, 9999) lineBreakMode:UILineBreakModeWordWrap];
    WeiboName.frame = CGRectMake(x + 55.0f, y + 20.0f, nameSize.width, nameSize.height);
    WeiboName.text = name;
    
    /*---------------------------本微博文本和图片显示--------------------------------------------------------------*/
    /*文本*/
    NSString *text = self.dataInternal.data.text;
    /*文本位置*/
    CGRect textFrame = CGRectMake(x + 55.0f, y + 45.0f, self.dataInternal.labelSize.width, self.dataInternal.labelSize.height);
    imageText.frame = textFrame;
    [imageText setBackgroundColor:[UIColor clearColor]];
    imageText.text = text;
    imageText.font=[UIFont systemFontOfSize:16.0];
    
    //consider the image would be nil
    if(self.dataInternal.data.text_image != nil){
        imageForImageText.image = self.dataInternal.data.text_image;
        imageForImageText.frame = CGRectMake(x + 55.0f, imageText.frame.origin.x + imageText.frame.size.height - 10.0f, imageForImageText.image.size.width, imageForImageText.image.size.height);
    }
    else {
        imageForImageText.frame = CGRectMake(x + 55.0f, imageText.frame.origin.x + imageText.frame.size.height, 0, 0);
    }
    
    /*--------------------------- 原文文本和图片显示--------------------------------------------------------------*/
    NSString *repost = self.dataInternal.data.origin_text;
    CGRect originTextFrame;
    if(repost != nil)
        originTextFrame = CGRectMake(x + 65.0f, imageForImageText.frame.origin.y + imageForImageText.frame.size.height + 8, self.dataInternal.originLabelSize.width-5, self.dataInternal.originLabelSize.height);
    else {
        originTextFrame = CGRectMake(x + 45.0f, imageForImageText.frame.origin.y + imageForImageText.frame.size.height + 8, 0, 0);
    }
    repostText.frame = originTextFrame;
    [repostText setBackgroundColor:[UIColor clearColor]];
    repostText.text = repost;
    repostText.font=[UIFont systemFontOfSize:15.0];
    
    if(self.dataInternal.data.origin_text_image != nil){
        imageForRepostTextView.image = self.dataInternal.data.origin_text_image;
        imageForRepostTextView.frame = CGRectMake(x + 70.0f, repostText.frame.origin.y + repostText.frame.size.height + 8, imageForRepostTextView.image.size.width, imageForRepostTextView.image.size.height);
    }
    else {
        imageForRepostTextView.frame = CGRectMake(x + 45.0f, repostText.frame.origin.y + repostText.frame.size.height, 0, 0);
    }
    
    if(repost != nil){
        UIImage *repostImg;
        NSBubbleType type = self.dataInternal.data.type;
        if(type == BubbleTypeMineInHomePage){
            repostImg = [[UIImage imageNamed:@"zhuanfakuang.png"] stretchableImageWithLeftCapWidth:160 topCapHeight:18];
        }
        //好友的转发框颜色要改改，还没改
        else{
            repostImg = [[UIImage imageNamed:@"zhuanfakuang2.png"] stretchableImageWithLeftCapWidth:160 topCapHeight:18];
        }
        repostBackgroundView.frame = CGRectMake(x + 55.0f, repostText.frame.origin.y - 20.0f, 205 , repostText.frame.size.height + imageForRepostTextView.frame.size.height + 35.0f);
        repostBackgroundView.image = repostImg;
        //repostBackgroundView.backgroundColor=[UIColor grayColor];
        repostBackgroundView.alpha=1.0;
    }
    else {
        repostBackgroundView.frame = CGRectMake(x + 47.0f, y, 0, 0);
    }
    
    /*---------------------------气泡框--------------------------------------------------------------*/
    UIImage *editButtonImage;
    UIImage *editButtonClickedImage;
    NSBubbleType type = self.dataInternal.data.type;
    if(type == BubbleTypeMineInHomePage){
        bubbleImage.image = [[UIImage imageNamed:@"duihuakuang.png"] stretchableImageWithLeftCapWidth:21 topCapHeight:50];
        editButtonImage = [UIImage imageNamed:@"bianji.png"];
        editButtonClickedImage = [UIImage imageNamed:@"bianjiclick.png"];
    }
    else if(type == BubbleTypeSomeoneElse){/*friendbubble.png duihuakuang.png*/
        bubbleImage.image = [friendBubbleImage stretchableImageWithLeftCapWidth:21 topCapHeight:50];
        editButtonImage = [UIImage imageNamed:@"friendbianji.png"];
        editButtonClickedImage = [UIImage imageNamed:@"friendbianji_click.png"];
        bubbleImage.alpha=1.0;
    }
    
    float bubbleHeight = self.dataInternal.labelSize.height + self.dataInternal.originLabelSize.height + self.dataInternal.data.text_image.size.height + self.dataInternal.data.origin_text_image.size.height + editButtonImage.size.height + 55.0f;

    if(self.dataInternal.data.text_image != nil)
        bubbleHeight += 15.0f;
    if(self.dataInternal.data.origin_text != nil)
        bubbleHeight += 45.0f;
    if(self.dataInternal.data.origin_text_image != nil)
        bubbleHeight += 28.0f;
    bubbleImage.frame = CGRectMake(x, y - 4.0f, [[UIScreen mainScreen] bounds].size.width - 20, bubbleHeight+5);

    /*---------------------------加号--------------------------------------------------------------*/
    [editButton setImage:editButtonImage forState:UIControlStateNormal];
    [editButton setImage:editButtonClickedImage forState:UIControlStateHighlighted];
    
    CGFloat origin_x = bubbleImage.frame.origin.x + bubbleImage.frame.size.width;
    CGFloat origin_y = bubbleImage.frame.origin.y + bubbleImage.frame.size.height;
    CGFloat width = 55.0f;
    CGFloat height = 55.0f;
    if(type == BubbleTypeMineInHomePage){
        origin_x -= 62.0f;
        origin_y -= 50.0f;
        if(self.dataInternal.data.text_image != nil || self.dataInternal.data.origin_text != nil || self.dataInternal.data.origin_text_image != nil)
            origin_y -= 5.0f;
    }
    else{
        origin_x -= 62.0f;
        origin_y -= 55.0f;
    }
    editButton.frame = CGRectMake(origin_x, origin_y, width, height);
        
    [editButton addTarget:self action:@selector(showEditingSubview) forControlEvents:UIControlEventTouchUpInside];
    self.isEditSubviewShow = NO;
    
    /*---------------------------时间和新浪（人人）标签--------------------------------------------------------------*/
    if([self.dataInternal.data.from isEqual:@"sina"])
        timeImage.image = [UIImage imageNamed:@"weiboIcon.png"];
    else
        timeImage.image = [UIImage imageNamed:@"renrenIcon.png"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr;
    if(self.dataInternal.data.date != NULL)
        dateStr = [dateFormatter stringFromDate:self.dataInternal.data.date];
    else
        dateStr = [dateFormatter stringFromDate:[NSDate date]];
    
    timeLabel.text = dateStr;
    
    CGRect timeImageFrame = CGRectMake(editButton.frame.origin.x - 6.0f,
                                       editButton.frame.origin.y + 15,
                                       20, 15);
    timeImage.frame = timeImageFrame;
    
    CGRect timeLabelFrame = CGRectMake(timeImageFrame.origin.x - 62,
                                       timeImageFrame.origin.y-4,
                                       60, 20);
    timeLabel.frame = timeLabelFrame;
    
    /*---------------------------吐槽框--------------------------------------------------------------*/
    if(self.dataInternal.shouldTucaoShow){
        UIImage *tucaoImg = [tucaoBackgroundImage stretchableImageWithLeftCapWidth:30 topCapHeight:30];
        [tucaoBackgroundView setImage:tucaoImg];
        
        [tTableView setBackgroundColor:[UIColor greenColor]];
        


        
        /*----------------------------
                    评论
         ----------------------------*/
        
        if(self.dataInternal.data.comments != nil){
            tTableView.delegate = self;
            tTableView.dataSource = self;
            
            tTableView.backgroundColor=[UIColor clearColor];
            
            UIView *tmpFoot=[[UIView alloc] init];
            [tTableView setTableFooterView:tmpFoot];
            
            //NSLog(@"pass");
            //NSLog(@"contentSize %f",self.dataInternal.commentsSize.height);
            tucaoBackgroundView.frame = CGRectMake(bubbleImage.frame.origin.x + 3.0f, bubbleImage.frame.origin.y + bubbleImage.frame.size.height - 28, 200, self.dataInternal.commentsSize.height+55);
            
            tTableView.frame = CGRectMake(tucaoBackgroundView.frame.origin.x + 25, tucaoBackgroundView.frame.origin.y + 28,150, self.dataInternal.commentsSize.height+100);
            
            tTableView.alpha = 1.0f;
            tucaoBackgroundView.alpha = 1.0f;
            
            tTableView.layer.cornerRadius = 4;
            tTableView.layer.masksToBounds = YES;
            [tTableView reloadData];
        }
    }
    
    //for reuse mechanism!!!!!!!!!!
    if(self.dataInternal.data.comments == nil && self.dataInternal.data.tucao == nil){
        tTableView.frame = CGRectZero;
        tTableView.dataSource=nil;
        tTableView.delegate=nil;
        tucaoBackgroundView.frame = CGRectZero;
        tucaoBackgroundView.image=nil;
    }
}

/**
 * show the editing subview
 */
-(void)showEditingSubview{
    //动画开始前的位置
    CGRect editSubviewFrame_begin = CGRectMake(320-108-30-30  , editButton.frame.origin.y-35 , 100 , 15 );
    //动画完成后的位置
    CGRect editSubviewFrame_end = CGRectMake(320-120-30  ,editButton.frame.origin.y - 35.0f ,  120 ,50
                                             );
    //108+50,37
    
    if(!isEditSubviewShow){
        isEditSubviewShow = YES;
        if(!self.editView)
        {
            /*在ImageView上面加Button的话，Button会丧失触控事件。所以只能在UIView上面加Button
             */
            self.editView=[[UIView alloc] initWithFrame:editSubviewFrame_begin];
            self.editSubview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.editView.frame.size.width, self.editView.frame.size.height)];
        }
        
        UIImage *editSubviewImg = [[UIImage imageNamed:@"bianjikuang.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
        self.editSubview.image = editSubviewImg;
        [self.editView addSubview:editSubview];
        
        /*删除按钮*/
        CGRect deleteButtonFrame =  CGRectMake(5, -10,60, 60);
        if(!self.deleteButton)
            self.deleteButton = [[UIButton alloc] initWithFrame:deleteButtonFrame];

        UIImage *deleteImage = [UIImage imageNamed:@"shanchu.png"];
        [self.deleteButton setImage:deleteImage forState:UIControlStateNormal];
        [self.deleteButton setTitle:@" 删除" forState:UIControlStateNormal];
        self.deleteButton.titleLabel.font = [UIFont systemFontOfSize:17.0];
        self.deleteButton.titleLabel.textAlignment = UITextAlignmentRight;
        [self.deleteButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.deleteButton addTarget:self action:@selector(onDeleteDiaryButton) forControlEvents:UIControlEventTouchUpInside];
        [self.editView addSubview:deleteButton];
        
        /*查询评论按钮*/
        CGRect commentsButtonFrame =  CGRectMake(60, -10,60, 60);
        if(!commentsButton)
            commentsButton = [[UIButton alloc] initWithFrame:commentsButtonFrame];
        [commentsButton setImage:[UIImage imageNamed:@"shanchu.png"] forState:UIControlStateNormal];
        [commentsButton setTitle:@"评论" forState:UIControlStateNormal];
        commentsButton.titleLabel.font = [UIFont systemFontOfSize:17.0];
        commentsButton.titleLabel.textAlignment = UITextAlignmentRight;
        [commentsButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [commentsButton addTarget:self action:@selector(LoadComments) forControlEvents:UIControlEventTouchUpInside];
        [self.editView addSubview:commentsButton];
        
        [self.contentView addSubview:editView];
        
        [UIView animateWithDuration:0.15f animations:^(void){
            editView.alpha=1;
            editView.frame=editSubviewFrame_end;
            editSubview.frame=CGRectMake(0, 0, self.editView.frame.size.width, self.editView.frame.size.height);
        }];
        
        //editSubview.alpha=0;
        
        /*安装按钮*/
        /*吐槽按钮*/
        /*CGRect tucaoButtonFrame =  CGRectMake(editSubview.frame.origin.x - 61, editSubview.frame.origin.y -19, 46, 23);
         //CGRect tucaoButtonFrame =  CGRectMake(5, 1, 46, 23);
         if(!tucaoButton)
         tucaoButton = [[UIButton alloc] initWithFrame:tucaoButtonFrame];
         
         
         UIImage *tucaoImage = [UIImage imageNamed:@"tucao.png"];
         [tucaoButton setImage:tucaoImage forState:UIControlStateNormal];
         [tucaoButton setTitle:@" 吐槽" forState:UIControlStateNormal];
         [tucaoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
         tucaoButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
         tucaoButton.titleLabel.textAlignment = UITextAlignmentRight;
         [tucaoButton addTarget:self action:@selector(addTuccao) forControlEvents:UIControlEventTouchUpInside];
         [self addSubview:tucaoButton];*/
        
        
    }
    else{
        isEditSubviewShow = NO;
        if(deleteButton)
            [deleteButton removeFromSuperview];
        if(commentsButton)
            [commentsButton removeFromSuperview];
        /*if(tucaoButton)
         [tucaoButton removeFromSuperview];*/
        [UIView animateWithDuration:0.10f animations:^(void){
            editView.alpha=0;
            editView.frame=editSubviewFrame_begin;
        }];
    }
}

-(void)deleteEditSubview{
    if(deleteButton)
        [deleteButton removeFromSuperview];
    if(commentsButton)
        [commentsButton removeFromSuperview];
    if(editSubview)
        [editSubview removeFromSuperview];
    /*if(tucaoButton)
     [tucaoButton removeFromSuperview];*/
}

-(void)addTuccao{
}

-(void)onDeleteDiaryButton{
    /*已给cell设置了tag等于indexpath*/
    NSNumber *index = [NSNumber numberWithInteger:self.tag];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"toDeleteCell" object:index];
    isEditSubviewShow = NO;
    if(deleteButton)
        [deleteButton removeFromSuperview];
    if(commentsButton)
        [commentsButton removeFromSuperview];
    if(editSubview)
        [editSubview removeFromSuperview];
    /*if(tucaoButton)
     [tucaoButton removeFromSuperview];*/
    
}
-(void)LoadComments
{
    NSNumber *index = [NSNumber numberWithInteger:self.tag];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"toLoadComments" object:index];
    isEditSubviewShow = NO;
    if(deleteButton)
        [deleteButton removeFromSuperview];
    /*if(tucaoButton)
     [tucaoButton removeFromSuperview];*/
    if(commentsButton)
        [commentsButton removeFromSuperview];
    if(editSubview)
        [editSubview removeFromSuperview];
}

#pragma mark -
#pragma mark Tucao Button Method
-(void)editTucao{
    
}

-(void)toggleDelete:(id)sender{
    //NSLog(@"did toggle delete");
    [tTableView setEditing: !tTableView.editing animated:YES];
    UIButton *senderButton = (UIButton *)sender;
    if(tTableView.editing){
        //图片应该换为完成的图片
        [senderButton setBackgroundImage:[UIImage imageNamed:@"bianjibutton.png"] forState:UIControlStateNormal];
        [senderButton setBackgroundImage:[UIImage imageNamed:@"bianji_click.png"] forState:UIControlStateHighlighted];
    }
    else {
        [senderButton setBackgroundImage:[UIImage imageNamed:@"shanchubotton.png"] forState:UIControlStateNormal];
        [senderButton setBackgroundImage:[UIImage imageNamed:@"shanchubutton_click.png"] forState:UIControlStateHighlighted];
    }
}

#pragma mark - UITableViewDelegate implementation

#pragma mark - UITableViewDataSource implementation

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //减去自己的吐槽
    return [self.dataInternal.data.comments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"tucaoCell";
    
    //少了autorelease
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        
        [cell.contentView setBackgroundColor:[UIColor whiteColor]];
        UIImageView *headImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        headImageView.tag = 4;
        [cell.contentView addSubview:headImageView];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        nameLabel.tag = 5;
        nameLabel.lineBreakMode = UILineBreakModeWordWrap;
        nameLabel.textColor = [UIColor colorWithRed:0.25 green:0.19 blue:0.12 alpha:1.0];
        nameLabel.numberOfLines = 0;
        nameLabel.opaque = NO;
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.font = [UIFont systemFontOfSize:14.0];
        [cell.contentView addSubview:nameLabel];
        
        ImageTextView *commentLabel = [[ImageTextView alloc] initWithFrame:CGRectZero];
        commentLabel.tag = 6;
        commentLabel.font=[UIFont systemFontOfSize:13.0];
        commentLabel.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:commentLabel];
    }
    CGRect cellFrame = [cell frame];
    cellFrame.origin = CGPointMake(0, 0);
    
    /*----------------------头像--------------------------------*/
    UIImageView *headImageView = (UIImageView *)[cell viewWithTag:4];
    NSData *headPicData = [[self.dataInternal.data.comments objectAtIndex:indexPath.row] valueForKey:@"headPicture"];
    headImageView.image = [UIImage imageWithData:headPicData];
    
    CGRect headPicRect = CGRectMake(5, 5, 25, 25);
    headImageView.frame = headPicRect;
    
    /*----------------------名字标签--------------------------------*/
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:5];
    
    NSString *commentorName = [[self.dataInternal.data.comments objectAtIndex:indexPath.row] valueForKey:@"name"];
    
    CGSize nameSize=[commentorName sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(110, 1000) lineBreakMode:UILineBreakModeWordWrap];
    
    nameLabel.text = commentorName;
    
    CGRect nameRect = CGRectMake(35, 5, 110, nameSize.height);
    nameLabel.frame = nameRect;
    
    [nameLabel sizeToFit];
    cellFrame.size.height = nameLabel.frame.size.height + 10.0f;
    
    /*----------------------评论内容标签--------------------------------*/
    ImageTextView *commentLable = (ImageTextView *)[cell viewWithTag:6];
    NSString *commentContent = [[self.dataInternal.data.comments objectAtIndex:indexPath.row] valueForKey:@"text"];
    
    UIFont *commentFont=[UIFont systemFontOfSize:13.0];
    CGSize commentSize=[commentContent sizeWithFont:commentFont constrainedToSize:CGSizeMake(110, 1000) lineBreakMode:UILineBreakModeWordWrap];
    
    commentLable.text = commentContent;
    CGRect commentRect = CGRectMake(35, nameLabel.frame.size.height + 10, 110, commentSize.height);
    commentLable.frame = commentRect;
    
    cellFrame.size.height += commentLable.frame.size.height + 15.0f;
    
    //[cell setFrame:cellFrame];
    return cell;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float returnHeight=0.0;
    UIFont *commentFont=[UIFont systemFontOfSize:13.0];
    NSDictionary *comment = [self.dataInternal.data.comments objectAtIndex:[indexPath row]];
    
    NSString *nameStr = [comment valueForKey:@"name"];
    CGSize nameSize=[nameStr sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(110, 1000) lineBreakMode:UILineBreakModeWordWrap];
    
    NSString *commentStr = [comment valueForKey:@"text"];
    CGSize commentSize=[commentStr sizeWithFont:commentFont constrainedToSize:CGSizeMake(110, 1000) lineBreakMode:UILineBreakModeWordWrap];
    
    returnHeight+=nameSize.height+commentSize.height+15.0;
    
    return returnHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *commentID = [[self.dataInternal.data.comments objectAtIndex:indexPath.row] valueForKey:@"id"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"somethingChangeToReload" object:commentID];
}


@end
