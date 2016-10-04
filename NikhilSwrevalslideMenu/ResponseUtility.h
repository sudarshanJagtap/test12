//
//  ResponseUtility.h
//  NikhilSwrevalslideMenu
//
//  Created by Sudarshan on 7/27/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResponseUtility : NSObject
+(ResponseUtility*)getSharedInstance;
@property (nonatomic, strong) NSMutableArray *UserFiltersResponseArray;
@property (nonatomic, strong) NSMutableArray *CustomizeMenuArray;
@property (nonatomic, strong) NSMutableArray *UserAddressArray;
@property (nonatomic, strong) NSMutableArray *UserOrderArray;
@property (nonatomic, strong) NSMutableArray *orderTrackingArray;
@property (nonatomic, strong) NSMutableArray *UserRatingsArray;
@property(nonatomic,strong)NSString *enteredAddress;
@property(nonatomic,strong)NSString *selectedReastuarantId;
@property(nonatomic,strong)NSString *salesTaxValue;
@end

@interface CustomizationMenu : NSObject
@property(nonatomic,strong)NSString *status;
@property(nonatomic,strong)NSString *data;
@property(nonatomic,strong)NSString *c_id;
@property(nonatomic,strong)NSString *restaurant_id;
@property(nonatomic,strong)NSString *category;
@property(nonatomic,strong)NSString *sub_category;
@property(nonatomic,assign)float price;
@property(nonatomic,strong)NSString *cust_description;
@property(nonatomic,strong)NSString *cust_id;
@property(nonatomic,strong)NSString *cust_option;
@property(nonatomic,assign)float cust_price;
@end

@interface UserFiltersResponse : NSObject

@property(nonatomic,strong)NSString *address_search;//" = "151,milk,Boston ,,MA 02109,";
@property(nonatomic,strong)NSString *closing_time;// = "23:58:00";
@property(nonatomic,strong)NSString *cuisine_string;//" =
@property(nonatomic,strong)NSString *day;// = fri;
@property(nonatomic,strong)NSString *delivery_facility;//" = 2;
@property(nonatomic,strong)NSString *delivery_time;//" = "30-35";
@property(nonatomic,strong)NSString *end_dist;//" = 2;
@property(nonatomic,strong)NSString *fee;// = 10;
@property(nonatomic,strong)NSString *ufp_id;// = 15;
@property(nonatomic,strong)NSString *logo;// = "smoke_pizza_123_1796.jpg";
@property(nonatomic,strong)NSString *min_order_amount;//" = 5;
@property(nonatomic,strong)NSString *name;// = lenwich123;
@property(nonatomic,strong)NSString *opening_status;//" = 1;
@property(nonatomic,strong)NSString *opening_time;//" = "00:00:00";
@property(nonatomic,strong)NSString *rating;// = 3;
@property(nonatomic,strong)NSString *restaurant_status;//" = 1;
@property(nonatomic,strong)NSString *start_dist;//" = 0;
@property(nonatomic,strong)NSString *pkDistance;
@property(nonatomic,strong)NSString *imageStr;

@end

//@interface AddToCart : NSObject
//
//@property(nonatomic,strong)NSString *address_search;//"
//@property(nonatomic,strong)NSString *cuisine_string;//" =
//@property(nonatomic,strong)NSString *delivery_facility;//" = 2;
//@property(nonatomic,assign)NSInteger reastuarant_id;// = 15;
//@property(nonatomic,assign)NSInteger unique_id;
//@property(nonatomic,strong)NSString *sub_category_id;// = 15;
//@property(nonatomic,strong)NSString *reastuarant_name;// = lenwich123;
//@property(nonatomic,strong)NSString *category_Name;
//@property(nonatomic,strong)NSString *sub_category_Name;
//@property(nonatomic,strong)NSString *cust_id;
//@property(nonatomic,strong)NSString *cust_option;
//@property(nonatomic,strong)NSString *cust_price;
//@property(nonatomic,strong)NSString *ccdescription;
//@property(nonatomic,strong)NSString *cuisineID;
//@property(nonatomic,assign)float Price;//" = 5
//@property(nonatomic,assign)float min_order_amount;//" = 5
//@property(nonatomic,assign)float delivery_fee;//" = 2;
//@property(nonatomic,strong)NSString *customizeCuisineString;
//@property(nonatomic,strong)NSString *customizeCuisinePrice;
//@property(nonatomic,strong)NSString *quantity;
//@property(nonatomic,strong)NSString *customizedCuisineId;
//@property(nonatomic,assign)float totalFinalPrice;
//@end

@interface USerSelectedCartData : NSObject;
@property(nonatomic,assign)NSInteger unique_id;
@property(nonatomic,assign)NSInteger restaurant_Id;
@property(nonatomic,assign)NSInteger subCategory_Id;
@property(nonatomic,strong)NSString *reasturant_Name;
@property(nonatomic,strong)NSString *category_Name;
@property(nonatomic,strong)NSString *sub_category_Name;
@property(nonatomic,strong)NSString *cust_id;
@property(nonatomic,strong)NSString *cust_option;
@property(nonatomic,strong)NSString *cust_price;
@property(nonatomic,strong)NSString *cust_description;
@property(nonatomic,assign)float subCategoryPrice;
@property(nonatomic,assign)float MIN_ORDER;
@property(nonatomic,assign)float delivery_fee;
@property(nonatomic,strong)NSString *customizeCuisineString;
@property(nonatomic,strong)NSString *customizeCuisinePrice;
@property(nonatomic,strong)NSString *customizedCuisineId;
@property(nonatomic,strong)NSString *quantity;
@property(nonatomic,assign)float TotalFinalPrice;
@property(nonatomic,strong)NSString *status;
@property(nonatomic,strong)NSString *ordertype;
@property(nonatomic,strong)NSString *userEnteredAddress;
@property(nonatomic,strong)NSString *rest_Address;
@property(nonatomic,strong)NSString *instructions;
@property(nonatomic,strong)NSString *obtainedCartID;
@property(nonatomic,strong)NSString *order_schedule_date;
@property(nonatomic,strong)NSString *order_schedule_status;
@property(nonatomic,strong)NSString *order_schedule_time;
@property(nonatomic,strong)NSString *serverCartID;
@property(nonatomic,strong)NSString *randomCartID;
@property(nonatomic,strong)NSString *Logo;
@end


@interface USerAddressData : NSObject;

@property(nonatomic,strong)NSString *fullName;
@property(nonatomic,strong)NSString *address1;
@property(nonatomic,strong)NSString *address2;
@property(nonatomic,strong)NSString *city;
@property(nonatomic,strong)NSString *state;
@property(nonatomic,strong)NSString *country;
@property(nonatomic,strong)NSString *zipcode;
@property(nonatomic,strong)NSString *contactno;
@property(nonatomic,strong)NSString *addID;
@end


@interface USerOrderHistory : NSObject;
@property(nonatomic,strong)NSString *restaurant_id;
@property(nonatomic,strong)NSString *restaurant_name;
@property(nonatomic,strong)NSString *order_id;
@property(nonatomic,strong)NSString *total_amount;
@property(nonatomic,strong)NSString *order_status;
@property(nonatomic,strong)NSString *order_date;
@property(nonatomic,strong)NSString *delivery_date;
@property(nonatomic,strong)NSString *review_status;
@end

@interface UserOrderTracking : NSObject
@property(nonatomic,strong)NSString *restaurant_name;
@property(nonatomic,strong)NSString *order_id;
@property(nonatomic,strong)NSString *total_amount;
@property(nonatomic,strong)NSString *order_status;
@property(nonatomic,strong)NSString *order_date;
@property(nonatomic,strong)NSString *delivery_date;


@end

@interface UserReviews : NSObject
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *comment;
@property(nonatomic,strong)NSString *rating;
@property(nonatomic,strong)NSString *created;

@end


@interface ViewOrderDetailsData : NSObject
@property(nonatomic,strong)NSString *cart_id;
@property(nonatomic,strong)NSString *cust_string;
@property(nonatomic,strong)NSString *dish_price;
@property(nonatomic,strong)NSString *dish_total;
@property(nonatomic,strong)NSString *quantity;
@property(nonatomic,strong)NSString *sub_category;
@end

@interface ViewOrderDetails : NSObject
@property(nonatomic,strong)NSString *coupon_amount;
@property(nonatomic,strong)NSString *delivery_fee;
@property(nonatomic,strong)NSString *order_amount;
@property(nonatomic,strong)NSString *tax_amount;
@property(nonatomic,strong)NSString *total_amount;
@property(nonatomic,strong)NSString *transaction_id;
@property(nonatomic,strong)NSMutableArray *viewOrderDetailsDataArray;


@end

