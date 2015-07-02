#import "HirNavBackBtn.h"
#define LeftCustomBarLeftEdge   -8


@implementation HirNavBackBtn
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        if (is_LATER_IOS7) {
            self.imageEdgeInsets = UIEdgeInsetsMake(0, LeftCustomBarLeftEdge, 0, 0);
        }
   
        [self setImage:[UIImage imageNamed:@"nav_back_btn_blue"] forState:UIControlStateNormal];
        [self addTarget:self action:@selector(pressNavBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}



-(void)pressNavBackBtn:(UIButton *)btn
{
    if(_delegate && [_delegate respondsToSelector:@selector(pressNavBackBtn:)])
    {
        [_delegate pressNavBackBtn:self];
    }
}

@end


























