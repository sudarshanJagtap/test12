//
//  LeftPanelViewController.m
//  NikhilSwrevalslideMenu
//
//  Created by Sudarshan on 8/16/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import "LeftPanelViewController.h"
#import "LeftPanelTableViewCell.h"
#import "SignUpLoginViewController.h"
#import  "SWRevealViewController.h"
#import "AddressListViewController.h"
#import "OrderHistoryViewController.h"
#import "OrderTrackingViewController.h"
#import "RequestUtility.h"
#import "DBManager.h"
#import "AboutUsViewController.h"
#import "ContactUSViewController.h"
#import "ContactReactUsContainerViewController.h"
#import "AppConstant.h"
@interface LeftPanelViewController ()
@property (strong, nonatomic) NSArray *array;
@property (strong, nonatomic) NSArray *arrayImage;
@end

@implementation LeftPanelViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.bgImg.image = [UIImage imageNamed:@"about_us_background.png"];
  self.bgImg.alpha = 0.9;
  
  UIView* footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
  [footerView setBackgroundColor:[UIColor colorWithRed:(138.0/255.f) green:(203.0/255.f) blue:(49.0/255.f) alpha:1.0f]];
  
  
  UIButton *googleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  [googleBtn addTarget:self
             action:@selector(socialBtnClick:)
   forControlEvents:UIControlEventTouchUpInside];
  [googleBtn setBackgroundImage:[UIImage imageNamed:@"google_plus12.png"] forState:UIControlStateNormal];
  googleBtn.frame = CGRectMake(30.0, 10.0, 30, 30);
  googleBtn.tag=0;
  [footerView addSubview:googleBtn];
  
  UIButton *facebookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  [facebookBtn addTarget:self
             action:@selector(socialBtnClick:)
   forControlEvents:UIControlEventTouchUpInside];
  [facebookBtn setBackgroundImage:[UIImage imageNamed:@"fb.png"] forState:UIControlStateNormal];
  facebookBtn.frame = CGRectMake(70.0, 10.0, 30, 30);
  facebookBtn.tag=1;
  [footerView addSubview:facebookBtn];

  UIButton *twitterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  [twitterBtn addTarget:self
             action:@selector(socialBtnClick:)
   forControlEvents:UIControlEventTouchUpInside];
  [twitterBtn setBackgroundImage:[UIImage imageNamed:@"twitter1.png"] forState:UIControlStateNormal];
  twitterBtn.frame = CGRectMake(110.0, 10.0, 30, 30);
  twitterBtn.tag=2;
  [footerView addSubview:twitterBtn];


  UIButton *pinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  [pinBtn addTarget:self
             action:@selector(socialBtnClick:)
   forControlEvents:UIControlEventTouchUpInside];
  [pinBtn setBackgroundImage:[UIImage imageNamed:@"pininterest.png"] forState:UIControlStateNormal];
  pinBtn.frame = CGRectMake(150.0, 10.0, 30, 30);
  pinBtn.tag=3;
  [footerView addSubview:pinBtn];

  UIButton *instaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  [instaBtn addTarget:self
             action:@selector(socialBtnClick:)
   forControlEvents:UIControlEventTouchUpInside];
  [instaBtn setBackgroundImage:[UIImage imageNamed:@"instagram.png"] forState:UIControlStateNormal];
  instaBtn.frame = CGRectMake(190.0, 10.0, 30, 30);
  instaBtn.tag = 4;
  [footerView addSubview:instaBtn];
  
  footerView.layer.borderWidth = 2;
  footerView.layer.borderColor = [[UIColor whiteColor] CGColor];
  
  self.tableVw.tableFooterView = footerView;
  
}

-(IBAction)socialBtnClick:(id)sender{
  UIButton *btn = (UIButton*)sender;
   NSLog(@"Button click %ld",(long)btn.tag);
  NSString *urlStr;
  switch (btn.tag) {
    case 0:
      urlStr = kgooglePlusUrl;
      break;
    case 1:
      urlStr = kFacebookUrl;
      break;
    case 2:
      urlStr = kTwitterUrl;
      break;
    case 3:
      urlStr = kPintrestUrl;
      break;
      
    default:
      urlStr = kInstagramUrl;
      break;
  }
    NSURL *url = [NSURL URLWithString:urlStr];
  [[UIApplication sharedApplication] openURL:url];
 
}

-(void)viewWillAppear:(BOOL)animated{
  [self loadLeftPanel];
}


-(void)loadLeftPanel{
  NSDictionary *userdictionary = [[DBManager getSharedInstance]getALlUserData];
  NSString *userId=[userdictionary valueForKey:@"user_id"];
  NSString *userFullName=[userdictionary valueForKey:@"user_name"];
  if (userId.length>0) {self.loginLbl.text = [NSString stringWithFormat:@" %@",userFullName];}else{self.loginLbl.text=@" Login to your account";}
  if (userId.length>0) {
    self.array = @[@"Address Book",
                   @"Order History",
                   @"Order Tracking",
                   @"About Us",
                   @"Contact Us",
                   @"Sign Out"];
    
    self.arrayImage = @[@"address_book",
                        @"order_history",
                        @"order_track",
                        @"about",
                        @"hours",
                        @"sign_out",
                        @"shareapp",
                        @"about",
                        @"about"];
    [self.tableVw reloadData];
    
  }else{
    
    self.array = @[@"About Us",@"Contact Us"];
    
    self.arrayImage = @[@"about",@"hours"];
    [self.tableVw reloadData];
    
//    CGFloat height = self.tableVw.rowHeight;
//    height *= self.array.count;
//    
//    CGRect tableFrame = self.tableVw.frame;
//    tableFrame.size.height = height;
//    self.tableVw.frame = tableFrame;
  }
  self.tableVw.backgroundColor = [UIColor clearColor];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

//#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  //#warning Incomplete implementation, return the number of sections
  return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 55;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  //#warning Incomplete implementation, return the number of rows
  
  return [self.array count];;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *cellIdentifier = @"LeftPanelTableViewCell";
  
  LeftPanelTableViewCell *cell = (LeftPanelTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  
  if(cell == nil) {
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"LeftPanelTableViewCell" owner:self options:nil];
    cell = [nib objectAtIndex:0];
  }
  cell.txtlbl.text = [self.array objectAtIndex:indexPath.row];
  cell.imgVw.image = [UIImage imageNamed:[self.arrayImage objectAtIndex:indexPath.row]];
  
  // Configure the cell...
  cell.backgroundColor = [UIColor whiteColor];
  // Configure the cell...
  float screenWidth = [[UIScreen mainScreen] bounds].size.width;
  
  UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 0.5)];/// change size as you need.
  separatorLineView.backgroundColor = [UIColor lightGrayColor];
  [cell.contentView addSubview:separatorLineView];
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
  NSDictionary *userdictionary = [[DBManager getSharedInstance]getALlUserData];
  NSString *userId=[userdictionary valueForKey:@"user_id"];
  if (userId.length>0) {
    NSString *storyboardName = @"Main";
    if (indexPath.row==0) {
      [RequestUtility sharedRequestUtility].isThroughLeftMenu = YES;
      UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
      UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"AddressListViewControllerId"];
      UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
      [navController setViewControllers: @[vc] animated: NO ];
      [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
    }
    if (indexPath.row==1) {
      [RequestUtility sharedRequestUtility].isThroughLeftMenu = YES;
      UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
      UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"OrderHistoryViewControllerId"];
      UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
      [navController setViewControllers: @[vc] animated: NO ];
      [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
    }
    if (indexPath.row==2) {
      
      [RequestUtility sharedRequestUtility].isThroughLeftMenu = YES;
      UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
      UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"OrderTrackingViewControllerId"];
      UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
      [navController setViewControllers: @[vc] animated: NO ];
      [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
      
    }
    if (indexPath.row==3) {
      [RequestUtility sharedRequestUtility].isThroughLeftMenu = YES;
      UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
      UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"AboutUsViewControllerId"];
      UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
      [navController setViewControllers: @[vc] animated: NO ];
      [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
    }
    if (indexPath.row==4) {
//      [RequestUtility sharedRequestUtility].isThroughLeftMenu = YES;
//      UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
//      UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"ContactUSViewControllerId"];
//      UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
//      [navController setViewControllers: @[vc] animated: NO ];
//      [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
      [RequestUtility sharedRequestUtility].isThroughLeftMenu = YES;
      UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
      UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"ContactReactUsContainerViewControllerId"];
      UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
      [navController setViewControllers: @[vc] animated: NO ];
      [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
      
    }
    
    if (indexPath.row==5) {
      
      BOOL retval = NO;
      retval = [DBManager getSharedInstance].deleteUserData;
      if (retval) {
        [self loadLeftPanel];
      }
    }
    
    
  }else{
     NSString *storyboardName = @"Main";
    if (indexPath.row==0) {
      [RequestUtility sharedRequestUtility].isThroughLeftMenu = YES;
      UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
      UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"AboutUsViewControllerId"];
      UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
      [navController setViewControllers: @[vc] animated: NO ];
      [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
    }else{
//      [RequestUtility sharedRequestUtility].isThroughLeftMenu = YES;
//      UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
//      UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"ContactUSViewControllerId"];
//      UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
//      [navController setViewControllers: @[vc] animated: NO ];
//      [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
      
      [RequestUtility sharedRequestUtility].isThroughLeftMenu = YES;
      UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
      UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"ContactReactUsContainerViewControllerId"];
      UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
      [navController setViewControllers: @[vc] animated: NO ];
      [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
    
    }
  }
  
}

- (IBAction)LoginBtnClick:(id)sender {
  
  NSDictionary *userdictionary = [[DBManager getSharedInstance]getALlUserData];
  NSString *userId=[userdictionary valueForKey:@"user_id"];
  if (userId.length>0) {
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"YourAccountViewControllerId"];
    UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
    [navController setViewControllers: @[vc] animated: NO ];
    [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
    
  }else{
    NSLog(@"Login Clicked");
    [RequestUtility sharedRequestUtility].isThroughLeftMenu = YES;
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"SignUpLoginViewControllerId"];
    UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
    [navController setViewControllers: @[vc] animated: NO ];
    [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
  }
}




@end
