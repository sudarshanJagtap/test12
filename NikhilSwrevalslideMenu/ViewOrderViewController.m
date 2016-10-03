//
//  ViewOrderViewController.m
//  NikhilSwrevalslideMenu
//
//  Created by Sudarshan on 9/6/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import "ViewOrderViewController.h"
#import "ViewOrderTableViewCell.h"
#import "DBManager.h"
#import "RequestUtility.h"
#import "ResponseUtility.h"
#import "AppDelegate.h"
@interface ViewOrderViewController ()<UITableViewDataSource,UITableViewDelegate>{
  AppDelegate *appDelegate;
}

@end

@implementation ViewOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  NSDictionary *userdictionary = [[DBManager getSharedInstance]getALlUserData];
  NSString *userId=[userdictionary valueForKey:@"user_id"];
  NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
  [dict setValue:userId forKey:@"user_id"];
  [dict setValue:self.orderID forKey:@"order_id"];
  [dict setValue:@"view_order" forKey:@"action"];
  [self getAllOrderHistory:dict];
}

- (IBAction)backNavBtnClick:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

-(void)getAllOrderHistory:(NSDictionary *)params{
  
  appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  [appDelegate showLoadingViewWithString:@"Loading..."];
  RequestUtility *utility = [RequestUtility sharedRequestUtility];
  NSString *url = @"http://ymoc.mobisofttech.co.in/android_api/user_order_details.php";
  
  NSError * err;
  NSData * jsonData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&err];
  NSString *String = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
  NSLog(@"order hsitory string \n = %@",String);
  
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
      [ResponseUtility getSharedInstance].orderTrackingArray = [[NSMutableArray alloc]init];
      if ([[ResponseDictionary valueForKey:@"data"]isKindOfClass:[NSDictionary class]]) {
        UserOrderTracking *oData = [[UserOrderTracking alloc]init];
        oData.restaurant_name = [ResponseDictionary valueForKey:@"restaurant_name"];
        oData.order_id = [ResponseDictionary valueForKey:@"order_id"];
        oData.total_amount = [ResponseDictionary valueForKey:@"total_amount"];
        oData.order_status = [ResponseDictionary valueForKey:@"order_status"];
        oData.order_date = [ResponseDictionary valueForKey:@"order_date"];
        oData.delivery_date = [ResponseDictionary valueForKey:@"delivery_date"];
        [[ResponseUtility getSharedInstance].orderTrackingArray addObject:oData];
      }
      else if ([[ResponseDictionary valueForKey:@"data"] isKindOfClass:[NSArray class]]){
        NSArray *valuesAr = [ResponseDictionary valueForKey:@"data"];
        for (NSArray *respo in valuesAr){
          UserOrderTracking *oData = [[UserOrderTracking alloc]init];
          oData.restaurant_name = [respo valueForKey:@"restaurant_name"];
          oData.order_id = [respo valueForKey:@"order_id"];
          oData.total_amount = [respo valueForKey:@"total_amount"];
          oData.order_status = [respo valueForKey:@"order_status"];
          oData.order_date = [respo valueForKey:@"order_date"];
          oData.delivery_date = [respo valueForKey:@"delivery_date"];
          [[ResponseUtility getSharedInstance].orderTrackingArray addObject:oData];
        }
      }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
      appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
      [appDelegate hideLoadingView];
      [self.tableVw reloadData];
    });
    
  }else{
    dispatch_async(dispatch_get_main_queue(), ^{
      appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
      [appDelegate hideLoadingView];
      [self.tableVw reloadData];
    });
  }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *cellIdentifier = @"ViewOrderTableViewCell";
  
  ViewOrderTableViewCell *cell = (ViewOrderTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  
  if(cell == nil) {
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ViewOrderTableViewCell" owner:self options:nil];
    cell = [nib objectAtIndex:0];
    
  }
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  return 104;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}


@end
