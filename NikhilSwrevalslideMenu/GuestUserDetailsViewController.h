//
//  GuestUserDetailsViewController.h
//  NikhilSwrevalslideMenu
//
//  Created by Sudarshan on 7/31/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuestUserDetailsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *nameTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *emailTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *mobileNoTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *address1TxtFld;
@property (weak, nonatomic) IBOutlet UITextField *adddress2TxtFld;
@property (weak, nonatomic) IBOutlet UITextField *cityTextFld;
@property (weak, nonatomic) IBOutlet UITextField *zipCodeTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *stateTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *countryTxtFld;
- (IBAction)procedFutherBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *deliveryAddressBtn;
- (IBAction)deliveryAddressBtnClick:(id)sender;

@end
