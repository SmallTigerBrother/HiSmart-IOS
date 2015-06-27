//
//  HIRArcImageView.m
//  ImageDL
//
//  Created by Pierre Abi-aad on 21/03/2014.
//  Copyright (c) 2014 Pierre Abi-aad. All rights reserved.
//

#import "HIRArcImageView.h"
#pragma mark - Utils
#define rad(degrees) ((degrees) / (180.0 / M_PI))
#define kLineWidth 3.f


@interface HIRArcImageView ()
@property (nonatomic, strong) CAShapeLayer *backgroundLayer;
@property (nonatomic, strong) CAShapeLayer *progressLayer;
@property (nonatomic, strong) UIImageView *containerImageView;
@property (nonatomic, strong) UIView      *progressContainer;
@property (nonatomic, assign) BOOL isInit;
@end

#pragma mark - SPMImageAsyncView


@implementation HIRArcImageView
- (id)init {
    self = [super init];
    if (self) {
        self.isInit = NO;
    }
    return self;
}

- (void)setImage:(UIImage *)image {
    if (self.isInit == NO) {
        self.isInit = YES;
        self.layer.cornerRadius     = CGRectGetWidth(self.bounds)/2.f;
        self.layer.masksToBounds    = NO;
        self.clipsToBounds          = YES;
        
        CGPoint arcCenter           = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        CGFloat radius              = MIN(CGRectGetMidX(self.bounds)-1, CGRectGetMidY(self.bounds)-1);
        
        UIBezierPath *circlePath    = [UIBezierPath bezierPathWithArcCenter:arcCenter
                                                                     radius:radius
                                                                 startAngle:-rad(90)
                                                                   endAngle:rad(360-90)
                                                                  clockwise:YES];
        
        _backgroundLayer = [CAShapeLayer layer];
        _backgroundLayer.path           = circlePath.CGPath;
        _backgroundLayer.strokeColor    = [[UIColor clearColor] CGColor];
        _backgroundLayer.fillColor      = [[UIColor clearColor] CGColor];
        _backgroundLayer.lineWidth      = kLineWidth;
        
        
        _progressLayer = [CAShapeLayer layer];
        _progressLayer.path         = _backgroundLayer.path;
        _progressLayer.strokeColor  = [[UIColor clearColor] CGColor];
        _progressLayer.fillColor    = _backgroundLayer.fillColor;
        _progressLayer.lineWidth    = _backgroundLayer.lineWidth;
        _progressLayer.strokeEnd    = 0.f;
        
        NSLog(@"%f,%f,%f,%f",self.frame.origin.x,self.frame.origin.y,self.frame.size.width,self.frame.size.height);
        _progressContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _progressContainer.layer.cornerRadius   = CGRectGetWidth(self.bounds)/2.f;
        _progressContainer.layer.masksToBounds  = NO;
        _progressContainer.clipsToBounds        = YES;
        _progressContainer.backgroundColor      = [UIColor clearColor];
        
        _containerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(1, 1, self.frame.size.width-2, self.frame.size.height-2)];
        _containerImageView.layer.cornerRadius = CGRectGetWidth(self.bounds)/2.f;
        _containerImageView.layer.masksToBounds = NO;
        _containerImageView.clipsToBounds = YES;
        _containerImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        [_progressContainer.layer addSublayer:_backgroundLayer];
        [_progressContainer.layer addSublayer:_progressLayer];
        
        [self addSubview:_containerImageView];
        [self addSubview:_progressContainer];
    }
    
    [self updateWithImage:image animated:NO];
}

- (void)updateWithImage:(UIImage *)image animated:(BOOL)animated {
    
    CGFloat duration    = (animated) ? 0.3 : 0.f;
    CGFloat delay       = (animated) ? 0.1 : 0.f;
    
    _containerImageView.transform   = CGAffineTransformMakeScale(0, 0);
    _containerImageView.alpha       = 0.f;
    _containerImageView.image       = image;
    
    [UIView animateWithDuration:duration
                     animations:^{
                         _progressContainer.transform    = CGAffineTransformMakeScale(1.1, 1.1);
                         _progressContainer.alpha        = 0.f;
                         [UIView animateWithDuration:duration
                                               delay:delay
                                             options:UIViewAnimationOptionCurveEaseOut
                                          animations:^{
                                              _containerImageView.transform   = CGAffineTransformIdentity;
                                              _containerImageView.alpha       = 1.f;
                                          } completion:nil];
                     } completion:^(BOOL finished) {
                         _progressLayer.strokeColor = [[UIColor whiteColor] CGColor];
                         [UIView animateWithDuration:duration
                                          animations:^{
                                              _progressContainer.transform    = CGAffineTransformIdentity;
                                              _progressContainer.alpha        = 1.f;
                                          }];
                     }];
}


@end
