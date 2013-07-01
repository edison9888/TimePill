//
//  Palette.h
//  MyPalette
//
//  Created by yanyu on 12-11-5.

#import <UIKit/UIKit.h>


@interface Palette : UIView
{
	float x;
	float y;
    
	//当前颜色和宽度
	int             Intsegmentcolor;
	float           Intsegmentwidth;
	CGColorRef      segmentColor;
    
	NSMutableArray* myallpoint;
	NSMutableArray* myallline;
	NSMutableArray* myallColor;
	NSMutableArray* myallwidth;
	
    BOOL allline;
}
@property float x;
@property float y;

-(void)initAllPoints;
-(void)addLines;
-(void)addPoints:(CGPoint)sender;
-(void)addColors:(int)sender;
-(void)addWidths:(int)sender;


-(void)clearAllLines;
-(void)RemoveLine;

@end
