//
//  HirBaseWebViewCtl.h
//  HiRemote
//
//  Created by lmf on 7/26/15.
//  Copyright (c) 2015 hiremote. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "HirBaseViewController.h"

@interface HirBaseWebViewCtl : HirBaseViewController<UIWebViewDelegate>
{
    UIWebView *_webView;
    
    NSURL *_theUrl;
}

@property(nonatomic,strong)NSURL *theUrl;

@end
