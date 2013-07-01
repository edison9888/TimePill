//
//  KeyboardHeaderView.m
//  Timeline
//
//  Created by 01 developer on 12-11-3.
//  Copyright (c) 2012年 Sun Yat-sen University. All rights reserved.
//

#import "KeyboardHeaderView.h"

@implementation KeyboardHeaderView

#pragma mark - Init Methods

- (id) init{
    self = [super init];
    if (self){
        
        [self keyboardCoViewCommonInit];
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        [self keyboardCoViewCommonInit];
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self){
        [self keyboardCoViewCommonInit];
    }
    return self;
}


- (void) keyboardCoViewCommonInit{
    //注册监听事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
}
#pragma mark - Keyboard notification methods
- (void) keyboardWillDisappear:(NSNotification*)notification
{
    //NSLog(@"keyboardWillDisappear");
    CGRect beginRect = [[notification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    beginRect = [self fixKeyboardRect:beginRect];
    if(beginRect.size.height>216)
    {
        CGRect selfEndingRect = CGRectMake(beginRect.origin.x,
                                       beginRect.origin.y - self.frame.size.height+36,
                                       beginRect.size.width,
                                       self.frame.size.height);
    
        self.frame = selfEndingRect;
    }
}

- (void) keyboardWillAppear:(NSNotification*)notification{
    //Get begin, ending rect and animation duration
    CGRect beginRect = [[notification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat animDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    //NSLog(@"%f",endRect.origin.y);
    //Transform rects to local coordinates
    beginRect = [self fixKeyboardRect:beginRect];
    endRect = [self fixKeyboardRect:endRect];
    
    
    /*记录键盘高度*/
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setDouble:endRect.size.height forKey:@"KeyboardHeight"];
    
    NSLog(@"%f,%f,%f,%f",endRect.origin.x,endRect.origin.y,endRect.size.width,endRect.size.height);
    CGRect selfEndingRect = CGRectMake(endRect.origin.x,
                                       endRect.origin.y - self.frame.size.height,
                                       endRect.size.width,
                                       self.frame.size.height);
    
    //Set view position and hidden
    self.frame = selfEndingRect;
    [self setHidden:NO];
//    
//    //If it's rotating, begin animation from current state
//    UIViewAnimationOptions options = UIViewAnimationOptionAllowAnimatedContent;
//    
//    //Start the animation
//    [UIView animateWithDuration:animDuration delay:0.0f
//                        options:options
//                     animations:^(void){
//                         //self.frame = selfEndingRect;
//                        // self.alpha = 1.0f;
//                     }
//                     completion:^(BOOL finished){
//                         //self.frame = selfEndingRect;
//                         //self.alpha = 1.0f;
//                     }];
//    
}


//- (void) keyboardWillDisappear:(NSNotification*)notification{
//    
//        //Get begin, ending rect and animation duration
//        CGRect beginRect = [[notification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
//        CGRect endRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
//        CGFloat animDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
//        
//        //Transform rects to local coordinates
//        beginRect = [self fixKeyboardRect:beginRect];
//        endRect = [self fixKeyboardRect:endRect];
//        
//        //Get this view begin and end rect
//        CGRect selfBeginRect = CGRectMake(beginRect.origin.x,
//                                          beginRect.origin.y - self.frame.size.height,
//                                          beginRect.size.width,
//                                          self.frame.size.height);
//        CGRect selfEndingRect = CGRectMake(endRect.origin.x,
//                                           endRect.origin.y - self.frame.size.height,
//                                           endRect.size.width,
//                                           self.frame.size.height);
//    scrollview=[[UIScrollView alloc] initWithFrame:beginRect];
//    scrollview.backgroundColor=[UIColor blueColor];
//    [self.superview addSubview:scrollview];
//        
//        //Set view position and hidden
//        self.frame = selfBeginRect;
//        self.alpha = 1.0f;
//        
//        
//        //Animation options
//        UIViewAnimationOptions options = UIViewAnimationOptionAllowAnimatedContent;
//        
//        //Animate view
//        [UIView animateWithDuration:animDuration delay:0.0f
//                            options:options
//                         animations:^(void){
//                             //self.frame = selfEndingRect;
//                             //self.alpha = 0.0f;
//                         }
//                         completion:^(BOOL finished){
//                             //self.frame = selfEndingRect;
//                             //self.alpha = 0.0f;
//                             //[self setHidden:YES];
//                         }];
//    
//}
#pragma mark - Private methods
- (CGRect) fixKeyboardRect:(CGRect)originalRect{
    
    //Get the UIWindow by going through the superviews
    UIView * referenceView = self.superview;
    //直到referenceView=uiwindow
    while ((referenceView != nil) && ![referenceView isKindOfClass:[UIWindow class]]){
        referenceView = referenceView.superview;
    }
    
    //If we finally got a UIWindow
    CGRect newRect = originalRect;
    if ([referenceView isKindOfClass:[UIWindow class]]){
        //Convert the received rect using the window
        UIWindow * myWindow = (UIWindow*)referenceView;

        newRect = [myWindow convertRect:originalRect toView:self.superview];
    }
    
    //Return the new rect (or the original if we couldn't find the Window -> this should never happen if the view is present)
    //新的矩形是相对于superview的
    return newRect;
}

#pragma mark - Dealloc method

- (void) dealloc{
    //Unregister notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
