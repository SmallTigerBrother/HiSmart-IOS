//
//  HirLoginViewController.m
//  HiRemote
//
//  Created by Peng on 15/8/1.
//  Copyright (c) 2015年 hiremote. All rights reserved.
//

#import "HirLoginViewController.h"

#define TextFieldBackGroundColor [UIColor colorWithRed:0.5529 green:0.8392 blue:0.6902 alpha:1]

@interface HirLoginViewController ()

@end

@implementation HirLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITextField *nameTextField = [[UITextField alloc]initWithFrame:CGRectMake(PHI05_SIZE_XXL, 50, SCREEN_WIDTH - 2*PHI05_SIZE_XXL, 44)];
    nameTextField.backgroundColor = TextFieldBackGroundColor;
    [nameTextField setLineColor:[UIColor whiteColor]];
    [nameTextField addLine:HirAddLineTypeDown];
    [nameTextField setPlaceholder:NSLocalizedString(@"lgUsername", @"")];
    [self.view addSubview:nameTextField];
    
    UITextField *passWordTextField = [[UITextField alloc]initWithFrame:CGRectMake(PHI05_SIZE_XXL, CGRectGetMaxY(nameTextField.frame), SCREEN_WIDTH - 2*PHI05_SIZE_XXL, 44)];
    passWordTextField.backgroundColor = TextFieldBackGroundColor;
    [passWordTextField addLine:HirAddLineTypeDown];
    [passWordTextField setPlaceholder:NSLocalizedString(@"lgPassword", @"")];
    [self.view addSubview:passWordTextField];
    
    UIButton *forgotBtn = [[UIButton alloc]initWithFrame:CGRectMake(PHI06_SIZE_XXXL, CGRectGetMaxY(passWordTextField.frame) + PVI05_SIZE_XXL, 100, 44)];
    [forgotBtn setTitle:NSLocalizedString(@"forgotPassword", @"") forState:UIControlStateNormal];
    [forgotBtn addTarget:self action:@selector(forgotBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgotBtn];
    
    UIButton *nextBtn = [[UIButton alloc]initWithFrame:CGRectMake(PHI05_SIZE_XXL, self.view.frame.size.height - PHI05_SIZE_XXL - 44, SCREEN_WIDTH - 2*PHI05_SIZE_XXL, 44)];
    [nextBtn settingStyle:HirStyleViewColor_Pale];
    [self.view addSubview:nextBtn];
    // Do any additional setup after loading the view from its nib.
}

-(void)forgotBtnPressed:(id)sender{
    NSLog(@"forgotBtnPressed");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
