//
//  ResponseUtility.m
//  NikhilSwrevalslideMenu
//
//  Created by Sudarshan on 7/27/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import "ResponseUtility.h"

@implementation ResponseUtility

+(ResponseUtility*)getSharedInstance{
  __strong static ResponseUtility *sharedSessionState = nil;
  static dispatch_once_t onceToken1;
  dispatch_once(&onceToken1, ^{
    sharedSessionState = [[self alloc] init];
    
  });
  return sharedSessionState;
}

@end

@implementation CustomizationMenu

@end

@implementation UserFiltersResponse

@end

//@implementation AddToCart
//
//@end

@implementation USerSelectedCartData

@end

@implementation USerAddressData

@end

@implementation USerOrderHistory

@end

@implementation UserOrderTracking

@end

@implementation UserReviews

@end

@implementation ViewOrderDetails

@end

@implementation ViewOrderDetailsData

@end