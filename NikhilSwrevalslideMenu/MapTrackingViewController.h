//
//  MapTrackingViewController.h
//  NikhilSwrevalslideMenu
//
//  Created by Sudarshan on 11/5/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface MapTrackingViewController : UIViewController<MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property(nonatomic,strong)NSString *order_id;

@end