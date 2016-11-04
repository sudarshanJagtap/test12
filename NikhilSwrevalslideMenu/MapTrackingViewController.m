//
//  MapTrackingViewController.m
//  NikhilSwrevalslideMenu
//
//  Created by Sudarshan on 11/5/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import "MapTrackingViewController.h"
#import "AppDelegate.h"
#import "AppConstant.h"
#import "RequestUtility.h"
@interface MapTrackingViewController (){
  
  AppDelegate *appDelegate;
  NSString *user_latitude;
  NSString *user_longitude;
  NSString *restaurant_latitude;
  NSString *restaurant_longitude;
  
  NSString *clatitude;
  NSString *clongitude;
  
}

@end

@implementation MapTrackingViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self initViews];
  [self Getgps_src_dst_location];

  //  [self initConstraints];
}

- (IBAction)backNavBtnClick:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

-(void)initViews
{
  //  self.mapView = [[MKMapView alloc] init];
  self.mapView.delegate = self;
  self.mapView.showsUserLocation = YES;
  
  MKCoordinateRegion region = self.mapView.region;
  
  region.center = CLLocationCoordinate2DMake(12.9752297537231, 80.2313079833984);
  
  region.span.longitudeDelta /= 1.0; // Bigger the value, closer the map view
  region.span.latitudeDelta /= 1.0;
  [self.mapView setRegion:region animated:NO]; // Choose if you want animate or not
  
  //  [self.view addSubview:self.mapView];
}

-(void)initConstraints
{
  self.mapView.translatesAutoresizingMaskIntoConstraints = NO;
  
  id views = @{
               @"mapView": self.mapView
               };
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[mapView]|" options:0 metrics:nil views:views]];
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[mapView]|" options:0 metrics:nil views:views]];
}

-(void)addPinWithTitle:(NSString *)title AndCoordinate:(NSString *)strCoordinate
{
  MKPointAnnotation *mapPin = [[MKPointAnnotation alloc] init];
  
  // clear out any white space
  strCoordinate = [strCoordinate stringByReplacingOccurrencesOfString:@" " withString:@""];
  
  // convert string into actual latitude and longitude values
  NSArray *components = [strCoordinate componentsSeparatedByString:@","];
  
  double latitude = [components[0] doubleValue];
  double longitude = [components[1] doubleValue];
  
  // setup the map pin with all data and add to map view
  CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
  
  mapPin.title = title;
  mapPin.coordinate = coordinate;
  
  [self.mapView addAnnotation:mapPin];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


-(void)Getgps_src_dst_location{
  appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  [appDelegate showLoadingViewWithString:@"Loading..."];
  RequestUtility *utility = [RequestUtility sharedRequestUtility];
  NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
  [params setValue:self.order_id forKey:@"order_id"];
  [params setValue:@"source_destination" forKey:@"action"];
  NSError * err;
  NSData * jsonData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&err];
  NSString *String = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
  NSLog(@"kgps_src_dst_location info string \n = %@",String);
  
  [utility doYMOCStringPostRequest:kgps_src_dst_location withParameters:String onComplete:^(bool status, NSDictionary *responseDictionary){
    if (status) {
      NSLog(@"response:%@",responseDictionary);
      [appDelegate hideLoadingView];
      dispatch_async(dispatch_get_main_queue(), ^{
//          [self Getgps_current_location];
        [appDelegate hideLoadingView];
        [self parse_GPRS_SRC_Location:responseDictionary];
      });
    }else{
      [appDelegate hideLoadingView];
    }
  }];
}

-(void)parse_GPRS_SRC_Location:(NSDictionary*)ResponseDictionary{

  if (ResponseDictionary) {
    NSString *code = [ResponseDictionary valueForKey:@"code"];
    if ([code isEqualToString:@"1"]) {
    
      user_latitude = [[ResponseDictionary valueForKey:@"data"]valueForKey:@"user_latitude"];
      user_longitude = [[ResponseDictionary valueForKey:@"data"]valueForKey:@"user_longitude"];
      restaurant_latitude = [[ResponseDictionary valueForKey:@"data"]valueForKey:@"restaurant_latitude"];
      restaurant_longitude = [[ResponseDictionary valueForKey:@"data"]valueForKey:@"restaurant_longitude"];
               [self addAllPins];
    }
  }
}

-(void)Getgps_current_location{
  appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  [appDelegate showLoadingViewWithString:@"Loading..."];
  RequestUtility *utility = [RequestUtility sharedRequestUtility];
  NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
  [params setValue:self.order_id forKey:@"order_id"];
  [params setValue:@"current_location" forKey:@"action"];
  NSError * err;
  NSData * jsonData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&err];
  NSString *String = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
  NSLog(@"kgps_current_location info string \n = %@",String);
  
  [utility doYMOCStringPostRequest:kgps_current_location withParameters:String onComplete:^(bool status, NSDictionary *responseDictionary){
    if (status) {
      NSLog(@"response:%@",responseDictionary);
      [appDelegate hideLoadingView];
      dispatch_async(dispatch_get_main_queue(), ^{
        [self parse_GPRS_Current_Location:responseDictionary];
      });
    }else{
      [appDelegate hideLoadingView];
    }
  }];
}

-(void)parse_GPRS_Current_Location:(NSDictionary*)ResponseDictionary{
  if (ResponseDictionary) {
    NSString *code = [ResponseDictionary valueForKey:@"code"];
    if ([code isEqualToString:@"1"]) {
      clatitude = [[ResponseDictionary valueForKey:@"data"]valueForKey:@"latitude"];
      clongitude = [[ResponseDictionary valueForKey:@"data"]valueForKey:@"longitude"];
      [self addAllPins];
    }
  }
}


-(void)addAllPins
{
  self.mapView.delegate=self;
  
  NSArray *name=[[NSArray alloc]initWithObjects:
                 @"Restaurant",
                 @"User", nil];
  
  NSMutableArray *arrCoordinateStr = [[NSMutableArray alloc] initWithCapacity:name.count];
  
  NSString *userLoc = [NSString stringWithFormat:@"%@,%@",user_latitude,user_longitude];
    NSString *restLoc = [NSString stringWithFormat:@"%@,%@",restaurant_latitude,restaurant_longitude];
  
  [arrCoordinateStr addObject:userLoc];
  [arrCoordinateStr addObject:restLoc];
  
  for(int i = 0; i < name.count; i++)
  {
    [self addPinWithTitle:name[i] AndCoordinate:arrCoordinateStr[i]];
  }
  
}

  
//  [self zoomToFitMapAnnotations:self.mapView];
//}
//
//  - (void)zoomToFitMapAnnotations:(MKMapView *)mapView {
//    if ([mapView.annotations count] == 0) return;
//    
//    CLLocationCoordinate2D topLeftCoord;
////    topLeftCoord.latitude = -90;
////    topLeftCoord.longitude = 180;
////    CLLocationCoordinate2D bottomRightCoord;
////    bottomRightCoord.latitude = 90;
////    bottomRightCoord.longitude = -180;
//    topLeftCoord.latitude = [user_latitude doubleValue];
//    topLeftCoord.longitude = [user_longitude doubleValue];
//    CLLocationCoordinate2D bottomRightCoord;
//    bottomRightCoord.latitude = [restaurant_latitude doubleValue];
//    bottomRightCoord.longitude = [restaurant_longitude doubleValue];
//    
//    for(id<MKAnnotation> annotation in mapView.annotations) {
//      topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
//      topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
//      bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
//      bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
//    }
//    
//    MKCoordinateRegion region;
//    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
//    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
//    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1;
//    
//    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1;
//    
//    region = [mapView regionThatFits:region];
//    [mapView setRegion:region animated:YES];
//  }

@end
