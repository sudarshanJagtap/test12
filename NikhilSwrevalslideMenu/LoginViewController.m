//
//  LoginViewController.m
//  NikhilSwrevalslideMenu
//
//  Created by Sudarshan on 7/31/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "RequestUtility.h"
#import "DBManager.h"
#import "CartViewController.h"
#import "SWRevealViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "DBManager.h"
#import "CartViewController.h"
#import <Google/SignIn.h>
#import <TwitterKit/TwitterKit.h>
#import "AppConstant.h"
#define kOFFSET_FOR_KEYBOARD 80.0
@interface LoginViewController ()<GIDSignInUIDelegate,GIDSignInDelegate>{
  AppDelegate *appDelegate;
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [GIDSignIn sharedInstance].uiDelegate = self;
  [GIDSignIn sharedInstance].delegate = self;
  // Do any additional setup after loading the view.
  
}



- (IBAction)backNavBtnClk:(id)sender {
   [self.navigationController popViewControllerAnimated:YES];
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

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  self.navigationController.navigationBarHidden = YES;
}

- (IBAction)fbLogin:(id)sender {
  FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
  [login
   logInWithReadPermissions: @[@"public_profile",@"email"]
   fromViewController:self
   handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
     if (error) {
       NSLog(@"Process error");
     } else if (result.isCancelled) {
       NSLog(@"Cancelled");
     } else {
       NSLog(@"Logged in");
       [self getUserDetails];
     }
   }];
}

-(void)getUserDetails
{
  __block NSMutableDictionary * parameters = [[NSMutableDictionary alloc]init];
  [parameters setValue:@"id,name,first_name,last_name,picture.type(large),email" forKey:@"fields"];
  
  [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters]
   startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                id result, NSError *error) {
     parameters =result;
     NSLog(@"%@",result);
     dispatch_async(dispatch_get_main_queue(), ^{
       [self uploadFbDetails:result];
     });
   }];
}

-(void)uploadFbDetails:(NSDictionary*)results{
  
  [appDelegate showLoadingViewWithString:@"Loading..."];
  RequestUtility *utility = [RequestUtility sharedRequestUtility];
  NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
  [params setValue:[results valueForKey:@"id"] forKey:@"app_id"];
  [params setValue:[results valueForKey:@"name"] forKey:@"full_name"];
  [params setValue:[results valueForKey:@"email"] forKey:@"email"];
  [params setValue:@"facebook" forKey:@"app_name"];
  [params setValue:@"after_socialmedia_login" forKey:@"action"];
  [utility doYMOCPostRequestfor:kAfter_socialmedia_login withParameters:params onComplete:^(bool status, NSDictionary *responseDictionary){
    if (status) {
      NSLog(@"response:%@",responseDictionary);
      [self parseUserResponseOfSocialMedia:responseDictionary];
    }else{
      [appDelegate hideLoadingView];
    }
  }];
}


-(void)parseUserResponseOfSocialMedia:(NSDictionary*)ResponseDictionary{
  if (ResponseDictionary) {
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
      NSString *code = [ResponseDictionary valueForKey:@"code"];
      if ([code isEqualToString:@"1"]) {
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
          //      [self.navigationController popViewControllerAnimated:YES];
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
        
      }else{
        [appDelegate hideLoadingView];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:[ResponseDictionary valueForKey:@"msg"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
      }
    });
    
  }
}




- (IBAction)twitterLogin:(id)sender {
  [[Twitter sharedInstance] logInWithMethods:TWTRLoginMethodWebBased completion:^(TWTRSession *session, NSError *error) {
    if (session) {
      NSLog(@"signed in as %@", [session userName]);
      NSString *message = [NSString stringWithFormat:@"@%@ logged in! (%@)",
                           [session userName], [session userID]];
      NSLog(@"%@",message);
      [self usersShow:session.userID];
    } else {
      NSLog(@"error: %@", [error localizedDescription]);
    }
  }];
}

-(void)usersShow:(NSString *)userID
{
  TWTRAPIClient *client = [TWTRAPIClient clientWithCurrentUser];
  NSURLRequest *request = [client URLRequestWithMethod:@"GET"
                                                   URL:@"https://api.twitter.com/1.1/account/verify_credentials.json"
                                            parameters:@{@"include_email": @"true", @"skip_status": @"true"}
                                                 error:nil];
  
  [client sendTwitterRequest:request completion:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
    
    NSLog(@"response ==%@",response);
    NSLog(@"data == %@",data);
    NSString *dataStr =  [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary* responseDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                       options:kNilOptions
                                                                         error:&error];
    [self uploadTwitterDetails:responseDictionary];
    NSLog(@"data String == %@",dataStr);
    NSLog(@"error == %@",connectionError);
  }];
  
}

-(void)uploadTwitterDetails:(NSDictionary*)results{
  
  [appDelegate showLoadingViewWithString:@"Loading..."];
  RequestUtility *utility = [RequestUtility sharedRequestUtility];
  NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
  [params setValue:[results valueForKey:@"id_str"] forKey:@"app_id"];
  [params setValue:[results valueForKey:@"name"] forKey:@"full_name"];
  [params setValue:[results valueForKey:@"screen_name"] forKey:@"email"];
  [params setValue:@"twitter" forKey:@"app_name"];
  [params setValue:@"after_socialmedia_login" forKey:@"action"];
  [utility doYMOCPostRequestfor:kAfter_socialmedia_login withParameters:params onComplete:^(bool status, NSDictionary *responseDictionary){
    if (status) {
      NSLog(@"response:%@",responseDictionary);
      [self parseUserResponseOfSocialMedia:responseDictionary];
    }else{
      [appDelegate hideLoadingView];
    }
  }];
}


- (IBAction)googlePlusLogin:(id)sender {
  [[GIDSignIn sharedInstance] signIn];
}

- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {
  //  [myActivityIndicator stopAnimating];
}

// Present a view that prompts the user to sign in with Google
- (void)signIn:(GIDSignIn *)signIn
presentViewController:(UIViewController *)viewController {
  [self presentViewController:viewController animated:YES completion:nil];
}


- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
  // Perform any operations on signed in user here.
  NSString *userId = user.userID;                  // For client-side use only!
  NSString *givenName = user.profile.givenName;
  NSString *familyName = user.profile.familyName;
  NSString *idToken = user.authentication.idToken; // Safe to send to the server
  NSLog(@" google data = %@,%@,%@ , %@",userId,familyName,idToken,givenName);
  NSString *fullName = user.profile.name;
  NSString *email = user.profile.email;
  NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
  [params setValue:userId forKey:@"app_id"];
  [params setValue:fullName forKey:@"full_name"];
  [params setValue:email forKey:@"email"];
  [params setValue:@"google" forKey:@"app_name"];
  [params setValue:@"after_socialmedia_login" forKey:@"action"];
  
  dispatch_async(dispatch_get_main_queue(), ^{
    [self uploadgoogleSignINDetails:params];
  });
  
}

-(void)uploadgoogleSignINDetails:(NSDictionary*)params{
  [appDelegate showLoadingViewWithString:@"Loading..."];
  RequestUtility *utility = [RequestUtility sharedRequestUtility];
  [utility doYMOCPostRequestfor:kAfter_socialmedia_login withParameters:params onComplete:^(bool status, NSDictionary *responseDictionary){
    if (status) {
      NSLog(@"response:%@",responseDictionary);
      [self parseUserResponseOfSocialMedia:responseDictionary];
    }else{
      [appDelegate hideLoadingView];
    }
  }];
}

- (void)signIn:(GIDSignIn *)signIn
didDisconnectWithUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
  
  UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
  [alert show];
}

// Dismiss the "Sign in with Google" view
- (void)signIn:(GIDSignIn *)signIn
dismissViewController:(UIViewController *)viewController {
  [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)loginBtnClick:(id)sender {
  
  NSString *emailTxt = self.emailIdTxtFld.text;
  NSString *pwdTxt = self.passwordTxtFld.text;
  
  if (![self NSStringIsValidEmail:emailTxt]) {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please enter valid Email Id" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
  }
  else if (pwdTxt.length==0) {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please enter valid Email Id" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
  }else{
    //
    [self doValidateUser:emailTxt andPwd:pwdTxt];
  }
}

- (IBAction)forgotPasswordBtnClick:(id)sender {
//  [self performSegueWithIdentifier:@"ForgetPwd" sender:nil];
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

-(void)doValidateUser:(NSString*)email andPwd:(NSString*)password{
  appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  [appDelegate showLoadingViewWithString:@"Loading..."];
  RequestUtility *utility = [RequestUtility sharedRequestUtility];
  NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
  [params setValue:email forKey:@"user_name"];
  [params setValue:password forKey:@"password"];
  [utility doPostRequestfor:kLogin withParameters:params onComplete:^(bool status, NSDictionary *responseDictionary){
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
      NSString *code = [ResponseDictionary valueForKey:@"code"];
      if ([ResponseDictionary valueForKey:@"code"] == [NSNumber numberWithLong:1]) {
        NSLog(@"login successfull");
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
        //      [self.navigationController popViewControllerAnimated:YES];
        NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
        for (UIViewController *aViewController in allViewControllers) {
          if ([aViewController isKindOfClass:[CartViewController class]]) {
            [self.navigationController popToViewController:aViewController animated:NO];
          }
        }
        }
      }else{
        [appDelegate hideLoadingView];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:[ResponseDictionary valueForKey:@"msg"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
      }
    });
    
  }
}

@end
