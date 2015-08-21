//
//  HirLoginViewController.m
//  HiRemote
//
//  Created by minfengliu on 15/8/20.
//  Copyright (c) 2015年 hiremote. All rights reserved.
//

#import "HirLoginViewController.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "HIRHttpRequest.h"
#import "HirResetPasswordCtl.h"
#import "HirRegistetViewController.h"

@interface HirLoginViewController ()
<FBSDKLoginButtonDelegate,
UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *forgotBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (strong, nonatomic) FBSDKLoginButton *faceBookBtn;

@end

@implementation HirLoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutSubView];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(observeProfileChange:) name:FBSDKProfileDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(observeTokenChange:) name:FBSDKAccessTokenDidChangeNotification object:nil];

    if ([FBSDKAccessToken currentAccessToken]) {
        [self observeProfileChange:nil];
    }

    // Do any additional setup after loading the view from its nib.
    
}

-(void)layoutSubView{
    _userNameTextField.placeholder = NSLocalizedString(@"UserName/E-mail:", nil);
    _userNameTextField.delegate = self;
    _passwordTextField.placeholder = NSLocalizedString(@"Password:", nil);
    _passwordTextField.delegate = self;
    [_forgotBtn setTitle:NSLocalizedString(@"Forgot password", nil) forState:UIControlStateNormal];
    [_registerBtn setTitle:NSLocalizedString(@"Register new Account", nil) forState:UIControlStateNormal];
    
    self.faceBookBtn = [[FBSDKLoginButton alloc]initWithFrame:CGRectMake(PHI05_SIZE_XXL, CGRectGetMaxY(_registerBtn.frame)+PVI06_SIZE_XXXL, SCREEN_WIDTH - 2*PHI05_SIZE_XXL, 44)];
    self.faceBookBtn.delegate = self;
    self.faceBookBtn.readPermissions = @[@"public_profile"];
    [self.view addSubview:self.faceBookBtn];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)forgotBtnPressed:(id)sender {
    HirResetPasswordCtl *resetPasswordCtl = [[HirResetPasswordCtl alloc]initWithNibName:@"HirResetPasswordCtl" bundle:nil];
    [self.navigationController pushViewController:resetPasswordCtl animated:YES];
}

- (IBAction)registerBtnPressed:(id)sender {
    HirRegistetViewController *registetViewController = [[HirRegistetViewController alloc]initWithNibName:@"HirRegistetViewController" bundle:nil];
    [self.navigationController pushViewController:registetViewController animated:YES];
}

-(void)login{
    if (!_userNameTextField.text.length) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Please enter email", nil)];
        return;
    }
    if (!_passwordTextField.text.length) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Please enter pass word", nil)];
        return;
    }
    
    [HIRHttpRequest sendAsynchronousRequestWithParaDic:@{@"email":_userNameTextField.text,@"password":_passwordTextField.text} api:HIR_API_MEMBER_LOGIN hirRequestSuccess:^(id result) {
        NSLog(@"登陆成功 %@",result);
    } hirRequestErro:nil hirRequestConnectFail:nil];
}

#pragma mark - textfield
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _userNameTextField) {
        [_passwordTextField becomeFirstResponder];
    }
    else if (textField == _passwordTextField){
        [self login];
    }
    return YES;
}

#pragma mark - Observations
- (void)observeProfileChange:(NSNotification *)notfication {
    if ([FBSDKProfile currentProfile])
    {
        NSString *facebookId = [FBSDKAccessToken currentAccessToken].userID;
        NSString *token = [FBSDKAccessToken currentAccessToken].tokenString;
        if (facebookId.length && token.length) {
            [HIRHttpRequest sendAsynchronousRequestWithParaDic:@{@"facebookId":facebookId,@"token":token} api:HIR_API_FACEBOOK_LOGIN hirRequestSuccess:^(id result) {
                NSLog(@"登陆成功 %@",result);
            } hirRequestErro:nil hirRequestConnectFail:nil];
        }
        else{
            
        }
    }
    else{
        
    }
}

- (void)observeTokenChange:(NSNotification *)notfication {
    if (![FBSDKAccessToken currentAccessToken]) {
        
    } else {
        [self observeProfileChange:nil];
    }
}

#pragma mark - FBSDKLoginButtonDelegate

- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error {
    if (error) {
        NSLog(@"Unexpected login error: %@", error);
        NSString *alertMessage = error.userInfo[FBSDKErrorLocalizedDescriptionKey] ?: @"There was a problem logging in. Please try again later.";
        NSString *alertTitle = error.userInfo[FBSDKErrorLocalizedTitleKey] ?: @"Oops";
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    } else {
        [self observeProfileChange:nil];
    }
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
    
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
