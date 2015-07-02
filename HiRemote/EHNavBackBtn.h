#import <UIKit/UIKit.h>

@protocol EHNavBackBtnDelegate <NSObject>

@optional
-(void)pressNavBackBtn:(UIButton *)btn;

@end

@interface EHNavBackBtn : UIButton
{
    __weak id<EHNavBackBtnDelegate>_delegate;
    
}

@property (nonatomic,weak)id<EHNavBackBtnDelegate>delegate;
@end