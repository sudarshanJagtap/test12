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
}

@end

@implementation GuestUserDetailsViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  delAddress = true;
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
  
  UIImageView *imgViewForDropDown = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35, self.stateTxtFld.frame.size.height)];
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
//          if([RequestUtility sharedRequestUtility].isThroughLeftMenu){
//            [[DBManager getSharedInstance] saveUserData:[ResponseDictionary valueForKey:@"data"]];
//            [appDelegate hideLoadingView];
//            NSString * storyboardName = @"Main";
//            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
//            UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"FrontHomeScreenViewControllerId"];
//            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
//            [navController setViewControllers: @[vc] animated: NO ];
//            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
//          }else{
//            [[DBManager getSharedInstance] saveUserData:[ResponseDictionary valueForKey:@"data"]];
//            
//            [appDelegate hideLoadingView];
//            NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
//            for (UIViewController *aViewController in allViewControllers) {
//              if ([aViewController isKindOfClass:[CartViewController class]]) {
//                [self.navigationController popToViewController:aViewController animated:NO];
//              }
//            }
//          }
          
          [[DBManager getSharedInstance] saveUserData:[ResponseDictionary valueForKey:@"data"]];
                      [appDelegate hideLoadingView];
          if (delAddress) {
            
            AddressListViewController *obj_clvc  = (AddressListViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"AddressListViewControllerId"];
            
//            obj_clvc.selectedUfrespo = ufpRespo;
            [self.navigationController pushViewController:obj_clvc animated:YES];
          }else{
            AddDeliveryAddressViewController *obj_clvc  = (AddDeliveryAddressViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"AddDeliveryAddressViewControllerId"];
            
//            obj_clvc.selectedUfrespo = ufpRespo;
            [self.navigationController pushViewController:obj_clvc animated:YES];
          
          }
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
//    NSString *str = [self.mobileNoTxtFld.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
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
      textField.text = [NSString stringWithFormat:@"(%@) ",num];
      
      if(range.length > 0)
        textField.text = [NSString stringWithFormat:@"%@",[num substringToIndex:3]];
    }
    else if(length == 6)
    {
      NSString *num = [self formatNumber:textField.text];
      //NSLog(@"%@",[num  substringToIndex:3]);
      //NSLog(@"%@",[num substringFromIndex:3]);
      textField.text = [NSString stringWithFormat:@"(%@) %@-",[num  substringToIndex:3],[num substringFromIndex:3]];
      
      if(range.length > 0)
        textField.text = [NSString stringWithFormat:@"(%@) %@",[num substringToIndex:3],[num substringFromIndex:3]];
    }
    return YES;
  }
  else if (textField==self.zipCodeTxtFld) {
    NSString *str = [self.zipCodeTxtFld.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (str.length >= ZIP_MAX_LENGTH && range.length == 0)
    {
      return NO; // return NO to not change text
    }else{return YES;}
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

@end
