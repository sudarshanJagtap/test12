//
//  VantivPaymentWebViewController.m
//  NikhilSwrevalslideMenu
//
//  Created by Sudarshan on 11/13/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import "VantivPaymentWebViewController.h"
#import "AppDelegate.h"
#import "DBManager.h"
#import "BillSummaryViewController.h"
#import "SWRevealViewController.h"
@interface VantivPaymentWebViewController ()<UIWebViewDelegate>{
  
  AppDelegate *appDelegate;
  UIView *blankScreen;
  UIView *alertView;
  UILabel *fromLabel;
  NSString *TransactionID;
}

@end

@implementation VantivPaymentWebViewController
@synthesize bfPaymentDictionary;
- (void)viewDidLoad {
  [super viewDidLoad];
  
  appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
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
  
  self.navigationController.navigationBarHidden = YES;
  NSURL *url = [NSURL URLWithString:self.urlStr];
  NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
  [self.vantivWebView loadRequest:urlRequest];
  [appDelegate showLoadingViewWithString:@"Loading..."];
}
- (IBAction)backNavBtnClick:(id)sender {
  [self.navigationController popToRootViewControllerAnimated:YES];
//  BillSummaryViewController *obj_clvc  = (BillSummaryViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"BillSummaryViewControllerId"];
//  [self.navigationController pushViewController:obj_clvc animated:YES];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
  
  NSString *urlString = [request URL].absoluteString;
  NSLog(@"current web string is ; /n %@",urlString);
  return YES;
  
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
  
  NSString *urlString = [webView.request URL].absoluteString;
  NSLog(@"webViewDidStartLoad web string is ; /n %@",urlString);
  
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
  [appDelegate hideLoadingView];
  NSString *urlString = [webView.request URL].absoluteString;
  NSLog(@"webViewDidFinishLoad web string is ; /n %@",urlString);
  if ([webView.request.URL.absoluteString hasPrefix:@"https://www.ymoc.com/android_api/ventiv/success.php?HostedPaymentStatus=Complete"]) {
    NSString *urlObtianed = [webView.request URL].absoluteString;
    NSArray *temp = [urlObtianed componentsSeparatedByString:@"&"];
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc]init];
    if (temp.count>0) {
      for (int i =0; i<temp.count; i++) {
        NSArray *innerTemp = [[temp objectAtIndex:i] componentsSeparatedByString:@"="];
        if (innerTemp.count>0) {
          [tempDict setValue:[innerTemp objectAtIndex:1] forKey:[innerTemp objectAtIndex:0]];
        }
      }
      NSLog(@"response dictionary is \n %@",tempDict);
      TransactionID = [tempDict valueForKey:@"TransactionID"];
      if (([[tempDict valueForKey:@"ExpressResponseCode"] isEqualToString:@"0"])&&([[tempDict valueForKey:@"ExpressResponseMessage"] isEqualToString:@"Approved"])) {
        NSString *msgStr = [NSString stringWithFormat:@"Payment Successful \nYour TransactionID=%@",TransactionID];
//        [self showMsg:@"Payment Successful"];
        [self showMsg:msgStr];
      }
    }
    
  }
  
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:( NSError *)error{
  NSString *urlString = [webView.request URL].absoluteString;
  NSLog(@"didFailLoadWithError web string is ; /n %@",urlString);
  NSLog(@"didFailLoadWithError error string is ; /n %@",error.description);
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


//appDelegate hideLoadingView];
//int restID = [[bfPaymentDictionary valueForKey:@"restaurant_id"] intValue];
//[[DBManager getSharedInstance] deleteRecordAfterPayment:restID];
//NSString *msg = [RequestUtility sharedRequestUtility].afterPaymentResponseString;
////          UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
////          [alert show];
////
//[self showMsg:@"Payment Successful"];



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

  int restID = [[bfPaymentDictionary valueForKey:@"restaurant_id"] intValue];
  [[DBManager getSharedInstance] deleteRecordAfterPayment:restID];
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

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
//  blankScreen.hidden = YES;
//  alertView.hidden = YES;
//  [alertView removeFromSuperview];
}

@end
