#import <UIKit/UIKit.h>
typedef enum
{
    VerticalAlignmentTop = 0, // default
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
} VerticalAlignment;

@interface EHVerticalLabel : UILabel

@property (nonatomic) VerticalAlignment verticalAlignment;
@end
