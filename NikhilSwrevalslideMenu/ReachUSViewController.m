//
//  ReachUSViewController.m
//  NikhilSwrevalslideMenu
//
//  Created by Sudarshan on 11/13/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import "ReachUSViewController.h"

@interface ReachUSViewController ()

@end

@implementation ReachUSViewController

- (void)viewDidLoad {
    [super viewDidLoad];

  CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(40.338373, -74.594379);  
  MKCoordinateSpan span = MKCoordinateSpanMake(0.1, 0.1);
  MKCoordinateRegion region = {coord, span};
  MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
  [annotation setCoordinate:coord];
  [self.mpView setRegion:region];
  [self.mpView addAnnotation:annotation];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
