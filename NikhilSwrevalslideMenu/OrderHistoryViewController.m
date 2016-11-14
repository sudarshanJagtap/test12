//
//  OrderHistoryViewController.m
//  NikhilSwrevalslideMenu
//
//  Created by Sudarshan on 9/2/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import "OrderHistoryViewController.h"
#import "RequestUtility.h"
#import "ResponseUtility.h"
#import "AppDelegate.h"
#import "DBManager.h"
#import "SWRevealViewController.h"
#import "OrderHistoryTableViewCell.h"
#import "ViewOrderViewController.h"
#import "AddReviewsViewController.h"
#import "AppConstant.h"
@interface OrderHistoryViewController ()<UITableViewDataSource,UITableViewDelegate>{
  AppDelegate *appDelegate;
  NSString *userId;
}

@end

@implementation OrderHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

-(void)viewWillAppear:(BOOL)animated{

  [ResponseUtility getSharedInstance].UserOrderArray = [[NSMutableArray alloc]init];
  NSDictionary *userdictionary = [[DBManager getSharedInstance]getALlUserData];
  userId=[userdictionary valueForKey:@"user_id"];
  NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
  [dict setValue:userId forKey:@"user_id"];
  [dict setValue:@"order_history" forKey:@"action"];
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
      [ResponseUtility getSharedInstance].UserOrderArray = [[NSMutableArray alloc]init];
      if ([[ResponseDictionary valueForKey:@"data"]isKindOfClass:[NSDictionary class]]) {
        USerOrderHistory *oData = [[USerOrderHistory alloc]init];
        oData.restaurant_id = [ResponseDictionary valueForKey:@"restaurant_id"];
        oData.restaurant_name = [ResponseDictionary valueForKey:@"restaurant_name"];
        oData.order_id = [ResponseDictionary valueForKey:@"order_id"];
        oData.total_amount = [ResponseDictionary valueForKey:@"total_amount"];
        oData.order_status = [ResponseDictionary valueForKey:@"order_status"];
        oData.order_date = [ResponseDictionary valueForKey:@"order_date"];
        oData.delivery_date = [ResponseDictionary valueForKey:@"delivery_date"];
        oData.review_status = [ResponseDictionary valueForKey:@"review_status"];        
        [[ResponseUtility getSharedInstance].UserOrderArray addObject:oData];
      }
      else if ([[ResponseDictionary valueForKey:@"data"] isKindOfClass:[NSArray class]]){
        NSArray *valuesAr = [ResponseDictionary valueForKey:@"data"];
        for (NSArray *respo in valuesAr){
          USerOrderHistory *oData = [[USerOrderHistory alloc]init];
          oData.restaurant_id = [respo valueForKey:@"restaurant_id"];
          oData.restaurant_name = [respo valueForKey:@"restaurant_name"];
          oData.order_id = [respo valueForKey:@"order_id"];
          oData.total_amount = [respo valueForKey:@"total_amount"];
          oData.order_status = [respo valueForKey:@"order_status"];
          oData.order_date = [respo valueForKey:@"order_date"];
          oData.delivery_date = [respo valueForKey:@"delivery_date"];
          oData.review_status = [respo valueForKey:@"review_status"];
          [[ResponseUtility getSharedInstance].UserOrderArray addObject:oData];
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
  return [[ResponseUtility getSharedInstance].UserOrderArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *cellIdentifier = @"OrderHistoryTableViewCell";
  OrderHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (cell == nil) {
    // Load the top-level objects from the custom cell XIB.
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"OrderHistoryTableViewCell" owner:self options:nil];
    // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
    cell = [topLevelObjects objectAtIndex:0];
  }
  
  
//  OrderHistoryTableViewCell *cell = (OrderHistoryTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//  if(cell == nil) {
//    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"OrderHistoryTableViewCell" owner:self options:nil];
//    cell = [nib objectAtIndex:0];
    USerOrderHistory *oData = (USerOrderHistory*)[[ResponseUtility getSharedInstance].UserOrderArray objectAtIndex:indexPath.row];
    UIColor *redClr = [UIColor colorWithRed:188.0/255.0 green:67.0/255.0 blue:67.0/255.0 alpha:1.0];
    cell.nameLbl.text = [NSString stringWithFormat:@"%@",oData.restaurant_name];
    cell.orderIdLbl.text= [NSString stringWithFormat:@"Order ID: %@",oData.order_id ];
    cell.totalAmtLbl.text= [NSString stringWithFormat:@"Total Amount: %@",oData.total_amount];
  NSString *odatee = [self getDisplayDate:oData.order_date];
  cell.orderDateLbl.text= [NSString stringWithFormat:@"Order Date: %@",odatee];
//    cell.orderDateLbl.text= [NSString stringWithFormat:@"Order Date: %@",oData.order_date];
  NSString *ddatee = [self getDisplayDate:oData.delivery_date];
  cell.deliveryDateLbl.text= [NSString stringWithFormat:@"Order Date: %@",ddatee];
//    cell.deliveryDateLbl.text= [NSString stringWithFormat:@"Delivery Date: %@",oData.delivery_date];
    cell.isDeliverdLbl.text= [NSString stringWithFormat:@"%@",oData.order_status];
    cell.isDeliverdLbl.layer.masksToBounds = YES;
    cell.isDeliverdLbl.layer.cornerRadius =8.0;
    cell.orderDetailsBtn.tag = indexPath.row;
  cell.orderDetails1.tag = indexPath.row;
  cell.review1.tag = indexPath.row;
    [cell.orderDetailsBtn addTarget:self action:@selector(viewOrder:) forControlEvents:UIControlEventTouchUpInside];
    [cell.orderDetails1 addTarget:self action:@selector(viewOrder:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.review1 addTarget:self action:@selector(addreviews:) forControlEvents:UIControlEventTouchUpInside];
    [[cell.orderDetailsBtn layer] setBorderWidth:2.0f];
    [cell.orderDetailsBtn layer].cornerRadius = 12.0;
    [[cell.orderDetailsBtn layer] setBorderColor:redClr.CGColor];

    [[cell.review1 layer] setBorderWidth:2.0f];
    [cell.review1 layer].cornerRadius = 12.0;
    [[cell.review1 layer] setBorderColor:redClr.CGColor];
    
    [[cell.orderDetails1 layer] setBorderWidth:2.0f];
    [cell.orderDetails1 layer].cornerRadius = 12.0;
    [[cell.orderDetails1 layer] setBorderColor:redClr.CGColor];
    
  if ([oData.order_status isEqualToString:@"Delivered"]) {
    cell.deliveryDateLbl.hidden = NO;
    cell.OrderDetailsBtnTopconstraint.constant = 3;
  }else{
  cell.deliveryDateLbl.hidden = YES;
    cell.OrderDetailsBtnTopconstraint.constant = -10;
  }
  

  if ([oData.order_status isEqualToString:@"Delivered"]) {
    
    NSString *rst = oData.review_status;
    if ([rst isEqual:@"0"]) {
      cell.orderDetailsBtn.hidden = YES;
      cell.orderDetails1.hidden = NO;
      cell.review1.hidden = NO;
    }else{
      cell.orderDetailsBtn.hidden = NO;
      cell.orderDetails1.hidden = YES;
      cell.review1.hidden = YES;
    }
  }else{
    cell.orderDetailsBtn.hidden = NO;
    cell.orderDetails1.hidden = YES;
    cell.review1.hidden = YES;
  }
//  }
  return cell;
}

-(NSString*)getDisplayDate:(NSString*)myString{
  //NSString *myString = @"2012-11-22 10:19:04";
  NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
  dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
  NSDate *yourDate = [dateFormatter dateFromString:myString];
  dateFormatter.dateFormat = @"MMMM dd yyyy HH:mm:ss a";
  NSLog(@"%@",[dateFormatter stringFromDate:yourDate]);
  return [dateFormatter stringFromDate:yourDate];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  CGFloat retval = 175;
  USerOrderHistory *oData = (USerOrderHistory*)[[ResponseUtility getSharedInstance].UserOrderArray objectAtIndex:indexPath.row];
  if ([oData.order_status isEqualToString:@"Delivered"]) {
    retval = 175;
  }else{
    retval = 175;
  }
  return retval;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}

-(IBAction)viewOrder:(id)sender{
  UIButton *btn = (UIButton*)sender;
  NSLog(@"%ld",(long)btn.tag);
  ViewOrderViewController *obj_clvc  = (ViewOrderViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"ViewOrderViewControllerId"];
  USerOrderHistory *oData = (USerOrderHistory*)[[ResponseUtility getSharedInstance].UserOrderArray objectAtIndex:btn.tag];
  obj_clvc.orderID =oData.order_id;
  [self.navigationController pushViewController:obj_clvc animated:YES];
}


-(IBAction)addreviews:(id)sender{
  UIButton *btn = (UIButton*)sender;
  NSLog(@"%ld",(long)btn.tag);
  AddReviewsViewController *obj_clvc  = (AddReviewsViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"AddReviewsViewControllerId"];
  USerOrderHistory *oData = (USerOrderHistory*)[[ResponseUtility getSharedInstance].UserOrderArray objectAtIndex:btn.tag];
  obj_clvc.userId = userId;
  obj_clvc.uData = oData;
  [self.navigationController pushViewController:obj_clvc animated:YES];
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
