//
//  AboutUsViewController.m
//  NikhilSwrevalslideMenu
//
//  Created by Sudarshan on 9/2/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import "AboutUsViewController.h"
#import "SWRevealViewController.h"
#import "PrivacyOpreationController.h"
@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  self.navigationController.navigationBar.hidden = YES;
    self.textViewContent.userInteractionEnabled=NO;
  NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
  NSString *temp = [NSString stringWithFormat:@"%@ %@ %@",@"You are on version",version,@"on Ymoc app.\n"];
  NSString *abtcontent = @"YMOC.COM is aimed to be one of the widely covered online meal ordering portals. The company is based in Cranbury, NJ. The portal aims to attract the online community to order meals for individuals, groups or corporates. Whatever the ocassion is YMOC.COM has everything that we call it a SUCCESS! The portal and it's team will work with the clients to design the meal plan for the meals to make it a successful dinning experience. The arrangements may be for Corporate Breakfasts, Lunch, Dinner, Birthday Party, Wedding or anything you just name it. The team is always there to sit and design with you for your dinning experience a success and pleasurable.";
  NSString *finalStr = [NSString stringWithFormat:@"%@%@",temp,abtcontent];
  self.textViewContent.text = finalStr
  ;
}

- (IBAction)backNavBtnClick:(id)sender {
  NSString * storyboardName = @"Main";
  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
  UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"FrontHomeScreenViewControllerId"];
  UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
  [navController setViewControllers: @[vc] animated: NO ];
  [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)privacyAction:(id)sender
{
    
       
    
}

- (IBAction)leaderShipAction:(id)sender {
}

- (IBAction)investOppturnity:(id)sender
{
  /*  UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Message" message:@"coming Soon...." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [alertView show];*/
    
    
    
    
    
}
@end
