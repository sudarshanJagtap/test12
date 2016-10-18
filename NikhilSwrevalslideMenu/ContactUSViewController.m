//
//  ContactUSViewController.m
//  NikhilSwrevalslideMenu
//
//  Created by Sudarshan on 10/14/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import "ContactUSViewController.h"
#import "SWRevealViewController.h"
#import "CCTextFieldEffects.h"
@interface ContactUSViewController ()<UITextFieldDelegate>

@end

@implementation ContactUSViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  self.navigationController.navigationBar.hidden = YES;
  self.addressVw.hidden = YES;
  self.emailView.hidden = YES;
  self.callVw.hidden = YES;
  self.scrollVw.hidden  = NO;
  self.ContactReactSegment.selectedSegmentIndex = 0;
  [self configuretxtfld];
}

-(void)configuretxtfld{
//  self.fNameTxtfld = [[JiroTextField alloc] initWithFrame:<#CGRect#>];
//  
//  self.fNameTxtfld.placeholder = @"";
//  
//  // The size of the placeholder label relative to the font size of the text field, default value is 0.65
//  self.jiroTextField.placeholderFontScale = <#CGFloat#>;
//  
//  // The color of the border, default value is R106 G121 B137
//  self.jiroTextField.borderColor = <#UIColor#>;
//  
//  // The color of the placeholder, default value is R106 G121 B137
//  self.jiroTextField.placeholderColor = <#UIColor#>;
//  
//  // The color of the cursor, default value is R211 G226 B226
//  self.jiroTextField.cursorColor = <#UIColor#>;
//  
//  // The color of the text, default value is R211 G226 B226
//  self.jiroTextField.textColor = <#UIColor#>;
//  
//  // The block excuted when the animation for obtaining focus has completed.
//  // Do not use textFieldDidBeginEditing:
//  self.jiroTextField.didBeginEditingHandler = ^{
//    // ...
//  };
//  
//  // The block excuted when the animation for losing focus has completed.
//  // Do not use textFieldDidEndEditing:
//  self.jiroTextField.didEndEditingHandler = ^{
//    // ...
//  };
//  JiroTextField *nametf1 = [[JiroTextField alloc] initWithFrame:self.highFrame];
//  tf1.placeholder = @"First Name";
//  [self.view addSubview:tf1];
//  self.fNameTxtfld.placeholder = @"First Name";
//   self.fNameTxtfld.placeholderFontScale = 0.65;
//  self.fNameTxtfld.borderColor = [UIColor blackColor];
//  self.fNameTxtfld.placeholderColor = [UIColor colorWithRed:106.0 green:121.0 blue:137.0 alpha:1];
//   self.fNameTxtfld.textColor = [UIColor colorWithRed:211.0 green:226.0 blue:226.0 alpha:1];
//  self.lNameTxtFld.placeholder = @"Last Name";
//     self.lNameTxtFld.placeholderFontScale = 0.65;
//   self.lNameTxtFld.borderColor = [UIColor colorWithRed:106.0 green:121.0 blue:137.0 alpha:1];
//  self.lNameTxtFld.placeholderColor = [UIColor colorWithRed:106.0 green:121.0 blue:137.0 alpha:1];
//  self.lNameTxtFld.textColor = [UIColor colorWithRed:211.0 green:226.0 blue:226.0 alpha:1];
//  self.emailTxtFld.placeholder = @"Email Id";
//     self.emailTxtFld.placeholderFontScale = 0.65;
//   self.emailTxtFld.borderColor = [UIColor colorWithRed:106.0 green:121.0 blue:137.0 alpha:1];
//  self.emailTxtFld.placeholderColor = [UIColor colorWithRed:106.0 green:121.0 blue:137.0 alpha:1];
//  self.emailTxtFld.textColor = [UIColor colorWithRed:211.0 green:226.0 blue:226.0 alpha:1];
//  self.phoneTxtfld.placeholder = @"Phone Number";
//     self.phoneTxtfld.placeholderFontScale = 0.65;
//   self.phoneTxtfld.borderColor = [UIColor colorWithRed:106.0 green:121.0 blue:137.0 alpha:1];
//  self.phoneTxtfld.placeholderColor = [UIColor colorWithRed:106.0 green:121.0 blue:137.0 alpha:1];
//  self.phoneTxtfld.textColor = [UIColor colorWithRed:211.0 green:226.0 blue:226.0 alpha:1];
//  self.quesTxtfld.placeholder = @"If any Questions?";
//     self.quesTxtfld.placeholderFontScale = 0.65;
//   self.quesTxtfld.borderColor = [UIColor colorWithRed:106.0 green:121.0 blue:137.0 alpha:1];
//  self.quesTxtfld.placeholderColor = [UIColor colorWithRed:106.0 green:121.0 blue:137.0 alpha:1];
//  self.quesTxtfld.textColor = [UIColor colorWithRed:211.0 green:226.0 blue:226.0 alpha:1];

}

- (IBAction)backNavBtnClick:(id)sender {
  NSString * storyboardName = @"Main";
  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
  UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"FrontHomeScreenViewControllerId"];
  UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
  [navController setViewControllers: @[vc] animated: NO ];
  [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
  [self animateTextField:textField up:YES];
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
  [self animateTextField:textField up:NO];
}


- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
  int animatedDistance;
  int moveUpValue = textField.frame.origin.y+ textField.frame.size.height;
  UIInterfaceOrientation orientation =
  [[UIApplication sharedApplication] statusBarOrientation];
  if (orientation == UIInterfaceOrientationPortrait ||
      orientation == UIInterfaceOrientationPortraitUpsideDown)
  {
    
    animatedDistance = 216-(520-moveUpValue-5);
  }
  else
  {
    animatedDistance = 162-(320-moveUpValue-5);
  }
  
  if(animatedDistance>0)
  {
    const int movementDistance = animatedDistance;
    const float movementDuration = 0.3f;
    int movement = (up ? -movementDistance : movementDistance);
    [UIView beginAnimations: nil context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
  }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
  
  [textField resignFirstResponder];
  return YES;
}
- (IBAction)subtmitBtnclick:(id)sender {
}
- (IBAction)segmentClick:(id)sender {
  UISegmentedControl *s = (UISegmentedControl *)sender;
  
  if (s.selectedSegmentIndex == 0)
  {
    self.txtfldVw.hidden = NO;
    self.addressVw.hidden = YES;
    self.emailView.hidden = YES;
    self.callVw.hidden = YES;
    self.subtmitBtn.hidden = NO;
    self.scrollVw.hidden  = NO;
  }else{
    self.txtfldVw.hidden = YES;
    self.addressVw.hidden = NO;
    self.emailView.hidden = NO;
    self.callVw.hidden = NO;
    self.subtmitBtn.hidden = YES;
    self.scrollVw.hidden  = YES;
  }
}
@end
