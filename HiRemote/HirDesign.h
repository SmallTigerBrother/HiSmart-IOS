//
//  HirDesign.h
//  Bluth
//
//  Created by minfengliu on 15/6/25.
//  Copyright (c) 2015年 tom.liu. All rights reserved.
//

#ifndef Bluth_HirDesign_h
#define Bluth_HirDesign_h

#pragma mark --color
#define COLOR(r,g,b) [UIColor colorWithRed:(CGFloat)r/255. green:(CGFloat)g/255. blue:(CGFloat)b/255. alpha:1.]

//前景色
#define COLOR_THEME                 COLOR(83,191,147)
#define COLOR_FRAME                 COLOR(137,137,138)
#define COLOR_TABLE_SECTION_TITLE   [UIColor whiteColor]
#define COLOR_TABLE_CELL_TITLE      COLOR(45,44,45)
#define COLOR_TABLE_CELL_CONTENT    COLOR(120,119,119)
#define COLOR_TABLE_CELL_RIGHT_TIME COLOR(45,44,45)

//背景色
#define COLOR_NAVIGATION_BACKGROUD      [UIColor whiteColor]
#define COLOR_TABLE_SECTION_BACKGROUD   COLOR_THEME
#define COLOR_VIEW_BACKGROUD            [UIColor whiteColor]

//FONT1 :Helvetica
//FONT2 :HelveticaNeue
#define FONT1(x) [UIFont systemFontOfSize:x]
#define FONT2(X) [UIFont systemFontOfSize:x]

#define FONT_NAVIGATION_TITLE       FONT1(18)
#define FONT_TABLE_SECTION_TITLE    FONT2(20)
#define FONT_TABLE_CELL_TITLE       FONT2(16)
#define FONT_TABLE_CELL_CONTENT     FONT2(13)
#define FONT_TABLE_CELL_RIGHT_TIME  FONT2(12)

//图像圆角
#define IMAGE_CORNER_RADIUS         4
//导航栏
#define NAV_BAR_HEIGHT              44
#define NAV_BUTTON_HEIGHT_DEFAULT   44

//搜索栏
#define SEARCHBAR_BACKGROUND_HEIGHT 44      //控件背景高度

#pragma mark - tableCell
//cell左右的间隔
#define Cell_Pand_H         5
//cell上下的间隔
#define Cell_Pand_V         5

#endif
