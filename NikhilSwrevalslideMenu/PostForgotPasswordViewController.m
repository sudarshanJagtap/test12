//
//  PostForgotPasswordViewController.m
//  NikhilSwrevalslideMenu
//
//  Created by Sudarshan on 10/8/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import "PostForgotPasswordViewController.h"
#import "YourAccountViewController.h"
#import "SWRevealViewController.h"
@interface PostForgotPasswordViewController ()

@end

@implementation PostForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
  
  self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
  self.navigationController.navigationBarHidden = YES;
}

- (IBAction)backNavBtnclick:(id)sender {
//  NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
//  for (UIViewController *aViewController in allViewControllers) {
//    if ([aViewController isKindOfClass:[YourAccountViewController class]]) {
//      [self.navigationController popToViewController:aViewController animated:NO];
//    }
//  }
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

@end
