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
#define COLOR_ALERT_BTN_TITLE       [UIColor blackColor]

//背景色
#define COLOR_NAVIGATION_BACKGROUD      [UIColor whiteColor]
#define COLOR_TABLE_SECTION_BACKGROUD   COLOR_THEME
#define COLOR_VIEW_BACKGROUD            [UIColor whiteColor]
#define COLOR_ALERTVIEW_BACKGROUD_GRAY  COLOR(239,239,244)      //白灰

//FONT1 :Helvetica
//FONT2 :HelveticaNeue
#define FONT1(x) [UIFont systemFontOfSize:x]
#define FONT2(x) [UIFont systemFontOfSize:x]

//导航
#define FONT_NAVIGATION_TITLE       FONT1(18)

//表格
#define FONT_TABLE_SECTION_TITLE    FONT2(20)
#define FONT_TABLE_CELL_TITLE       FONT2(16)
#define FONT_TABLE_CELL_CONTENT     FONT2(13)
#define FONT_TABLE_CELL_RIGHT_TIME  FONT2(12)

//弹出框
#define FONT_ALERTVIEW_TITLE        FONT2(16)


//图像圆角
#define IMAGE_CORNER_RADIUS         4
//导航栏
#define NAV_BAR_HEIGHT              44
#define NAV_BUTTON_HEIGHT_DEFAULT   44

//搜索栏
#define SEARCHBAR_BACKGROUND_HEIGHT 44      //控件背景高度

//分享，指导页，弹出窗口背景色，饱和度为40%的黑色
#define POPUP_WINDOW_BG_COLOR   [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.4]

#pragma mark - tableCell
//cell左右的间隔
#define Cell_Pand_H         5
//cell上下的间隔
#define Cell_Pand_V         5
#define Cell_LeftMargin     PHI05_SIZE_XXL


//通用颜色定义方式
#define EHCOLOR(r,g,b) [UIColor colorWithRed:(CGFloat)r/255. green:(CGFloat)g/255. blue:(CGFloat)b/255. alpha:1.]
//基本颜色定义，用户版主色为绿色r31g162b77，园区版为深蓝色r30g39b78
#define C001_COLOR_WHITE  [UIColor whiteColor]//白色
#define C002_COLOR_GRAY   [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1]//绿灰
#define C003_COLOR_GRAY   [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1]//白灰
#define C004_COLOR_GRAY   [UIColor colorWithRed:201/255.0 green:201/255.0 blue:206/255.0 alpha:1]//淡灰
#define C005_COLOR_GRAY   [UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1]//浅灰
#define C006_COLOR_GRAY   [UIColor colorWithRed:200/255.0 green:199/255.0 blue:204/255.0 alpha:1]//炭灰
#define C007_COLOR_GRAY   [UIColor colorWithRed:143/255.0 green:143/255.0 blue:149/255.0 alpha:1]//暗灰
#define C008_COLOR_GRAY   [UIColor colorWithRed:109/255.0 green:109/255.0 blue:114/255.0 alpha:1]//深灰
#define C009_COLOR_BLACK  [UIColor blackColor]//黑色
#define C010_COLOR_GRAY   [UIColor colorWithRed:210/255.0 green:209/255.0 blue:209/255.0 alpha:1]
#define C011_COLOR_GRAY   [UIColor colorWithRed:110/255.0 green:110/255.0 blue:116/255.0 alpha:1]
#define C012_COLOR_HOST   [UIColor colorWithRed:224/255.0 green:239/255.0 blue:231/255.0 alpha:1]
#define C013_COLOR_HOST   [UIColor colorWithRed:204/255.0 green:219/255.0 blue:211/255.0 alpha:1]
#define C014_COLOR_HOST   [UIColor colorWithRed:31/255.0 green:162/255.0 blue:77/255.0 alpha:1]//主色
#define C015_COLOR_HOST   [UIColor colorWithRed:21/255.0 green:111/255.0 blue:53/255.0 alpha:1]
#define C016_COLOR_RED    [UIColor colorWithRed:225/255.0 green:35/255.0 blue:36/255.0 alpha:1]//红色
#define C017_COLOR_RED    [UIColor colorWithRed:172/255.0 green:22/255.0 blue:23/255.0 alpha:1]
#define C018_COLOR_HOST   [UIColor colorWithRed:188/255.0 green:227/255.0 blue:202/255.0 alpha:1]
#define C019_COLOR_HOST   [UIColor colorWithRed:165/255.0 green:218/255.0 blue:184/255.0 alpha:1]
#define CC00_COLOR_ORANGE [UIColor colorWithRed:245/255.0 green:143/255.0 blue:62/255.0 alpha:1]//橙色
#define CC01_COLOR_GRAY   [UIColor colorWithRed:229/255.0 green:229/255.0 blue:234/255.0 alpha:1]//灰灰
#define CC02_COLOR_GRAY   [UIColor colorWithRed:206/255.0 green:206/255.0 blue:209/255.0 alpha:1]
#define CC03_COLOR_HOST   [UIColor colorWithRed:0/255.0 green:82/255.0 blue:29/255.0 alpha:1]//辅助色

//色值点击效果
#define S001_COLOR_NORMAL       C002_COLOR_GRAY
#define S001_COLOR_HIGHLIGHT    C010_COLOR_GRAY
#define S002_COLOR_NORMAL       C008_COLOR_GRAY
#define S002_COLOR_HIGHLIGHT    C011_COLOR_GRAY
#define S003_COLOR_NORMAL       C012_COLOR_GRAY
#define S003_COLOR_HIGHLIGHT    C013_COLOR_GRAY
#define S004_COLOR_NORMAL       C014_COLOR_GRAY
#define S004_COLOR_HIGHLIGHT    C015_COLOR_GRAY
#define S005_COLOR_NORMAL       C016_COLOR_GRAY
#define S005_COLOR_HIGHLIGHT    C017_COLOR_GRAY
#define S006_COLOR_NORMAL       C018_COLOR_GRAY
#define S006_COLOR_HIGHLIGHT    C019_COLOR_GRAY
#define S007_COLOR_NORMAL       CC01_COLOR_GRAY
#define S007_COLOR_HIGHLIGHT    CC02_COLOR_GRAY

/**---------------------------------------------------------设计规范 基础Color----------------------------------------------------------------------**/

/**---------------------------------------------------------设计规范 基础Font Size------------------------------------------------------------------**/
//  字体大小=文字像素/2
#define TEXT_FONT_16       [UIFont systemFontOfSize:16]
#define TEXT_FONT_16_BOLD  [UIFont boldSystemFontOfSize:16]
#define TEXT_FONT_14       [UIFont systemFontOfSize:14]
#define TEXT_FONT_14_BOLD  [UIFont boldSystemFontOfSize:14]
#define TEXT_FONT_13       [UIFont systemFontOfSize:13]
#define TEXT_FONT_12       [UIFont systemFontOfSize:12]
#define TEXT_FONT_11       [UIFont systemFontOfSize:11]
#define TEXT_FONT_9        [UIFont systemFontOfSize:9]
// 特殊字体大小
#define TEXT_FONT_20       [UIFont systemFontOfSize:20]
#define TEXT_FONT_20_BOLD  [UIFont boldSystemFontOfSize:20]
#define TEXT_FONT_25       [UIFont systemFontOfSize:25]//优惠劵价格
#define TEXT_FONT_28       [UIFont systemFontOfSize:28]//餐饮价格

/**---------------------------------------------------------设计规范 基础Font Size------------------------------------------------------------------**/

/**----------------------------------------------------------设计规范 基础Layout--------------------------------------------------------------------**/
//间距Pitch 垂直间距Vertical interval 水平间距Horizontal spacing
//垂直间距
#define PVI01_SIZE_S    8
#define PVI02_SIZE_M    10
#define PVI03_SIZE_L    13
#define PVI04_SIZE_XL   15
#define PVI05_SIZE_XXL  20
#define PVI06_SIZE_XXXL 30

//水平间距
#define PHI01_SIZE_S    8
#define PHI02_SIZE_M    10
#define PHI03_SIZE_L    13
#define PHI04_SIZE_XL   15
#define PHI05_SIZE_XXL  20
#define PHI06_SIZE_XXXL 30

//图标大小
#define II01_SIZE_M     14
#define II02_SIZE_L     24
#define II03_SIZE_XL    35
/**----------------------------------------------------------设计规范 基础Layout--------------------------------------------------------------------**/


//***********************//
//*                     *//
//*      扩充宏模块       *//
//*                     *//
//***********************//

//↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓宏的重定义请在下面对应区域进行修改↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓//
//↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓命名规则 控件名称_用途_属性 （可阅读） ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓//
//↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓复合文字属性番号请在EHThemeManage里面进行定义 ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓//

/**-------------------------------------------------------------iOS 【字体大小】-----------------------------------------------------------------------**/
//文字大小对应整型值
#define TEXT_FONT_SUPER_XXL_INT     28
#define TEXT_FONT_SUPER_XL_INT      25
#define TEXT_FONT_SUPER_L_INT       20
#define TEXT_FONT_XXXL_INT          16
#define TEXT_FONT_XXL_INT           14
#define TEXT_FONT_XL_INT            13
#define TEXT_FONT_L_INT             12
#define TEXT_FONT_M_INT             11
#define TEXT_FONT_S_INT             9

#define TEXT_FONT_SUPER_XXL     TEXT_FONT_28
#define TEXT_FONT_SUPER_XL      TEXT_FONT_25
#define TEXT_FONT_SUPER_L       TEXT_FONT_20
#define TEXT_FONT_SUPER_L_BOLD  TEXT_FONT_20_BOLD
#define TEXT_FONT_XXXL          TEXT_FONT_16
#define TEXT_FONT_XXXL_BOLD     TEXT_FONT_16_BOLD
#define TEXT_FONT_XXL           TEXT_FONT_14
#define TEXT_FONT_XXL_BOLD      TEXT_FONT_14_BOLD
#define TEXT_FONT_XL            TEXT_FONT_13
#define TEXT_FONT_L             TEXT_FONT_12
#define TEXT_FONT_M             TEXT_FONT_11
#define TEXT_FONT_S             TEXT_FONT_9
/**-------------------------------------------------------------iOS 【字体大小】-----------------------------------------------------------------------**/

/**-------------------------------------------------------------iOS 【字体颜色】-----------------------------------------------------------------------**/
//番号含义，T→Text H→黑（拼音首字母）TH→黑色，TB→白色，TL→绿色（主色），TS→深灰，TA→暗灰，TC→橙色
#define TEXT_COLOR_TH       C009_COLOR_BLACK    //【文字】黑色
#define TEXT_COLOR_TB       C001_COLOR_WHITE    //【文字】白色
#define TEXT_COLOR_TL       C014_COLOR_HOST     //【文字】绿色
#define TEXT_COLOR_TS       C008_COLOR_GRAY     //【文字】深灰
#define TEXT_COLOR_TA       C007_COLOR_GRAY     //【文字】暗灰
#define TEXT_COLOR_TC       CC00_COLOR_ORANGE   //【文字】橙色
/**-------------------------------------------------------------iOS 【字体颜色】-----------------------------------------------------------------------**/

/**-------------------------------------------------------------iOS【控件背景颜色】---------------------------------------------------------------------**/
//黑、白、透明色
#define WHITE_COLOR C001_COLOR_WHITE
#define BLACK_COLOR C009_COLOR_BLACK
#define CLEAR_COLOR [UIColor clearColor]

//背景颜色定义(设计规范参考定义表)
#define BG_COLOR_C8C7CC     C006_COLOR_GRAY     //分割线，打破行
#define BG_COLOR_F8F8F8     C002_COLOR_GRAY     //【背景】弹出界面
#define BG_COLOR_F58F3E     CC00_COLOR_ORANGE   //部分弹出背景，字体（橙色）
#define BG_COLOR_EFEFF4     C003_COLOR_GRAY     //【背景】编辑框,默认背景
#define BG_COLOR_00521D     CC03_COLOR_HOST     //链接，数字，号码
#define BG_COLOR_C9C9CE     C004_COLOR_GRAY     //【背景】头像，搜索框背景
#define BG_COLOR_E5E5EA     CC01_COLOR_GRAY     //【背景】便条、评论等
#define BG_COLOR_D9D9D9     C005_COLOR_GRAY     //【背景】主菜单选中

//UITableView
#define TABLE_CELL_BG_COLOR                 C001_COLOR_WHITE    //Cell背景颜色
#define TABLE_CELL_SECTION_TITLE_BG_COLOR   C003_COLOR_GRAY     //分组表格，Section title背景颜色
#define TABLE_CELL_SEG_COLOR                BG_COLOR_C8C7CC     //表格分割线颜色
#define TABLE_CELL_MSG_BG_COLOR             CC01_COLOR_GRAY     //便条背景色
#define TABLE_CELL_MSG_SELECT_COLOR         CC02_COLOR_GRAY     //便条点击按下状态
#define TABLE_CELL_PLACEHOLDER_COLOR         C004_COLOR_GRAY     //cell中提示文字的颜色

//UISegmentedControl
#define SEG_TEXT_TINTCOLOR     C001_COLOR_WHITE             //分段控件默认字体颜色,背景是主色

//UINavigationBar
#define NAV_BG_COLOR                    C014_COLOR_HOST     //导航栏背景颜色
#define NAV_BUTTON_BG_COLOR             C014_COLOR_HOST     //导航栏按钮背景颜色
#define NAV_LABEL_BG_COLOR              C014_COLOR_HOST     //导航栏标签背景颜色
#define NAV_BUTTON_HIGHLIGHTED_COLOR    C010_COLOR_GRAY     //按钮文字高亮

//UISearchBar
#define SEARCHBAR_BG_COLOR  C004_COLOR_HOST                 //整个搜索控件的背景颜色，对应tintColor

//COMMON BUTTON
#define COMMON_BUTTON_NORMAL_BG_COLOR         C012_COLOR_HOST   //正常状态
#define COMMON_BUTTON_SELECTED_BG_COLOR       C014_COLOR_HOST   //普通选中按钮
#define COMMON_BUTTON_DELETE_BG_COLOR         C016_COLOR_RED    //普通删除按钮

//View
#define VIEW_BORDER_COLOR               BG_COLOR_C8C7CC         //view的边框颜色
#define VIEW_LINE_COLOR_NORMAL          BG_COLOR_C8C7CC         //view的下划线颜色,普通灰色

//红点颜色
#define RED_POINT_COLOR C016_COLOR_RED

//分享，指导页，弹出窗口背景色，饱和度为40%的黑色
#define POPUP_WINDOW_BG_COLOR   [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.4]

//切换楼栋按钮颜色
#define CHANGE_BUILDING_BUTTON_TITLE_COLOR   [UIColor colorWithRed:29/255.0 green:112/255.0 blue:166/255.0 alpha:1]//蓝色

//logo的背景颜色
#define LOGO_BG_COLOR    C015_COLOR_HOST

//赠卷颜色
#define COUPON_DEFAULT_COLOR        [UIColor colorWithRed:255/255.0 green:168/255.0 blue:0/255.0 alpha:1]//橙色
#define COUPON_RELAXTION_COLOR      [UIColor colorWithRed:255/255.0 green:168/255.0 blue:0/255.0 alpha:1]//橙色
#define COUPON_CATERING_COLOR       [UIColor colorWithRed:178/255.0 green:18/255.0 blue:18/255.0 alpha:1]//暗红色
#define COUPON_HOMEKEEPING_COLOR    [UIColor colorWithRed:9/255.0 green:113/255.0 blue:178/255.0 alpha:1]//深蓝色
#define COUPON_SHOPPING_COLOR       [UIColor colorWithRed:99/255.0 green:43/255.0 blue:144/255.0 alpha:1]//紫色
#define COUPON_UNKNOWN_COLOR        [UIColor colorWithRed:246/255.0 green:9/255.0 blue:79/255.0 alpha:1]//红色

//Date Picker背景颜色
#define DATEPICKER_BG_COLOR     C008_COLOR_GRAY
//Lease Picker背景颜色
#define LEASEPICKER_BG_COLOR    C008_COLOR_GRAY

//pageControl颜色
#define PAGE_DEFAULT_COLOR    C004_COLOR_GRAY
#define PAGE_CURRENT_COLOR    C008_COLOR_GRAY
/**-------------------------------------------------------------iOS【控件背景颜色】---------------------------------------------------------------------**/

/**---------------------------------------------------------------iOS【控件尺寸】----------------------------------------------------------------------**/
//图标大小
#define ICON_WIDTH_SMALL    II01_SIZE_M
#define ICON_WIDTH_MEDIUM   II02_SIZE_L
#define ICON_WIDTH_LARGE    II03_SIZE_XL

//图像圆角
#define IMAGE_CORNER_RADIUS     4

//头像尺寸
#define HEAD_SIZE_MAX 64        //头像尺寸,适用我大头像
#define HEAD_SIZE_MED 35        //头像尺寸,中
#define HEAD_SIZE_MIN 32        //头像尺寸,小

//Label的高度
#define LABEL_HEIGHT_TINY   20
#define LABEL_HEIGHT_SMALL  30
#define LABEL_HEIGHT_LARGE  60

//导航栏
#define NAV_BAR_HEIGHT              44
#define NAV_BUTTON_HEIGHT_DEFAULT   44

//搜索栏
#define SEARCHBAR_BACKGROUND_HEIGHT     44      //控件背景高度
#define SEARCHBAR_INPUT_HEIGHT          28      //搜索框高度
#define SEARCHBAR_EDGING                0.5     //搜索框边框大小

//头像在左侧的Cell高度
#define TABLE_CELL_HEIGHT_SMALL         40 //无头像表格
#define TABLE_CELL_HEIGHT_MEDIUM        50 //有头像但没有detailtext
#define TABLE_CELL_HEIGHT_LARGE         60 //有头像，detailtext
#define TABLE_CELL_AVATOR_WIDTH         60 //头像
//cell 高度
#define TABLE_CELL_HEIGHT_DEFAULT       40
#define TABLE_CELL_HEIGHT_LARGER        80//右侧显示家庭或个人头像的cell
//分割线的高度
#define SEPARATE_LINE_HEIGHT_DEFAULT (0.5)
#define TABLE_CELL_SEG_X 0
#define TABLE_CELL_SEG_H SEPARATE_LINE_HEIGHT_DEFAULT

//Tab Bar
#define TAB_BAR_HEIGHT      49

//ActionSheet
#define ACTIONSHEET_BUTTON_HEIGHT       44              //actionsheet中按键高

//底视图的默认高度
#define FOOT_VIEW_HEIGHT_DEFAULT    (44)


//文字描述的宽度
#define WORD_PORTRAIT_WIDTH_BIG     (60)
#define WORD_PORTRAIT_WIDTH_SMALL   (32)

//红点尺寸
#define RED_POINT_WIDTH (10)
/**---------------------------------------------------------------iOS【控件尺寸】----------------------------------------------------------------------**/

/**---------------------------------------------------------------iOS【控件布局】----------------------------------------------------------------------**/
//外边距的大小
#define MARGIN_SUPER_TINY   PVI01_SIZE_S
#define MARGIN_DOUBLE_TINY  PVI02_SIZE_M
#define MARGIN_TINY         PVI03_SIZE_L
#define MARGIN_DOUBLE_SMALL PVI04_SIZE_XL
#define MARGIN_SMALL        PVI05_SIZE_XXL
#define MARGIN_MIDDLE       PVI06_SIZE_XXXL

//内边距
#define PADDING_SUPER_TINY      PVI01_SIZE_S
#define PADDING_DOUBLE_TINY     PVI02_SIZE_M
#define PADDING_TINY            PVI03_SIZE_L
#define PADDING_DOUBLE_SMALL    PVI04_SIZE_XL
#define PADDING_SMALL           PVI05_SIZE_XXL
#define PADDING_MIDDLE          PVI06_SIZE_XXXL

//间距的高度
#define GAP_SUPER_TINY      PVI01_SIZE_S
#define GAP_DOUBLE_TINY     PVI02_SIZE_M
#define GAP_TINY            PVI03_SIZE_L
#define GAP_DOUBLE_SMALL    PVI04_SIZE_XL
#define GAP_SMALL           PVI05_SIZE_XXL
#define GAP_MIDDLE          PVI06_SIZE_XXXL

//左侧有文字的搜索栏
#define SEARCHBAR_VERTICAL_PADDING          PVI01_SIZE_S    //搜索框与控件垂直内间距
#define SEARCHBAR_HORIZONTAL_PADDING_LEFT   80              //搜索框与控件左内间距
#define SEARCHBAR_HORIZONTAL_PADDING_RIGHT  PHI01_SIZE_S    //搜索框与控件右内间距

//Table Cell
#define TABLE_CELL_HORIZONTAL_MARGIN    PHI02_SIZE_M

//导航栏
#define NAV_HORIZONTAL_MARGIN       PHI01_SIZE_S        //导航栏内button与控件间距

//导航item之间的间隔
#define NAV_BUTTON_INTERVAL     PHI01_SIZE_S

//Action Sheet
#define ACTIONSHEET_HORIZONTAL_MARGIN   PHI01_SIZE_S    //按键边距
#define ACTIONSHEET_VERTICAL_MARGIN     PVI02_SIZE_M    //按键垂直间距
/**---------------------------------------------------------------iOS【控件布局】----------------------------------------------------------------------**/

/**---------------------------------------------------------------iOS【其他宏定义】---------------------------------------------------------------------**/
//输入框，字数限制
#define WORD_NUMBER_LIMIT_LARGER            (100)
#define WORD_NUMBER_LIMIT_DESCRIPTION       (20)
#define WORD_NUMBER_LIMIT_MIDDLE            (15)
#define WORD_NUMBER_LIMIT_SHORT             (10)
//设置inset
#define LeftCustomBarLeftEdge   -8
#define RightCustomBarRightEdge -8

//区分不同的园区版
#ifdef PARK_VERSION_FLAG
#if PARK_VERSION_FLAG == 10001
#define COLOR_MAJOR_1FA24D [UIColor colorWithRed:30/255.0 green:39/255.0 blue:78/255.0 alpha:1]
/**    主题绿色 (按钮）已赞 ；（背景）当前操作 ；（文字）当前操作 ，用于选中 **/
#define COLOR_MAJOR_156F35 [UIColor colorWithRed:21/255.0 green:27/255.0 blue:54/255.0 alpha:1]
/**    (按钮)选中 ；（图形）饼图 **/
#endif
#else
#define COLOR_MAJOR_1FA24D [UIColor colorWithRed:31/255.0 green:162/255.0 blue:77/255.0 alpha:1]
/**    主题绿色 (按钮）已赞 ；（背景）当前操作 ；（文字）当前操作 ，用于选中 **/
#define COLOR_MAJOR_156F35 [UIColor colorWithRed:21/255.0 green:111/255.0 blue:53/255.0 alpha:1]
/**    (按钮)选中 ；（图形）饼图 **/
#endif

/**---------------------------------------------------------------iOS【其他宏定义】---------------------------------------------------------------------**/

#endif
