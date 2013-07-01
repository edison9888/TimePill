//
//  HomePageViewController.m
//  Timeline
//
//  Created by 04 developer on 12-10-24.
//  Copyright (c) 2012年 Sun Yat-sen University. All rights reserved.
//

#import "HomePageViewController.h"
#import "NSBubbleData.h"
#import "UIBubbleTableViewDataSource.h"
#import "UIBubbleTableView.h"

@interface HomePageViewController()
<UIActionSheetDelegate,UIAlertViewDelegate,AWActionSheetDelegate>
{
     
     NSString *deleteCommentID;
     NSNumber * selectedWeiboIndexForComment;
}
@end

@implementation HomePageViewController

@synthesize navBar;
@synthesize bubbleHeader;
@synthesize item;
@synthesize sheet;
@synthesize colors;
@synthesize bar = _bar;
@synthesize myBubbleDiaryTableView;
@synthesize bigCircleTimeView;
@synthesize diaries;
@synthesize ACData;
@synthesize settingButton;
@synthesize headImageView;
@synthesize nameLabel;
@synthesize backgroundIV;
@synthesize actionSheet;
#pragma mark 生命周期
- (void)viewDidLoad
{//NSLog(@"viewDidLoad");
     [super viewDidLoad];
     [self initBackground];
     [self initTableView];
     [self initHraderView];
     [self initHeadImage];
     [self initNavigationBar];
     [self initAddButton];
     [self initData];
     [self initSlideView];
     [self configueSlide];
}

-(void)viewDidAppear:(BOOL)animated
{//NSLog(@"viewDidAppear");
    [super viewDidAppear:animated];
     if(FirstViewDidAppear==YES)
     {
     
          FirstViewDidAppear=NO;
          [self DoInViewDidAppear];
     }
}

-(void)viewDidDisappear:(BOOL)animated
{
    //NSLog(@"viewDidDisappear");
     [super viewDidDisappear:YES];
     [self DoInViewDidDisappear];
}

- (void)viewDidUnload
{
    //NSLog(@"viewDidUnload");
     [super viewDidUnload];
     [self setMyBubbleDiaryTableView:nil];
     self.bar = nil;
     self.bigCircleTimeView = nil;
     self.nameLabel = nil;
     self.settingButton = nil;
     self.headImageView = nil;
}

-(void)setTableScrollEnable:(Boolean)en
{
    
    self.myBubbleDiaryTableView.scrollEnabled=en;
}
#pragma mark - 通知执行函数

-(void)somethingChangeToReload:(NSNotification *)notification
{
     self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择要进行的操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"删除", nil];
     [self.actionSheet showInView:self.view];
     deleteCommentID = (NSString *)notification.object;
}

-(void)ToDeleteDiary:(NSNotification * )note
{
     NSInteger deleteCellIndex = [note.object intValue];
     // NSLog(@"删除第几个？%d",deleteCellIndex);
     
     NSString *statusId_or_weiboId=[[self.ACData objectAtIndex:deleteCellIndex] valueForKey:@"id"];
     //NSLog(@"要删除的ID,%@",[self.diaries objectAtIndex:0]);
     [[DataClient shareClient] deleteItem:statusId_or_weiboId];
     [[DataClient shareClient] deleteCommentWithWeiboID:statusId_or_weiboId];
     [self.ACData removeObjectAtIndex:deleteCellIndex];
     
     //调用api修改core data函数
     [self.myBubbleDiaryTableView beginUpdates];
     [self.diaries removeObjectAtIndex:deleteCellIndex];
     [self.myBubbleDiaryTableView reloadData];
     
     NSMutableArray *tmp = [NSMutableArray arrayWithObject:[NSIndexPath indexPathForRow:deleteCellIndex inSection:0]];
     [self.myBubbleDiaryTableView deleteRowsAtIndexPaths:tmp withRowAnimation:UITableViewRowAnimationFade];
     [self.myBubbleDiaryTableView endUpdates];
}
/*加载评论页面*/
-(void)LoadComments:(NSNotification *)note
{
     selectedWeiboIndexForComment = note.object;
   //  NSLog(@"LoadComments-ACData的个数%d,",[self.ACData count]);
   //  NSLog(@"LoadComments-diary的个数%d,",[self.diaries count]);
     //NSLog(@"LoadComments");
     NSNumber *number=note.object;
     int index=[number intValue];
     //NSLog(@"index %d",index);
     //NSLog(@"LoadComments_ACData.count=%d",[self.ACData count]);
     NSString *statusId_or_weiboId=[[self.ACData objectAtIndex:index] valueForKey:@"id"];
     NSString *userId=[[self.ACData objectAtIndex:index] valueForKey:@"user"];
     NSString *type=[[self.ACData objectAtIndex:index] valueForKey:@"from"];
     //NSLog(@"weiboId_or_statusId=%@ ,userId =%@ , type = %@",statusId_or_weiboId,userId,type);
     
     CommentsViewController *commentsVC=[[CommentsViewController alloc] init];  
     [commentsVC setValue:statusId_or_weiboId forKey:@"statusId_or_weiboId"];
     [commentsVC setValue:userId forKey:@"userId"];
     [commentsVC setValue:type forKey:@"type"];
     [self presentModalViewController:commentsVC animated:YES];
}

-(void)returnComments:(NSNotification *)note
{
     
}

/*显示微博个人信息*/
-(void)WeiboUserInfo:(NSNotification *)note
{
     NSString *urlStr=[note.object objectForKey:@"profile_image_url"];
     //从url显示图片
     NSURL *url=[NSURL URLWithString:urlStr];
     NSURLRequest *request=[[NSURLRequest alloc] initWithURL:url];
     NSURLConnection *connection=[NSURLConnection connectionWithRequest:request delegate:self];
     [connection start];
     
}

/*接收到头像*/
- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data
{
     
     UIImage *img = [[UIImage alloc] initWithData:data];
     if(img!=nil)
          [self.headImageView setImage:img];
     
}

/*显示人人个人信息*/
-(void)RenRenUserInfo:(NSNotification *)note
{
     NSString *urlStr=[note.object objectForKey:@"headUrl"];
     //从url显示图片
     NSURL *url=[NSURL URLWithString:urlStr];
     NSURLRequest *request=[[NSURLRequest alloc] initWithURL:url];
     NSURLConnection *connection=[NSURLConnection connectionWithRequest:request delegate:self];
     [connection start];
}




#pragma mark ActionSheet功能
-(void)makeLongWeibo
{
     /*长微博*/
     
     /*背景图预设*/
     UIImage *originImage=self.backgroundIV.image;
     UIImage *backgroundImage=[originImage stretchableImageWithLeftCapWidth:5 topCapHeight:5];  //把背景图伸展
     UIImageView *imageview=[[UIImageView alloc] initWithImage:backgroundImage];
     imageview.frame=CGRectMake(0, 0, self.view.frame.size.width,self.myBubbleDiaryTableView.contentSize.height);
     
     /*Table预设*/
     CGRect origineRect=self.myBubbleDiaryTableView.frame;
     CGRect longRect=CGRectMake(0, 0, self.view.frame.size.width,self.myBubbleDiaryTableView.contentSize.height);
     self.myBubbleDiaryTableView.frame=longRect;
     
     UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.view.frame.size.width, self.myBubbleDiaryTableView.contentSize.height), NO, 0.0);
     /*绘制进context中*/
     [imageview.layer renderInContext:UIGraphicsGetCurrentContext()];
     [self.myBubbleDiaryTableView.layer renderInContext:UIGraphicsGetCurrentContext()];
     //[lineView.layer renderInContext:UIGraphicsGetCurrentContext()];
     /*得到长微博*/
     longWeibo = UIGraphicsGetImageFromCurrentImageContext();
     longWeibo_big=UIGraphicsGetImageFromCurrentImageContext();
     UIGraphicsEndImageContext();
     
     self.myBubbleDiaryTableView.frame=origineRect;  //复原
    

     
}

-(void)chearAll
{
     UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"确定要清空吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
     [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
     switch (buttonIndex) {
          case 1:
               [[DataClient shareClient] deleteAll];
               [[DataClient shareClient] deleteAllComment];
               [self.diaries removeAllObjects];
               [self.myBubbleDiaryTableView reloadData];
               break;
               
          default:
               break;
     }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
     if([actionSheet isEqual:self.actionSheet])
     {
          if(buttonIndex == 0){
               //删除对应的评论，需要comment id
               [[DataManager sharedDataManager].dataClient deleteCommentWithID:deleteCommentID];
              
              [self.ACData removeAllObjects];
              [self.diaries removeAllObjects];
              [self getData];
              [self.myBubbleDiaryTableView reloadData];
          }

     }
     else
     {
     switch (buttonIndex) {
          case 0:
               if([self.diaries count]==0)
               {
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"添加些微博吧" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [alert show];
               }
               else
               {
                    [self makeLongWeibo];
                    [SVProgressHUD showSuccessWithStatus:@"已保存到相册" duration:0.5];
                    UIImageWriteToSavedPhotosAlbum(longWeibo, nil, nil, nil);
                    NSData *data = UIImageJPEGRepresentation(longWeibo, 1.0);
                    int h = longWeibo.size.height;
                    int w = longWeibo.size.width;
                    float scale = (float)200.0/w;
                    CGSize itemSize = CGSizeMake(w, h);
                    UIGraphicsBeginImageContext(itemSize);
                    CGRect imageRect = CGRectMake(0, 0, scale*w, scale*h);
                    [longWeibo drawInRect:imageRect];
                    longWeibo = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                    CGRect rect =  CGRectMake(0, 0, 200, self.view.frame.size.height*0.75);
                    CGImageRef cgimg = CGImageCreateWithImageInRect([longWeibo CGImage], rect);
                    UIImage *temImage = [UIImage imageWithCGImage:cgimg];
                    
                    NSData *aData = UIImageJPEGRepresentation(temImage, 1.0);
                    [[DataManager sharedDataManager] addLongWeibo:data andAbstract:aData];
               }
               break;
          case 1:
               if([self.diaries count]==0)
               {
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"添加些微博吧" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [alert show];
               }
               else
               {
                    [self makeLongWeibo];
                    NSData *data2 = UIImageJPEGRepresentation(longWeibo, 1.0);
                    
                    int h2 = longWeibo.size.height;
                    int w2 = longWeibo.size.width;
                    float scale2 = (float)200.0/w2;
                    CGSize itemSize2 = CGSizeMake(w2, h2);
                    UIGraphicsBeginImageContext(itemSize2);
                    CGRect imageRect2 = CGRectMake(0, 0, scale2*w2, scale2*h2);
                    [longWeibo drawInRect:imageRect2];
                    longWeibo = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                    CGRect rect2 =  CGRectMake(0, 0, 200, self.view.frame.size.height*0.7);
                    CGImageRef cgimg2 = CGImageCreateWithImageInRect([longWeibo CGImage], rect2);
                    UIImage *temImage2 = [UIImage imageWithCGImage:cgimg2];
                    
                    NSData *aData2 = UIImageJPEGRepresentation(temImage2, 1.0);
                    [[DataManager sharedDataManager] addLongWeibo:data2 andAbstract:aData2];
                    
                    if(![[DataManager sharedDataManager] isWeiboAuthValid])
                         [[[DataManager sharedDataManager] sinaWeiboData] ToLogin];
                    else {
                         /*发日志*/
                         UIStoryboard *story=[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
                         UIViewController *createDiaryViewController=[story instantiateViewControllerWithIdentifier:@"CreateDiaryViewController"];
                         [createDiaryViewController setValue:longWeibo_big forKey:@"longWeibo"];
                         [createDiaryViewController setValue:@"sina" forKey:@"type"];
                         [self presentModalViewController:createDiaryViewController animated:YES];
                         [self dismissModalViewControllerAnimated:YES];
                    }
               }
               break;
          case 2:
               if([self.diaries count]==0)
               {
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"添加些微博吧" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [alert show];
               }
               else{
                    [self makeLongWeibo];
                    NSData *data3 = UIImageJPEGRepresentation(longWeibo, 1.0);
                    int h3 = longWeibo.size.height;
                    int w3 = longWeibo.size.width;
                    float scale3 = (float)200.0/w3;
                    CGSize itemSize3 = CGSizeMake(w3, h3);
                    UIGraphicsBeginImageContext(itemSize3);
                    CGRect imageRect3 = CGRectMake(0, 0, scale3*w3, scale3*h3);
                    [longWeibo drawInRect:imageRect3];
                    longWeibo = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                    CGRect rect3 =  CGRectMake(0, 0, 200, self.view.frame.size.height*0.7);
                    CGImageRef cgimg3 = CGImageCreateWithImageInRect([longWeibo CGImage], rect3);
                    UIImage *temImage3 = [UIImage imageWithCGImage:cgimg3];
                    
                    NSData *aData3 = UIImageJPEGRepresentation(temImage3, 1.0);
                    [[DataManager sharedDataManager] addLongWeibo:data3 andAbstract:aData3];
                    if(![[DataManager sharedDataManager] isWeiboAuthValid])
                         [[[DataManager sharedDataManager] renrenData] ToLogin];
                    else {
                         /*发日志*/
                         UIStoryboard *story=[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
                         UIViewController *createDiaryViewController=[story instantiateViewControllerWithIdentifier:@"CreateDiaryViewController"];
                         [createDiaryViewController setValue:longWeibo_big forKey:@"longWeibo"];
                         [createDiaryViewController setValue:@"renren" forKey:@"type"];
                         [self presentModalViewController:createDiaryViewController animated:YES];
                         [self dismissModalViewControllerAnimated:YES];
                    }
               }
               break;
          case 3:
               [self chearAll];
               break;
          default:
               break;
     }
     }
}


#pragma mark 加号内动作
- (void) onCreateDiary
{
     UIStoryboard *story=[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
     UIViewController *CreateDiaryViewController=[story instantiateViewControllerWithIdentifier:@"CreateDiaryViewController"];
     [self presentModalViewController:CreateDiaryViewController animated:YES];
}

- (void) toMaterialKit
{
     UIStoryboard *story=[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
     UIViewController *MaterialKitViewController=[story instantiateViewControllerWithIdentifier:@"MaterialKitViewController"];
     [self presentModalViewController:MaterialKitViewController animated:YES];}

- (void) toThemeKit
{
     self.sheet = [[AWActionSheet alloc] initwithIconSheetDelegate:self ItemCount:4];
     [self.sheet showInView:self.view];
     //[self.sheet release];
    // [self.sheet action];
     
}

#pragma mark 主题
-(int)numberOfItemsInActionSheet
{
     return 4;
}

-(AWActionSheetCell *)cellForActionAtIndex:(NSInteger)index
{
     AWActionSheetCell* cell = [[AWActionSheetCell alloc] init];
     
     //[[cell iconView] setBackgroundColor:[self.colors objectAtIndex:index]];
     if (index == 0) {
          [[cell iconView] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"toutu_blue.png"]]];
          [[cell titleLabel] setText:@"活泼"];
     }
     if (index == 1) {
          [[cell iconView] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"toutu_yellow.png"]]];
          [[cell titleLabel] setText:@"闲适"];
     }
     if (index == 2) {
          [[cell iconView] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"toutu_grey.png"]]];
          [[cell titleLabel] setText:@"灰暗"];
     }
     if (index == 3) {
          [[cell iconView] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"toutu.png"]]];
          [[cell titleLabel] setText:@"淡雅"];
     }
     cell.index = index;
     return cell;
}

- (UIColor *)backgroundColor:(UIImage *)inputImage
{
     CGImageRef inImage = inputImage.CGImage;
     CFDataRef m_DataRef = CGDataProviderCopyData(CGImageGetDataProvider(inImage));
     CFDataRef m_OutDataRef = CGDataProviderCopyData(CGImageGetDataProvider(inImage));
     UInt8 * m_PixelBuf = (UInt8 *) CFDataGetBytePtr(m_DataRef);
     UInt8 * m_OutPixelBuf = (UInt8 *) CFDataGetBytePtr(m_OutDataRef);
     
     int h = CGImageGetHeight(inImage);
     int w = CGImageGetWidth(inImage);
     

     int i = 0, j = 0;
     
     double r = 0, g = 0, b = 0;
     
     for (i = 0; i < h; i++) {
          for (j = 0; j < w; j++) {
               
               int inIndex = (i*w*4) + (j*4);
               r += m_PixelBuf[inIndex];
               g += m_PixelBuf[inIndex + 1];
               b += m_PixelBuf[inIndex + 2];
                            
          }
     }
     r=r/(w*h);
     g=g/(w*h);
     b=b/(w*h);
     
    // NSLog(@"r=%f , g=%f , b=%f",r,g,b);
     
     UIColor *color=[[UIColor alloc] initWithRed:r/255 green:g/255 blue:b/255 alpha:0.12];
//     for (i = 0; i < h; i++) {
//          for (j = 0; j < w; j++) {
//               
//               int outIndex = (i*w*4) + (j*4);
//               
//               m_OutPixelBuf[outIndex]     = r;
//               m_OutPixelBuf[outIndex + 1] = g;
//               m_OutPixelBuf[outIndex + 2] = b;
//               m_OutPixelBuf[outIndex + 3] = 255;
//          }
//     }
//     
//     CGContextRef ctx = CGBitmapContextCreate(m_OutPixelBuf,
//                                              CGImageGetWidth(inImage),
//                                              CGImageGetHeight(inImage),
//                                              CGImageGetBitsPerComponent(inImage),
//                                              CGImageGetBytesPerRow(inImage),
//                                              CGImageGetColorSpace(inImage),
//                                              CGImageGetBitmapInfo(inImage)
//                                              );
//     
//     CGImageRef imageRef = CGBitmapContextCreateImage(ctx);
//     CGContextRelease(ctx);
//     UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
//     CGImageRelease(imageRef);
//     CFRelease(m_DataRef);  
//     CFRelease(m_OutDataRef);  
     
     return color;
}

-(void)DidTapOnItemAtIndex:(NSInteger)index
{
     [self.sheet dismissWithClickedButtonIndex:index animated:YES];
     [self.view setBackgroundColor:[self.colors objectAtIndex:index]];
     NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
     
     if (index == 0) {
          [bubbleHeader setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"toutu_blue.png"]]];
          [self.backgroundIV setImage:[[UIImage imageNamed:@"background_blue.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:5]];
          [defaults setObject:@"blue" forKey:@"themechoose"];
          [self.myBubbleDiaryTableView reloadData];
          }
     else if (index == 1) {
          [bubbleHeader setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"toutu_yellow.png"]]];
          [self.backgroundIV setImage:[[UIImage imageNamed:@"background_yellow.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:5]];
          [defaults setObject:@"yellow" forKey:@"themechoose"];
          [self.myBubbleDiaryTableView reloadData];
     }
     else if (index == 2) {
          [bubbleHeader setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"toutu_grey.png"]]];
          [self.backgroundIV setImage:[[UIImage imageNamed:@"background_grey.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:5]];
          [defaults setObject:@"grey" forKey:@"themechoose"];
          [self.myBubbleDiaryTableView reloadData];
     }
     else if(index == 3) {
          [bubbleHeader setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"toutu.png"]]];
          [self.backgroundIV setImage:[[UIImage imageNamed:@"background.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:5]];
          [defaults setObject:@"nomal" forKey:@"themechoose"];
          [self.myBubbleDiaryTableView reloadData];
     }
     
}


#pragma mark -
#pragma mark bubble table view delegate method
-(NSInteger)rowsForBubbleTable:(UIBubbleTableView *)tableView{
    return [self.diaries count];
}

-(NSBubbleData *)bubbleTableView:(UIBubbleTableView *)tableView dataForRow:(NSInteger)row{
    return [self.diaries objectAtIndex:row];
}


/**
 * Called on the delegate right after calendar controller removes itself from a superview.
 */
//- (void)calendarControllerDidDismissCalendar:(PMCalendarController *)calendarController;



#pragma mark 刷新视图数据
-(void)DoInViewDidAppear
{
    [self initNotification];
     
     [self getData];
     [self.myBubbleDiaryTableView reloadData];
}

-(void)DoInViewDidDisappear
{
     FirstViewDidAppear=YES;
     [[NSNotificationCenter defaultCenter] removeObserver:self];
     self.ACData=nil;
     self.diaries=nil;
}
-(void) getData
{
     /*从数据库取出数据显示*/
     
     NSArray *temp=[[DataClient shareClient] getAllWeibo];
     
     self.ACData=[[NSMutableArray alloc] init];
     if(self.diaries == nil)
          self.diaries=[[NSMutableArray alloc] init];
     
     [self.diaries removeAllObjects];
     [self.ACData removeAllObjects];
     UIImage *testImage = [UIImage imageNamed:@"meng.png"];
     
     for(NSDictionary *dic in temp)
     {
          [self.ACData addObject:dic];
          
          NSString *statusId_or_weiboId=[dic valueForKey:@"id"];
          
          NSArray *comments = [[DataManager sharedDataManager].dataClient getCommentsWithID:statusId_or_weiboId];
          
          if ([comments count] == 0) {
               comments = nil;
          }
          
          NSString *name = [dic valueForKey:@"name"];
          NSString *text = nil;
          NSString *originText = nil;
          UIImage *textImage = nil;
          UIImage *originTextImage = nil;
          NSDate *createdAt = [dic valueForKey:@"created_at"];
          NSBubbleData *bubbleData = nil;
          NSString *fromWhere = [dic valueForKey:@"from"];
          NSBubbleType bubbleType;
          if([[dic valueForKey:@"type"] isEqual:@"person"])
               bubbleType = BubbleTypeMineInHomePage;
          else
               bubbleType = BubbleTypeSomeoneElse;
          
          if([fromWhere isEqualToString:@"sina"]){
               text = [dic valueForKey:@"text"];
               originText = [dic valueForKey:@"repost_text"];
               textImage = [UIImage imageWithData:[dic valueForKey:@"image"]];
               originTextImage = [UIImage imageWithData:[dic valueForKey:@"repostImage"]];
               
               bubbleData = [NSBubbleData dataWithHeadImage:testImage andName:name andText:text andTextImage:textImage andOriginText:originText andOriginTextImage:originTextImage andDate:createdAt andFrom:@"sina" andType:bubbleType andComments:comments andTucao:nil];
               
          }
          //from renren
          else {
               NSString *forward = [dic valueForKey:@"forward"];
               if(forward != nil){
                    text = [dic valueForKey:@"forward"];
                    originText = [dic valueForKey:@"repost_text"];
                    //mine
                    bubbleData = [NSBubbleData dataWithHeadImage:testImage andName:name andText:text andTextImage:nil andOriginText:originText andOriginTextImage:nil andDate:createdAt andFrom:@"renren" andType:bubbleType andComments:comments andTucao:nil];
                    
               }
               //forward is not nil
               else {
                    text = [dic valueForKey:@"text"];
                    bubbleData = [NSBubbleData dataWithHeadImage:testImage andName:name andText:text andTextImage:nil andOriginText:originText andOriginTextImage:nil andDate:createdAt andFrom:@"renren" andType:bubbleType andComments:comments andTucao:nil];
                    
               }
          }          
          [self.diaries addObject:bubbleData];
     }
}
- (void) preloadLeft {
     TimeMenuViewController *c = [[TimeMenuViewController alloc] init];
     [self.revealSideViewController preloadViewController:c
                                                  forSide:PPRevealSideDirectionLeft
                                               withOffset:_offset];
    //NSLog(@"preload");
}
- (void) showLeft {
     TimeMenuViewController *c = [[TimeMenuViewController alloc] init];
     [self.revealSideViewController pushViewController:c onDirection:PPRevealSideDirectionLeft withOffset:_offset animated:YES];
}
-(void)pushControllerWhenRightBarButtonClicked{
     UIActionSheet *actionSheet=[[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"保存到本地" otherButtonTitles:@"分享到新浪微博",@"分享到人人网" ,@"清空全部",nil];
     [actionSheet showInView:[self view]];
}

#pragma  mark 初始化视图和数据
-(void)initNotification
{
    /*各种通知*/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ToDeleteDiary:) name:@"toDeleteCell" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LoadComments:) name:@"toLoadComments" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WeiboUserInfo:) name:@"weibo_userInfo" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(somethingChangeToReload:) name:@"somethingChangeToReload" object:nil];
    
    
}
-(void)configueSlide
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(preloadLeft) object:nil];
    [self performSelector:@selector(preloadLeft) withObject:nil afterDelay:0.0];
}

-(void)initTableView
{
     CGRect bubbleFrame = CGRectMake(0, 0, 320, self.view.frame.size.height - 0);
     self.myBubbleDiaryTableView = [[UIBubbleTableView alloc] initWithFrame:bubbleFrame style:UITableViewStylePlain];
     self.myBubbleDiaryTableView.bubbleDataSource = self;
     self.myBubbleDiaryTableView.showsVerticalScrollIndicator = NO;
     [self.view addSubview:myBubbleDiaryTableView];
}
-(void)initBackground
{
     /*背景图*/
     self.backgroundIV=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
     self.backgroundIV.userInteractionEnabled=NO;
     [self.view addSubview:self.backgroundIV];
     
     
     
     /*时间轴*/
     CGRect lineFrame = CGRectMake(self.view.frame.size.width - 23, 0, 5, self.view.frame.size.height);
     lineView = [[UIView alloc] initWithFrame:lineFrame];
     [lineView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"timeline.png"]]];
     [self.backgroundIV addSubview:lineView];
}
-(void)initHraderView
{
     /*头图*/
     bubbleHeader=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320,153.5)];
     NSUserDefaults *defalut=[NSUserDefaults standardUserDefaults];
     NSString * themechoose=[defalut objectForKey:@"themechoose"];
     UIImage *backgroundImage;
     
     if(themechoose==nil)
     {
          [bubbleHeader setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"toutu.png"]]];
          backgroundImage=[UIImage imageNamed:@"background.png"];
     }
     else if ([themechoose isEqual:@"blue"])
     {
          [bubbleHeader setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"toutu_blue.png"]]];
          backgroundImage=[UIImage imageNamed:@"background_blue.png"];
     }
     else if ([themechoose isEqual:@"yellow"])
     {
          [bubbleHeader setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"toutu_yellow.png"]]];
          backgroundImage=[UIImage imageNamed:@"background_yellow.png"];
     }
     else if ([themechoose isEqual:@"grey"])
     {
          [bubbleHeader setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"toutu_grey.png"]]];
          backgroundImage=[UIImage imageNamed:@"background_grey.png"];
     }
     else if ([themechoose isEqual:@"nomal"])
     {
          [bubbleHeader setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"toutu.png"]]];
          backgroundImage=[UIImage imageNamed:@"background.png"];
     }
     
     
     [self.backgroundIV setImage:[backgroundImage stretchableImageWithLeftCapWidth:0 topCapHeight:5]];
     
     
     
     self.myBubbleDiaryTableView.tableHeaderView=bubbleHeader;
     self.myBubbleDiaryTableView.bounces=NO;
}
-(void)initHeadImage
{
     //圆圈边框
     UIView *circleKuang=[[UIView alloc] initWithFrame:CGRectMake(8, 77, 80, 80)];
     [circleKuang setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"touxiangkuang.png"]]];
     [bubbleHeader addSubview:circleKuang];
     //日记本条
     UIView *bijiben=[[UIView alloc] initWithFrame:CGRectMake(100, 116, 212, 24)];
     [bijiben setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bijiben.png"]]];
     [bubbleHeader addSubview:bijiben];
     
     UIImage *headImage = [UIImage imageNamed:@"defaultHeadImage.png"];
     self.headImageView=[[UIImageView alloc ]initWithFrame:CGRectMake(15, 84, 63, 63)];
     [self.headImageView setImage:headImage];
     self.headImageView.layer.cornerRadius=31;
     self.headImageView.layer.masksToBounds=YES;
     [bubbleHeader addSubview:self.headImageView];
}
-(void)initAddButton
{
     UIImage *image = [UIImage imageNamed:@"jiahao.png"];
     UIImage *selectedImage = [UIImage imageNamed:@"jiahao.png"];
     UIImage *toggledImage = [UIImage imageNamed:@"jiahao.png"];
     UIImage *toggledSelectedImage = [UIImage imageNamed:@"jiahao.png"];
     
     CGPoint center = CGPointMake(40.0f, self.view.frame.size.height-40);
     
     NSArray *buttons;
     CGRect buttonFrame = CGRectMake(0, 0, 60.0f, 60.0f);
     UIButton *b1 = [UIButton buttonWithType:UIButtonTypeCustom];
     [b1 setFrame:buttonFrame];
     [b1 setImage:[UIImage imageNamed:@"publish.png"] forState:UIControlStateNormal];
     [b1 setImage:[UIImage imageNamed:@"publishclick.png"] forState:UIControlStateHighlighted];
     [b1 addTarget:self action:@selector(onCreateDiary) forControlEvents:UIControlEventTouchUpInside];
     UIButton *b2 = [UIButton buttonWithType:UIButtonTypeCustom];
     [b2 setImage:[UIImage imageNamed:@"weiboku.png"] forState:UIControlStateNormal];
     [b2 setImage:[UIImage imageNamed:@"weiboku2.png"] forState:UIControlStateHighlighted];
     [b2 setFrame:buttonFrame];
     [b2 addTarget:self action:@selector(toMaterialKit) forControlEvents:UIControlEventTouchUpInside];
     
     UIButton *b3 = [UIButton buttonWithType:UIButtonTypeCustom];
     [b3 setImage:[UIImage imageNamed:@"zhuti.png"] forState:UIControlStateNormal];
     [b3 setImage:[UIImage imageNamed:@"zhuti2.png"] forState:UIControlStateHighlighted];
     [b3 setFrame:buttonFrame];
     [b3 addTarget:self action:@selector(toThemeKit) forControlEvents:UIControlEventTouchUpInside];
     
     buttons = [NSArray arrayWithObjects:b1, b2, b3, nil];
     
     ExpandingButtonBar *bar = [[ExpandingButtonBar alloc] initWithImage:image selectedImage:selectedImage toggledImage:toggledImage toggledSelectedImage:toggledSelectedImage buttons:buttons center:center];
     [bar setHorizontal:YES];
     [bar setExplode:YES];
     
     [bar setDelegate:self];
     [bar setSpin:YES];
     
     [self setBar:bar];
     [[self view] addSubview:[self bar]];
     
     [[self navigationController] setToolbarHidden:YES];
     [[self navigationController] setNavigationBarHidden:NO];
}
-(void)initNavigationBar
{
     //导航bar
     navBar=[[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
     [navBar setBackgroundImage:[UIImage imageNamed:@"wodeshijianzhou.png"] forBarMetrics:UIBarMetricsDefault];
     //导航item
     item=[[UINavigationItem alloc] initWithTitle:nil];
     [navBar pushNavigationItem:item animated:YES];
     
     UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
     [rightButton setBackgroundColor:[UIColor clearColor]];
     rightButton.frame = CGRectMake(0, 0, 40, 40);
     [rightButton setImage:[UIImage imageNamed:@"share1.png"] forState:UIControlStateNormal];
     [rightButton setImage:[UIImage imageNamed:@"share2.png"] forState:UIControlStateHighlighted];
     [rightButton addTarget:self action:@selector(pushControllerWhenRightBarButtonClicked) forControlEvents:UIControlEventTouchUpInside];
     UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
     item.rightBarButtonItem = button;
     
     UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
     backButton.frame = CGRectMake(0, 0, 40, 40);
     [backButton setImage:[UIImage imageNamed:@"change.png"] forState:UIControlStateNormal];
     //[backButton setImage:[UIImage imageNamed:@"timeclick.png"] forState:UIControlStateHighlighted];
     [backButton addTarget:self action:@selector(showLeft) forControlEvents:UIControlEventTouchUpInside];
     button = [[UIBarButtonItem alloc] initWithCustomView:backButton];
     item.leftBarButtonItem = button;
     
     [self.view addSubview:navBar];
     
}
-(void)initSlideView
{
     /*侧边栏*/
     _offset=100.0;
     [self.revealSideViewController changeOffset:_offset
                                    forDirection:PPRevealSideDirectionLeft];
     
     PPRevealSideInteractions inter = PPRevealSideInteractionNone;
     inter |= PPRevealSideInteractionContentView;
     self.revealSideViewController.panInteractionsWhenOpened = inter;
     self.revealSideViewController.panInteractionsWhenClosed = inter;
     self.revealSideViewController.tapInteractionsWhenOpened = inter;
}
-(void)initData
{
     /*用户信息*/
     if([[DataManager sharedDataManager] isWeiboAuthValid])
     {
          [[DataManager sharedDataManager] userInfo:1];
     }
     else if([[DataManager sharedDataManager] isWeiboAuthValid])
     {
          [[DataManager sharedDataManager] userInfo:2];
     }
     
     FirstViewDidAppear=YES;
     
//     UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(simpleClick:)];
//     tapGestureRecognizer.cancelsTouchesInView = NO;
//     [self.view addGestureRecognizer:tapGestureRecognizer];
}
-(void)simpleClick:(UITapGestureRecognizer *)sender{
     [self.bar hideButtonsAnimated:NO];
     //由UIBubbleTableViewCell接收 通知，用gesture位置！！！！！
     CGPoint point = [sender locationInView:self.view];
     NSValue *position = [NSValue valueWithCGPoint:point];
     //给uibubbletableviewcell传通知，关闭editsubview
     [[NSNotificationCenter defaultCenter] postNotificationName:@"closeEditSubviewWhenTouched" object:position];
     
}

@end
