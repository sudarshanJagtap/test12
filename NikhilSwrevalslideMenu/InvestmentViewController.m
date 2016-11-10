//
//  InvestmentViewController.m
//  NikhilSwrevalslideMenu
//
//  Created by Sunny Gupta on 28/10/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import "InvestmentViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "NIDropDown.h"
#define kOFFSET_FOR_KEYBOARD 100.0
#import "AppDelegate.h"
#import "RequestUtility.h"
#import "AppConstant.h"
#import "NIDropDown.h"
#import "SWRevealViewController.h"

@interface InvestmentViewController ()<UITextViewDelegate,NIDropDownDelegate>{
  AppDelegate *appDelegate;
  NSArray *statesArray;
  NIDropDown *dropDown;
  BOOL isAsapSelected;
  BOOL isInvest;
  BOOL isInvestChanged;
  
  UIView *blankScreen;
  UIView *alertView;
  UILabel *fromLabel;
}

@end

@implementation InvestmentViewController
@synthesize scrollView;
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
  
  isAsapSelected = NO;
  isInvest = YES;
  isInvestChanged = NO;
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWasShown:)
                                               name:UIKeyboardDidShowNotification object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWillBeHidden:)
                                               name:UIKeyboardWillHideNotification object:nil];
  [self getStates];
  // Do any additional setup after loading the view.
  self.textViewDescription.layer.borderWidth=5;
  self.textViewDescription.layer.borderColor=[UIColor blackColor].CGColor;
  
  self.commentTextView.delegate = self;
  self.commentTextView.text = @"Comments";
  self.commentTextView.textColor = [UIColor lightGrayColor];
  
  [[self.commentTextView layer] setBorderColor:[[UIColor grayColor] CGColor]];
  [[self.commentTextView layer] setBorderWidth:1.3];
  
  
  self.Enquiryview.layer.borderWidth = 5.0f;
  self.Enquiryview.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor grayColor]);
  
  UIColor *color = [UIColor grayColor];
  self.Enquiryview.layer.shadowColor = [color CGColor];
  self.Enquiryview.layer.shadowRadius = 10.0f;
  self.Enquiryview.layer.shadowOpacity = 1;
  self.Enquiryview.layer.shadowOffset = CGSizeZero;
  self.Enquiryview.layer.masksToBounds = NO;
  
//  self.CheckboxFirst.selected = YES;
  [self.CheckboxFirst addTarget:self action:@selector(checkboxSelected:) forControlEvents:UIControlEventTouchUpInside];
  self.investTf.userInteractionEnabled=NO;
  
//  self.checkBoxSecond.selected = NO;
  [self.checkBoxSecond addTarget:self action:@selector(checkBoxSelectedNext:) forControlEvents:UIControlEventTouchUpInside];
  
//  self.asapCheckbox.selected = YES;
  [self.asapCheckbox addTarget:self action:@selector(AsapcheckSelectedNext:) forControlEvents:UIControlEventTouchUpInside];
  
  UIToolbar *keyboardDoneButtonView = [[UIToolbar alloc] init];
  [keyboardDoneButtonView sizeToFit];
  UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                 style:UIBarButtonItemStylePlain target:self
                                                                action:@selector(doneClicked:)];
  [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:doneButton, nil]];
  self.contactTf.keyboardType = UIKeyboardTypePhonePad;
  self.zipcodeTf.keyboardType = UIKeyboardTypePhonePad;
  self.contactTf.inputAccessoryView = keyboardDoneButtonView;
  self.zipcodeTf.inputAccessoryView = keyboardDoneButtonView;
  
  
  UIImageView *imgViewForDropDown = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35, self.stateTf.frame.size.height)];
   imgViewForDropDown.image = [UIImage imageNamed:@"drop2.png"];
  [imgViewForDropDown.layer setBorderColor: [[UIColor blackColor] CGColor]];
  [imgViewForDropDown.layer setBorderWidth: 1.0];
  self.stateTf.rightView = imgViewForDropDown;
  self.stateTf.rightViewMode = UITextFieldViewModeAlways;

  
  [self.asapCheckbox setBackgroundImage:[UIImage imageNamed:@"uncheckBx"] forState:UIControlStateNormal];
  [self.checkBoxSecond setBackgroundImage:[UIImage imageNamed:@"uncheckBx"] forState:UIControlStateNormal];
  [self.CheckboxFirst setBackgroundImage:[UIImage imageNamed:@"uncheckBx"] forState:UIControlStateNormal];
  

}

- (IBAction)doneClicked:(id)sender
{
  NSLog(@"Done Clicked.");
  [self.view endEditing:YES];
}

-(void)AsapcheckSelectedNext:(id)sender{
  
  
  if([self.asapCheckbox isSelected]==YES)
  {
    isAsapSelected = NO;
    [self.asapCheckbox setSelected:NO];
    [self.asapCheckbox setBackgroundImage:[UIImage imageNamed:@"uncheckBx"] forState:UIControlStateNormal];
  }
  else{
    isAsapSelected = YES;
    [self.asapCheckbox setSelected:YES];
    [self.asapCheckbox setBackgroundImage:[UIImage imageNamed:@"checkBx"] forState:UIControlStateNormal];
  }
  
}



-(void)checkboxSelected:(id)sender{
  isInvestChanged = YES;
  isInvest = YES;
  [self.CheckboxFirst setBackgroundImage:[UIImage imageNamed:@"checkBx"] forState:UIControlStateNormal];
  [self.checkBoxSecond setBackgroundImage:[UIImage imageNamed:@"uncheckBx"] forState:UIControlStateNormal];
  
//  if([self.CheckboxFirst isSelected]==YES)
//  {
//    isInvest = NO;
//    [self.CheckboxFirst setSelected:NO];
//    [self.CheckboxFirst setBackgroundImage:[UIImage imageNamed:@"uncheckBx"] forState:UIControlStateNormal];
//    [self.checkBoxSecond setBackgroundImage:[UIImage imageNamed:@"checkBx"] forState:UIControlStateNormal];
//  }
//  else{
//    isInvest = YES;
//    [self.CheckboxFirst setSelected:YES];
//    [self.CheckboxFirst setBackgroundImage:[UIImage imageNamed:@"checkBx"] forState:UIControlStateNormal];
//    [self.checkBoxSecond setBackgroundImage:[UIImage imageNamed:@"uncheckBx"] forState:UIControlStateNormal];
//  }
  
}


-(void)checkBoxSelectedNext:(id)sender{
  isInvestChanged = YES;
  isInvest = NO;
  [self.checkBoxSecond setSelected:YES];
  [self.checkBoxSecond setBackgroundImage:[UIImage imageNamed:@"checkBx"] forState:UIControlStateNormal];
  [self.CheckboxFirst setBackgroundImage:[UIImage imageNamed:@"uncheckBx"] forState:UIControlStateNormal];
  
//  if([self.checkBoxSecond isSelected]==YES)
//  {
//    isInvest = YES;
//    [self.checkBoxSecond setSelected:NO];
//    [self.checkBoxSecond setBackgroundImage:[UIImage imageNamed:@"uncheckBx"] forState:UIControlStateNormal];
//    [self.CheckboxFirst setBackgroundImage:[UIImage imageNamed:@"checkBx"] forState:UIControlStateNormal];
//  }
//  else{
//    isInvest = NO;
//    [self.checkBoxSecond setSelected:YES];
//    [self.checkBoxSecond setBackgroundImage:[UIImage imageNamed:@"checkBx"] forState:UIControlStateNormal];
//    [self.CheckboxFirst setBackgroundImage:[UIImage imageNamed:@"uncheckBx"] forState:UIControlStateNormal];
//  }
  
}




- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  [textField resignFirstResponder];
  
  return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
  BOOL retval = NO;
  if (textField == self.stateTf) {
    if(dropDown == nil) {
      CGFloat f = 200;
      dropDown = [[NIDropDown alloc]showDropDown:self.stateTf :&f :statesArray :nil :@"down"];
      dropDown.delegate = self;
    }
    else {
      [dropDown hideDropDown:self.stateTf];
      [self rel];
    }
    retval = NO;
  }else{
    retval = YES;
  }
  return retval;
}

- (IBAction)backButton:(id)sender
{
  
  [self.navigationController popViewControllerAnimated:YES];
  
}

#pragma mark textView delegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
  if ([textView.text isEqualToString:@"Comments"]) {
    textView.text = @"";
    textView.textColor = [UIColor blackColor]; //optional
  }
  [textView becomeFirstResponder];
  [self animateTextview:textView up:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
  if ([textView.text isEqualToString:@""]) {
    textView.text = @"Comments";
    textView.textColor = [UIColor lightGrayColor]; //optional
  }
  [textView resignFirstResponder];
  [self animateTextview:textView up:NO];
}

- (void) animateTextview: (UITextView*) textview up: (BOOL) up
{
  //  int animatedDistance;
  //
  //  int moveUpValue = textview.frame.origin.y+ textview.frame.size.height+100;
  //  UIInterfaceOrientation orientation =
  //  [[UIApplication sharedApplication] statusBarOrientation];
  //  if (orientation == UIInterfaceOrientationPortrait ||
  //      orientation == UIInterfaceOrientationPortraitUpsideDown)
  //  {
  //
  //    animatedDistance = 216-(self.view.frame.size.height-moveUpValue-5);
  //  }
  //  else
  //  {
  //    animatedDistance = 162-(320-moveUpValue-5);
  //  }
  //
  //  if(animatedDistance>0)
  //  {
  //    const int movementDistance = animatedDistance;
  //    const float movementDuration = 0.3f;
  //    int movement = (up ? -movementDistance : movementDistance);
  //    [UIView beginAnimations: nil context: nil];
  //    [UIView setAnimationBeginsFromCurrentState: YES];
  //    [UIView setAnimationDuration: movementDuration];
  //    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
  //    [UIView commitAnimations];
  //  }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
  
  if([text isEqualToString:@"\n"]) {
    [textView resignFirstResponder];
    return NO;
  }
  
  return YES;
}

#pragma mark textfield delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
  [self animateTextField:textField up:YES];
  self.scrollView.contentOffset = CGPointMake(0, textField.frame.origin.y);
  
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
  [self animateTextField:textField up:NO];
}


- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
  //  int animatedDistance;
  //
  //  int moveUpValue = textField.frame.origin.y+ textField.frame.size.height+100;
  //  UIInterfaceOrientation orientation =
  //  [[UIApplication sharedApplication] statusBarOrientation];
  //  if (orientation == UIInterfaceOrientationPortrait ||
  //      orientation == UIInterfaceOrientationPortraitUpsideDown)
  //  {
  //
  //    animatedDistance = 216-(520-moveUpValue-5);
  //  }
  //  else
  //  {
  //    animatedDistance = 162-(320-moveUpValue-5);
  //  }
  //
  //  if(animatedDistance>0)
  //  {
  //    const int movementDistance = animatedDistance;
  //    const float movementDuration = 0.3f;
  //    int movement = (up ? -movementDistance : movementDistance);
  //    [UIView beginAnimations: nil context: nil];
  //    [UIView setAnimationBeginsFromCurrentState: YES];
  //    [UIView setAnimationDuration: movementDuration];
  //    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
  //    [UIView commitAnimations];
  //  }
}

- (void)keyboardWasShown:(NSNotification*)notification
{
  //  NSDictionary *info = [notification userInfo];
  //  CGRect keyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
  //  keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
  //
  //  UIEdgeInsets contentInset = self.scrollView.contentInset;
  //  contentInset.bottom = keyboardRect.size.height-100;
  //  self.scrollView.contentInset = contentInset;
}

- (void)keyboardWillBeHidden:(NSNotification*)notification
{
  //  UIEdgeInsets contentInsets = UIEdgeInsetsZero;
  //  self.scrollView.contentInset = contentInsets;
}

-(void)clearTextField{
 dispatch_async(dispatch_get_main_queue(), ^{
  self.nameTf.text = @"";
  self.emailIdTf.text = @"";
  self.contactTf.text = @"";
  self.streetNameTf.text = @"";
  self.houseNoTf.text = @"";
  self.zipcodeTf.text = @"";
  self.cityTf.text = @"";
  self.commentTextView.text = @"Comments";
  self.commentTextView.textColor = [UIColor lightGrayColor];
   isAsapSelected = YES;
   isInvest = YES;
   isInvestChanged = NO;
   [self.asapCheckbox setBackgroundImage:[UIImage imageNamed:@"uncheckBx"] forState:UIControlStateNormal];
   [self.checkBoxSecond setBackgroundImage:[UIImage imageNamed:@"uncheckBx"] forState:UIControlStateNormal];
   [self.CheckboxFirst setBackgroundImage:[UIImage imageNamed:@"uncheckBx"] forState:UIControlStateNormal];
 });
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


-(BOOL)doValidateUserTextFieldText:(NSMutableString*)message{
  
  BOOL retval = NO;
  if (self.nameTf.text.length == 0) {
    retval= NO;
    [message appendString:@"Enter Name"];
  }
  else if (![self NSStringIsValidEmail:self.emailIdTf.text]) {
    retval= NO;
    [message appendString:@"Enter valid Email Address"];
  }
  else if (self.emailIdTf.text.length == 0) {
    retval= NO;
    [message appendString:@"Enter valid Email Address"];
  }
  else if (self.contactTf.text.length == 0) {
    retval= NO;
    [message appendString:@"Enter valid Contact Number"];
  }
  else if (![self validatePhone:self.contactTf.text]) {
    retval= NO;
    [message appendString:@"Enter valid Contact Number"];
  }
  else if (self.streetNameTf.text.length == 0) {
    retval= NO;
    [message appendString:@"Enter Street Name"];
  }
  else if (self.zipcodeTf.text.length == 0) {
    retval= NO;
    [message appendString:@"Enter valid zipcode"];
  }
  else if (![self isValidPinCode:self.zipcodeTf.text]) {
    retval= NO;
    [message appendString:@"Please enter valid zipcode"];
  }
  else if (self.cityTf.text.length == 0) {
    retval= NO;
    [message appendString:@"Enter City"];
  }
  else if (self.stateTf.text.length == 0) {
    retval= NO;
    [message appendString:@"Please select State"];
  }
  else{
    retval = YES;
  }
  return retval;
}

-(BOOL)isValidPinCode:(NSString*)pincode    {
  
  //For US
  NSString *pinRegex = @"^\\d{5}(-\\d{4})?$";
  
  //  NSString *pinRegex = @"^[0-9]{6}$";
  NSPredicate *pinTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pinRegex];
  
  BOOL pinValidates = [pinTest evaluateWithObject:pincode];
  return pinValidates;
}

#pragma mark GetStates
-(void)getStates{
  
  appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  [appDelegate showLoadingViewWithString:@"Loading..."];
  RequestUtility *utility = [RequestUtility sharedRequestUtility];
  NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
  //  [params setValue:self.countryTxtFld.text forKey:@"country"];
  NSError * err;
  NSData * jsonData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&err];
  NSString *String = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
  NSLog(@"additional info string \n = %@",String);
  
  [utility doYMOCStringPostRequest:kStates withParameters:String onComplete:^(bool status, NSDictionary *responseDictionary){
    if (status) {
      NSLog(@"response:%@",responseDictionary);
      [appDelegate hideLoadingView];
      [self parseStatesResponse:responseDictionary];
    }else{
      [appDelegate hideLoadingView];
    }
  }];
}

-(void)parseStatesResponse:(NSDictionary*)ResponseDictionary{
  if (ResponseDictionary) {
    NSString *code = [ResponseDictionary valueForKey:@"code"];
    if ([code isEqualToString:@"1"]) {
      
      dispatch_async(dispatch_get_main_queue(), ^{
        appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate hideLoadingView];
        if ([[ResponseDictionary valueForKey:@"code"]isEqualToString:@"1"]) {
          NSLog(@"login successfull");
          NSMutableArray *listarray = [[NSMutableArray alloc]init];
          NSArray *temp = [ResponseDictionary valueForKey:@"data"];
          for (int i =0; i<temp.count; i++) {
//            NSString *stateStr = [[temp objectAtIndex:i]valueForKey:@"state"];
//            [listarray addObject:stateStr];
            NSString *codeStr = [[temp objectAtIndex:i]valueForKey:@"code"];
            NSString *stateStr = [[temp objectAtIndex:i]valueForKey:@"state"];
            NSString *displayStr = [NSString stringWithFormat:@"%@-%@",codeStr,stateStr];
            [listarray addObject:displayStr];
          }
          statesArray = [NSArray arrayWithArray:listarray];
          NSLog(@"\n\n ListArray = %@",listarray);
//          if (statesArray.count>0) {
//            self.stateTf.text = [statesArray objectAtIndex:0];
//          }
          
          if (statesArray.count>0) {
            
            if ([statesArray containsObject:@"NJ-New Jersey"]) {
              self.stateTf.text = @"NJ-New Jersey";
            }else{
              self.stateTf.text = [statesArray objectAtIndex:0];
            }
          }
        }
        
      });
      
    }
    
  }else{
    dispatch_async(dispatch_get_main_queue(), ^{
      appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
      [appDelegate hideLoadingView];
    });
  }
}




#pragma mark drop down
- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
  //  [self btnFindFood:self];
  [self rel];
}

-(void)rel{
  dropDown = nil;
}

#pragma markInvestmentAPI




- (IBAction)submitForm:(id)sender {
  
  NSMutableString *msgString = [[NSMutableString alloc]init];
  BOOL retval = [self doValidateUserTextFieldText:msgString];
  if (retval) {
    
    [self doSubmitDetails];
    
    
  }else{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:msgString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    
  }
}

#define ACCEPTABLE_CHARACTERS @" ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
#define MOB_MAX_LENGTH 10
#define ZIP_MAX_LENGTH 11

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string  {
  if ([textField isEqual:self.nameTf]) {
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARACTERS] invertedSet];
    
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    return [string isEqualToString:filtered];
  }
  else if ([textField isEqual:self.cityTf]) {
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARACTERS] invertedSet];
    
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    return [string isEqualToString:filtered];
  }
  else if(textField ==self.contactTf){
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
//    int length = (int)[self getLength:textField.text];
//    //NSLog(@"Length  =  %d ",length);
//    
//    if(length == 10)
//    {
//      if(range.length == 0)
//        return NO;
//    }
//    
//    if(length == 3)
//    {
//      NSString *num = [self formatNumber:textField.text];
//      textField.text = [NSString stringWithFormat:@"(%@) ",num];
//      
//      if(range.length > 0)
//        textField.text = [NSString stringWithFormat:@"%@",[num substringToIndex:3]];
//    }
//    else if(length == 6)
//    {
//      NSString *num = [self formatNumber:textField.text];
//      //NSLog(@"%@",[num  substringToIndex:3]);
//      //NSLog(@"%@",[num substringFromIndex:3]);
//      textField.text = [NSString stringWithFormat:@"(%@) %@-",[num  substringToIndex:3],[num substringFromIndex:3]];
//      
//      if(range.length > 0)
//        textField.text = [NSString stringWithFormat:@"(%@) %@",[num substringToIndex:3],[num substringFromIndex:3]];
//    }
//    return YES;
    
  }
  else if (textField==self.zipcodeTf) {
    NSString *str = [self.zipcodeTf.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (str.length >= ZIP_MAX_LENGTH && range.length == 0)
    {
      return NO; // return NO to not change text
    }else{return YES;}
  }
  else{
    
    return YES;
  }
  
}

//#define MOB_MAX_LENGTH 10
//#define ZIP_MAX_LENGTH 6
//
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//  if(textField ==self.contactTf){
//    NSString *str = [self.contactTf.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    if (str.length >= MOB_MAX_LENGTH && range.length == 0)
//    {
//      return NO; // return NO to not change text
//    }else{return YES;}
//  }
//  if (textField==self.zipcodeTf) {
//    NSString *str = [self.zipcodeTf.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    if (str.length >= ZIP_MAX_LENGTH && range.length == 0)
//    {
//      return NO; // return NO to not change text
//    }else{return YES;}
//  }
//  else
//  {return YES;}
//}

-(void)doSubmitDetails{
  
  //  "{
  //  ""name"": ""rajesh"",
  //  ""email"": ""rajesh.p@mobisofttech.co.in"",
  //  ""contact_no"": ""1234567890"",
  //  ""address_line_1"": ""thane"",
  //  ""address_line_2"": ""west"",
  //  ""zipcode"": ""400605"",
  //  ""city"": ""thane"",
  //  ""state"": ""maharashtra"",
  //  ""comment"": ""sfsdfsdfdfsdf"",
  //  ""time_to_contact"": ""asap"",
  //  ""inquiry_type"": ""ddfgdf"",
  //  ""action"": ""investment_opportunity""
  //}"

  appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  [appDelegate showLoadingViewWithString:@"Loading..."];
  RequestUtility *utility = [RequestUtility sharedRequestUtility];
  
  NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
  [params setValue:self.nameTf.text forKey:@"name"];
  [params setValue:self.emailIdTf.text forKey:@"email"];
  [params setValue:self.self.streetNameTf.text forKey:@"address_line1"];
  [params setValue:self.houseNoTf.text forKey:@"address_line2"];
  [params setValue:self.contactTf.text forKey:@"contact_no"];
  [params setValue:self.zipcodeTf.text forKey:@"zipcode"];
  [params setValue:self.stateTf.text forKey:@"state"];
  [params setValue:self.cityTf.text forKey:@"city"];
  [params setValue:self.commentTextView.text forKey:@"comment"];
  if (isAsapSelected) {
    [params setValue:@"asap" forKey:@"time_to_contact"];
  }else{
    [params setValue:@" " forKey:@"time_to_contact"];
  }
  if (isInvestChanged) {

  if (isInvest) {
    [params setValue:@"0" forKey:@"inquiry_type"];
  }else{
    [params setValue:@"1" forKey:@"inquiry_type"];
  }
  }else{
  [params setValue:@" " forKey:@"inquiry_type"];
  }
  [params setValue:@"investment_opportunity" forKey:@"action"];
  NSLog(@"%@",params);
  
  NSError * err;
  NSData * jsonData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&err];
  NSString *String = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
  NSLog(@"investment info string \n = %@",String);
  
  [utility doYMOCStringPostRequest:kInvestMentOppurtunity withParameters:String onComplete:^(bool status, NSDictionary *responseDictionary){
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
//          UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:[ResponseDictionary valueForKey:@"msg"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//          [alert show];
//          UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Thanks for Contacting us." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//          [alert show];
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
