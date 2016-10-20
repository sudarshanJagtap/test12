//
//  YourAccountViewController.m
//  NikhilSwrevalslideMenu
//
//  Created by Sudarshan on 8/16/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import "YourAccountViewController.h"
#import "RequestUtility.h"
#import "ResponseUtility.h"
#import "YourAccountTableViewCell.h"
#import "SWRevealViewController.h"
#import "AppDelegate.h"
#import "DBManager.h"
#import "ChangePasswordViewController.h"
#import "AppConstant.h"
@interface YourAccountViewController (){
  NSArray *lblArray;
  NSMutableArray *detailArray;
  AppDelegate *appDelegate;
  NSMutableDictionary *responsedict;
}

@end

@implementation YourAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  lblArray = [[NSArray alloc]initWithObjects:@"Name",@"Email",@"Password",@"Mobile",@"Address",@"", nil];
  detailArray = [[NSMutableArray alloc]initWithObjects:@"Name",@"Email",@"Password",@"Mobile",@"Address",@"", nil];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
  [self getUserDetails];
 self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
  self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
  return lblArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  YourAccountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YourAccountTableViewCell" forIndexPath:indexPath];
  cell.lbl.text= [lblArray objectAtIndex:indexPath.row];
  if (indexPath.row==2) {
    NSString *myPickerValue = [detailArray objectAtIndex:indexPath.row];
    cell.detailLbl.text = [@"" stringByPaddingToLength: [myPickerValue length] withString: @"*" startingAtIndex:0];
  }else{
    cell.detailLbl.text = [detailArray objectAtIndex:indexPath.row];
  }
  float screenWidth = [[UIScreen mainScreen] bounds].size.width;
  
  UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 1)];/// change size as you need.
  separatorLineView.backgroundColor = [UIColor colorWithRed:(196/255.f) green:(196/255.f) blue:(196/255.f) alpha:1.0f];
  [cell.contentView addSubview:separatorLineView];
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  if (indexPath.row==2) {
    ChangePasswordViewController *obj_clvc  = (ChangePasswordViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"ChangePasswordViewControllerId"];
    [self.navigationController pushViewController:obj_clvc animated:YES];
  }
  if (indexPath.row==4) {
    [RequestUtility sharedRequestUtility].isThroughLeftMenu = YES;
    NSString *storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"AddressListViewControllerId"];
    UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
    [navController setViewControllers: @[vc] animated: NO ];
    [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
  }
  
}


- (IBAction)backNavBtnClick:(id)sender {

    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"FrontHomeScreenViewControllerId"];
    UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
    [navController setViewControllers: @[vc] animated: NO ];
    [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];

}

-(void)getUserDetails{
  appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  [appDelegate showLoadingViewWithString:@"Loading..."];
  RequestUtility *utility = [RequestUtility sharedRequestUtility];
  NSDictionary *userdictionary = [[DBManager getSharedInstance]getALlUserData];
  NSString *userId=[userdictionary valueForKey:@"user_id"];
  NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
  [params setValue:userId forKey:@"user_id"];
  [params setValue:@"get_user_details" forKey:@"action"];
  NSError * err;
  NSData * jsonData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&err];
  NSString * myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
  [utility doYMOCStringPostRequest:kUser_profile withParameters:myString onComplete:^(bool status, NSDictionary *responseDictionary){
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
      if ([[ResponseDictionary valueForKey:@"code"] isEqualToString: @"1"]) {
        NSLog(@"login successfull");
        responsedict = [[NSMutableDictionary alloc]init];
        NSArray *array = [ResponseDictionary valueForKey:@"data"];
        for (int i = 0 ; i < [array count]; i++)
        {
         NSDictionary *dictionary = [array objectAtIndex:i];
          
          NSString *name =[dictionary valueForKey:@"full_name"];
          if (name.length>0) {
            [detailArray replaceObjectAtIndex:0 withObject:name];
          }
          
          NSString *email =[dictionary valueForKey:@"email"];
          if (email.length>0) {
            [detailArray replaceObjectAtIndex:1 withObject:email];
          }
          
          NSString *mobile =[dictionary valueForKey:@"mobile"];
          if (mobile == nil || mobile == (id)[NSNull null]) {
             [detailArray replaceObjectAtIndex:3 withObject:@""];
          }else{
            if (mobile.length>0) {
              [detailArray replaceObjectAtIndex:3 withObject:mobile];
            }
          }
         
          
          NSString *address1 =[dictionary valueForKey:@"address_line1"];
          NSString *address2 =[dictionary valueForKey:@"address_line2"];
          if (address1 == nil || address1 == (id)[NSNull null]) {
         [detailArray replaceObjectAtIndex:4 withObject:@"Add your address"];
          }else{
            if (address1.length>0) {
              NSString *fullAdress = [NSString stringWithFormat:@"%@ %@",address1,address2];
              [detailArray replaceObjectAtIndex:4 withObject:fullAdress];
            }
          }
          [self.tblVw reloadData];
          
          [responsedict setValue:[dictionary valueForKey:@"full_name"] forKey:@"full_name"];
          [responsedict setValue:[dictionary valueForKey:@"email"] forKey:@"email"];
          [responsedict setValue:[dictionary valueForKey:@"mobile"] forKey:@"mobile"];
          [responsedict setValue:[dictionary valueForKey:@"address_line1"] forKey:@"address_line1"];
          [responsedict setValue:[dictionary valueForKey:@"address_line2"] forKey:@"address_line2"];
          [responsedict setValue:[dictionary valueForKey:@"city"] forKey:@"city"];
          [responsedict setValue:[dictionary valueForKey:@"country"] forKey:@"country"];
          [responsedict setValue:[dictionary valueForKey:@"state"] forKey:@"state"];
          [responsedict setValue:[dictionary valueForKey:@"zipcode"] forKey:@"zipcode"];
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

@end
