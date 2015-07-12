//
//  PostViewController.m
//  SCCaptureCameraDemo
//
//  Created by Aevitx on 14-1-21.
//  Copyright (c) 2014年 Aevitx. All rights reserved.
//

#import "PostViewController.h"

@interface PostViewController ()

@end

@implementation PostViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if (_postImage) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:_postImage];
        imgView.clipsToBounds = YES;
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        CGFloat offsetY_H = 0;
        if (DEVICE_IS_IPHONE5) {
            offsetY_H = 70;
        }else if(!DEVICE_IS_IPHONE4) {
            offsetY_H = 100;
        }
        imgView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width+offsetY_H);
        imgView.center = self.view.center;
        [self.view addSubview:imgView];
    }
//    
//    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    backBtn.frame = CGRectMake(0, self.view.frame.size.height - 40, 80, 40);
//    [backBtn setTitle:@"back" forState:UIControlStateNormal];
//    [backBtn addTarget:self action:@selector(backBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:backBtn];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backBtnPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}






@end
