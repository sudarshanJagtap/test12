//
//  SignUpLoginViewController.h
//  NikhilSwrevalslideMenu
//
//  Created by Sudarshan on 7/31/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Google/SignIn.h>
@interface SignUpLoginViewController : UIViewController<GIDSignInUIDelegate>
- (IBAction)facebookBtnClick:(id)sender;
- (IBAction)twitterBtnClick:(id)sender;
- (IBAction)googlePlusBtnClick:(id)sender;
- (IBAction)signUpBtnClick:(id)sender;
- (IBAction)loginBtnClick:(id)sender;
- (IBAction)guestUserBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *skipLogin;
@property(weak, nonatomic) IBOutlet GIDSignInButton *signInButton;
- (IBAction)backNavBtnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;

@end
