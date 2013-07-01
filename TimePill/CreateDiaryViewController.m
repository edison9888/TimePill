//
//  CreateDiaryViewController.m
//  Timeline
//
//  Created by 04 developer on 12-10-24.
//  Copyright (c) 2012年 Sun Yat-sen University. All rights reserved.
//啊

#import "CreateDiaryViewController.h"

@implementation CreateDiaryViewController
@synthesize textview;
@synthesize label_time;
@synthesize label_date;
@synthesize label_place;
@synthesize btn_position;
@synthesize iv_Preview;
@synthesize keyboardHeader;
@synthesize longWeibo,type;
- (void)viewDidLoad
{
    [super viewDidLoad];
    /*----------------------------------------导航栏----------------------------------------*/
    //导航bar
    UINavigationBar *bar=[[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [bar setBackgroundImage:[UIImage imageNamed:@"fabuxinriji.png"] forBarMetrics:UIBarMetricsDefault];
    //导航item
    UINavigationItem *item=[[UINavigationItem alloc] initWithTitle:nil];
    [bar pushNavigationItem:item animated:YES];
    //返回按钮
    UIButton *returnBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    returnBtn.frame=CGRectMake(0, 0, 40, 40);
    [returnBtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [returnBtn setImage:[UIImage imageNamed:@"backclick.png"] forState:UIControlEventTouchUpInside];
    [returnBtn addTarget:self action:@selector(ReturnTo) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:returnBtn];
    item.leftBarButtonItem=leftBarButtonItem;
    //发送按钮
    UIButton *publishBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    publishBtn.frame=CGRectMake(0, 0, 40, 40);
    [publishBtn setImage:[UIImage imageNamed:@"done.png"] forState:UIControlStateNormal];
    [publishBtn setImage:[UIImage imageNamed:@"doneclick.png"] forState:UIControlEventTouchUpInside];
    [publishBtn addTarget:self action:@selector(PublishTo) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:publishBtn];
    item.rightBarButtonItem=rightBarButtonItem;
    [self.view addSubview:bar];
    
    /*----------------------------------------背景----------------------------------------*/
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    keyboardHeader.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"rectangle.png"]];
    self.iv_Preview.frame=CGRectMake(25, self.view.bounds.size.height-216-50-25, 25, 25);
    
    /*----------------------------------------编辑框----------------------------------------*/
    [textview becomeFirstResponder];
    self.textview.hint = NSLocalizedString(@"写点什么吧...",);
    
    /*----------------------------------------地点----------------------------------------*/
    //获取地点
    lm=[[CLLocationManager alloc] init];
    lm.delegate=self;
    isUsingPosition=NO;
    //label_place.layer.contents=(id)[UIImage imageNamed:@"button.png"].CGImage;
    //label_place.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"button.png"]];
    
    //设置当前时间
    [self setCurrentTime];
    //监听键盘退出事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
    
    /*----------------------------------------分享栏----------------------------------------*/

    shareBack=[[UIView alloc] initWithFrame:CGRectMake(160, self.view.bounds.size.height/2-50, 150, 66)];
    shareBack.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"switch_bg.png"]];
    shareBack.hidden=YES;
    [self.view insertSubview:shareBack aboveSubview:textview];
    isOpen=NO;
    
    //微博开关
    CustomSwitch *weiboSwitch=[[CustomSwitch alloc] initWithFrame:CGRectMake(20, 15, 47, 18) andBackImage:[UIImage imageNamed:@"onoff.png"] andButtonImage:[UIImage imageNamed:@"weibo.png"] andType:1];
    [shareBack addSubview:weiboSwitch];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL weibo_isOn = [userDefaults boolForKey:@"1"];
    [weiboSwitch setOn:weibo_isOn];
            NSLog(@"weibo_isOn=%d",weibo_isOn);
    //人人开关
    CustomSwitch *renrenSwitch=[[CustomSwitch alloc] initWithFrame:CGRectMake(95, 15, 47, 18) andBackImage:[UIImage imageNamed:@"onoff.png"] andButtonImage:[UIImage imageNamed:@"renren.png"] andType:2];
    [shareBack addSubview:renrenSwitch];
    BOOL renren_isOn = [userDefaults boolForKey:@"2"];
        NSLog(@"renren_isOn=%d",renren_isOn);
    [renrenSwitch setOn:renren_isOn];
    
    
    /*----------------------------------------表情栏----------------------------------------*/
    //设置背景
    emotionsBack=[[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, 320, 216)];
    emotionsBack.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"motionbg.png"]];
    //设置表情ScrollView
    emotionsView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
    emotionsView.pagingEnabled=YES;  //是否自动滑到边缘的关键
    emotionsView.contentSize=CGSizeMake(320*2, 216);
    emotionsView.showsHorizontalScrollIndicator=NO;
    emotionsView.delegate=self;
    [self.view insertSubview:emotionsBack aboveSubview:shareBack];
    [emotionsBack addSubview:emotionsView];
    
    //表情文本数组
    weiboEmotions=[[NSArray alloc] initWithObjects:@"[爱你]",@"[悲伤]",@"[闭嘴]",@"[馋嘴]",@"[吃惊]",@"[哈哈]",@"[害羞]",@"[汗]",@"[呵呵]",@"[黑线]",@"[花心]",@"[挤眼]",@"[可爱]",@"[可怜]",@"[酷]",@"[困]",@"[泪]",@"[生病]",@"[失望]",@"[偷笑]",@"[晕]",@"[挖鼻屎]",@"[阴险]",@"[囧]",@"[怒]",@"[good]",@"[给力]",@"[浮云]", nil];
    weiboEmotions2=[[NSArray alloc] initWithObjects:@"[嘻嘻]",@"[鄙视]",@"[亲亲]",@"[太开心]",@"[懒得理你]",@"[右哼哼]",@"[左哼哼]",@"[嘘]",@"[衰]",@"[委屈]",@"[吐]",@"[打哈欠]",@"[抱抱]",@"[疑问]",@"[拜拜]",@"[思考]",@"[睡觉]",@"[钱]",@"[哼]",@"[鼓掌]",@"[抓狂]",@"[怒骂]",@"[熊猫]",@"[奥特曼]",@"[猪头]",@"[蜡烛]",@"[蛋糕]",@"[din推撞]", nil];
    
    //把表情添加到scrollview中
    for(int i=0;i<4;i++)
    {
        for(int j=0;j<7;j++)
        {
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            button.frame=CGRectMake(18+j*43, 20+i*45, 25, 25);
            UIImage *image=[UIImage imageNamed:[NSString stringWithFormat:@"w%d.gif",i*7+j]];
            [button setImage:image forState:UIControlStateNormal];
            button.tag=i*7+j;
            [button addTarget:self action:@selector(emotionclicked:) forControlEvents:UIControlEventTouchUpInside];
            [emotionsView addSubview:button];
        }
    }
    for(int i=0;i<4;i++)
    {
        for(int j=0;j<7;j++)
        {
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            button.frame=CGRectMake(320+18+j*43, 20+i*45, 25, 25);
            UIImage *image=[UIImage imageNamed:[NSString stringWithFormat:@"r%d.gif",i*7+j]];
            [button setImage:image forState:UIControlStateNormal];
            button.tag=28+i*7+j;
            [button addTarget:self action:@selector(emotionclicked:) forControlEvents:UIControlEventTouchUpInside];

            [emotionsView addSubview:button];
        }
    }
    //设置表情pageControl
    pageControl=[[UIPageControl alloc] initWithFrame:CGRectMake(135, 170, 40, 50)];
    pageControl.numberOfPages=2;
    pageControl.currentPage=0;
    [pageControl addTarget:self action:@selector(showChanges) forControlEvents:UIControlEventValueChanged];
    [emotionsBack insertSubview:pageControl atIndex:2];
    
    /*----------------------------------------注册通知----------------------------------------*/
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(returnImage:) name:@"painting" object:nil ];
    
    /*长微博时使用*/
    if(self.longWeibo!=nil)
    {
        if([self.type isEqualToString:@"sina"])
        {
            [weiboSwitch setOn:YES];
            [renrenSwitch setOn:NO];
            [self.iv_Preview setImage:longWeibo];
        }
        else {
            [weiboSwitch setOn:NO];
            [renrenSwitch setOn:YES];
            [self.iv_Preview setImage:longWeibo];
        }
    }
}

#pragma mark 导航栏
-(void)ReturnTo
{
    [self performSegueWithIdentifier:@"CreateToFirst" sender:self];
}

-(void)PublishTo
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //微博开关
    Boolean weibo_isOn = [userDefaults boolForKey:@"1"];
    //人人开关
    Boolean renren_isOn = [userDefaults boolForKey:@"2"];
    
    NSLog(@"weibo=%d,renren=%d",weibo_isOn,renren_isOn);
    if(renren_isOn==YES && weibo_isOn==YES)
    {
        if (![[DataManager sharedDataManager] isWeiboAuthValid] && ![[DataManager sharedDataManager] isRenRenAuthValid])
        {
            [self performSegueWithIdentifier:@"ToLogin" sender:self];
        }
        else if(![[DataManager sharedDataManager] isWeiboAuthValid])  //微博未授权
        {
            [[[DataManager sharedDataManager] sinaWeiboData] ToLogin];
        }
        else if(![[DataManager sharedDataManager] isRenRenAuthValid])  //人人未授权
        {
            [[[DataManager sharedDataManager] renrenData] ToLogin];
        }
        else {
           
            NSString *latStr=[NSString stringWithFormat:@"%f",latitude];
            NSString *longStr=[NSString stringWithFormat:@"%f",longitude];
            if(iv_Preview.image==nil)  //没有图片
            {
                if([[textview text] isEqualToString:@""])
                {
                    //提示输入文本为空
                    [SVProgressHUD showErrorWithStatus:@"写点东西吧..." duration:1.0f];
                }
                else {
                    [[[DataManager sharedDataManager] sinaWeiboData] postStatus:[textview text] andLat:latStr andLong:longStr];
                    [[[DataManager sharedDataManager] renrenData] postStatus:[textview text]];
                    [self dismissModalViewControllerAnimated:YES];
                }
            }
            else{   //有图片
                if([[textview text] isEqualToString:@""])
                    [textview setText:@"分享图片"];
                [[[DataManager sharedDataManager] sinaWeiboData] postImageStatus:[textview text] andImage:[iv_Preview image] andLat:latStr andLong:longStr]; 
                [[[DataManager sharedDataManager] renrenData] postImageStatus:[textview text] andImage:[iv_Preview image]];
                [self dismissModalViewControllerAnimated:YES];
            }
        }

    }
    else if(renren_isOn==NO && weibo_isOn==YES)
    {
        if(![[DataManager sharedDataManager] isWeiboAuthValid])  //微博未授权
        {
            [[[DataManager sharedDataManager] sinaWeiboData] ToLogin];
        }
        else {
            
            NSString *latStr=[NSString stringWithFormat:@"%f",latitude];
            NSString *longStr=[NSString stringWithFormat:@"%f",longitude];
            if(iv_Preview.image==nil)  //没有图片
            {
                if([[textview text] isEqualToString:@""])
                {
                    //提示输入文本为空
                    [SVProgressHUD showErrorWithStatus:@"写点东西吧..." duration:1.0f];
                }
                else {
                    
                    [[[DataManager sharedDataManager] sinaWeiboData] postStatus:[textview text] andLat:latStr andLong:longStr];
                    [self dismissModalViewControllerAnimated:YES];
                }
            }
            else{   //有图片
                
                if([[textview text] isEqualToString:@""])
                    [textview setText:@"分享图片"];
                [[[DataManager sharedDataManager] sinaWeiboData] postImageStatus:[textview text] andImage:[iv_Preview image] andLat:latStr andLong:longStr];
                [self dismissModalViewControllerAnimated:YES];
            }
        }

    }
    else if(renren_isOn==YES && weibo_isOn==NO)
    {
        if(![[DataManager sharedDataManager] isRenRenAuthValid])  //人人未授权
        {
            [[[DataManager sharedDataManager] renrenData] ToLogin];
        }
        else {
            if(iv_Preview.image==nil)  //没有图片
            {
                if([[textview text] isEqualToString:@""])
                {
                    //提示输入文本为空
                    [SVProgressHUD showErrorWithStatus:@"写点东西吧..." duration:1.0f];
                }
                else {
                    [[[DataManager sharedDataManager] renrenData] postStatus:[textview text]];
                    [self dismissModalViewControllerAnimated:YES];
                }
            }
            else{   //有图片
                if([[textview text] isEqualToString:@""])
                    [textview setText:@"分享图片"];
                [[[DataManager sharedDataManager] renrenData] postImageStatus:[textview text] andImage:[iv_Preview image]];
                [self dismissModalViewControllerAnimated:YES];
            }
        }

    }
    else {
        
        [SVProgressHUD showErrorWithStatus:@"请选择要分享到哪？" duration:1.0f];
    }
        
}

#pragma mark 分页控制
-(void)showChanges
{
    int page=pageControl.currentPage;
    emotionsView.contentOffset=CGPointMake(320*(page), 0);
}

#pragma mark 表情栏
//点击某一个表情后调用
-(void)emotionclicked:(id)sender
{
    UIButton *button=(UIButton *)sender;
    int tag=button.tag;
    NSLog(@"%d",button.tag);
    //该表情的文本
    NSString *emotionStr;
    if(tag>=28)
    {
        int index=tag-28;
        emotionStr=[weiboEmotions2 objectAtIndex:index];
        //NSLog(@"%@",emotionStr);
    }
    else {
        emotionStr=[weiboEmotions objectAtIndex:tag];
    }
    textview.text=[textview.text stringByAppendingFormat:emotionStr];
}

#pragma mark 时间栏
-(void)setCurrentTime
{
    // NSDateFormatter
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init]; 
    // NSDate
    NSDate *date = [NSDate date]; 
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    // NSCalendar
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]; 
    // NSDateComponents
    NSDateComponents *comps;
    NSInteger unitFlags = NSYearCalendarUnit | 
    NSMonthCalendarUnit | 
    NSDayCalendarUnit | 
    NSWeekdayCalendarUnit | 
    NSHourCalendarUnit | 
    NSMinuteCalendarUnit | 
    NSSecondCalendarUnit; 
    comps = [calendar components:unitFlags fromDate:date]; 
    int week = [comps weekday]; 
    int year=[comps year]; 
    int month = [comps month]; 
    int day = [comps day]; 
    int hour = [comps hour]; 
    int min = [comps minute]; 
    weeks=[[NSArray alloc] initWithObjects:@"星期x",@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六", nil];
    NSString *timeStr=[NSString stringWithFormat:@"%d:%d",hour,min];
    NSString *dateStr=[NSString stringWithFormat:@"%@ %d年%d月%d日",[weeks objectAtIndex:week],year,month,day];
    label_time.text=timeStr;
    label_date.text=dateStr;
}
- (void) keyboardWillDisappear:(NSNotification*)notification{
    animDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
}

#pragma mark 滚动视图delegate

/*----------------------滑动的时候设置对应的分页-----------------------*/
- (void)scrollViewDidScroll:(UIScrollView *)scrollView_ 
{
    CGFloat pageWidth = scrollView_.frame.size.width;
    
    int page = floor((scrollView_.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
	
	[pageControl setCurrentPage:page];
}

#pragma mark 地点delegate
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [btn_position setImage:[UIImage imageNamed:@"positionclick.png"] forState:UIControlStateNormal];
    latitude=newLocation.coordinate.latitude;
    longitude=newLocation.coordinate.longitude;
    CLGeocoder *geocoder=[[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks,NSError *error)
     {
         for(CLPlacemark *placemark in placemarks)
         {
             NSLog(@"获取地点成功");
             NSLog(@"address dir %@",placemark.addressDictionary);
             label_place.text=[placemark.addressDictionary objectForKey:@"City"];
         }
     }];
    [lm stopUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"注意"
                          message:@"获取地点失败"
                          delegate:self
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark 工具栏函数
- (IBAction)shareTo:(id)sender {
    if(isOpen==NO)
    {
        //键盘高度
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        double height=[defaults doubleForKey:@"KeyboardHeight"];
        [UIView animateWithDuration:0.1618f animations:^(void){
            shareBack.hidden=NO;
            shareBack.frame=CGRectMake(160, self.view.bounds.size.height-height-70-44, 150, 66);
        }];
        isOpen=YES;
    }
    else {
        [UIView animateWithDuration:0.1618f animations:^(void){
            shareBack.frame=CGRectMake(160, self.view.bounds.size.height/2+50, 150, 66);
        }completion:^(BOOL finished){
            shareBack.hidden=YES;
        }];
        isOpen=NO;
    }

}


- (IBAction)getPlace:(id)sender {
    if(isUsingPosition==NO)
    {
        [lm startUpdatingLocation];
        isUsingPosition=YES;
    }
    else {
        [lm stopUpdatingLocation];
        [btn_position setImage:[UIImage imageNamed:@"position.png"] forState:UIControlStateNormal];
        isUsingPosition=NO;
    }
   
}

- (IBAction)getEmotions:(id)sender {
    if([textview isFirstResponder])
       {
           [textview resignFirstResponder];
           UIViewAnimationOptions options = UIViewAnimationOptionAllowAnimatedContent;
           //Animate view
           [UIView animateWithDuration:animDuration delay:0.0f
                               options:options
                            animations:^(void){
                                emotionsBack.frame=CGRectMake(0, self.view.bounds.size.height-216, 320, 216);
                            }
                            completion:^(BOOL finished){
                                emotionsBack.frame=CGRectMake(0, self.view.bounds.size.height-216, 320, 216);
                            }];
       }
    else {
        [textview becomeFirstResponder];
        emotionsBack.frame=CGRectMake(0, self.view.bounds.size.height-216, 320, 216);
        UIViewAnimationOptions options = UIViewAnimationOptionAllowAnimatedContent;
        //Animate view
        [UIView animateWithDuration:animDuration delay:0.0f
                            options:options
                         animations:^(void){
                             emotionsBack.frame=CGRectMake(0, self.view.bounds.size.height, 320, 216);
                         }
                         completion:^(BOOL finished){
                             emotionsBack.frame=CGRectMake(0, self.view.bounds.size.height, 320, 216);
                         }];
    }
    
}

- (IBAction)getPhotos:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"照相机",@"相册",nil];
    [actionSheet showInView:self.view];
}

- (IBAction)ToDraw:(id)sender {
    UIStoryboard *story=[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    
    UIViewController *paintingVC=[story instantiateViewControllerWithIdentifier:@"PaintingViewController"];
    [self presentModalViewController:paintingVC animated:YES];
}


#pragma mark 通知处理
-(void)returnImage:(NSNotification *)note
{
    NSLog(@"pass");
    iv_Preview.image=note.object;
}
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	UIImagePickerController *picker=[[UIImagePickerController alloc] init];
	picker.delegate=self;
	picker.allowsEditing=YES;
    
    /*----------------------调用照相机-----------------------*/
    if(buttonIndex==0)
    {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            NSLog(@"照相机不能用");
        }
        //前后摄像机
        //picker.cameraDevice=UIImagePickerControllerCameraDeviceFront;
        picker.sourceType=UIImagePickerControllerSourceTypeCamera;
        [self presentModalViewController:picker animated:YES];
    }
    /*----------------------调用相册-----------------------*/
    else if(buttonIndex==1){
        picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentModalViewController:picker animated:YES];
    }
}

#pragma mark UIImagePickerControllerDelegate
//调用照片成功
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	//返回原来界面
	[picker dismissModalViewControllerAnimated:YES];
	UIImage* image=[info objectForKey:UIImagePickerControllerEditedImage];
    self.iv_Preview.image=image;
}



- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self setTextview:nil];
    [self setLabel_time:nil];
    [self setLabel_date:nil];
    [self setLabel_place:nil];
    [self setKeyboardHeader:nil];
    [self setBtn_position:nil];
    [self setIv_Preview:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
@end
