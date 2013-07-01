//
//  EditContentView.h
//  Timeline
//
//  Created by 01 developer on 12-11-3.
//  Copyright (c) 2012年 Sun Yat-sen University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditContentView : UITextView

@property(nonatomic, retain) NSString *hint;
@property (nonatomic, retain) UIColor* realTextColor;
@property (nonatomic, readonly) NSString* realText;

- (void) beginEditing:(NSNotification*) notification;
- (void) endEditing:(NSNotification*) notification;
@end
