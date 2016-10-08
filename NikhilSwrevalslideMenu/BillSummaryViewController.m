//
//  BillSummaryViewController.m
//  NikhilSwrevalslideMenu
//
//  Created by Sudarshan on 7/31/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import "BillSummaryViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AddressListViewController.h"
#import "ResponseUtility.h"
#import "AppDelegate.h"
#import "RequestUtility.h"
#import "SWRevealViewController.h"
#import "DBManager.h"
// Set the environment:
// - For live charges, use PayPalEnvironmentProduction (default).
// - To use the PayPal sandbox, use PayPalEnvironmentSandbox.
// - For testing, use PayPalEnvironmentNoNetwork.
#define kPayPalEnvironment PayPalEnvironmentSandbox

@interface BillSummaryViewController (){
  AppDelegate *appDelegate;
   UIView *blankScreen;
  UIView *alertView;
  UILabel *fromLabel;
  int tag;
  
}
@property(nonatomic, strong, readwrite) PayPalConfiguration *payPalConfig;
@end

@implementation BillSummaryViewController

@synthesize subTotalPassed,salesTaxPassed,deliveryFeePassed,totalAmountPassed,bfPaymentDictionary;

- (void)viewDidLoad {
  [super viewDidLoad];
  tag=0;
  [RequestUtility sharedRequestUtility].backFromPaypalScreen = NO;
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
  // Set up payPalConfig
  _payPalConfig = [[PayPalConfiguration alloc] init];
#if HAS_CARDIO
  // You should use the PayPal-iOS-SDK+card-Sample-App target to enable this setting.
  // For your apps, you will need to link to the libCardIO and dependent libraries. Please read the README.md
  // for more details.
  _payPalConfig.acceptCreditCards = YES;
#else
  _payPalConfig.acceptCreditCards = NO;
#endif
  _payPalConfig.merchantName = @"YMOC";
  _payPalConfig.merchantPrivacyPolicyURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/privacy-full"];
  _payPalConfig.merchantUserAgreementURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/useragreement-full"];
  
  // Setting the languageOrLocale property is optional.
  //
  // If you do not set languageOrLocale, then the PayPalPaymentViewController will present
  // its user interface according to the device's current language setting.
  //
  // Setting languageOrLocale to a particular language (e.g., @"es" for Spanish) or
  // locale (e.g., @"es_MX" for Mexican Spanish) forces the PayPalPaymentViewController
  // to use that language/locale.
  //
  // For full details, including a list of available languages and locales, see PayPalPaymentViewController.h.
  
  _payPalConfig.languageOrLocale = [NSLocale preferredLanguages][0];
  
  
  // Setting the payPalShippingAddressOption property is optional.
  //
  // See PayPalConfiguration.h for details.
  
  //  _payPalConfig.payPalShippingAddressOption = PayPalShippingAddressOptionPayPal;
  
  // Do any additional setup after loading the view, typically from a nib.
  
  // use default environment, should be Production in real life
  self.environment = kPayPalEnvironment;
  
  NSLog(@"PayPal iOS SDK version: %@", [PayPalMobile libraryVersion]);
}

-(void)viewWillAppear:(BOOL)animated{
  
  if([RequestUtility sharedRequestUtility].delivery_status == 1){
 if (![[RequestUtility sharedRequestUtility].selectedAddressId isEqual:@"-1"]) {
      self.paybtn.enabled = YES;
      self.paybtn.backgroundColor =[UIColor colorWithRed:(80/255.f) green:(193/255.f) blue:(72/255.f) alpha:1.0f];
      
      self.addressLabel.hidden = NO;
      USerAddressData *data = (USerAddressData*)[RequestUtility sharedRequestUtility].selectedAddressDataObj;
      NSString *addString = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@\n%@",data.fullName,data.address1,data.address2,data.contactno,data.zipcode,data.state];
      NSLog(@"Address string == %@",addString);
      self.addressLabel.numberOfLines = 6;
      self.addressLabel.text = addString;
      self.addressConstraint.constant = 110;
     self.hAddressChangeConstraint.constant = 30;
   if ([RequestUtility sharedRequestUtility].backFromPaypalScreen == NO) {
     [self getDeliveryFee:[RequestUtility sharedRequestUtility].selectedAddressId];
   }
   
    }else{
      self.paybtn.enabled = NO;
      self.paybtn.backgroundColor = [UIColor grayColor];
      self.addressConstraint.constant = 0;
      self.hAddressChangeConstraint.constant = 0;
      self.addressLabel.hidden = YES;
    }
    self.addAdressBtnHeightConstraint.constant = 41;
  }else{
    self.paybtn.enabled = YES;
    self.paybtn.backgroundColor =[UIColor colorWithRed:(80/255.f) green:(193/255.f) blue:(72/255.f) alpha:1.0f];
    
    self.addressLabel.hidden = YES;
    USerAddressData *data = (USerAddressData*)[RequestUtility sharedRequestUtility].selectedAddressDataObj;
    NSString *addString = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@\n%@",data.fullName,data.address1,data.address2,data.contactno,data.zipcode,data.state];
    NSLog(@"Address string == %@",addString);
    self.addressLabel.numberOfLines = 6;
    self.addressLabel.text = addString;
    self.addressConstraint.constant = 0;
    self.hAddressChangeConstraint.constant = 0;
    self.addAddressBtn.hidden = YES;
    self.addAdressBtnHeightConstraint.constant = 0;
    
  }
  self.subTotalAmount.text = [NSString stringWithFormat:@"%@",subTotalPassed];
  self.salesTaxAmount.text = [NSString stringWithFormat:@"%@",salesTaxPassed];
    if([RequestUtility sharedRequestUtility].delivery_status == 0){
        self.deliveryFeeAmount.text = [NSString stringWithFormat:@"%@",deliveryFeePassed];
      self.hDeliveryFeeConstriant.constant = 0;
      self.deliveryFeeConstriant.constant = 0;

    }else{
      self.hDeliveryFeeConstriant.constant = 40;
      self.deliveryFeeConstriant.constant = 40;
      self.deliveryFeeAmount.text = [NSString stringWithFormat:@"%@",deliveryFeePassed];
    }
  
  
      self.hCouponAmountConstraint.constant=0;
      self.couponAmountConstraint.constant=0;
//  if (![[bfPaymentDictionary valueForKey:@"couponAmount"] isEqual:@"0"]) {
//    self.hCouponAmountConstraint.constant=40;
//    self.couponAmountConstraint.constant=40;
//  }else{
//    self.hCouponAmountConstraint.constant=0;
//    self.couponAmountConstraint.constant=0;
//  }

  self.totalAmount.text = [NSString stringWithFormat:@"%@",totalAmountPassed];
  [self setPayPalEnvironment:self.environment];
  appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

-(void)getDeliveryFee:(NSString*)AddID{
  
  
  NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
  [dict setValue:[bfPaymentDictionary valueForKey:@"restaurant_id"] forKey:@"restaurant_id"];
  [dict setValue:@"delivery_fee" forKey:@"action"];
  [dict setValue:AddID forKey:@"delivery_address_id"];
  appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  [appDelegate showLoadingViewWithString:@"Loading..."];
  RequestUtility *utility = [RequestUtility sharedRequestUtility];
  NSString *url = @"http://mailer.mobisofttech.co.in/ymoc_portal_dev_latest/android_api/delivery_fee.php";
  
  NSError * err;
  NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&err];
  NSString *String = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
  NSLog(@"getDeliveryFee info string \n = %@",String);
  
  [utility doYMOCStringPostRequest:url withParameters:String onComplete:^(bool status, NSDictionary *responseDictionary){
    if (status) {
      NSLog(@"\n\n response of getDeliveryFee \n\n :%@",responseDictionary);
      [appDelegate hideLoadingView];
      [self parseGetDeliveryFeeInfoResponse:responseDictionary];
    }else{
      [appDelegate hideLoadingView];
    }
  }];
}


-(void)parseGetDeliveryFeeInfoResponse:(NSDictionary*)ResponseDictionary{
  if (ResponseDictionary) {
    NSString *code = [ResponseDictionary valueForKey:@"code"];
    if ([code isEqualToString:@"1"]) {
      
      dispatch_async(dispatch_get_main_queue(), ^{
        appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate hideLoadingView];
        NSString *newfee = [ResponseDictionary valueForKey:@"data" ];
        if ([newfee isEqualToString:[deliveryFeePassed substringFromIndex:2]]) {
          
        }else{
        
          deliveryFeePassed = [NSString stringWithFormat:@"$ %@",newfee];
          float finalAmount;
          if([RequestUtility sharedRequestUtility].delivery_status == 1){
            finalAmount= [[subTotalPassed substringFromIndex:2] floatValue] + [[salesTaxPassed substringFromIndex:2] floatValue] + [[deliveryFeePassed substringFromIndex:2] floatValue];
          }else{
            finalAmount= [[subTotalPassed substringFromIndex:2] floatValue] + [[salesTaxPassed substringFromIndex:2] floatValue];
          }
          totalAmountPassed = [NSString stringWithFormat:@"$ %.02f",finalAmount];
          self.subTotalAmount.text = [NSString stringWithFormat:@"%@",subTotalPassed];
          self.salesTaxAmount.text = [NSString stringWithFormat:@"%@",salesTaxPassed];
          self.deliveryFeeAmount.text = [NSString stringWithFormat:@"%@",deliveryFeePassed];
          self.totalAmount.text = [NSString stringWithFormat:@"%@",totalAmountPassed];
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

- (BOOL)acceptCreditCards {
  return self.payPalConfig.acceptCreditCards;
}

- (void)setAcceptCreditCards:(BOOL)acceptCreditCards {
  self.payPalConfig.acceptCreditCards = acceptCreditCards;
}

- (void)setPayPalEnvironment:(NSString *)environment {
  self.environment = environment;
  [PayPalMobile preconnectWithEnvironment:environment];
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



-(void)sendAfterPaymentRequestToServer:(PayPalPayment *)completedPaymen{
  //{"action":"after_payment","user_id":"1","restaurant_id":"9","order_mode":"1","order_schedule_status":"0","order_schedule_date":"0000-00-00","order_schedule_time":"00:00:00","order_amount":"43.60","tax_percent":"15.0","tax_amount":"6.54","delivery_fee":"0","total_amount":"47.14","coupon_amount":"3","coupon_code":"382647","delivery_address_id":"1","transaction_id":"PAY-18X32451H0459092JKO7KFUI","total_quantity":"2"}
  
  NSMutableDictionary *afterPaymentDictionary = [[NSMutableDictionary alloc]init];
  [afterPaymentDictionary setValue:@"after_payment" forKey:@"action"];
  [afterPaymentDictionary setValue:[bfPaymentDictionary valueForKey:@"user_id"] forKey:@"user_id"];
  [afterPaymentDictionary setValue:[bfPaymentDictionary valueForKey:@"restaurant_id"] forKey:@"restaurant_id"];
  [afterPaymentDictionary setValue:[bfPaymentDictionary valueForKey:@"order_mode"] forKey:@"order_mode"];
  [afterPaymentDictionary setValue:[bfPaymentDictionary valueForKey:@"order_schedule_status"] forKey:@"order_schedule_status"];
  [afterPaymentDictionary setValue:[bfPaymentDictionary valueForKey:@"order_schedule_date"] forKey:@"order_schedule_date"];
  [afterPaymentDictionary setValue:[bfPaymentDictionary valueForKey:@"order_schedule_time"] forKey:@"order_schedule_time"];
  [afterPaymentDictionary setValue:[subTotalPassed substringFromIndex:2] forKey:@"order_amount"];
  [afterPaymentDictionary setValue:[ResponseUtility getSharedInstance].salesTaxValue forKey:@"tax_percent"];
  [afterPaymentDictionary setValue:[salesTaxPassed substringFromIndex:2] forKey:@"tax_amount"];
  [afterPaymentDictionary setValue:[deliveryFeePassed substringFromIndex:2] forKey:@"delivery_fee"];
  [afterPaymentDictionary setValue:[totalAmountPassed substringFromIndex:2] forKey:@"total_amount"];
  [afterPaymentDictionary setValue:@"0" forKey:@"coupon_amount"];
  [afterPaymentDictionary setValue:@"0" forKey:@"coupon_code"];
  [afterPaymentDictionary setValue:[RequestUtility sharedRequestUtility].selectedAddressId forKey:@"delivery_address_id"];
  [afterPaymentDictionary setValue:[[completedPaymen.confirmation valueForKey:@"response"]valueForKey:@"id"] forKey:@"transaction_id"];
  [afterPaymentDictionary setValue:@"1" forKey:@"total_quantity"];
  [self afterPayment:afterPaymentDictionary];
  
}
-(void)afterPayment:(NSDictionary*)dictionary{
  NSError * err;
  NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&err];
  NSString *String = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
  NSLog(@"after payment string \n = %@",String);
  [appDelegate showLoadingViewWithString:@"Loading..."];
  RequestUtility *utility = [RequestUtility sharedRequestUtility];
  NSString *url = @"http://ymoc.mobisofttech.co.in/android_api/after_payment.php";
  [utility doYMOCStringPostRequest:url withParameters:String onComplete:^(bool status, NSDictionary *responseDictionary){
    if (status) {
      dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"response:%@",responseDictionary);
        [appDelegate hideLoadingView];
        if (status==YES &&responseDictionary==nil) {
          [appDelegate hideLoadingView];
          int restID = [[bfPaymentDictionary valueForKey:@"restaurant_id"] intValue];
          [[DBManager getSharedInstance] deleteRecordAfterPayment:restID];
          NSString *msg = [RequestUtility sharedRequestUtility].afterPaymentResponseString;
//          UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//          [alert show];
//          
          [self showMsg:@"Payment Successful"];
//          NSString * storyboardName = @"Main";
//          UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
//          UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"FrontHomeScreenViewControllerId"];
//          UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
//          [navController setViewControllers: @[vc] animated: NO ];
//          [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
        }else{
          [self parseUserResponseBeforePayment:responseDictionary];
        }
      });
    }else{
      dispatch_async(dispatch_get_main_queue(), ^{
      [appDelegate hideLoadingView];
      });
    }
  }];
}

-(void)parseUserResponseBeforePayment:(NSDictionary*)ResponseDictionary{
  if (ResponseDictionary) {
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
      NSString *code = [ResponseDictionary valueForKey:@"code"];
      if ([code isEqualToString:@"1"]) {
        NSLog(@"payment successfull");
        [appDelegate hideLoadingView];
        int restID = [[bfPaymentDictionary valueForKey:@"restaurant_id"] intValue];
        [[DBManager getSharedInstance] deleteRecordAfterPayment:restID];
        [self showMsg:@"Payment Successful"];
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Payment successfull" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
//        
//        NSString * storyboardName = @"Main";
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
//        UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"FrontHomeScreenViewControllerId"];
//        UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
//        [navController setViewControllers: @[vc] animated: NO ];
//        [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
        
      }else{
        [appDelegate hideLoadingView];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Problem initiating users after payment" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
      }
    });
    
  }
}

#pragma mark PayPalPaymentDelegate methods

- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment {
  NSLog(@"PayPal Payment Success!");
  self.resultText = [completedPayment description];
  
  [self sendCompletedPaymentToServer:completedPayment]; // Payment was processed successfully; send to server for verification and fulfillment
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
  NSLog(@"PayPal Payment Canceled");
  self.resultText = nil;
  [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Proof of payment validation

- (void)sendCompletedPaymentToServer:(PayPalPayment *)completedPayment {
  // TODO: Send completedPayment.confirmation to server
  NSLog(@"Here is your proof of payment:\n\n%@\n\nSend this to your server for confirmation and fulfillment.", completedPayment.confirmation);
  [self sendAfterPaymentRequestToServer:completedPayment];
}


#pragma mark - Authorize Future Payments

- (IBAction)getUserAuthorizationForFuturePayments:(id)sender {
  
  PayPalFuturePaymentViewController *futurePaymentViewController = [[PayPalFuturePaymentViewController alloc] initWithConfiguration:self.payPalConfig delegate:self];
  [self presentViewController:futurePaymentViewController animated:YES completion:nil];
}


#pragma mark PayPalFuturePaymentDelegate methods

- (void)payPalFuturePaymentViewController:(PayPalFuturePaymentViewController *)futurePaymentViewController
                didAuthorizeFuturePayment:(NSDictionary *)futurePaymentAuthorization {
  NSLog(@"PayPal Future Payment Authorization Success!");
  self.resultText = [futurePaymentAuthorization description];
  
  [self sendFuturePaymentAuthorizationToServer:futurePaymentAuthorization];
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)payPalFuturePaymentDidCancel:(PayPalFuturePaymentViewController *)futurePaymentViewController {
  NSLog(@"PayPal Future Payment Authorization Canceled");
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendFuturePaymentAuthorizationToServer:(NSDictionary *)authorization {
  // TODO: Send authorization to server
  NSLog(@"Here is your authorization:\n\n%@\n\nSend this to your server to complete future payment setup.", authorization);
}


#pragma mark - Authorize Profile Sharing

- (IBAction)getUserAuthorizationForProfileSharing:(id)sender {
  
  NSSet *scopeValues = [NSSet setWithArray:@[kPayPalOAuth2ScopeOpenId, kPayPalOAuth2ScopeEmail, kPayPalOAuth2ScopeAddress, kPayPalOAuth2ScopePhone]];
  
  PayPalProfileSharingViewController *profileSharingPaymentViewController = [[PayPalProfileSharingViewController alloc] initWithScopeValues:scopeValues configuration:self.payPalConfig delegate:self];
  [self presentViewController:profileSharingPaymentViewController animated:YES completion:nil];
}


#pragma mark PayPalProfileSharingDelegate methods

- (void)payPalProfileSharingViewController:(PayPalProfileSharingViewController *)profileSharingViewController
             userDidLogInWithAuthorization:(NSDictionary *)profileSharingAuthorization {
  NSLog(@"PayPal Profile Sharing Authorization Success!");
  self.resultText = [profileSharingAuthorization description];
  
  [self sendProfileSharingAuthorizationToServer:profileSharingAuthorization];
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)userDidCancelPayPalProfileSharingViewController:(PayPalProfileSharingViewController *)profileSharingViewController {
  NSLog(@"PayPal Profile Sharing Authorization Canceled");
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendProfileSharingAuthorizationToServer:(NSDictionary *)authorization {
  // TODO: Send authorization to server
  NSLog(@"Here is your authorization:\n\n%@\n\nSend this to your server to complete profile sharing setup.", authorization);
}


- (IBAction)backNavigationClick:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)addAddressBtnClick:(id)sender {
  [self showMsg:@"Delivery Fee will be changed as per your delivery address"];
  
}
- (IBAction)payPalPaymentOptionBtnClick:(id)sender {
}

- (IBAction)payBtnClick:(id)sender {
  [RequestUtility sharedRequestUtility].backFromPaypalScreen = YES;
  // Remove our last completed payment, just for demo purposes.
  self.resultText = nil;
  
  // Note: For purposes of illustration, this example shows a payment that includes
  //       both payment details (subtotal, shipping, tax) and multiple items.
  //       You would only specify these if appropriate to your situation.
  //       Otherwise, you can leave payment.items and/or payment.paymentDetails nil,
  //       and simply set payment.amount to your total charge.
  
  // Optional: include multiple items
  //  PayPalItem *item1 = [PayPalItem itemWithName:@"Old jeans with holes"
  //                                  withQuantity:2
  //                                     withPrice:[NSDecimalNumber decimalNumberWithString:@"84.99"]
  //                                  withCurrency:@"USD"
  //                                       withSku:@"Hip-00037"];
  //  PayPalItem *item2 = [PayPalItem itemWithName:@"Free rainbow patch"
  //                                  withQuantity:1
  //                                     withPrice:[NSDecimalNumber decimalNumberWithString:@"0.00"]
  //                                  withCurrency:@"USD"
  //                                       withSku:@"Hip-00066"];
  //  PayPalItem *item3 = [PayPalItem itemWithName:@"Long-sleeve plaid shirt (mustache not included)"
  //                                  withQuantity:1
  //                                     withPrice:[NSDecimalNumber decimalNumberWithString:@"37.99"]
  //                                  withCurrency:@"USD"
  //                                       withSku:@"Hip-00291"];
  //  NSArray *items = @[item1, item2, item3];
  //  NSDecimalNumber *subtotal = [PayPalItem totalPriceForItems:items];
  //
  //  // Optional: include payment details
  //  NSDecimalNumber *shipping = [[NSDecimalNumber alloc] initWithString:@"5.99"];
  //  NSDecimalNumber *tax = [[NSDecimalNumber alloc] initWithString:@"2.50"];
  NSDecimalNumber *totalAmountPasseddecimal = [NSDecimalNumber decimalNumberWithString:[[totalAmountPassed componentsSeparatedByString:@" "] objectAtIndex:1]];
  NSDecimalNumber *subTotalPasseddecimal = [NSDecimalNumber decimalNumberWithString:[[subTotalPassed componentsSeparatedByString:@" "] objectAtIndex:1]];
  NSDecimalNumber *deliveryFeePasseddecimal = [NSDecimalNumber decimalNumberWithString:[[deliveryFeePassed componentsSeparatedByString:@" "] objectAtIndex:1]];
  NSDecimalNumber *salesTaxPasseddecimal = [NSDecimalNumber decimalNumberWithString:[[salesTaxPassed componentsSeparatedByString:@" "] objectAtIndex:1]];
  PayPalPaymentDetails *paymentDetails;
  if([RequestUtility sharedRequestUtility].delivery_status == 0){
    paymentDetails = [PayPalPaymentDetails paymentDetailsWithSubtotal:subTotalPasseddecimal
                                                                               withShipping:0
                                                                                    withTax:salesTaxPasseddecimal];
  
  }else{
    paymentDetails = [PayPalPaymentDetails paymentDetailsWithSubtotal:subTotalPasseddecimal
                                                                               withShipping:deliveryFeePasseddecimal
                                                                                    withTax:salesTaxPasseddecimal];
    
  }
  
  
  PayPalPayment *payment = [[PayPalPayment alloc] init];
  payment.amount = totalAmountPasseddecimal;
  payment.currencyCode = @"USD";
  payment.shortDescription = @"YMOC";
  payment.items = nil;  // if not including multiple items, then leave payment.items as nil
  payment.paymentDetails = paymentDetails; // if not including payment details, then leave payment.paymentDetails as nil
  
  if (!payment.processable) {
    // This particular payment will always be processable. If, for
    // example, the amount was negative or the shortDescription was
    // empty, this payment wouldn't be processable, and you'd want
    // to handle that here.
  }
  
  // Update payPalConfig re accepting credit cards.
  self.payPalConfig.acceptCreditCards = self.acceptCreditCards;
  
  PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment
                                                                                              configuration:self.payPalConfig
                                                                                                   delegate:self];
  [self presentViewController:paymentViewController animated:YES completion:nil];
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
  
  if ([msgStr isEqualToString:@"Delivery Fee will be changed as per your delivery address"]) {
    tag=1;
  }else{
    tag=0;
  }
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
  if (tag==1) {
    [RequestUtility sharedRequestUtility].isThroughPaymentScreen = YES;
    AddressListViewController *obj_clvc  = (AddressListViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"AddressListViewControllerId"];
    [self.navigationController pushViewController:obj_clvc animated:YES];
  }else{
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"FrontHomeScreenViewControllerId"];
    UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
    [navController setViewControllers: @[vc] animated: NO ];
    [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
  }
  
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
  blankScreen.hidden = YES;
  alertView.hidden = YES;
  [alertView removeFromSuperview];
}
@end
