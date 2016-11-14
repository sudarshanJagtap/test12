//
//  ViewOrderViewController.m
//  NikhilSwrevalslideMenu
//
//  Created by Sudarshan on 9/6/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import "ViewOrderViewController.h"
#import "DBManager.h"
#import "RequestUtility.h"
#import "ResponseUtility.h"
#import "AppDelegate.h"
#import "AppConstant.h"
@interface ViewOrderViewController ()<UITableViewDataSource,UITableViewDelegate>{
  AppDelegate *appDelegate;
  ViewOrderDetails *vwData;
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
  self.tableHeightConstraint.constant = 0;
  [self getAllOrderHistory:dict];
  
  if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ){
    
    NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"ViewOrderTableViewCell" owner:self options:nil];
    
    for (UIView *view in nibObjects) {
      
      if ([view isKindOfClass:[viewOrderCustomView class]]) {
        
        self.header = (viewOrderCustomView *)view;
        
        [self.view addSubview:self.header];
      }
    }
  }
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
      
      vwData = [[ViewOrderDetails alloc]init];
      vwData.viewOrderDetailsDataArray = [[NSMutableArray alloc]init];
      
      [ResponseUtility getSharedInstance].orderTrackingArray = [[NSMutableArray alloc]init];
      
      if ([[ResponseDictionary valueForKey:@"data"]isKindOfClass:[NSDictionary class]]) {
        vwData.coupon_amount = [[ResponseDictionary valueForKey:@"data"]valueForKey:@"coupon_amount"];
        vwData.delivery_fee = [[ResponseDictionary valueForKey:@"data"]valueForKey:@"delivery_fee"];
        vwData.order_amount = [[ResponseDictionary valueForKey:@"data"]valueForKey:@"order_amount"];
        vwData.tax_amount = [[ResponseDictionary valueForKey:@"data"]valueForKey:@"tax_amount"];
        vwData.total_amount = [[ResponseDictionary valueForKey:@"data"]valueForKey:@"total_amount"];
        vwData.transaction_id = [[ResponseDictionary valueForKey:@"data"]valueForKey:@"transaction_id"];
        
         vwData.order_mode = [[ResponseDictionary valueForKey:@"data"]valueForKey:@"order_mode"];
         vwData.order_schedule_date = [[ResponseDictionary valueForKey:@"data"]valueForKey:@"order_schedule_date"];
         vwData.order_schedule_status = [[ResponseDictionary valueForKey:@"data"]valueForKey:@"order_schedule_status"];
         vwData.order_schedule_time = [[ResponseDictionary valueForKey:@"data"]valueForKey:@"order_schedule_time"];
        NSArray *dataArray = [[ResponseDictionary valueForKey:@"data"]valueForKey:@"order_data"];
        
        for (int i =0; i<dataArray.count; i++) {
          NSDictionary *data = [dataArray objectAtIndex:i];
          ViewOrderDetailsData *vw = [[ViewOrderDetailsData alloc]init];
          vw.cart_id = [data valueForKey:@"cart_id"];
          vw.cust_string = [data valueForKey:@"cust_string"];
          vw.dish_price = [data valueForKey:@"dish_price"];
          vw.dish_total = [data valueForKey:@"dish_total"];
          vw.quantity = [data valueForKey:@"quantity"];
          vw.sub_category = [data valueForKey:@"sub_category"];
          [vwData.viewOrderDetailsDataArray addObject:vw];
        }
      }
      else if ([[ResponseDictionary valueForKey:@"data"] isKindOfClass:[NSArray class]]){
        vwData.coupon_amount = [[ResponseDictionary valueForKey:@"data"]valueForKey:@"coupon_amount"];
        vwData.delivery_fee = [[ResponseDictionary valueForKey:@"data"]valueForKey:@"delivery_fee"];
        vwData.order_amount = [[ResponseDictionary valueForKey:@"data"]valueForKey:@"order_amount"];
        vwData.tax_amount = [[ResponseDictionary valueForKey:@"data"]valueForKey:@"tax_amount"];
        vwData.total_amount = [[ResponseDictionary valueForKey:@"data"]valueForKey:@"total_amount"];
        vwData.transaction_id = [[ResponseDictionary valueForKey:@"data"]valueForKey:@"transaction_id"];
        
        vwData.order_mode = [[ResponseDictionary valueForKey:@"data"]valueForKey:@"order_mode"];
        vwData.order_schedule_date = [[ResponseDictionary valueForKey:@"data"]valueForKey:@"order_schedule_date"];
        vwData.order_schedule_status = [[ResponseDictionary valueForKey:@"data"]valueForKey:@"order_schedule_status"];
        vwData.order_schedule_time = [[ResponseDictionary valueForKey:@"data"]valueForKey:@"order_schedule_time"];
        
        NSArray *valuesAr = [[ResponseDictionary valueForKey:@"data"]valueForKey:@"data"];
        for (NSArray *respo in valuesAr){
          NSArray *dataArray = [respo valueForKey:@"order_data"];
          for (int i =0; i<dataArray.count; i++) {
            NSDictionary *data = [dataArray objectAtIndex:i];
            ViewOrderDetailsData *vw = [[ViewOrderDetailsData alloc]init];
            vw.cart_id = [data valueForKey:@"cart_id"];
            vw.cust_string = [data valueForKey:@"cust_string"];
            vw.dish_price = [data valueForKey:@"dish_price"];
            vw.dish_total = [data valueForKey:@"dish_total"];
            vw.quantity = [data valueForKey:@"quantity"];
            vw.sub_category = [data valueForKey:@"sub_category"];
            [vwData.viewOrderDetailsDataArray addObject:vw];
          }
        }
      }
      dispatch_async(dispatch_get_main_queue(), ^{
        appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate hideLoadingView];
        self.asubTotal.text = [NSString stringWithFormat:@"$ %@",vwData.order_amount];
        self.asalesTax.text = [NSString stringWithFormat:@"$ %@",vwData.tax_amount];
        NSString *delvieryStr = [NSString stringWithFormat:@"$ %@",vwData.delivery_fee];
        self.aTotal.text = [NSString stringWithFormat:@"$ %@",vwData.total_amount];
        NSString *couponLblStr =[NSString stringWithFormat:@"$ %@",vwData.coupon_amount];
        
     
        
        if (couponLblStr == nil || couponLblStr == (id)[NSNull null]) {
        
        }else{
          self.aCouponAmt.text = couponLblStr;
        }
        
        if (delvieryStr == nil || delvieryStr == (id)[NSNull null]) {
          
        }else{
          self.aDeliveryFee.text = delvieryStr;
        }
        int half=0,full=0;
        for (int i =0; i<vwData.viewOrderDetailsDataArray.count; i++) {
         NSString *custStringLblStr =[[vwData.viewOrderDetailsDataArray objectAtIndex:i] valueForKey:@"cust_string"];
          if (custStringLblStr == nil || custStringLblStr == (id)[NSNull null]) {
            half++;
          }else{
            full++;
          }
        }
        float halfhght = 35*half;
        float fullhght = 70*full;
        
        self.tableHeightConstraint.constant = halfhght+fullhght;
        
        float subtotalAmoutF = [vwData.order_amount floatValue];
        float asalesTaxF = [vwData.tax_amount floatValue];
        float totalAmoutF = [vwData.total_amount floatValue];
        float coupAmtF = [vwData.coupon_amount floatValue];
        
        float add = subtotalAmoutF+asalesTaxF+coupAmtF;
        BOOL oMode = [vwData.order_mode boolValue];
//        if (add == totalAmoutF) {
         if (!oMode) {
          self.deliveryFeeLabelheightConstraint.constant = 0;
          self.adeliveryHghtConstraint.constant = 0;
          self.aTotalTopcontraint.constant = 0;
          self.totalLblTopContraint.constant = 0;
        }
        BOOL oSstatus = [vwData.order_schedule_status boolValue];
        if (oSstatus) {
          NSString *oschDateTime = [NSString stringWithFormat:@"%@ %@",vwData.order_schedule_date,vwData.order_schedule_time];
          oschDateTime = [self getDisplayDate:oschDateTime];
          self.aOrderScheduleLbl.text = oschDateTime;
          self.orderScheduleLbl.hidden = NO;
          self.aOrderScheduleLbl.hidden = NO;
          self.aCpAmtTop.constant = 61;
          self.cpAmtTop.constant = 61;
        }else{
          self.aCpAmtTop.constant = 15;
          self.cpAmtTop.constant = 15;
          self.orderScheduleLbl.hidden = YES;
          self.aOrderScheduleLbl.hidden = YES;
        }
        [self.tableVw reloadData];
      });
    }
  }else{
    dispatch_async(dispatch_get_main_queue(), ^{
      appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
      [appDelegate hideLoadingView];
      [self.tableVw reloadData];
    });
  }
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return vwData.viewOrderDetailsDataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *cellIdentifier = @"ViewOrderTableViewCell";
  
  ViewOrderTableViewCell *cell = (ViewOrderTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  
  if(cell == nil) {
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ViewOrderTableViewCell" owner:self options:nil];
    cell = [nib objectAtIndex:0];
    
    NSString *subCatNameLblStr =[[vwData.viewOrderDetailsDataArray objectAtIndex:indexPath.row] valueForKey:@"sub_category"];
    NSString *custStringLblStr =[[vwData.viewOrderDetailsDataArray objectAtIndex:indexPath.row] valueForKey:@"cust_string"];
    NSString *quantityLblStr =[[vwData.viewOrderDetailsDataArray objectAtIndex:indexPath.row] valueForKey:@"quantity"];
    NSString *dishTotalLblStr =[[vwData.viewOrderDetailsDataArray objectAtIndex:indexPath.row] valueForKey:@"dish_total"];
    NSString *dishPriceLblStr =[[vwData.viewOrderDetailsDataArray objectAtIndex:indexPath.row] valueForKey:@"dish_price"];
    
    if (subCatNameLblStr == nil || subCatNameLblStr == (id)[NSNull null]) {
      cell.subCatNameLbl.text = @" ";
    } else {
      cell.subCatNameLbl.text = subCatNameLblStr;
    }
    
    if (custStringLblStr == nil || custStringLblStr == (id)[NSNull null]) {
      cell.custStringLbl.text = @" ";
      cell.custStrnghghtConstant.constant = 0;
    } else {
      cell.custStringLbl.text = custStringLblStr;
//      cell.custStrnghghtConstant.constant = 45;
    }
    if (dishPriceLblStr == nil || dishPriceLblStr == (id)[NSNull null]) {
      cell.dishPriceLbl.text = @" ";
    } else {
      cell.dishPriceLbl.text = dishPriceLblStr;
    }
    
    
    if (quantityLblStr == nil || quantityLblStr == (id)[NSNull null]) {
      cell.quantityLbl.text = @" ";
    } else {
      cell.quantityLbl.text= quantityLblStr;
    }
    
    if (dishTotalLblStr == nil || dishTotalLblStr == (id)[NSNull null]) {
      cell.dishTotalLbl.text = @" ";
    } else {
      cell.dishTotalLbl.text = dishTotalLblStr;
    }
  }
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   NSString *custStringLblStr =[[vwData.viewOrderDetailsDataArray objectAtIndex:indexPath.row] valueForKey:@"cust_string"];
  CGFloat retval = 0;
  if (custStringLblStr == nil || custStringLblStr == (id)[NSNull null]) {
    retval = 35;
  }else{
    retval = 70;
  }
  return retval;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}


@end
