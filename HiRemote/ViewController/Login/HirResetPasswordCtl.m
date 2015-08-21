//
//  HirResetPasswordCtl.m
//  HiRemote
//
//  Created by minfengliu on 15/8/20.
//  Copyright (c) 2015年 hiremote. All rights reserved.
//

#import "HirResetPasswordCtl.h"
#import "HIRHttpRequest.h"

@interface HirResetPasswordCtl ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIButton *resetBtn;

@end

@implementation HirResetPasswordCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutSubView];
    
    self.title = NSLocalizedString(@"Reset Password", nil);
    // Do any additional setup after loading the view from its nib.
}

-(void)layoutSubView{
    [self.titleLabel setText:NSLocalizedString(@"ResetPWTip", nil)];
    self.emailTextField.placeholder = NSLocalizedString(@"E-mail", nil);
    [self.resetBtn setTitle:NSLocalizedString(@"Reset Password", nil) forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)resetBtnPress:(id)sender {
    if (_emailTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Please enter email", nil)];
        return;
    }
    [HIRHttpRequest sendAsynchronousRequestWithParaDic:@{@"email":_emailTextField.text} api:HIR_API_MEMBER_FIND_PWD hirRequestSuccess:^(id result){
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Reset password email had send,please turn to your email reset password.", nil)];
    }hirRequestErro:nil hirRequestConnectFail:nil];
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
