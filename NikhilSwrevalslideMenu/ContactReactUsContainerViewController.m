//
//  ContactReactUsContainerViewController.m
//  NikhilSwrevalslideMenu
//
//  Created by Sudarshan on 11/13/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import "ContactReactUsContainerViewController.h"
#import "SWRevealViewController.h"
@interface ContactReactUsContainerViewController ()
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) UIViewController *currentViewController;
@end

@implementation ContactReactUsContainerViewController

- (void)viewDidLoad {
  self.currentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ContactUSViewControllerId"];
//  self.currentViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
  [self addChildViewController:self.currentViewController];
  [self addSubview:self.currentViewController.view toView:self.containerView];
  [super viewDidLoad];
}

- (IBAction)showComponent:(UISegmentedControl *)sender {
  if (sender.selectedSegmentIndex == 0) {
    UIViewController *newViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ContactUSViewControllerId"];
//    newViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self cycleFromViewController:self.currentViewController toViewController:newViewController];
    self.currentViewController = newViewController;
  } else {
    UIViewController *newViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ReachUSViewControllerId"];
//    newViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self cycleFromViewController:self.currentViewController toViewController:newViewController];
    self.currentViewController = newViewController;
  }
}

- (void)cycleFromViewController:(UIViewController*) oldViewController
               toViewController:(UIViewController*) newViewController {
  [oldViewController willMoveToParentViewController:nil];
  [self addChildViewController:newViewController];
  [self addSubview:newViewController.view toView:self.containerView];
  newViewController.view.alpha = 0;
//  [newViewController.view layoutIfNeeded];
  
  [UIView animateWithDuration:0.5
                   animations:^{
                     newViewController.view.alpha = 1;
                     oldViewController.view.alpha = 0;
                   }
                   completion:^(BOOL finished) {
                     [oldViewController.view removeFromSuperview];
                     [oldViewController removeFromParentViewController];
                     [newViewController didMoveToParentViewController:self];
                   }];
}

- (void)addSubview:(UIView *)subView toView:(UIView*)parentView {
  [parentView addSubview:subView];
  
//  NSDictionary * views = @{@"subView" : subView,};
//  NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[subView]|"
//                                                                 options:0
//                                                                 metrics:0
//                                                                   views:views];
//  [parentView addConstraints:constraints];
//  constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[subView]|"
//                                                        options:0
//                                                        metrics:0
//                                                          views:views];
//  [parentView addConstraints:constraints];
}
- (IBAction)navBackBtnClk:(id)sender {

  NSString * storyboardName = @"Main";
  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
  UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"FrontHomeScreenViewControllerId"];
  UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
  [navController setViewControllers: @[vc] animated: NO ];
  [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
}

@end
