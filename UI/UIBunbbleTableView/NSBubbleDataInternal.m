//
//  NSBubbleDataInternal.m
//
//  Created by yanyu
//

#import "NSBubbleDataInternal.h"
#import "NSBubbleData.h"

@implementation NSBubbleDataInternal

@synthesize data = _data;
@synthesize height = _height;
@synthesize labelSize = _labelSize;
@synthesize originLabelSize = _originLabelSize;
@synthesize barButtonSize = _barButtonSize;
@synthesize shouldTucaoShow = _shouldTucaoShow;
@synthesize commentsSize = _commentsSize;
@synthesize tucaoSize = _tucaoSize;

- (void)dealloc
{
	[_data release];
	_data = nil;
    [super dealloc];
}

@end
