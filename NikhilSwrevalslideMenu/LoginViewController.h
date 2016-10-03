//
//  LoginViewController.h
//  NikhilSwrevalslideMenu
//
//  Created by Sudarshan on 7/31/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Google/SignIn.h>

@interface LoginViewController : UIViewController<GIDSignInUIDelegate>
- (IBAction)fbLogin:(id)sender;
- (IBAction)twitterLogin:(id)sender;
- (IBAction)googlePlusLogin:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *emailIdTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *passwordTxtFld;
- (IBAction)loginBtnClick:(id)sender;
- (IBAction)forgotPasswordBtnClick:(id)sender;

@end
