//
//  CustomSwitch.h
//  Timeline
//
//  Created by 01 developer on 12-11-9.
//  Copyright (c) 2012年 Sun Yat-sen University. All rights reserved.
//  呕心沥血的原创

#import <UIKit/UIKit.h>

@protocol CustomSwitchDelegate <NSObject>

-(void)returnSwitch:(Boolean ) isOn  andType:(int) type;
@end

@interface CustomSwitch : UIControl
{
    Boolean isOn;
    int type; //标定是什么类型
}

@property (retain,nonatomic) IBOutlet id<CustomSwitchDelegate> delegate;
- (id)initWithFrame:(CGRect)frame andBackImage:(UIImage *)backImage andButtonImage:(UIImage *)buttonImage andType:(int) type;
@property (assign,nonatomic) Boolean isOn;
-(void)setOn:(Boolean) _isOn;
@end



