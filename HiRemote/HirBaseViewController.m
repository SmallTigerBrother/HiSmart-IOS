//
//  HirBaseViewController.m
//  HiRemote
//
//  Created by minfengliu on 15/6/27.
//  Copyright (c) 2015年 hiremote. All rights reserved.
//

#import "HirBaseViewController.h"

@interface HirBaseViewController ()

@end

@implementation HirBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setCustomBackBarButttonItem];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)setCustomBackBarButttonItem{
    
    _backBtn = [[HirNavBackBtn alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    _backBtn.delegate = self;
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:_backBtn]];
}

#pragma mark - pressBtn
- (void)pressNavBackBtn:(UIButton *)btn
{
    
    if ([self.navigationController.viewControllers count] == 1)
    {
        
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
