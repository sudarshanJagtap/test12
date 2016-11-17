//
//  SignUpViewController.m
//  NikhilSwrevalslideMenu
//
//  Created by Sudarshan on 8/1/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import "SignUpViewController.h"
#import "AppDelegate.h"
#import "RequestUtility.h"
#import "DBManager.h"
#import "CartViewController.h"
#import "SWRevealViewController.h"
#import "AppConstant.h"
#define kOFFSET_FOR_KEYBOARD 80.0
@interface SignUpViewController (){
  AppDelegate *appDelegate;
  UIView *blankScreen;
  UIView *alertView;
  UILabel *fromLabel;
  int tag;
  RequestUtility *sharedReqUtlty;
}

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    // Do any additional setup after loading the view.
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
  [self animateTextField:textField up:YES];
}
- (IBAction)backNavBtnClk:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
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
    NSLog(@"%d",animatedDistance);
  }
  else
  {
    animatedDistance = 162-(320-moveUpValue-5);
     NSLog(@"1 == %d",animatedDistance);
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

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  self.navigationController.navigationBarHidden = YES;
  UIToolbar *keyboardDoneButtonView = [[UIToolbar alloc] init];
  [keyboardDoneButtonView sizeToFit];
  UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                 style:UIBarButtonItemStylePlain target:self
                                                                action:@selector(TBdoneClicked:)];
  [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:doneButton, nil]];
  self.mobileTxtFld.inputAccessoryView = keyboardDoneButtonView;
  self.mobileTxtFld.keyboardType = UIKeyboardTypeNumberPad;
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  self.navigationController.navigationBarHidden = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)singUpBtnClick:(id)sender {
  NSMutableString *msgString = [[NSMutableString alloc]init];
  BOOL retval = [self doValidateUserTextFieldText:msgString];
  if (retval) {
    [self doValidateUserDetails];
  }else{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:msgString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    
  }
}

- (IBAction)alreadyAccountBtnClk:(id)sender {
}

-(void)doValidateUserDetails{
  appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  [appDelegate showLoadingViewWithString:@"Loading..."];
  RequestUtility *utility = [RequestUtility sharedRequestUtility];
  NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
  [params setValue:self.nameTxtFld.text forKey:@"name"];
  [params setValue:self.mobileTxtFld.text forKey:@"mobile"];
  [params setValue:self.emailTxtFld.text forKey:@"email"];
  [params setValue:self.passwordTxtFld.text forKey:@"password"];

  
  [utility doPostRequestfor:kSignup withParameters:params onComplete:^(bool status, NSDictionary *responseDictionary){
    if (status) {
      NSLog(@"response:%@",responseDictionary);
      [self parseUserResponse:responseDictionary];
    }else{
      [appDelegate hideLoadingView];
    }
  }];
  
}

-(void)parseUserResponse:(NSDictionary*)ResponseDictionary{
  if (ResponseDictionary) {
    dispatch_async(dispatch_get_main_queue(), ^{
//      NSString *code = [ResponseDictionary valueForKey:@"code"];
      if ([ResponseDictionary valueForKey:@"code"] == [NSNumber numberWithLong:1]) {
      NSLog(@"login successfull");
        
        [[DBManager getSharedInstance] saveUserData:[ResponseDictionary valueForKey:@"data"]];
        [appDelegate hideLoadingView];
        [self showMsg:@"Registration Successful"];
//        if([RequestUtility sharedRequestUtility].isThroughLeftMenu){
//          [[DBManager getSharedInstance] saveUserData:[ResponseDictionary valueForKey:@"data"]];
//          [appDelegate hideLoadingView];
//          NSString * storyboardName = @"Main";
//          UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
//          UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"FrontHomeScreenViewControllerId"];
//          UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
//          [navController setViewControllers: @[vc] animated: NO ];
//          [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
//        }else{
//        [appDelegate hideLoadingView];
//      [[DBManager getSharedInstance] saveUserData:[ResponseDictionary valueForKey:@"data"]];
//        NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
//        for (UIViewController *aViewController in allViewControllers) {
//          if ([aViewController isKindOfClass:[CartViewController class]]) {
//            [self.navigationController popToViewController:aViewController animated:NO];
//          }
//        }
//        }
      }else{
    
      
      
      [appDelegate hideLoadingView];
      UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:[ResponseDictionary valueForKey:@"msg"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
      [alert show];
    }
    });
    
  }
}

-(BOOL)doValidateUserTextFieldText:(NSMutableString*)message{
  
  NSString *pwd = self.passwordTxtFld.text;
  NSString *cpwd = self.confirmPasswordTxtFld.text;
  BOOL retval = NO;
  if (self.nameTxtFld.text.length == 0) {
    retval= NO;
    [message appendString:@"Please enter name"];
  }
  else if (self.mobileTxtFld.text.length == 0) {
    retval= NO;
    [message appendString:@"Please enter mobile number"];
  }
  else if (![self validatePhone:self.mobileTxtFld.text]) {
    retval= NO;
    [message appendString:@"Please enter valid mobile number"];
  }
  else if (self.emailTxtFld.text.length == 0) {
    retval= NO;
    [message appendString:@"Please enter valid email address"];
  }
  else if (![self NSStringIsValidEmail:self.emailTxtFld.text]) {
    retval= NO;
    [message appendString:@"Please enter valid email address"];
  }
  else if (self.passwordTxtFld.text.length == 0) {
    retval= NO;
    [message appendString:@"Please enter password"];
  }
  else if (self.confirmPasswordTxtFld.text.length == 0) {
    retval= NO;
    [message appendString:@"Please enter confirm password"];
  }
  else if (![pwd isEqualToString: cpwd]) {
    retval= NO;
    [message appendString:@"Password and Confirm Password do not match"];
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

- (IBAction)TBdoneClicked:(id)sender
{
  NSLog(@"Done Clicked.");
  [self.view endEditing:YES];
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
  else if(textField ==self.mobileTxtFld){
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
  else{
    
    return YES;
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

  if([RequestUtility sharedRequestUtility].isThroughLeftMenu){
//    [[DBManager getSharedInstance] saveUserData:[ResponseDictionary valueForKey:@"data"]];
    [appDelegate hideLoadingView];
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"FrontHomeScreenViewControllerId"];
    UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
    [navController setViewControllers: @[vc] animated: NO ];
    [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
  }else{
    [appDelegate hideLoadingView];
//    [[DBManager getSharedInstance] saveUserData:[ResponseDictionary valueForKey:@"data"]];
    NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
    for (UIViewController *aViewController in allViewControllers) {
      if ([aViewController isKindOfClass:[CartViewController class]]) {
        [self.navigationController popToViewController:aViewController animated:NO];
      }
    }
  }
  
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
  //  blankScreen.hidden = YES;
  //  alertView.hidden = YES;
  //  [alertView removeFromSuperview];
}


@end
