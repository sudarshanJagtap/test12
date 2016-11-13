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
//  MKPointAnnotation*    annotation = [[MKPointAnnotation alloc] init];
//  CLLocationCoordinate2D myCoordinate;
//  myCoordinate.latitude=40.338373;
//  myCoordinate.longitude=-74.594379;
//  annotation.coordinate = myCoordinate;
//  [self.mpView addAnnotation:annotation];
  
  
  CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(40.338373, -74.594379);
  
  MKCoordinateSpan span = MKCoordinateSpanMake(0.1, 0.1);
  MKCoordinateRegion region = {coord, span};
  
  MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
  [annotation setCoordinate:coord];
  
  [self.mpView setRegion:region];
  [self.mpView addAnnotation:annotation];

    // Do any additional setup after loading the view.
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
