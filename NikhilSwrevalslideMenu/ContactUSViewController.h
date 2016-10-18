//
//  ContactUSViewController.h
//  NikhilSwrevalslideMenu
//
//  Created by Sudarshan on 10/14/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCTextFieldEffects.h"
@interface ContactUSViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *scrollVw;
@property (weak, nonatomic) IBOutlet UIView *txtfldVw;
@property (weak, nonatomic) IBOutlet UITextField *fNameTxtfld;
@property (weak, nonatomic) IBOutlet UITextField *lNameTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *emailTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *phoneTxtfld;
@property (weak, nonatomic) IBOutlet UITextField *quesTxtfld;
@property (weak, nonatomic) IBOutlet UIButton *subtmitBtn;
- (IBAction)subtmitBtnclick:(id)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *ContactReactSegment;
- (IBAction)segmentClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *addressVw;
@property (weak, nonatomic) IBOutlet UIView *emailView;
@property (weak, nonatomic) IBOutlet UIView *callVw;
@end
