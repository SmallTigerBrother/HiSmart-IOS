#import <UIKit/UIKit.h>

@protocol HirNavBackBtnDelegate <NSObject>

@optional
-(void)pressNavBackBtn:(UIButton *)btn;

@end

@interface HirNavBackBtn : UIButton
{
    __weak id<HirNavBackBtnDelegate>_delegate;
    
}

@property (nonatomic,weak)id<HirNavBackBtnDelegate>delegate;
@end