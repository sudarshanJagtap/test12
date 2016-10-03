//
//  ChangePasswordViewController.m
//  NikhilSwrevalslideMenu
//
//  Created by Sudarshan on 8/19/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "AppDelegate.h"
#import "RequestUtility.h"
#import "DBManager.h"
@interface ChangePasswordViewController ()<UITextFieldDelegate>{
  BOOL isSecureEntryOn;
  AppDelegate *appDelegate;
}

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  isSecureEntryOn = YES;
  self.PwdTxtFld.secureTextEntry = YES;
    // Do any additional setup after loading the view.
  
}
-(void)viewWillAppear:(BOOL)animated{

  self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
  self.navigationController.navigationBarHidden = YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
  [textField resignFirstResponder];
  return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backNavBtnClick:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)submitBtnClick:(id)sender {
  NSMutableString *msgString = [[NSMutableString alloc]init];
  BOOL retval = [self doValidateUserTextFieldText:msgString];
  if (retval) {
    [self dochangePwd];
  }else{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:msgString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    
  }
}

- (IBAction)forgotPwdClick:(id)sender {
}

- (IBAction)showPwdClick:(id)sender {
  if (isSecureEntryOn) {
    isSecureEntryOn = NO;
    self.PwdTxtFld.secureTextEntry = NO;
  }else{
    isSecureEntryOn = YES;
    self.PwdTxtFld.secureTextEntry = YES;
  }
}

-(BOOL)doValidateUserTextFieldText:(NSMutableString*)message{
  BOOL retval = NO;
  if (self.currentPwdTxtFld.text.length == 0) {
    retval= NO;
    [message appendString:@"Please enter current password"];
  }
  else if (self.PwdTxtFld.text.length == 0) {
    retval= NO;
    [message appendString:@"Please enter new password"];
  }
  else{
    retval = YES;
  }
  return retval;
}

-(void)dochangePwd{
  appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  [appDelegate showLoadingViewWithString:@"Loading..."];
  RequestUtility *utility = [RequestUtility sharedRequestUtility];
  NSString *url = @"http://ymoc.mobisofttech.co.in/android_api/user_profile.php";
  NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
  NSDictionary *userdictionary = [[DBManager getSharedInstance]getALlUserData];
  NSString *userId=[userdictionary valueForKey:@"user_id"];
  [params setValue:self.currentPwdTxtFld.text forKey:@"old_password"];
  [params setValue:self.PwdTxtFld.text forKey:@"new_password"];
    [params setValue:userId forKey:@"user_id"];
    [params setValue:@"change_password" forKey:@"action"];
  NSError * err;
  NSData * jsonData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&err];
  NSString * myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
  [utility doYMOCStringPostRequest:url withParameters:myString onComplete:^(bool status, NSDictionary *responseDictionary){
    if (status) {
      NSLog(@"response:%@",responseDictionary);
      [self parseUserResponse:responseDictionary];
    }else{
         dispatch_async(dispatch_get_main_queue(), ^{
      self.PwdTxtFld.text= @"";
      self.currentPwdTxtFld.text = @"";
      [appDelegate hideLoadingView];
         });
    }
  }];
  
}


-(void)parseUserResponse:(NSDictionary*)ResponseDictionary{
  if (ResponseDictionary) {
  
    dispatch_async(dispatch_get_main_queue(), ^{
      self.PwdTxtFld.text= @"";
      self.currentPwdTxtFld.text = @"";
      //      NSString *code = [ResponseDictionary valueForKey:@"code"];
      if ([ResponseDictionary valueForKey:@"code"] == [NSNumber numberWithLong:1]) {
        NSLog(@"login successfull");
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Your password has changed successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
//        if([RequestUtility sharedRequestUtility].isThroughLeftMenu){
//            [appDelegate hideLoadingView];
////          [[DBManager getSharedInstance] saveUserData:[ResponseDictionary valueForKey:@"data"]];
////          NSString * storyboardName = @"Main";
////          UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
////          UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"FrontHomeScreenViewControllerId"];
////          UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
////          [navController setViewControllers: @[vc] animated: NO ];
////          [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
//        }else{
//          [appDelegate hideLoadingView];
////          [[DBManager getSharedInstance] saveUserData:[ResponseDictionary valueForKey:@"data"]];
////          NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
////          for (UIViewController *aViewController in allViewControllers) {
////            if ([aViewController isKindOfClass:[CartViewController class]]) {
////              [self.navigationController popToViewController:aViewController animated:NO];
////            }
////          }
//        }
      }else{
        
        
        
        [appDelegate hideLoadingView];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:[ResponseDictionary valueForKey:@"msg"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
      }
    });
    
  }
}

@end
