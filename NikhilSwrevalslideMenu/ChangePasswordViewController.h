//
//  ChangePasswordViewController.h
//  NikhilSwrevalslideMenu
//
//  Created by Sudarshan on 8/19/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePasswordViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *currentPwdTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *PwdTxtFld;
- (IBAction)submitBtnClick:(id)sender;

- (IBAction)forgotPwdClick:(id)sender;
- (IBAction)showPwdClick:(id)sender;
@end
