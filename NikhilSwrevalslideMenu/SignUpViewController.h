//
//  SignUpViewController.h
//  NikhilSwrevalslideMenu
//
//  Created by Sudarshan on 8/1/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *nameTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *mobileTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *emailTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *passwordTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTxtFld;
- (IBAction)singUpBtnClick:(id)sender;
- (IBAction)alreadyAccountBtnClk:(id)sender;

@end
