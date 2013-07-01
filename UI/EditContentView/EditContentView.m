//
//  EditContentView.m
//  Timeline
//
//  Created by 01 developer on 12-11-3.
//  Copyright (c) 2012年 Sun Yat-sen University. All rights reserved.
//

#import "EditContentView.h"

@implementation EditContentView

@synthesize hint,realTextColor;

#pragma mark -
#pragma mark Initialisation

- (id) initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginEditing:) name:UITextViewTextDidBeginEditingNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endEditing:) name:UITextViewTextDidEndEditingNotification object:self];
    
    self.realTextColor = [UIColor blackColor];
}

#pragma mark -
#pragma mark Setter/Getters

- (void) setHint:(NSString *)ahint
{
    if ([self.realText isEqualToString:hint]) {
        self.text = ahint;
        
    }
    
    [hint release];
    hint = [ahint retain];
    
    [self endEditing:nil];
}

- (NSString *) text {
    NSString* text = [super text];
    if ([text isEqualToString:self.hint]) return @"";
    return text;
}

- (void) setText:(NSString *)text {
    
    if ([text isEqualToString:@""] || text == nil) {
        super.text = self.hint;
    }
    else {
        super.text = text;
    }
    
    if ([text isEqualToString:self.hint]) {
        self.textColor = [UIColor blackColor];
    }
    else {
        self.textColor = self.realTextColor;
    }
}

- (NSString *) realText {
    return [super text];
}

//当它become first responder的时候
- (void) beginEditing:(NSNotification*) notification {
    if ([self.realText isEqualToString:self.hint]) {
        super.text = nil;
        self.textColor = self.realTextColor;
    }
}

- (void) endEditing:(NSNotification*) notification {
    if ([self.realText isEqualToString:@""] || self.realText == nil) {
        super.text = self.hint;
        self.textColor = [UIColor blackColor];
    }
}

- (void) setTextColor:(UIColor *)textColor {
    if ([self.realText isEqualToString:self.hint]) {
        if ([textColor isEqual:[UIColor blackColor]]) [super setTextColor:textColor];
        else self.realTextColor = textColor;
    }
    else {
        self.realTextColor = textColor;
        [super setTextColor:textColor];
    }
}

#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
    [realTextColor release];
    [hint release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}
@end
