//
//  OrderTrackingViewController.m
//  NikhilSwrevalslideMenu
//
//  Created by Sudarshan on 9/2/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import "OrderTrackingViewController.h"
#import "RequestUtility.h"
#import "ResponseUtility.h"
#import "AppDelegate.h"
#import "DBManager.h"
#import "SWRevealViewController.h"
#import "OrderTrackingTableViewCell.h"
#import "AppConstant.h"
@interface OrderTrackingViewController ()<UITableViewDataSource,UITableViewDelegate>{
  AppDelegate *appDelegate;
}

@end

@implementation OrderTrackingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  NSDictionary *userdictionary = [[DBManager getSharedInstance]getALlUserData];
  NSString *userId=[userdictionary valueForKey:@"user_id"];
  NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
  [dict setValue:userId forKey:@"user_id"];
  [dict setValue:@"track_order" forKey:@"action"];
  [self getAllOrderHistory:dict];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

-(void)getAllOrderHistory:(NSDictionary *)params{
  
  appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  [appDelegate showLoadingViewWithString:@"Loading..."];
  RequestUtility *utility = [RequestUtility sharedRequestUtility];  
  NSError * err;
  NSData * jsonData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&err];
  NSString *String = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
  NSLog(@"order hsitory string \n = %@",String);
  
  [utility doYMOCStringPostRequest:kUser_order_details withParameters:String onComplete:^(bool status, NSDictionary *responseDictionary){
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
  return [[ResponseUtility getSharedInstance].orderTrackingArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *cellIdentifier = @"OrderTrackingTableViewCell";
  
  OrderTrackingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (cell == nil) {
    // Load the top-level objects from the custom cell XIB.
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"OrderTrackingTableViewCell" owner:self options:nil];
    // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
    cell = [topLevelObjects objectAtIndex:0];
  }
  
  
//  OrderTrackingTableViewCell *cell = (OrderTrackingTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//  
//  if(cell == nil) {
//    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"OrderTrackingTableViewCell" owner:self options:nil];
//    cell = [nib objectAtIndex:0];
    UserOrderTracking *oData = (UserOrderTracking*)[[ResponseUtility getSharedInstance].orderTrackingArray objectAtIndex:indexPath.row];
    
    cell.nameLbl.text = [NSString stringWithFormat:@"%@",oData.restaurant_name];
    cell.orderIdLbl.text= [NSString stringWithFormat:@"Order ID: %@",oData.order_id ];
    cell.totalAmtLbl.text= [NSString stringWithFormat:@"Total Amount: %@",oData.total_amount];
    cell.orderDateLbl.text= [NSString stringWithFormat:@"Order Date: %@",oData.order_date];
    cell.deliveryDateLbl.text= [NSString stringWithFormat:@"Delivery Date: %@",oData.delivery_date];
    cell.isDeliverdLbl.text= [NSString stringWithFormat:@"%@",oData.order_status];
    cell.isDeliverdLbl.layer.masksToBounds = YES;
    cell.isDeliverdLbl.layer.cornerRadius =8.0;
    
    [[cell.orderDetailsBtn layer] setBorderWidth:2.0f];
    [[cell.orderDetailsBtn layer] setBorderColor:[UIColor redColor].CGColor];
//  }
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  return 143;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}

- (IBAction)navBackBtnClick:(id)sender {
  NSString * storyboardName = @"Main";
  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
  UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"FrontHomeScreenViewControllerId"];
  UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
  [navController setViewControllers: @[vc] animated: NO ];
  [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
}
@end
