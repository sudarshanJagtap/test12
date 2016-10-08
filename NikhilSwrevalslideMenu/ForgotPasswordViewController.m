//
//  ForgotPasswordViewController.m
//  NikhilSwrevalslideMenu
//
//  Created by Sudarshan on 10/2/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "AppDelegate.h"
#import "RequestUtility.h"
#import "DBManager.h"
@interface ForgotPasswordViewController ()<UITextFieldDelegate>{
  AppDelegate *appDelegate;
}

@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  self.postForgetView.hidden = YES;
  
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
  self.postForgetView.hidden = YES;
  [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)submitBtnClick:(id)sender {
  NSString *emailStr = self.emailTxtFld.text;
  BOOL retval = [self NSStringIsValidEmail:emailStr];
  if (retval) {
    [self doforgetPwd];
  }else{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Please enter valid email address" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
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

-(void)doforgetPwd{
  appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  [appDelegate showLoadingViewWithString:@"Loading..."];
  RequestUtility *utility = [RequestUtility sharedRequestUtility];
  NSString *url = @"http://mailer.mobisofttech.co.in/ymoc_portal_dev_latest/android_api/forgot_password.php";
  NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
//  NSDictionary *userdictionary = [[DBManager getSharedInstance]getALlUserData];
//  NSString *userId=[userdictionary valueForKey:@"user_id"];
  [params setValue:self.emailTxtFld.text forKey:@"email"];
  [params setValue:@"forgot_password" forKey:@"action"];
  NSError * err;
  NSData * jsonData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&err];
  NSString * myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
  [utility doYMOCStringPostRequest:url withParameters:myString onComplete:^(bool status, NSDictionary *responseDictionary){
    if (status) {
      NSLog(@"response:%@",responseDictionary);
      [self parseUserResponse:responseDictionary];
    }else{
      self.emailTxtFld.text= @"";
      [appDelegate hideLoadingView];
    }
  }];
  
}

-(void)parseUserResponse:(NSDictionary*)ResponseDictionary{
  if (ResponseDictionary) {
    self.emailTxtFld.text= @"";

    dispatch_async(dispatch_get_main_queue(), ^{
      //      NSString *code = [ResponseDictionary valueForKey:@"code"];
      if (([ResponseDictionary valueForKey:@"code"] == [NSNumber numberWithLong:1])|| ([[ResponseDictionary valueForKey:@"code"]isEqualToString:@"1"])){
        [appDelegate hideLoadingView];
//        [self performSegueWithIdentifier:@"PostforgetPwd" sender:nil];
        NSLog(@"successfull");
        self.postForgetView.hidden = NO;
        [self.view bringSubviewToFront:self.postForgetView];
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Your password has changed successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
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
