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
@interface GuestUserDetailsViewController (){
  AppDelegate *appDelegate;
}

@end

@implementation GuestUserDetailsViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
  self.navigationController.navigationBarHidden = NO;
  UIToolbar *keyboardDoneButtonView = [[UIToolbar alloc] init];
  [keyboardDoneButtonView sizeToFit];
  UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                 style:UIBarButtonItemStylePlain target:self
                                                                action:@selector(TBdoneClicked:)];
  [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:doneButton, nil]];
  self.mobileNoTxtFld.inputAccessoryView = keyboardDoneButtonView;
  self.zipCodeTxtFld.inputAccessoryView = keyboardDoneButtonView;
}

-(void)viewWillDisappear:(BOOL)animated{
  self.navigationController.navigationBarHidden = YES;
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
  NSString *url = @"http://ymoc.mobisofttech.co.in/android_api/guest_signup.php?";
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
  
  [utility doPostRequestfor:url withParameters:params onComplete:^(bool status, NSDictionary *responseDictionary){
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
        if([RequestUtility sharedRequestUtility].isThroughLeftMenu){
          [[DBManager getSharedInstance] saveUserData:[ResponseDictionary valueForKey:@"data"]];
          [appDelegate hideLoadingView];
          NSString * storyboardName = @"Main";
          UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
          UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"FrontHomeScreenViewControllerId"];
          UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
          [navController setViewControllers: @[vc] animated: NO ];
          [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
        }else{
          [[DBManager getSharedInstance] saveUserData:[ResponseDictionary valueForKey:@"data"]];
          
          [appDelegate hideLoadingView];
          NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
          for (UIViewController *aViewController in allViewControllers) {
            if ([aViewController isKindOfClass:[CartViewController class]]) {
              [self.navigationController popToViewController:aViewController animated:NO];
            }
          }
        }
      }else{
        [appDelegate hideLoadingView];
      }
    }
//    dispatch_async(dispatch_get_main_queue(), ^{
      [appDelegate hideLoadingView];
      UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:[ResponseDictionary valueForKey:@"msg"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
      [alert show];
//    });
    
  }
    });
}

-(BOOL)doValidateUserTextFieldText:(NSMutableString*)message{
  
  BOOL retval = NO;
   if (self.nameTxtFld.text.length == 0) {
    retval= NO;
    [message appendString:@"Please enter name details"];
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
   else if (self.adddress2TxtFld.text.length == 0) {
     retval= NO;
     [message appendString:@"Please enter address2 details"];
   }
  
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


- (BOOL)validatePhone:(NSString *)number
{
  
  NSString *numberRegEx = @"[0-9]{10}";
  NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegEx];
  if ([numberTest evaluateWithObject:number] == YES)
  return TRUE;
  else
  return FALSE;
  
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
}

- (IBAction)TBdoneClicked:(id)sender
{
  NSLog(@"Done Clicked.");
  [self.view endEditing:YES];
}

#define MOB_MAX_LENGTH 10
#define ZIP_MAX_LENGTH 6

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
  if(textField ==self.mobileNoTxtFld){
    NSString *str = [self.mobileNoTxtFld.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  if (str.length >= MOB_MAX_LENGTH && range.length == 0)
  {
    return NO; // return NO to not change text
  }else{return YES;}
  }
  if (textField==self.zipCodeTxtFld) {
     NSString *str = [self.zipCodeTxtFld.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
     if (str.length >= ZIP_MAX_LENGTH && range.length == 0)
  {
    return NO; // return NO to not change text
  }else{return YES;}
  }
  else
  {return YES;}
}
@end
