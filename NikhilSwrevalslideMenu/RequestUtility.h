//
//  RequestUtility.h
//  NikhilSwrevalslideMenu
//
//  Created by Sudarshan on 7/27/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResponseUtility.h"
@interface RequestUtility : NSObject<NSURLSessionDelegate,NSURLSessionDataDelegate,NSURLSessionTaskDelegate>

@property(nonatomic,strong)NSMutableArray *selectedCusinesArray;
@property(nonatomic,strong)NSMutableArray *selectedFeaturesArray;
@property(nonatomic,assign)int ratings;
@property(nonatomic,assign)int delivery_status;
@property(nonatomic,strong)NSString *address;
@property(nonatomic,strong)NSString *sorting;
@property(nonatomic,strong)NSString *action1;
@property(nonatomic,strong)NSString *search;
@property(nonatomic,strong)NSString *min_order_amount;
@property(nonatomic,strong)NSString *schedule_date;
@property(nonatomic,strong)NSString *schedule_time;
@property(nonatomic,assign)BOOL isThroughLeftMenu;
@property(nonatomic,strong)NSString *asapSchedule_date;
@property(nonatomic,strong)NSString *asapSchedule_time;
@property(nonatomic,strong)NSString *asapDisplayLbl;
@property(nonatomic,assign)BOOL isAsap;
@property(nonatomic,strong)NSString *selectedOrderType;
@property(nonatomic,assign)BOOL isThroughPaymentScreen;
@property(nonatomic,strong)NSString *selectedAddressId;
@property(nonatomic,strong)NSString *afterPaymentResponseString;
@property(nonatomic,strong)USerAddressData *selectedAddressDataObj;

+ (RequestUtility *)sharedRequestUtility;

-(NSDictionary*)getParamsForUserFilters;

-(NSDictionary*)getParamsForAsapUserFilters;

-(NSString*)getFeaturNamefromSelectedTag:(int)SelectedTag;

-(NSString*)getMinimumOrderAmountfromRating:(int)rating;

-(NSString*)getSortingKeyfromIndex:(int)index;

-(NSString*)getDisplayFeature:(NSString*)key;

-(void)doGetRequestfor:(NSString*)url withParameters:(NSDictionary*)params onComplete:(void (^)(bool status, NSDictionary  *response))completionBlock;

-(void)doPostRequestfor:(NSString*)url withParameters:(NSDictionary*)params onComplete:(void (^)(bool status, NSDictionary  *response))completionBlock;

-(void)doYMOCPostRequestfor:(NSString*)url withParameters:(NSDictionary*)params onComplete:(void (^)(bool status, NSDictionary  *response))completionBlock;

-(void)doYMOCStringPostRequest:(NSString*)url withParameters:(NSString*)params onComplete:(void (^)(bool status, NSDictionary  *response))completionBlock;

-(NSString*)getCurrentDate;
-(NSString*)getCurrentTime;

@end

@interface customization : NSObject
@property(nonatomic,strong)NSString *cart_id;
@property(nonatomic,strong)NSString *cust_id;
@property(nonatomic,strong)NSString *cust_option;
@property(nonatomic,strong)NSString *cust_price;

@end

@interface cart_data : NSObject
@property(nonatomic,strong)NSString *AND_cart_id;
@property(nonatomic,strong)NSString *cart_id;
@property(nonatomic,strong)NSString *rest_id;
@property(nonatomic,strong)NSString *sub_cat_id;
@property(nonatomic,strong)NSString *quantity;
@property(nonatomic,strong)NSString *instruction;
@property(nonatomic,strong)NSMutableArray *customizatinObjArray;

@end

@interface AddtoCartData : NSObject
@property(nonatomic,strong)NSString *user_id;
@property(nonatomic,strong)NSString *app_status;
@property(nonatomic,strong)NSString *ip_address;
@property(nonatomic,strong)NSString *order_mode;
@property(nonatomic,strong)NSString *order_schedule_status;
@property(nonatomic,strong)NSString *order_schedule_date;
@property(nonatomic,strong)NSString *order_schedule_time;
@property(nonatomic,strong)NSMutableArray *cartDataObjArray;

@end

@interface AllRestoCartData : NSObject
@property(nonatomic,strong)NSString *rest_id;
@property(nonatomic,strong)NSString *rest_name;
@property(nonatomic,strong)NSString *orderCount;
@property(nonatomic,strong)NSString *orderType;


@end


