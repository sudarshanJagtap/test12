//
//  InvestmentViewController.h
//  NikhilSwrevalslideMenu
//
//  Created by Sunny Gupta on 28/10/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InvestmentViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UITextView *textViewDescription;

- (IBAction)backButton:(id)sender;


@property (strong, nonatomic) IBOutlet UITextField *nameTf;

@property (strong, nonatomic) IBOutlet UITextField *emailIdTf;

@property (strong, nonatomic) IBOutlet UITextField *contactTf;

@property (strong, nonatomic) IBOutlet UITextField *streetNameTf;


@property (strong, nonatomic) IBOutlet UITextField *houseNoTf;


@property (strong, nonatomic) IBOutlet UITextField *zipcodeTf;

@property (strong, nonatomic) IBOutlet UITextField *cityTf;
@property (strong, nonatomic) IBOutlet UITextView *commentTextView;

@property (strong, nonatomic) IBOutlet UIButton *CheckboxFirst;
@property (strong, nonatomic) IBOutlet UIButton *asapCheckbox;

@property (strong, nonatomic) IBOutlet UIButton *checkBoxSecond;

@property (strong, nonatomic) IBOutlet UITextField *investTf;

@end
