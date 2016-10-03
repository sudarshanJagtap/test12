//
//  AdditionalInfoViewController.m
//  NikhilSwrevalslideMenu
//
//  Created by Sudarshan on 9/26/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import "AdditionalInfoViewController.h"
#import "AppDelegate.h"
#import "RequestUtility.h"
@interface AdditionalInfoViewController (){
AppDelegate *appDelegate;
}
@end

@implementation AdditionalInfoViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
  [dict setValue:self.restID forKey:@"restaurant_id"];
  [dict setValue:@"additional_info" forKey:@"action"];
    [dict setValue:@"" forKey:@"order_schedule_date"];
    [dict setValue:@"" forKey:@"order_schedule_status"];
    [dict setValue:@"" forKey:@"order_schedule_time"];
  
  [self getAdditionalInfo:dict];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

-(void)getAdditionalInfo:(NSDictionary *)params{
  
  appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  [appDelegate showLoadingViewWithString:@"Loading..."];
  RequestUtility *utility = [RequestUtility sharedRequestUtility];
  NSString *url = @"http://ymoc.mobisofttech.co.in/android_api/additional_info.php";
  
  NSError * err;
  NSData * jsonData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&err];
  NSString *String = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
  NSLog(@"additional info string \n = %@",String);
  
  [utility doYMOCStringPostRequest:url withParameters:String onComplete:^(bool status, NSDictionary *responseDictionary){
    if (status) {
      NSLog(@"response:%@",responseDictionary);
      [appDelegate hideLoadingView];
      [self parseSearchDetailsInfoResponse:responseDictionary];
    }else{
      [appDelegate hideLoadingView];
    }
  }];
}


-(void)parseSearchDetailsInfoResponse:(NSDictionary*)ResponseDictionary{
  if (ResponseDictionary) {
    NSString *code = [ResponseDictionary valueForKey:@"code"];
    if ([code isEqualToString:@"1"]) {
    
    dispatch_async(dispatch_get_main_queue(), ^{
      appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
      [appDelegate hideLoadingView];
      NSString *timeStr = [[[ResponseDictionary valueForKey:@"data" ] valueForKey:@"opening_closing_time"] objectAtIndex:0];
      NSString *addressStr = [[[ResponseDictionary valueForKey:@"data" ]valueForKey:@"restaurant_address"] objectAtIndex:0];
      NSString *contactStr = [[[ResponseDictionary valueForKey:@"data" ] valueForKey:@"contact_number"] objectAtIndex:0];
      self.addressLbl.text = [NSString stringWithFormat:@" %@",addressStr];
      self.mobileLbl.text = [NSString stringWithFormat:@" Mobile: %@",contactStr];
      
      NSArray *TimeArray = [timeStr componentsSeparatedByString:@"~"];
      NSString *morn,*even;
      if (TimeArray.count>1) {
        morn = [TimeArray objectAtIndex:1];
        even = [TimeArray objectAtIndex:0];
        self.timingLbl.text = [NSString stringWithFormat:@" Morning : %@ \n Evening : %@",morn,even];
      }else{
        self.timingLbl.text = [NSString stringWithFormat:@" %@",timeStr];
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

- (IBAction)navBackBtnClk:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
