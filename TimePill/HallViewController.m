//
//  HallViewController.m
//  Timeline
//
//  Created by yongry on 12-12-15.
//  Copyright (c) 2012年 Sun Yat-sen University. All rights reserved.
//

#import "HallViewController.h"
#import "TimeMenuViewController.h"
#define ITEM_SPACING 200

@interface HallViewController ()
@property (nonatomic, strong) NSArray *picArray;

@property BOOL flag;
@property (nonatomic,strong)UIView *zoomView;
@property (nonatomic, strong)UIScrollView *fullView;
@property int nowIndex;
@property (nonatomic,strong)UIImageView *bgImage;
@property (nonatomic, strong)UIImage *temptImage;
@property (nonatomic, strong)UIImage *storeImage;
@property (nonatomic, strong)UIView *subView;
@property (nonatomic, strong)UINavigationBar *temNavBar;
@end

@implementation HallViewController

@synthesize carousel;
@synthesize zoomView;
@synthesize navBar;
@synthesize fullView;
@synthesize item;
@synthesize flag;
@synthesize wrap;
@synthesize bgImage;
@synthesize nowIndex;
@synthesize temptImage;
@synthesize picArray;
@synthesize storeImage;
@synthesize subView;
@synthesize temNavBar;


#pragma mark -

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        wrap = YES;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
    [self configueSlide];
    [SVProgressHUD showWithStatus:@"加载图片中..."];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{[self initHall];
        dispatch_async(dispatch_get_main_queue(), ^{
            carousel.delegate = self;
            carousel.dataSource = self;
            [SVProgressHUD dismiss];
        });
    });
    
    
}
-(void)initView
{
    /*----------------------------导航栏---------------------------*/
    //导航bar
    navBar.backgroundColor=[UIColor whiteColor];
    [navBar setBackgroundImage:[UIImage imageNamed:@"nav.png"] forBarMetrics:UIBarMetricsDefault];
    
    UIButton *timeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [timeButton setBackgroundColor:[UIColor clearColor]];
    timeButton.frame = CGRectMake(0, 0, 40, 40);
    [timeButton setImage:[UIImage imageNamed:@"change.png"] forState:UIControlStateNormal];
    
    [timeButton addTarget:self action:@selector(showLeft) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *timeitem = [[UIBarButtonItem alloc] initWithCustomView:timeButton];
    item.leftBarButtonItem = timeitem;
    
    //导航item
    [navBar pushNavigationItem:item animated:YES];
    temNavBar=[[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [temNavBar setBackgroundImage:[UIImage imageNamed:@"nav.png"] forBarMetrics:UIBarMetricsDefault];
    
    UINavigationItem *temItem=[[UINavigationItem alloc] initWithTitle:nil];
    [temNavBar pushNavigationItem:temItem animated:YES];
    
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setBackgroundColor:[UIColor clearColor]];
    leftButton.frame = CGRectMake(0, 0, 40, 40);
    [leftButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    
    [leftButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    temItem.leftBarButtonItem = button;
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setBackgroundColor:[UIColor clearColor]];
    rightButton.frame = CGRectMake(0, 0, 40, 40);
    [rightButton setImage:[UIImage imageNamed:@"magic.png"] forState:UIControlStateNormal];
    [rightButton setImage:[UIImage imageNamed:@"magicdown.png"] forState:UIControlStateHighlighted];
    [rightButton addTarget:self action:@selector(pushControllerWhenRightBarButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *button2 = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    temItem.rightBarButtonItem = button2;
    
    [temNavBar setAlpha:0.0];
    
    // 背景
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"hlbackground.png"]]];

}
-(void)initHall
{

    carousel.type = iCarouselTypeCoverFlow2;
    //self.wrap = YES;
    self.picArray = [[DataManager sharedDataManager] getLongWeibo];
    self.flag = false;
    //NSLog(@"有几幅图%d",[self.picArray count]);
    bgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pic3.png"]];
    bgImage.frame = CGRectMake(32, 60, 255, 400);
    int h = bgImage.image.size.height;
    int w = bgImage.image.size.width;
    // float scale = (float)240.0/w;
    CGSize itemSize = CGSizeMake(w, h);
    UIGraphicsBeginImageContext(itemSize);
    CGRect imageRect = CGRectMake(0, 0, 255, 400);
    [self.bgImage.image drawInRect:imageRect];
    self.bgImage.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGRect rect =  CGRectMake(0, 0, 255, 400);
    CGImageRef cgimg = CGImageCreateWithImageInRect([bgImage.image CGImage], rect);
    temptImage = [UIImage imageWithCGImage:cgimg];
    
}
-(void)configueSlide
{
    PPRevealSideInteractions inter = PPRevealSideInteractionNone;
    self.revealSideViewController.panInteractionsWhenOpened = inter;
    self.revealSideViewController.panInteractionsWhenClosed = inter;
    self.revealSideViewController.tapInteractionsWhenOpened = inter;
    //self.revealSideViewController
}
- (void) showLeft {
    TimeMenuViewController *c = [[TimeMenuViewController alloc] init];
    [self.revealSideViewController pushViewController:c onDirection:PPRevealSideDirectionLeft withOffset:100.0 animated:YES];
}
-(void)setTableScrollEnable:(Boolean)en
{
    
}
- (BOOL)carouselShouldWrap:(iCarousel *)carousel
{
    return wrap;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.navBar = nil;
    self.carousel = nil;
    self.item = nil;
    // self.navItem = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark -

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [picArray count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index
{
    NSData *temData = [[self.picArray objectAtIndex:index] valueForKey:@"abstract"];
    //NSLog(@"data is");
    temptImage = [UIImage imageWithData:temData];
    self.nowIndex = index;
    self.subView = [[UIImageView alloc] initWithImage:temptImage];
    subView.frame = CGRectMake(70, 80, 200, self.view.frame.size.height*0.75);
   // [self.view insertSubview:subView aboveSubview:bgImage];
    subView.userInteractionEnabled = YES;
    self.bgImage.image = temptImage;
    //  [self.view addSubview:bgImage];
        
    return subView;
}

- (void)enterFullscreen
{
	self.flag = YES;
	
	[self disableApp];
	
	[self.navigationController setNavigationBarHidden:YES animated:YES];
	
	[UIView beginAnimations:@"galleryOut" context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(enableApp)];
	self.navBar.alpha = 0.0;
    self.temNavBar.alpha = 0.0;
	[UIView commitAnimations];
}



- (void)exitFullscreen
{
	self.flag = NO;
    
	[self disableApp];
    
	[self.navigationController setNavigationBarHidden:NO animated:YES];
    
	[UIView beginAnimations:@"galleryIn" context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(enableApp)];
	self.navBar.alpha = 0.0;
    self.temNavBar.alpha = 1.0;
	[UIView commitAnimations];
}



- (void)enableApp
{
	[[UIApplication sharedApplication] endIgnoringInteractionEvents];
}


- (void)disableApp
{
	[[UIApplication sharedApplication] beginIgnoringInteractionEvents];
}




- (void)singClicked:(id)sender
{
    [self.temNavBar setAlpha:1.0];
    [self.view addSubview:temNavBar];
    if (flag == FALSE) {
        [self enterFullscreen];
        
        flag = TRUE;
    }
    else {
        [self exitFullscreen];
        flag = FALSE;
        
    }
    
}

-(void)backButtonClicked
{
    
    zoomView = [carousel itemViewAtIndex:nowIndex];
    [fullView setBackgroundColor:[UIColor colorWithPatternImage:temptImage]];
    [UIView animateWithDuration:0.2 animations:^(void){
        //  zoomView.frame = CGRectMake(-60, -48-44, self.view.frame.size.width, self.view.frame.size.height);
        fullView.frame = CGRectMake(60, 92, 200, 320);
        
    } completion:^(BOOL finished){
        [fullView removeFromSuperview];
        [self.temNavBar removeFromSuperview];
        [self exitFullscreen];
        self.navBar.alpha = 1.0;
        
    }];
    
}


- (NSUInteger)numberOfPlaceholdersInCarousel:(iCarousel *)carousel
{
	return 0;
}

- (NSUInteger)numberOfVisibleItemsInCarousel:(iCarousel *)carousel
{
    // if ([picArray count] > 3) {
    return 3;
    //  }
    // return [picArray count];
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    return ITEM_SPACING;
}

- (CATransform3D)carousel:(iCarousel *)_carousel transformForItemView:(UIView *)view withOffset:(CGFloat)offset
{
    view.alpha = 1.0 - fminf(fmaxf(offset, 0.0), 1.0);
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = self.carousel.perspective;
    transform = CATransform3DRotate(transform, M_PI / 8.0, 0, 1.0, 0);
    return CATransform3DTranslate(transform, 0.0, 0.0, offset * carousel.itemWidth);
}

-(void)pushControllerWhenRightBarButtonClicked
{
    UIActionSheet *actionSheet=[[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil];
    [actionSheet showInView:[self view]];
}



-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //NSLog(@"%d",buttonIndex);
    switch (buttonIndex){
        case 0:
        {
            [[DataManager sharedDataManager] deleteLong:self.nowIndex];
            self.picArray = [[DataManager sharedDataManager] getLongWeibo];
            [carousel removeItemAtIndex:nowIndex animated:YES];
            [self backButtonClicked];
            [carousel reloadData];
            // [self reloadInputViews];
            //
            // [self.carousel setNeedsDisplay];
        }
        case 1:
            
            break;
        case 2:
            break;
        case 3:
            break;
        default:
            break;
    }
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    self.nowIndex = index;
    
    NSData *temData = [[self.picArray objectAtIndex:index] valueForKey:@"longWeibo"];
    temptImage = [UIImage imageWithData:temData];
    
    
    zoomView = [carousel itemViewAtIndex:index];
    //	NSData *temData = [[self.picArray objectAtIndex:self.nowIndex] valueForKey:@"longWeibo"];
    //    NSLog(@"%f",self.zoomView.superview.frame.origin.y);
    //   UIImage *zoomImage = [UIImage imageWithData:temData];
    CGSize imageSize = temptImage.size;
    CGFloat w = imageSize.width;
    float scale = (float)320.0/w;
    CGFloat h = imageSize.height;
    
    CGSize itemSize = CGSizeMake(w, h);
    UIGraphicsBeginImageContext(itemSize);
    CGRect imageRect = CGRectMake(0, 0, scale*w, scale*h);
    [temptImage drawInRect:imageRect];
    temptImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //  [temptImage setBackgroundColor:nil];
    fullView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.zoomView.superview.frame.origin.x , self.zoomView.superview.frame.origin.y+44, 200, 320)];
    //NSLog(@"%f,%f",self.zoomView.superview.frame.origin.x , self.zoomView.superview.frame.origin.y+44);
    //    fullView.contentSize = CGSizeMake(w*scale, h*scale);
    //    [fullView setBackgroundColor:[UIColor colorWithPatternImage:zoomImage]];
    fullView.contentSize = CGSizeMake(scale*w, scale*h);
    [fullView setBackgroundColor:[UIColor colorWithPatternImage:temptImage]];
    fullView.bounces = NO;
    [fullView setShowsHorizontalScrollIndicator:NO];
    [self.view addSubview:fullView];
    
    [UIView animateWithDuration:0.3 animations:^(void)
     {
         fullView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
         
     }];
    
    
    
    [self enterFullscreen];
    flag = TRUE;
    
    UITapGestureRecognizer *singleClick = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singClicked:)];
    [fullView addGestureRecognizer:singleClick];
    
}


@end




