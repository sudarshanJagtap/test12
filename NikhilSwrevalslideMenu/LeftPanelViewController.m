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
@interface LeftPanelViewController (){

  UIView *blankScreen;
  UIView *alertView;
  UILabel *fromLabel;
  int tag;
  RequestUtility *sharedReqUtlty;
}
@property (strong, nonatomic) NSArray *array;
@property (strong, nonatomic) NSArray *arrayImage;
@end

@implementation LeftPanelViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.bgImg.image = [UIImage imageNamed:@"about_us_background.png"];
  self.bgImg.alpha = 0.9;
  
  tag=0;
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
        [self showMsg:@"Sign Out Successfull"];
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
  
  //  if ([msgStr isEqualToString:@"Delivery Fee will be changed as per your delivery address"]) {
  //    tag=1;
  //  }else if ([msgStr isEqualToString:@"Please select payment type"]){
  //    tag =3;
  //  }
  //  else if([msgStr isEqualToString:@"Please check selected delivery address"]){
  //    tag =4;
  //  }
  //  else{
  //    tag=0;
  //  }
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

  
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
  //  blankScreen.hidden = YES;
  //  alertView.hidden = YES;
  //  [alertView removeFromSuperview];
}




@end
