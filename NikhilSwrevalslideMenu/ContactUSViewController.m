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
#import "AppDelegate.h"
#import "AppConstant.h"
#import "RequestUtility.h"
@interface ContactUSViewController ()<UITextFieldDelegate>{

  AppDelegate *appDelegate;
  UIView *blankScreen;
  UIView *alertView;
  UILabel *fromLabel;
}

@end

@implementation ContactUSViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  CGRect screenRect = [[UIScreen mainScreen] bounds];
  CGFloat screenHeight = screenRect.size.height;
  CGFloat screenWidth = screenRect.size.width;
  alertView = [[UIView alloc]init];
  fromLabel = [[UILabel alloc]init];
  blankScreen = [[UIView alloc]init];
  blankScreen.frame = CGRectMake(0, 0, screenWidth, screenHeight);
  blankScreen.backgroundColor = [UIColor blackColor];
  blankScreen.alpha = 0.5;
  blankScreen.hidden =YES;
  [self.view addSubview:blankScreen];
  [self.view bringSubviewToFront:blankScreen];

  // Do any additional setup after loading the view.
  self.navigationController.navigationBar.hidden = YES;
  self.addressVw.hidden = YES;
  self.emailView.hidden = YES;
  self.callVw.hidden = YES;
  self.scrollVw.hidden  = NO;
  self.ContactReactSegment.selectedSegmentIndex = 0;
  [self configuretxtfld];
  
  UIToolbar *keyboardDoneButtonView = [[UIToolbar alloc] init];
  [keyboardDoneButtonView sizeToFit];
  UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                 style:UIBarButtonItemStylePlain target:self
                                                                action:@selector(doneClicked:)];
  [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:doneButton, nil]];
  self.phoneTxtfld.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneTxtfld.inputAccessoryView = keyboardDoneButtonView;
  
}

- (IBAction)doneClicked:(id)sender
{
  NSLog(@"Done Clicked.");
  [self.view endEditing:YES];
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
  int moveUpValue = textField.frame.origin.y+ textField.frame.size.height+100;
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
  
  NSMutableString *msgString = [[NSMutableString alloc]init];
  BOOL retval = [self doValidateUserTextFieldText:msgString];
  if (retval) {
    
    [self doSubmitDetails];
    
    
  }else{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:msgString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    
  }
  
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

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
  BOOL stricterFilter = NO;
  NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
  NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
  NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
  NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
  return [emailTest evaluateWithObject:checkString];
}

- (BOOL)validatePhone:(NSString *)mobileNumber
{
  
  mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
  mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
  mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
  mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
  mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
  
  NSLog(@"%@", mobileNumber);
  
  int length = (int)[mobileNumber length];
  if(length > 10)
  {
    mobileNumber = [mobileNumber substringFromIndex: length-10];
    NSLog(@"%@", mobileNumber);
    
  }
  
  NSString *numberRegEx = @"[0-9]{10}";
  NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegEx];
  if ([numberTest evaluateWithObject:mobileNumber] == YES)
    return TRUE;
  else
    return FALSE;
  
}
//#define MOB_MAX_LENGTH 10
//#define ZIP_MAX_LENGTH 6
//
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//  if(textField ==self.phoneTxtfld){
//    NSString *str = [self.phoneTxtfld.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    if (str.length >= MOB_MAX_LENGTH && range.length == 0)
//    {
//      return NO; // return NO to not change text
//    }else{return YES;}
//  }
//  else
//  {return YES;}
//}


#define ACCEPTABLE_CHARACTERS @" ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
#define MOB_MAX_LENGTH 10
#define ZIP_MAX_LENGTH 11

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string  {
  if ([textField isEqual:self.fNameTxtfld]) {
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARACTERS] invertedSet];
    
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    return [string isEqualToString:filtered];
  }
  else if ([textField isEqual:self.lNameTxtFld]) {
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARACTERS] invertedSet];
    
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    return [string isEqualToString:filtered];
  }
  else if(textField ==self.phoneTxtfld){
//    NSString *str = [self.phoneTxtfld.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    if (str.length >= MOB_MAX_LENGTH && range.length == 0)
//    {
//      return NO; // return NO to not change text
//    }else{return YES;}
    int length = (int)[self getLength:textField.text];
    //NSLog(@"Length  =  %d ",length);
    
    if(length == 10)
    {
      if(range.length == 0)
        return NO;
    }
    
    if(length == 3)
    {
      NSString *num = [self formatNumber:textField.text];
      textField.text = [NSString stringWithFormat:@"%@",num];
      
      if(range.length > 0)
        textField.text = [NSString stringWithFormat:@"%@",[num substringToIndex:3]];
    }
    else if(length == 6)
    {
      NSString *num = [self formatNumber:textField.text];
      //NSLog(@"%@",[num  substringToIndex:3]);
      //NSLog(@"%@",[num substringFromIndex:3]);
      textField.text = [NSString stringWithFormat:@"%@-%@-",[num  substringToIndex:3],[num substringFromIndex:3]];
      
      if(range.length > 0)
        textField.text = [NSString stringWithFormat:@"%@-%@",[num substringToIndex:3],[num substringFromIndex:3]];
    }
    return YES;
  }
  else{
    
    return YES;
  }
  
}

-(BOOL)doValidateUserTextFieldText:(NSMutableString*)message{
  
  BOOL retval = NO;
  if (self.fNameTxtfld.text.length == 0) {
    retval= NO;
    [message appendString:@"Enter First Name"];
  }
  else if (self.lNameTxtFld.text.length == 0) {
    retval= NO;
    [message appendString:@"Enter Last Name"];
  }
  else if (![self NSStringIsValidEmail:self.emailTxtFld.text]) {
    retval= NO;
    [message appendString:@"Enter valid Email Address"];
  }
  else if (self.emailTxtFld.text.length == 0) {
    retval= NO;
    [message appendString:@"Enter valid Email Address"];
  }
  else if (self.phoneTxtfld.text.length == 0) {
    retval= NO;
    [message appendString:@"Enter valid Contact Number"];
  }
  else if (![self validatePhone:self.phoneTxtfld.text]) {
    retval= NO;
    [message appendString:@"Enter valid Contact Number"];
  }
  else{
    retval = YES;
  }
  return retval;
}

-(void)clearTextField{
  dispatch_async(dispatch_get_main_queue(), ^{
    self.fNameTxtfld.text = @"";
    self.lNameTxtFld.text = @"";
    self.emailTxtFld.text = @"";
    self.phoneTxtfld.text = @"";
    self.quesTxtfld.text = @"";
  });
}


-(void)doSubmitDetails{
  
//  "{
//  ""first_name"": ""rajesh"",
//  ""last_name"": ""patil"",
//  ""email"": ""rajesh.p@mobisofttech.co.in"",
//  ""contact_no"": ""1234567890"",
//  ""questions"": ""testing"",
//  ""action"": ""contact_us""
//}"
  
  appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  [appDelegate showLoadingViewWithString:@"Loading..."];
  RequestUtility *utility = [RequestUtility sharedRequestUtility];
  
  NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
  [params setValue:self.fNameTxtfld.text forKey:@"first_name"];
  [params setValue:self.lNameTxtFld.text forKey:@"last_name"];
  [params setValue:self.self.emailTxtFld.text forKey:@"email"];
  [params setValue:self.phoneTxtfld.text forKey:@"contact_no"];
  [params setValue:self.quesTxtfld.text forKey:@"questions"];
  [params setValue:@"contact_us" forKey:@"action"];
  NSLog(@"%@",params);
  
  NSError * err;
  NSData * jsonData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&err];
  NSString *String = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
  NSLog(@"Contact us info string \n = %@",String);
  
  [utility doYMOCStringPostRequest:kContact_us withParameters:String onComplete:^(bool status, NSDictionary *responseDictionary){
    if (status) {
      NSLog(@"response:%@",responseDictionary);
      [self clearTextField];
      [self parseUserResponse:responseDictionary];
    }else{
      [self clearTextField];
      appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
      dispatch_async(dispatch_get_main_queue(), ^{
        [appDelegate hideLoadingView];
      });
    }
  }];
  
}

-(void)parseUserResponse:(NSDictionary*)ResponseDictionary{
  if (ResponseDictionary) {
    dispatch_async(dispatch_get_main_queue(), ^{
      NSString *code = [ResponseDictionary valueForKey:@"code"];
      if ([code isEqualToString:@"1"]) {
        NSLog(@"address add successfull");
        [appDelegate hideLoadingView];
        [self clearTextField];
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:[ResponseDictionary valueForKey:@"msg"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Thanks for Contacting us." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
        [self showMsg:@"Thanks for Contacting us."];
        
      }else{
        
        [self clearTextField];
        
        [appDelegate hideLoadingView];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:[ResponseDictionary valueForKey:@"msg"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
      }
    });
    
  }
}



#pragma mark phone number format


- (NSString *)formatNumber:(NSString *)mobileNumber
{
  mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
  mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
  mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
  mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
  mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
  
  NSLog(@"%@", mobileNumber);
  
  int length = (int)[mobileNumber length];
  if(length > 10)
  {
    mobileNumber = [mobileNumber substringFromIndex: length-10];
    NSLog(@"%@", mobileNumber);
    
  }
  
  return mobileNumber;
}

- (int)getLength:(NSString *)mobileNumber
{
  mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
  mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
  mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
  mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
  mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
  
  int length = (int)[mobileNumber length];
  
  return length;
}


-(void)showMsg:(NSString*)msgStr{
  
  
  
  float screenWidth = [[UIScreen mainScreen] bounds].size.width;
  float screenheight = [[UIScreen mainScreen] bounds].size.height;
  //  fullscreenView.frame = self.view.bounds;
  //  fullscreenView.backgroundColor = [UIColor blackColor];
//  UITapGestureRecognizer *singleFingerTap =
//  [[UITapGestureRecognizer alloc] initWithTarget:self
//                                          action:@selector(handleSingleTap:)];
//  [blankScreen addGestureRecognizer:singleFingerTap];
  blankScreen.hidden = NO;
  alertView.hidden = NO;
  //  fullscreenView.alpha = 0.5;
  //  [self.view addSubview:fullscreenView];
  //  [self.view bringSubviewToFront:fullscreenView];
  
  
  alertView.backgroundColor = [UIColor whiteColor];
  [alertView setFrame:CGRectMake(20, screenheight, screenWidth-40, 155)];
  
  UIImageView *imgView = [[UIImageView alloc]init];
  [imgView setFrame:CGRectMake(0, 0, screenWidth-40, 47)];
  [imgView setImage: [UIImage imageNamed:@"alertImg.png"]];
  imgView.backgroundColor = [UIColor colorWithRed:203.0 green:255.0 blue:112.0 alpha:1];
  [alertView addSubview:imgView];
  
//  UILabel *lineLbl = [[UILabel alloc]init];
//  [lineLbl setFrame:CGRectMake(0, 47, alertView.frame.size.width, 1)];
//  lineLbl.backgroundColor = [UIColor lightGrayColor];
//  lineLbl.numberOfLines = 1;
//  [alertView addSubview:lineLbl];
  
  [fromLabel setFrame:CGRectMake(0, 50, screenWidth-40, 45)];
  fromLabel.font = [UIFont fontWithName:@"Sansation-Bold" size:16];
  fromLabel.text = msgStr;
  fromLabel.numberOfLines = 4;
  fromLabel.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
  fromLabel.adjustsFontSizeToFitWidth = YES;
  fromLabel.minimumScaleFactor = 10.0f/12.0f;
  fromLabel.adjustsFontSizeToFitWidth = YES;
  fromLabel.backgroundColor = [UIColor clearColor];
  fromLabel.textColor = [UIColor colorWithRed:85.0/255.0 green:150.0/255.0 blue:28.0/255.0 alpha:1.0];;
  fromLabel.textAlignment = NSTextAlignmentCenter;
  fromLabel.lineBreakMode = NSLineBreakByWordWrapping;
  [alertView addSubview:fromLabel];
  
  UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  [okBtn addTarget:self
            action:@selector(OKBtnClicked:)
  forControlEvents:UIControlEventTouchUpInside];
  [okBtn setTitle:@"OK" forState:UIControlStateNormal];
  okBtn.frame = CGRectMake(alertView.frame.size.width/2-50, 105, 100, 40.0);
  okBtn.backgroundColor = [UIColor colorWithRed:63/255.0f green:173/255.0f blue:232/255.0f alpha:1.0f];
  
  blankScreen.hidden =NO;
  [alertView addSubview:okBtn];
  [self.view addSubview:alertView];
  [self.view bringSubviewToFront:alertView];
  
  [UIView transitionWithView:alertView
                    duration:0.5
                     options:UIViewAnimationOptionTransitionNone
                  animations:^{
                    alertView.center = self.view.center;
                  }
                  completion:nil];
  
}
-(IBAction)OKBtnClicked:(id)sender{
  //  UIButton *btn = (UIButton*)sender;
  blankScreen.hidden =YES;
  alertView.hidden = YES;
  [alertView removeFromSuperview];
  
  NSString * storyboardName = @"Main";
  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
  UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"FrontHomeScreenViewControllerId"];
  UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
  [navController setViewControllers: @[vc] animated: NO ];
  [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
  
  
}

@end
