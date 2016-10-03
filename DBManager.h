//
//  DBManager.h
//  NikhilSwrevalslideMenu
//
//  Created by Sudarshan on 7/30/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "ResponseUtility.h"
@interface DBManager : NSObject
{
  NSString *databasePath;
}

+(DBManager*)getSharedInstance;
-(BOOL)createDB;
- (BOOL) saveDataIntoCart:(USerSelectedCartData*)cartObject;
- (NSArray*)getALlCartData:(int)resName;
-(BOOL)deleteRecord:(int)recordID;
-(BOOL)updateDataIntoDB:(USerSelectedCartData*)cart;
-(BOOL)updateDataIntoDB:(USerSelectedCartData*)cart andQuanity:(int)quantity andPrice:(float)totalFinalPrice;
- (USerSelectedCartData*)getALlCartDataWithID:(int)unique_Id andSubCateforyId:(int)subCatId;

- (BOOL) saveUserData:(NSDictionary*)dictionary;
- (NSDictionary*)getALlUserData;
-(BOOL)deleteUserData;

-(BOOL)updateDataIntoDB:(NSString*)serverCartID andLocalCartID:(NSString*)randomID;
- (NSArray*)getALlPendingCartDatatobeAdded:(int)restaurant_Id;
-(BOOL)deleteRecordAfterPayment:(int)recordID;
- (NSDictionary*)getALlRestuarants;
- (int)getALlRestuarantswhereOrderIs:(NSString*)OrderMode andRestuarantId:(int)rID;

- (BOOL) saveUserFilterResponse:(UserFiltersResponse*)filterObject;
- (UserFiltersResponse*)getUserFilterData:(NSString*)restaurant_Id;
-(BOOL)deleteRecord:(int)restID andOrderType:(NSString*)orderType;

-(NSString*)getOrderTypeForRestaurantID:(int)rID;
-(BOOL)updateOrderModeIntoDB:(NSString*)restID andOrderMode:(NSString*)orderMode;

@end