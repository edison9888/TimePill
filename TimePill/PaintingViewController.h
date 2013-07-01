//
//  PaintingViewController.h
//  Timeline
//
//  Created by 01 developer on 12-11-6.
//  Copyright (c) 2012年 Sun Yat-sen University. All rights reserved.
//  test

#import <UIKit/UIKit.h>
#import "Palette.h"

@interface PaintingViewController : UIViewController
{
    /*------绘图-------*/
    Palette *PaintingBoard;
    CGPoint MyBeganpoint;
	CGPoint MyMovepoint;
    
    /*------颜色栏-------*/
    UIView *colorView;
    Boolean isSelectingColor;
    int selectedColor;
    NSArray *colorImageArray;
    
    /*------铅笔栏-------*/
    UIView *pencilView;  
    NSArray *pencilImageArray;
    NSArray *pencilButtonArray;
    
    //flag
    Boolean isSelectingPencil;  //点击铅笔按钮铅笔选项的弹出与收起
    int lastPencilcount;  //上次选择的是几号铅笔
    int currentPencilcount;  //当前选择的铅笔
    Boolean pencilEnable;  
    int priousColor;
    Boolean isFirstSelectPencil;  //第一次点击铅笔按钮不弹出铅笔选项
    
    /*-------share-------*/
    int selectedPencil;   //铅笔和橡皮的公用变量，传到画板决定画笔大小
    
    /*------橡皮栏-------*/
    UIView *eraserView;
    Boolean eraserEnable;
    NSArray *eraserButtonArray;
    Boolean isSelectingEraser;  //点击铅笔按钮铅笔选项的弹出与收起
    int lastErasercount;  //上次选择的是几号铅笔
    int currentErasercount;  //当前选择的铅笔
    Boolean isFirstSelectEraser;  //第一次点击铅笔按钮不弹出铅笔选项
}


@property (retain, nonatomic) IBOutlet UIView *headerPic;
@property (retain, nonatomic) IBOutlet UIView *toolBar;
@property (retain, nonatomic) IBOutlet UIButton *btn_color;
@property (retain, nonatomic) IBOutlet UIButton *btn_pencil;
@property (retain, nonatomic) IBOutlet UIButton *btn_eraser;
- (IBAction)SelectColor:(id)sender;
- (IBAction)SelectPecil:(id)sender;
- (IBAction)SelectEraser:(id)sender;
- (IBAction)SelectUndo:(id)sender;
- (IBAction)SelectTrash:(id)sender;

@end

