//
//  HirBaseWebViewCtl.h
//  HiRemote
//
//  Created by lmf on 7/26/15.
//  Copyright (c) 2015 hiremote. All rights reserved.
//

#import "HirBaseWebViewCtl.h"

@interface HirBaseWebViewCtl ()

@end

@implementation HirBaseWebViewCtl

@synthesize theUrl = _theUrl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)loadWebView
{
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _webView.delegate = self;
    [_webView loadRequest:[NSURLRequest requestWithURL:_theUrl]];
    [self.view addSubview:_webView];
}

- (void)webViewDidStartLoad:(UIWebView *)webView;
{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView;
{
    [self finishLoadWebViewAndSetTitle:self.title];
}

-(void)finishLoadWebViewAndSetTitle:(NSString *)title{
    NSLog(@"设置title = %@",title);
    
    if (title.length) {
        self.title = title;
    }
    else{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSString *theTitle=[_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
            [self finishLoadWebViewAndSetTitle:theTitle];
        });
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self loadWebView];
}

-(void)dealloc
{
    _webView.delegate = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
