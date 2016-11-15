//
//  AddressListViewController.m
//  NikhilSwrevalslideMenu
//
//  Created by Sudarshan on 7/31/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import "AddressListViewController.h"
#import "AddDeliveryAddressViewController.h"
#import "AddressListTableViewCell.h"
#import "RequestUtility.h"
#import "ResponseUtility.h"
#import "AppDelegate.h"
#import "DBManager.h"
#import "SWRevealViewController.h"
#import "BillSummaryViewController.h"
#import "AppConstant.h"

@interface AddressListViewController ()<UITableViewDataSource,UITableViewDelegate>{
  AppDelegate *appDelegate;
}

@end

@implementation AddressListViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
}


-(void)viewWillAppear:(BOOL)animated{
  NSDictionary *userdictionary = [[DBManager getSharedInstance]getALlUserData];
  NSString *userId=[userdictionary valueForKey:@"user_id"];
  NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
  [params setValue:userId forKey:@"user_id"];
  [params setValue:@"get_delivery_address" forKey:@"action"];
  [self getAllUserAddress:params];
}

-(void)getAllUserAddress:(NSDictionary *)params{
  
  appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  [appDelegate showLoadingViewWithString:@"Loading..."];
  RequestUtility *utility = [RequestUtility sharedRequestUtility];
  [utility doYMOCPostRequestfor:kDelivery_address withParameters:params onComplete:^(bool status, NSDictionary *responseDictionary){
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
     [ResponseUtility getSharedInstance].UserAddressArray = [[NSMutableArray alloc]init];
    NSString *code = [ResponseDictionary valueForKey:@"code"];
    if ([code isEqualToString:@"1"]) {
      [ResponseUtility getSharedInstance].UserAddressArray = [[NSMutableArray alloc]init];
      if ([[ResponseDictionary valueForKey:@"data"]isKindOfClass:[NSDictionary class]]) {
        USerAddressData *uData = [[USerAddressData alloc]init];
        uData.fullName = [ResponseDictionary valueForKey:@"full_name"];
        uData.address1 = [ResponseDictionary valueForKey:@"address_line1"];
        uData.address2 = [ResponseDictionary valueForKey:@"address_line2"];
        NSString *contactnum;
        if ([ResponseDictionary valueForKey:@"contact_no"] == nil || [ResponseDictionary valueForKey:@"contact_no"] == (id)[NSNull null]) {
          // nil branch
          contactnum = @" ";
        } else {
          // category name is set
          contactnum =[ResponseDictionary valueForKey:@"contact_no"];
        }
        uData.contactno = contactnum;
        uData.city = [ResponseDictionary valueForKey:@"city"];
        uData.zipcode = [ResponseDictionary valueForKey:@"zipcode"];
        uData.state = [ResponseDictionary valueForKey:@"state"];
        uData.country = [ResponseDictionary valueForKey:@"country"];
        uData.addID = [ResponseDictionary valueForKey:@"id"];
        
        [[ResponseUtility getSharedInstance].UserAddressArray addObject:uData];
      }
      else if ([[ResponseDictionary valueForKey:@"data"] isKindOfClass:[NSArray class]]){
        NSArray *valuesAr = [ResponseDictionary valueForKey:@"data"];
        for (NSArray *respo in valuesAr){
          USerAddressData *uData = [[USerAddressData alloc]init];
          uData.fullName = [respo valueForKey:@"full_name"];
          uData.address1 = [respo valueForKey:@"address_line1"];
          uData.address2 = [respo valueForKey:@"address_line2"];
          NSString *contactnum;
          if ([respo valueForKey:@"contact_no"] == nil || [respo valueForKey:@"contact_no"] == (id)[NSNull null]) {
            // nil branch
            contactnum = @" ";
          } else {
            // category name is set
            contactnum =[respo valueForKey:@"contact_no"];
          }
          uData.contactno = contactnum;
          uData.city = [respo valueForKey:@"city"];
          uData.zipcode = [respo valueForKey:@"zipcode"];
          uData.state = [respo valueForKey:@"state"];
          uData.country = [respo valueForKey:@"country"];
          uData.addID = [respo valueForKey:@"id"];
          [[ResponseUtility getSharedInstance].UserAddressArray addObject:uData];
        }
      }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
      appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
      [appDelegate hideLoadingView];
      [self.addressTableView reloadData];
    });
    
  }else{
    dispatch_async(dispatch_get_main_queue(), ^{
      appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
      [appDelegate hideLoadingView];
      [self.addressTableView reloadData];
    });
  }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return [[ResponseUtility getSharedInstance].UserAddressArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *cellIdentifier = @"AddressListTableViewCell";
  
  AddressListTableViewCell *cell = (AddressListTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  
  if(cell == nil) {
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AddressListTableViewCell" owner:self options:nil];
    cell = [nib objectAtIndex:0];
  }
  USerAddressData *data = (USerAddressData*)[[ResponseUtility getSharedInstance].UserAddressArray objectAtIndex:indexPath.row];
  cell.fullNameLbl.text = data.fullName;
  cell.address1Lbl.text = data.address1;
  cell.address2Lbl.text = data.address2;
  cell.contactNoLbl.text = data.contactno;
  cell.zipCodeLbl.text = data.zipcode;
  cell.stateLbl.text = data.state;
  cell.countryLbl.text = data.country;
  cell.cityLbl.text = data.city;
  
  [cell.fullNameLbl setFont: [cell.fullNameLbl.font fontWithSize: 15]];
  [cell.address1Lbl setFont: [cell.fullNameLbl.font fontWithSize: 15]];
  [cell.address2Lbl setFont: [cell.fullNameLbl.font fontWithSize: 15]];
  [cell.contactNoLbl setFont: [cell.fullNameLbl.font fontWithSize: 15]];
  [cell.zipCodeLbl setFont: [cell.fullNameLbl.font fontWithSize: 15]];
  [cell.stateLbl setFont: [cell.fullNameLbl.font fontWithSize: 15]];
  [cell.countryLbl setFont: [cell.fullNameLbl.font fontWithSize: 15]];
  [cell.cityLbl setFont: [cell.fullNameLbl.font fontWithSize: 15]];
  cell.editBtn.tag = indexPath.row;
  cell.deleteBtn.tag = indexPath.row;
  [cell.editBtn addTarget:self action:@selector(editBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
  [cell.deleteBtn addTarget:self action:@selector(deleteBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
  //  cell.backgroundColor = [UIColor grayColor];
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  return 204;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  [RequestUtility sharedRequestUtility].FromCartScreen = NO;
  AddDeliveryAddressViewController *obj_clvc  = (AddDeliveryAddressViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"AddDeliveryAddressViewControllerId"];
  USerAddressData *uData = (USerAddressData*)[[ResponseUtility getSharedInstance].UserAddressArray objectAtIndex:indexPath.row];
  obj_clvc.data = uData;
  if ([RequestUtility sharedRequestUtility].isThroughPaymentScreen) {
    [RequestUtility sharedRequestUtility].selectedAddressId =uData.addID;
    [RequestUtility sharedRequestUtility].selectedAddressDataObj =uData;
    [self.navigationController popViewControllerAnimated:YES];
  }else if ([RequestUtility sharedRequestUtility].isThroughLeftMenu){
    
  }else if ([RequestUtility sharedRequestUtility].isThroughGuestUser){
    [RequestUtility sharedRequestUtility].isThroughGuestUser= YES;
    [RequestUtility sharedRequestUtility].selectedAddressId =uData.addID;
    [RequestUtility sharedRequestUtility].selectedAddressDataObj =uData;
    BillSummaryViewController *obj_clvc  = (BillSummaryViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"BillSummaryViewControllerId"];
    
    //            obj_clvc.selectedUfrespo = ufpRespo;
    [self.navigationController pushViewController:obj_clvc animated:YES];
  }else{
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"FrontHomeScreenViewControllerId"];
    UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
    [navController setViewControllers: @[vc] animated: NO ];
    [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
    
//    AddDeliveryAddressViewController *obj_clvc  = (AddDeliveryAddressViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"AddDeliveryAddressViewControllerId"];
//    
//    USerAddressData *uData = (USerAddressData*)[[ResponseUtility getSharedInstance].UserAddressArray objectAtIndex:0];
//    obj_clvc.data = uData;
//    [RequestUtility sharedRequestUtility].selectedAddressId =uData.addID;
//    [RequestUtility sharedRequestUtility].selectedAddressDataObj =uData;
////    [self.navigationController popViewControllerAnimated:YES];
//    for (UIViewController *controller in self.navigationController.viewControllers) {
//      
//      //Do not forget to import AnOldViewController.h
//      if ([controller isKindOfClass:[BillSummaryViewController class]]) {
//        
//        [self.navigationController popToViewController:controller
//                                              animated:YES];
//        break;
//      }
//    }
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (IBAction)editBtnPressed:(id)sender {
  UIButton *btn = ((UIButton*)sender);
  NSLog(@"%ld",(long)btn.tag);
  AddDeliveryAddressViewController *obj_clvc  = (AddDeliveryAddressViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"AddDeliveryAddressViewControllerId"];
  USerAddressData *uData = (USerAddressData*)[[ResponseUtility getSharedInstance].UserAddressArray objectAtIndex:btn.tag];
  obj_clvc.data = uData;
    [self.navigationController pushViewController:obj_clvc animated:YES];
  
  
}


- (IBAction)deleteBtnPressed:(id)sender {
  UIButton *btn = ((UIButton*)sender);
  NSLog(@"%ld",(long)btn.tag);
  USerAddressData *uData = (USerAddressData*)[[ResponseUtility getSharedInstance].UserAddressArray objectAtIndex:btn.tag];
  [self deleteUserDetailswithID:uData.addID];

}



-(void)deleteUserDetailswithID:(NSString*)addId{
  NSDictionary *userdictionary = [[DBManager getSharedInstance]getALlUserData];
  NSString *userId=[userdictionary valueForKey:@"user_id"];
  appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  [appDelegate showLoadingViewWithString:@"Loading..."];
  RequestUtility *utility = [RequestUtility sharedRequestUtility];
  NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
  [params setValue:userId forKey:@"user_id"];
  [params setValue:@"delete_delivery_address" forKey:@"action"];
  [params setValue:addId forKey:@"delivery_address_id"];
  NSLog(@"%@",params);
  [utility doYMOCPostRequestfor:kDelivery_address withParameters:params onComplete:^(bool status, NSDictionary *responseDictionary){
    if (status) {
      NSLog(@"response:%@",responseDictionary);
      [self parseUserResponseforDeleteAddress:responseDictionary];
    }else{
      appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
      [appDelegate hideLoadingView];
    }
  }];
  
}

-(void)parseUserResponseforDeleteAddress:(NSDictionary*)ResponseDictionary{
  if (ResponseDictionary) {
    dispatch_async(dispatch_get_main_queue(), ^{
      NSString *code = [ResponseDictionary valueForKey:@"code"];
      //      if ([ResponseDictionary valueForKey:@"code"] == [NSNumber numberWithLong:1]) {
      if ([code isEqualToString:@"1"]) {
        NSLog(@"address add successfull");
        [appDelegate hideLoadingView];
        NSDictionary *userdictionary = [[DBManager getSharedInstance]getALlUserData];
        NSString *userId=[userdictionary valueForKey:@"user_id"];
        NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
        [params setValue:userId forKey:@"user_id"];
        [params setValue:@"get_delivery_address" forKey:@"action"];
        [self getAllUserAddress:params];
        
      }else{
        
        
        
        [appDelegate hideLoadingView];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:[ResponseDictionary valueForKey:@"msg"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
      }
    });
    
  }
}


- (IBAction)backNavBtnClick:(id)sender {
//  [self.navigationController popViewControllerAnimated:YES];
  
  if([RequestUtility sharedRequestUtility].isThroughLeftMenu){
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"FrontHomeScreenViewControllerId"];
    UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
    [navController setViewControllers: @[vc] animated: NO ];
    [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
  }else{
    
    [self.navigationController popViewControllerAnimated:YES];
//    AddDeliveryAddressViewController *obj_clvc  = (AddDeliveryAddressViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"AddDeliveryAddressViewControllerId"];
//
//    USerAddressData *uData = (USerAddressData*)[[ResponseUtility getSharedInstance].UserAddressArray objectAtIndex:0];
//    obj_clvc.data = uData;
//      [RequestUtility sharedRequestUtility].selectedAddressId =uData.addID;
//      [RequestUtility sharedRequestUtility].selectedAddressDataObj =uData;
////    [self.navigationController popViewControllerAnimated:YES];
//    for (UIViewController *controller in self.navigationController.viewControllers) {
//      
//      //Do not forget to import AnOldViewController.h
//      if ([controller isKindOfClass:[BillSummaryViewController class]]) {
//        
//        [self.navigationController popToViewController:controller
//                                              animated:YES];
//        break;
//      }
//    }
  }
}

- (IBAction)addAddressBtnClick:(id)sender {
  
  AddDeliveryAddressViewController *obj_clvc  = (AddDeliveryAddressViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"AddDeliveryAddressViewControllerId"];
  //  obj_clvc.data = selectedData;
  [self.navigationController pushViewController:obj_clvc animated:YES];
}
@end
