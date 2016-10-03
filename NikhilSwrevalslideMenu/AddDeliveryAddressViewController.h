//
//  AddDeliveryAddressViewController.h
//  NikhilSwrevalslideMenu
//
//  Created by Sudarshan on 8/7/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResponseUtility.h"
@interface AddDeliveryAddressViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *fullNameTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *address1TxtFld;
@property (weak, nonatomic) IBOutlet UITextField *address2TxtFld;
@property (weak, nonatomic) IBOutlet UITextField *contactNoTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *cityTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *zipCodeTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *stateTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *countryTxtFld;
@property (weak, nonatomic) IBOutlet USerAddressData *data;
- (IBAction)DoneBtnClick:(id)sender;
- (IBAction)NavigationBackBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UIButton *doneUpdateBtn;
- (IBAction)doneUpdateBtnClick:(id)sender;

@end
