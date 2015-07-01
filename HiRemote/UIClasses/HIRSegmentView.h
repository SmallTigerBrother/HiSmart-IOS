//
//  HIRSegmentView.h
//  HIRSegmentView
//
//  Created by 王若风 on 1/15/15.
//  Copyright (c) 2015 王若风. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HIRSegmentViewDelegate <NSObject>
- (void)segmentViewSelectIndex:(NSInteger)index;
@end

@interface HIRSegmentView : UIView
/**
 *  设置风格颜色 默认蓝色风格
 */
@property(nonatomic, strong) UIColor *tintColor;
@property(nonatomic, weak) id<HIRSegmentViewDelegate> delegate;

/**
 *  默认构造函数
 *
 *  @param frame frame
 *  @param items title字符串数组
 *
 *  @return 当前实例
 */
- (id)initWithFrame:(CGRect)frame items:(NSArray *)items;

@end
