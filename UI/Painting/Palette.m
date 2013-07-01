//
//  Palette.m
//  MyPalette
//
//  Created by yanyu on 12-11-5.

#import "Palette.h"


@implementation Palette
@synthesize x;
@synthesize y;
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
        allline=NO;
    }
    return self;
	
}
-(void)IntsegmentColor
{
	switch (Intsegmentcolor)
	{
		case 0:
			segmentColor=[[UIColor colorWithRed:255/255 green:36/255 blue:0 alpha:1] CGColor];
			break;
		case 1:
			segmentColor=[[UIColor colorWithRed:255.0/255.0 green:242.0/255.0 blue:30.0/255.0 alpha:1.0] CGColor];
			break;
		case 2:
			segmentColor=[[UIColor colorWithRed:220.0/255.0 green:184.0/255.0 blue:209.0/255.0 alpha:1.0] CGColor];

			break;
		case 3:
			segmentColor=[[UIColor colorWithRed:160.0/255.0 green:192.0/255.0 blue:90.0/255.0 alpha:1.0] CGColor];
			break;
		case 4:
			segmentColor=[[UIColor colorWithRed:100.0/255.0 green:151.0/255.0 blue:184.0/255.0 alpha:1.0] CGColor];
			break;
		case 5:
			segmentColor=[[UIColor colorWithRed:212.0/255.0 green:167.0/255.0 blue:117.0/255.0 alpha:1.0] CGColor];
			break;
        case 6:
			segmentColor=[[UIColor colorWithRed:0 green:0 blue:0 alpha:1] CGColor];
			break;
        case 7:
			segmentColor=[[UIColor whiteColor] CGColor];
			break;
    
		default:
			break;
	}
}

- (void)drawRect:(CGRect)rect 
{
	//获取上下文
	CGContextRef context=UIGraphicsGetCurrentContext();
	//设置笔冒
	CGContextSetLineCap(context, kCGLineCapRound);
	//设置画线的连接处　拐点圆滑
	CGContextSetLineJoin(context, kCGLineJoinRound);
	//第一次时候个myallline开辟空间
	//static BOOL allline=NO;
	if (allline==NO)
	{
		myallline=[[NSMutableArray alloc] initWithCapacity:10];
		myallColor=[[NSMutableArray alloc] initWithCapacity:10];
		myallwidth=[[NSMutableArray alloc] initWithCapacity:10];
		allline=YES;
	}
	//画之前的线
	if ([myallline count]>0)
	{
		for (int i=0; i<[myallline count]; i++)
		{
			NSArray* tempArray=[NSArray arrayWithArray:[myallline objectAtIndex:i]];
			
			if ([myallColor count]>0)
			{
				Intsegmentcolor=[[myallColor objectAtIndex:i] intValue];
				Intsegmentwidth=[[myallwidth objectAtIndex:i]floatValue]+1;
			}
			
			if ([tempArray count]>1)
			{
				CGContextBeginPath(context);
				CGPoint myStartPoint=[[tempArray objectAtIndex:0] CGPointValue];
				CGContextMoveToPoint(context, myStartPoint.x, myStartPoint.y);
				
				for (int j=0; j<[tempArray count]-1; j++)
				{
					CGPoint myEndPoint=[[tempArray objectAtIndex:j+1] CGPointValue];
					
					CGContextAddLineToPoint(context, myEndPoint.x,myEndPoint.y);	
				}
				[self IntsegmentColor];
				CGContextSetStrokeColorWithColor(context, segmentColor);
				
				CGContextSetLineWidth(context, Intsegmentwidth);
				CGContextStrokePath(context);
			}
		}
	}
	//画当前的线
	if ([myallpoint count]>1)
	{
		CGContextBeginPath(context);
		
		//起点
		
		CGPoint myStartPoint=[[myallpoint objectAtIndex:0]   CGPointValue];
		CGContextMoveToPoint(context,    myStartPoint.x, myStartPoint.y);
		//把move的点全部加入　数组
		for (int i=0; i<[myallpoint count]-1; i++)
		{
			CGPoint myEndPoint=  [[myallpoint objectAtIndex:i+1] CGPointValue];
			CGContextAddLineToPoint(context, myEndPoint.x,   myEndPoint.y);
		}
		//在颜色和画笔大小数组里面取不相应的值
		Intsegmentcolor=[[myallColor lastObject] intValue];
		Intsegmentwidth=[[myallwidth lastObject]floatValue]+1;
		
		
		//绘制画笔颜色
		[self IntsegmentColor];
		CGContextSetStrokeColorWithColor(context, segmentColor);
		CGContextSetFillColorWithColor (context,  segmentColor);
		
		//绘制画笔宽度
		CGContextSetLineWidth(context, Intsegmentwidth);
		//把数组里面的点全部画出来
		CGContextStrokePath(context);
	}
}

//初始化所有点
-(void)initAllPoints
{
	myallpoint=[[NSMutableArray alloc] initWithCapacity:10];
}

//把一次画过的点放到线的数组中
-(void)addLines
{
	[myallline addObject:myallpoint];
}

//把点加入数组
-(void)addPoints:(CGPoint)sender
{
	NSValue* pointvalue=[NSValue valueWithCGPoint:sender];
	[myallpoint addObject:pointvalue];
}


//接收颜色segement反过来的值
-(void)addColors:(int)sender
{
	NSNumber* Numbersender= [NSNumber numberWithInt:sender];
	[myallColor addObject:Numbersender];
    NSLog(@"color%d",sender);
}


//接收线条宽度按钮反回来的值
-(void)addWidths:(int)sender
{
	NSNumber* Numbersender= [NSNumber numberWithInt:sender];
	[myallwidth addObject:Numbersender];
    NSLog(@"width%d",sender);
}

//清屏
-(void)clearAllLines
{
	if ([myallline count]>0)
	{
		[myallline removeAllObjects];
		[myallColor removeAllObjects];
		[myallwidth removeAllObjects];
		[myallpoint removeAllObjects];
		myallline=[[NSMutableArray alloc] initWithCapacity:10];
		myallColor=[[NSMutableArray alloc] initWithCapacity:10];
		myallwidth=[[NSMutableArray alloc] initWithCapacity:10];
		[self setNeedsDisplay];
	}
}

//撤销
-(void)RemoveLine
{
	if ([myallline count]>0)
	{
		[myallline  removeLastObject];
		[myallColor removeLastObject];
		[myallwidth removeLastObject];
		[myallpoint removeAllObjects];
	}
	[self setNeedsDisplay];	
}

-(void)dealloc
{
        
}
@end
