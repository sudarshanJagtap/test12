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

@interface AddressAnnotation1 : NSObject<MKAnnotation> {
}
@property (nonatomic, retain) NSString *mPinColor;
@end

@implementation AddressAnnotation1

- (NSString *)pincolor{
  return self.mPinColor;
}

- (void) setpincolor:(NSString*) String1{
  self.mPinColor = String1;
}

@end
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
}

- (IBAction)backNavBtnClick:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

-(void)initViews
{
  self.mapView.delegate = self;
  self.mapView.showsUserLocation = YES;
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
  strCoordinate = [strCoordinate stringByReplacingOccurrencesOfString:@" " withString:@""];
  NSArray *components = [strCoordinate componentsSeparatedByString:@","];
  double latitude = [components[0] doubleValue];
  double longitude = [components[1] doubleValue];
  CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
  mapPin.title = title;
  mapPin.coordinate = coordinate;
  [self.mapView addAnnotation:mapPin];
}

#pragma mark annotation delegate
- (MKAnnotationView *) mapView:(MKMapView *)mapView1 viewForAnnotation:(id <MKAnnotation>) annotation{
  
  AddressAnnotation1 *annotationInst = (AddressAnnotation1*)annotation;
  
  MKAnnotationView *pinView = nil;
  if(annotation != self.mapView.userLocation)
  {
    static NSString *defaultPinID = @"pinId";
    pinView = (MKAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
    
    if ( pinView == nil ){
      pinView = [[MKAnnotationView alloc]
                  initWithAnnotation:annotation reuseIdentifier:defaultPinID];
    }
    pinView.canShowCallout = YES;
    if([annotationInst.title isEqualToString:@"User"]){
      pinView.image = [UIImage imageNamed:@"User Home Marker.png"];
    }
    else if([annotationInst.title isEqualToString:@"Restaurant"]){
      pinView.image = [UIImage imageNamed:@"Restaurant location Marker.png"];
    }
    else if([annotationInst.title isEqualToString:@"Delivery boy "]){
      pinView.image = [UIImage imageNamed:@"Delivery boy.png"];
    }
//    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//    pinView.rightCalloutAccessoryView = rightButton;
  }
  return pinView;    
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
  MKMapRect zoomRect = MKMapRectNull;
  for (id <MKAnnotation> annotation in self.mapView.annotations)
  {
    MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
    MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.05, 0.05);
    zoomRect = MKMapRectUnion(zoomRect, pointRect);
  }
  zoomRect.origin.x = zoomRect.origin.x-50;
    zoomRect.origin.y = zoomRect.origin.y-50;
  [self.mapView setVisibleMapRect:zoomRect animated:YES];
 
  [self.mapView showAnnotations:self.mapView.annotations animated:YES];
}

@end
