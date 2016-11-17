//
//  GuestUserDetailsViewController.m
//  NikhilSwrevalslideMenu
//
//  Created by Sudarshan on 7/31/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import "GuestUserDetailsViewController.h"
#import "RequestUtility.h"
#import "AppDelegate.h"
#import "SWRevealViewController.h"
#import "DBManager.h"
#import "CartViewController.h"
#import "NIDropDown.h"
#import "AddDeliveryAddressViewController.h"
#import "AddressListViewController.h"
#import "AppConstant.h"
#import <QuartzCore/QuartzCore.h>
@interface GuestUserDetailsViewController ()<NIDropDownDelegate>{
  AppDelegate *appDelegate;
  NSArray *statesArray;
  NIDropDown *dropDown;
  BOOL delAddress;
  UIView *blankScreen;
  UIView *alertView;
  UILabel *fromLabel;
  int tag;
  RequestUtility *sharedReqUtlty;
}

@end

@implementation GuestUserDetailsViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  delAddress = true;
  tag=0;
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
  [self getStates];
  
  // Do any additional setup after loading the view.
}
- (IBAction)backNavBtnclk:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
  self.navigationController.navigationBarHidden = YES;
  UIToolbar *keyboardDoneButtonView = [[UIToolbar alloc] init];
  [keyboardDoneButtonView sizeToFit];
  UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                 style:UIBarButtonItemStylePlain target:self
                                                                action:@selector(TBdoneClicked:)];
  [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:doneButton, nil]];
  self.mobileNoTxtFld.inputAccessoryView = keyboardDoneButtonView;
  self.zipCodeTxtFld.inputAccessoryView = keyboardDoneButtonView;
  
  self.mobileNoTxtFld.keyboardType = UIKeyboardTypeNumberPad;
  self.zipCodeTxtFld.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
  
  UIImageView *imgViewForDropDown = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, self.stateTxtFld.frame.size.height)];
  imgViewForDropDown.image = [UIImage imageNamed:@"drop2.png"];
  [imgViewForDropDown.layer setBorderColor: [[UIColor blackColor] CGColor]];
  [imgViewForDropDown.layer setBorderWidth: 1.0];
  self.stateTxtFld.rightView = imgViewForDropDown;
  self.stateTxtFld.rightViewMode = UITextFieldViewModeAlways;
}

-(void)viewWillDisappear:(BOOL)animated{
  self.navigationController.navigationBarHidden = YES;
}



- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
  BOOL retval = NO;
  if (textField == self.stateTxtFld) {
    if(dropDown == nil) {
      CGFloat f = 200;
      dropDown = [[NIDropDown alloc]showDropDown:self.stateTxtFld :&f :statesArray :nil :@"down"];
      dropDown.delegate = self;
    }
    else {
      [dropDown hideDropDown:self.stateTxtFld];
      [self rel];
    }
    retval = NO;
  }else{
    retval = YES;
  }
  return retval;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}
- (IBAction)proceedFutherBtnClick:(id)sender {
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

-(void)doValidateUserDetails{
  
  appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  [appDelegate showLoadingViewWithString:@"Loading..."];
  RequestUtility *utility = [RequestUtility sharedRequestUtility];
  utility.isThroughGuestUser = YES;
  NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
  [params setValue:self.countryTxtFld.text forKey:@"country"];
  [params setValue:self.zipCodeTxtFld.text forKey:@"zipcode"];
  [params setValue:self.mobileNoTxtFld.text forKey:@"mobile"];
  [params setValue:self.cityTextFld.text forKey:@"city"];
  [params setValue:self.address1TxtFld.text forKey:@"address1"];
  [params setValue:self.adddress2TxtFld.text forKey:@"address2"];
  [params setValue:self.emailTxtFld.text forKey:@"email"];
  [params setValue:self.nameTxtFld.text forKey:@"name"];
  [params setValue:self.stateTxtFld.text forKey:@"state"];
  if (delAddress) {
    [params setValue:@"1" forKey:@"flag"];
  }else{
    [params setValue:@"0" forKey:@"flag"];
  }
  [utility doPostRequestfor:kGuest_signup withParameters:params onComplete:^(bool status, NSDictionary *responseDictionary){
    if (status) {
      NSLog(@"response:%@",responseDictionary);
      [self parseUserResponse:responseDictionary];
    }else{
      [appDelegate hideLoadingView];
    }
  }];
  
}

-(void)parseUserResponse:(NSDictionary*)ResponseDictionary{
  dispatch_async(dispatch_get_main_queue(), ^{
    if (ResponseDictionary) {
      NSString *code = [ResponseDictionary valueForKey:@"code"];
      if ([code intValue] == 1) {
        NSLog(@"login successfull");
        NSString *ud = [[ResponseDictionary valueForKey:@"data"]valueForKey:@"user_name"];
        if ( ud.length>0) {
          [[DBManager getSharedInstance] saveUserData:[ResponseDictionary valueForKey:@"data"]];
          [appDelegate hideLoadingView];
          [self showMsg:@"Registration Successful"];
          
          
//          [[DBManager getSharedInstance] saveUserData:[ResponseDictionary valueForKey:@"data"]];
//                      [appDelegate hideLoadingView];
//          if (delAddress) {
//            
//            AddressListViewController *obj_clvc  = (AddressListViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"AddressListViewControllerId"];
//            
////            obj_clvc.selectedUfrespo = ufpRespo;
//            [self.navigationController pushViewController:obj_clvc animated:YES];
//          }else{
//            AddDeliveryAddressViewController *obj_clvc  = (AddDeliveryAddressViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"AddDeliveryAddressViewControllerId"];
//            
////            obj_clvc.selectedUfrespo = ufpRespo;
//            [self.navigationController pushViewController:obj_clvc animated:YES];
//          
//          }
        }else{
          [appDelegate hideLoadingView];
        }
      }
      //    dispatch_async(dispatch_get_main_queue(), ^{
      [appDelegate hideLoadingView];
//      UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:[ResponseDictionary valueForKey:@"msg"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//      [alert show];
      //    });
      
    }
  });
}

-(BOOL)doValidateUserTextFieldText:(NSMutableString*)message{
  
  BOOL retval = NO;
  if (self.nameTxtFld.text.length == 0) {
    retval= NO;
    [message appendString:@"Please enter name"];
  }
  else if (self.emailTxtFld.text.length == 0) {
    retval= NO;
    [message appendString:@"Please enter valid email details"];
  }
  else if (![self NSStringIsValidEmail:self.emailTxtFld.text]) {
    retval= NO;
    [message appendString:@"Please enter valid email details"];
  }
  else if (self.mobileNoTxtFld.text.length == 0) {
    retval= NO;
    [message appendString:@"Please enter mobile details"];
  }
  else if (![self validatePhone:self.mobileNoTxtFld.text]) {
    retval= NO;
    [message appendString:@"Please enter valid mobile details"];
  }
  else if (self.address1TxtFld.text.length == 0) {
    retval= NO;
    [message appendString:@"Please enter address1 details"];
  }
//  else if (self.adddress2TxtFld.text.length == 0) {
//    retval= NO;
//    [message appendString:@"Please enter address2 details"];
//  }
  
  else if (self.cityTextFld.text.length == 0) {
    retval= NO;
    [message appendString:@"Please enter city details"];
  }
  else if (self.zipCodeTxtFld.text.length == 0) {
    retval= NO;
    [message appendString:@"Please enter zipcode details"];
  }
  else if (![self isValidPinCode:self.zipCodeTxtFld.text]) {
    retval= NO;
    [message appendString:@"Please enter valid zipcode"];
  }
  else if (self.stateTxtFld.text.length == 0) {
    retval= NO;
    [message appendString:@"Please enter state details"];
  }
  else if (self.countryTxtFld.text.length == 0) {
    retval= NO;
    [message appendString:@"Please enter Country details"];
  }
  else{
    retval = YES;
  }
  return retval;
}

-(BOOL)isValidPinCode:(NSString*)pincode    {
  
  //For US
//  NSString *pinRegex = @"^\\d{5}(-\\d{4})?$";
//  
//  //  NSString *pinRegex = @"^[0-9]{6}$";
//  NSPredicate *pinTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pinRegex];
//  
//  BOOL pinValidates = [pinTest evaluateWithObject:pincode];
//  return pinValidates;
  
  BOOL ret = NO;
  if (pincode.length>=5) {
    ret = YES;
  }else{
    ret =NO;
  }
  return ret;
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

#define ACCEPTABLE_CHARACTERS @" ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
#define MOB_MAX_LENGTH 10
#define ZIP_MAX_LENGTH 11
#define ZipACCEPTABLE_CHARACTERS @"0123456789-"
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string  {
  if ([textField isEqual:self.nameTxtFld]) {
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARACTERS] invertedSet];
    
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    return [string isEqualToString:filtered];
  }
  else if ([textField isEqual:self.cityTextFld]) {
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARACTERS] invertedSet];
    
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    return [string isEqualToString:filtered];
  }
  else if(textField ==self.mobileNoTxtFld){
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
  else if (textField==self.zipCodeTxtFld) {
//    NSString *str = [self.zipCodeTxtFld.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    if (str.length >= ZIP_MAX_LENGTH && range.length == 0)
//    {
//      return NO; // return NO to not change text
//    }else{return YES;}
//  }
//  else{
//  
//    return YES;
//  }
    
    int length = (int)textField.text.length;
    //NSLog(@"Length  =  %d ",length);
    
    if(length == 11)
    {
      if(range.length == 0)
        return NO;
    }
    
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ZipACCEPTABLE_CHARACTERS] invertedSet];
    
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    return [string isEqualToString:filtered];
  }
  else{
    
    return YES;
  }
  
}

- (IBAction)procedFutherBtnClick:(id)sender {
  NSMutableString *msgString = [[NSMutableString alloc]init];
  BOOL retval = [self doValidateUserTextFieldText:msgString];
  if (retval) {
    [self doValidateUserDetails];
  }else{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:msgString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    
  }
}

- (IBAction)deliveryAddressBtnClick:(id)sender {
  if([self.deliveryAddressBtn.currentBackgroundImage isEqual:[UIImage imageNamed:@"uncheckBx.png"]])
  {
    delAddress = true;
    [self.deliveryAddressBtn  setBackgroundImage:[UIImage imageNamed: @"checkBx.png"] forState:UIControlStateNormal];
  }
  else
  {
    delAddress = false;
    [self.deliveryAddressBtn  setBackgroundImage:[UIImage imageNamed: @"uncheckBx.png"] forState:UIControlStateNormal];
  }
}

- (IBAction)TBdoneClicked:(id)sender
{
  NSLog(@"Done Clicked.");
  [self.view endEditing:YES];
}

//#define MOB_MAX_LENGTH 10
//#define ZIP_MAX_LENGTH 6

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//  if(textField ==self.mobileNoTxtFld){
//    NSString *str = [self.mobileNoTxtFld.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    if (str.length >= MOB_MAX_LENGTH && range.length == 0)
//    {
//      return NO; // return NO to not change text
//    }else{return YES;}
//  }
//  if (textField==self.zipCodeTxtFld) {
//    NSString *str = [self.zipCodeTxtFld.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    if (str.length >= ZIP_MAX_LENGTH && range.length == 0)
//    {
//      return NO; // return NO to not change text
//    }else{return YES;}
//  }
//  else
//  {
//    return YES;
//  }
//}


-(void)getStates{
  
  appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  [appDelegate showLoadingViewWithString:@"Loading..."];
  RequestUtility *utility = [RequestUtility sharedRequestUtility];
  NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
  [params setValue:self.countryTxtFld.text forKey:@"country"];
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
            
            NSString *codeStr = [[temp objectAtIndex:i]valueForKey:@"code"];
            NSString *stateStr = [[temp objectAtIndex:i]valueForKey:@"state"];
            NSString *displayStr = [NSString stringWithFormat:@"%@-%@",codeStr,stateStr];
            [listarray addObject:displayStr];
          }
          statesArray = [NSArray arrayWithArray:listarray];
          if (statesArray.count>0) {
            
            if ([statesArray containsObject:@"NJ-New Jersey"]) {
              self.stateTxtFld.text = @"NJ-New Jersey";
            }else{
            self.stateTxtFld.text = [statesArray objectAtIndex:0];
            }
          }
          
          NSLog(@"\n\n ListArray = %@",listarray);
          
//          if(dropDown == nil) {
//            CGFloat f = 200;
//            dropDown = [[NIDropDown alloc]showDropDown:self.stateTxtFld :&f :statesArray :nil :@"down"];
//            dropDown.delegate = self;
//          }
//          else {
//            [dropDown hideDropDown:self.stateTxtFld];
//            [self rel];
//          }
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
  UITapGestureRecognizer *singleFingerTap =
  [[UITapGestureRecognizer alloc] initWithTarget:self
                                          action:@selector(handleSingleTap:)];
  [blankScreen addGestureRecognizer:singleFingerTap];
  blankScreen.hidden = NO;
  alertView.hidden = NO;
  //  fullscreenView.alpha = 0.5;
  //  [self.view addSubview:fullscreenView];
  //  [self.view bringSubviewToFront:fullscreenView];
  
  
  alertView.backgroundColor = [UIColor whiteColor];
  [alertView setFrame:CGRectMake(20, screenheight, screenWidth-40, 155)];
  UIImageView *imgView = [[UIImageView alloc]init];
  [imgView setFrame:CGRectMake(alertView.frame.size.width/2-85, 10, 170, 30)];
  [imgView setImage: [UIImage imageNamed:@"ymoc_login_logo.png"]];
  [alertView addSubview:imgView];
  
  UILabel *lineLbl = [[UILabel alloc]init];
  [lineLbl setFrame:CGRectMake(0, 47, alertView.frame.size.width, 1)];
  lineLbl.backgroundColor = [UIColor lightGrayColor];
  lineLbl.numberOfLines = 1;
  [alertView addSubview:lineLbl];
  
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
  
  //  if ([msgStr isEqualToString:@"Delivery Fee will be changed as per your delivery address"]) {
  //    tag=1;
  //  }else if ([msgStr isEqualToString:@"Please select payment type"]){
  //    tag =3;
  //  }
  //  else if([msgStr isEqualToString:@"Please check selected delivery address"]){
  //    tag =4;
  //  }
  //  else{
  //    tag=0;
  //  }
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
  if (delAddress) {
    
    AddressListViewController *obj_clvc  = (AddressListViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"AddressListViewControllerId"];
    
    //            obj_clvc.selectedUfrespo = ufpRespo;
    [self.navigationController pushViewController:obj_clvc animated:YES];
  }else{
    AddDeliveryAddressViewController *obj_clvc  = (AddDeliveryAddressViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"AddDeliveryAddressViewControllerId"];
    
    //            obj_clvc.selectedUfrespo = ufpRespo;
    [self.navigationController pushViewController:obj_clvc animated:YES];
    
  }
  
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {

}

@end
