//
//  HirRegistetViewController.m
//  HiRemote
//
//  Created by minfengliu on 15/8/21.
//  Copyright (c) 2015年 hiremote. All rights reserved.
//

#import "HirRegistetViewController.h"
#import "HIRHttpRequest.h"
#import "HirBaseWebViewCtl.h"

@interface HirRegistetViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPsTextField;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
@property (weak, nonatomic) IBOutlet UIButton *registBtn;
@property (weak, nonatomic) IBOutlet UIButton *agreFlagBtn;

@end

@implementation HirRegistetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutSubView];
    // Do any additional setup after loading the view from its nib.
}

-(void)layoutSubView{
    _userNameTextField.placeholder = NSLocalizedString(@"UserName/E-mail:", nil);
    [_userNameTextField addLine:HirAddLineTypeDown];
    [_passwordTextField addLine:HirAddLineTypeDown|HirAddLineTypeUp];

    _emailTextField.placeholder = NSLocalizedString(@"E-mail", nil);
    _passwordTextField.placeholder = NSLocalizedString(@"Password", nil);
    _confirmPsTextField.placeholder = NSLocalizedString(@"Confirm password", nil);
    
    [_agreeBtn setTitle:NSLocalizedString(@"I Agree to...", nil) forState:UIControlStateNormal];
    [_registBtn setTitle:NSLocalizedString(@"Register new Account", nil) forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)agreetoBtnPressed:(id)sender {
    NSString *url = HirPrivacyPolicy;
    [self pushWebViewCtl:url title:NSLocalizedString(@"PrivacyPolicy", nil)];
}

- (IBAction)registBtnPressed:(id)sender {
    if (!_agreFlagBtn.selected) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"you should agree to before continue", nil)];
        return;
    }
    if (!_passwordTextField.text.length) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Please enter user name", nil)];
        return;
    }
    if (!_emailTextField.text.length) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Please enter email", nil)];
        return;
    }
    if (!_passwordTextField.text.length) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Please enter pass word", nil)];
        return;
    }
    if (![_confirmPsTextField.text isEqualToString:_passwordTextField.text]) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"confirm password is no equal", nil)];
        return;
    }
    [HIRHttpRequest sendAsynchronousRequestWithParaDic:@{@"userName":_userNameTextField.text,@"password":_passwordTextField.text,@"email":_emailTextField.text} api:HIR_API_MEMBER_REGISTER hirRequestSuccess:^(id result){
        NSLog(@"注册成功:%@",result);
    }hirRequestErro:^(NSError *erro){
        [SVProgressHUD showErrorWithStatus:erro.description];
    }hirRequestConnectFail:nil];
}

- (IBAction)agreeFlagBtnPressed:(UIButton *)sender {
    sender.selected = !sender.selected;
}

-(void)pushWebViewCtl:(NSString *)url title:(NSString *)title{
    HirBaseWebViewCtl *baseWebViewCtl = [[HirBaseWebViewCtl alloc]init];
    baseWebViewCtl.title = title;
    baseWebViewCtl.theUrl = [NSURL URLWithString:url];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:baseWebViewCtl];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
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
