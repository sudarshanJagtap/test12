//
//  DBManager.m
//  NikhilSwrevalslideMenu
//
//  Created by Sudarshan on 7/30/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import "DBManager.h"
static DBManager *sharedInstance = nil;
static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;

@implementation DBManager

+(DBManager*)getSharedInstance{
  if (!sharedInstance) {
    sharedInstance = [[super allocWithZone:NULL]init];
    [sharedInstance createDB];
  }
  return sharedInstance;
}



//+(DBManager*)getSharedInstance{
//  static dispatch_once_t onceToken1;
//  dispatch_once(&onceToken1, ^{
//    sharedInstance = [[self alloc] init];
//    
//  });
//  
//  return sharedInstance;
//}

-(BOOL)createDB{
  NSString *docsDir;
  NSArray *dirPaths;
  dirPaths = NSSearchPathForDirectoriesInDomains
  (NSDocumentDirectory, NSUserDomainMask, YES);
  docsDir = dirPaths[0];
  NSLog(@"DB PATH + %@",docsDir);
  databasePath = [[NSString alloc] initWithString:
                  [docsDir stringByAppendingPathComponent: @"YMOC.db"]];
  BOOL isSuccess = YES;
  NSFileManager *filemgr = [NSFileManager defaultManager];
  if ([filemgr fileExistsAtPath: databasePath ] == NO)
  {
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
      char *errMsg1;
       NSString *sql_stmt1 = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS UserSelectedAddToCartInfo (id INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL  UNIQUE, restaurant_Id INTEGER NOT NULL,subCategory_Id INTEGER NOT NULL,reasturant_Name TEXT, category_Name TEXT, sub_category_Name TEXT, cust_id TEXT, cust_option TEXT,cust_price TEXT,cust_description TEXT, subCategoryPrice FLOAT,MIN_ORDER FLOAT,delivery_fee FLOAT,customizeCuisineString TEXT,customizeCuisinePrice TEXT,customizedCuisineId Text,quantity TEXT, TotalFinalPrice FLOAT,status TEXT, orderType TEXT, userEnteredAddress TEXT,rest_Address TEXT, instructions TEXT,serverCartID TEXT,randomcartID TEXT,LOGO TEXT,Distance TEXT)"];
      
      if (sqlite3_exec(database, [sql_stmt1 UTF8String], NULL, NULL, &errMsg1)
          != SQLITE_OK)
      {
        isSuccess = NO;
        NSLog(@"Failed to create table");
      }
      
      char *errMsg2;
      NSString *sql_stmt2 = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS UserData (id INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL  UNIQUE, user_id TEXT,user_full_name TEXT, user_name TEXT)"];
      
      if (sqlite3_exec(database, [sql_stmt2 UTF8String], NULL, NULL, &errMsg2)
          != SQLITE_OK)
      {
        isSuccess = NO;
        NSLog(@"Failed to create table");
      }

      
      char *errMsg3;
      NSString *sql_stmt3 = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS UserFilterResponseData (id INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL  UNIQUE, address_search TEXT,closing_time TEXT, cuisine_string TEXT, day TEXT,delivery_facility TEXT, delivery_time TEXT, end_dist TEXT,fee TEXT, ufp_id TEXT UNIQUE, logo TEXT,min_order_amount TEXT, name TEXT, opening_status TEXT,opening_time TEXT, rating TEXT, restaurant_status TEXT, start_dist TEXT,pkDistance TEXT)"];
      
      if (sqlite3_exec(database, [sql_stmt3 UTF8String], NULL, NULL, &errMsg3)
          != SQLITE_OK)
      {
        isSuccess = NO;
        NSLog(@"Failed to create table");
      }

      
      sqlite3_close(database);
      isSuccess = YES;
    }
    else {
      isSuccess = NO;
      NSLog(@"Failed to open/create database");
    }
  }
  return isSuccess;
}


- (BOOL) saveUserFilterResponse:(UserFiltersResponse*)filterObject
{
  const char *dbpath = [databasePath UTF8String];
  if (sqlite3_open(dbpath, &database) == SQLITE_OK)
  {
        NSString *insertSQL = [NSString stringWithFormat:@"insert into UserFilterResponseData (address_search ,closing_time , cuisine_string , day ,delivery_facility , delivery_time , end_dist ,fee , ufp_id , logo ,min_order_amount , name , opening_status ,opening_time , rating , restaurant_status , start_dist ,pkDistance ) values (\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",filterObject.address_search,filterObject.closing_time,filterObject.cuisine_string,filterObject.day,filterObject.delivery_facility,filterObject.delivery_time,filterObject.end_dist,filterObject.fee,filterObject.ufp_id,filterObject.logo,filterObject.min_order_amount,filterObject.name,filterObject.opening_status,filterObject.opening_time,filterObject.rating,filterObject.restaurant_status,filterObject.start_dist,filterObject.pkDistance];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
          return YES;
        }
        else {
          
          BOOL retu = [self updateUserFilterResponse:filterObject andDistance:filterObject.pkDistance];
          return retu;
        }
      }
  return NO;
}

-(BOOL)updateUserFilterResponse:(UserFiltersResponse*)filterObject andDistance:(NSString*)dist{
  if ((dist!=Nil)||(dist!=nil)) {

  const char *dbpath = [databasePath UTF8String];
  if (sqlite3_open(dbpath, &database) == SQLITE_OK)
  {
    NSString *queryStr = [NSString stringWithFormat:@"UPDATE UserFilterResponseData SET pkDistance = '%@' WHERE id = %@",dist,filterObject.ufp_id];
    const char *insert_stmt = [queryStr UTF8String];
    sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
    if (sqlite3_step(statement) == SQLITE_DONE)
    {
      return YES;
    }
    else {
      return NO;
    }
  }return NO;
  }
  return NO;
}

- (BOOL) saveDataIntoCart:(USerSelectedCartData*)cartObject;
{
  const char *dbpath = [databasePath UTF8String];
  if (sqlite3_open(dbpath, &database) == SQLITE_OK)
  {
    NSString *insertSQL = [NSString stringWithFormat:@"insert into UserSelectedAddToCartInfo (restaurant_Id,subCategory_Id, reasturant_Name,category_Name, sub_category_Name,cust_id,cust_option,cust_price,cust_description,subCategoryPrice,MIN_ORDER,delivery_fee,customizeCuisineString,customizeCuisinePrice,customizedCuisineId,quantity,TotalFinalPrice,status,ordertype,userEnteredAddress,rest_Address,instructions,serverCartID,randomcartID,LOGO,Distance) values (\"%ld\",\"%ld\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%f\",\"%f\",\"%f\",\"%@\",\"%@\",\"%@\",\"%@\",\"%f\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",cartObject.restaurant_Id,cartObject.subCategory_Id,cartObject.reasturant_Name,cartObject.category_Name,cartObject.sub_category_Name,cartObject.cust_id,cartObject.cust_option,cartObject.cust_price,cartObject.cust_description,cartObject.subCategoryPrice,cartObject.MIN_ORDER,cartObject.delivery_fee,cartObject.customizeCuisineString,cartObject.customizeCuisinePrice,cartObject.customizedCuisineId,cartObject.quantity,cartObject.TotalFinalPrice,cartObject.status,cartObject.ordertype,cartObject.userEnteredAddress,cartObject.rest_Address,cartObject.instructions,cartObject.serverCartID,cartObject.randomCartID,cartObject.Logo,cartObject.distance];
    const char *insert_stmt = [insertSQL UTF8String];
    sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
    if (sqlite3_step(statement) == SQLITE_DONE)
    {
      return YES;
    }
    else {
      return NO;
    }
    //    sqlite3_reset(statement);
  }
  return NO;
}

- (BOOL) saveUserData:(NSDictionary*)dictionary
{
  const char *dbpath = [databasePath UTF8String];
  if (sqlite3_open(dbpath, &database) == SQLITE_OK)
  {
    NSString *insertSQL = [NSString stringWithFormat:@"insert into UserData (user_id,user_full_name, user_name) values (\"%@\",\"%@\",\"%@\")",[dictionary valueForKey:@"user_id"],[dictionary valueForKey:@"user_full_name"],[dictionary valueForKey:@"user_name"]];
    const char *insert_stmt = [insertSQL UTF8String];
    sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
    if (sqlite3_step(statement) == SQLITE_DONE)
    {
      return YES;
    }
    else {
      return NO;
    }
  }
  return NO;
}

- (NSDictionary*)getALlUserData
{
  NSMutableDictionary *userDictioanry = [[NSMutableDictionary alloc]init];
  const char *dbpath = [databasePath UTF8String];
  if (sqlite3_open(dbpath, &database) == SQLITE_OK)
  {
    sqlite3_stmt *stmt;
    NSString *queryStr = [NSString stringWithFormat:@"SELECT * FROM UserData"];
    if (sqlite3_prepare(database, [queryStr UTF8String], -1, &stmt, nil) == SQLITE_OK)
    {
      while (sqlite3_step(stmt) == SQLITE_ROW)
      {
        char *userIDChar = (char*)sqlite3_column_text(stmt, 1);
        NSString *userID = [NSString stringWithUTF8String:userIDChar];
        [userDictioanry setValue:userID forKey:@"user_id"];
        char *userFullNameChar = (char*)sqlite3_column_text(stmt, 2);
        NSString *userFullName = [NSString stringWithUTF8String:userFullNameChar];
        [userDictioanry setValue:userFullName forKey:@"user_full_name"];
        char *userNameChar = (char*)sqlite3_column_text(stmt, 3);
        NSString *userName = [NSString stringWithUTF8String:userNameChar];
        [userDictioanry setValue:userName forKey:@"user_name"];
      }
    }
  }
  return userDictioanry;
}

-(BOOL)deleteUserData
{
  [self deleteCartData];
  const char *dbpath = [databasePath UTF8String];
  if (sqlite3_open(dbpath, &database) == SQLITE_OK)
  {
    NSString *queryStr = [NSString stringWithFormat:@"DELETE from UserData"];
    const char *insert_stmt = [queryStr UTF8String];
    sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
    if (sqlite3_step(statement) == SQLITE_DONE)
    {
      return YES;
    }
    else {
      return NO;
    }
  }return NO;
}

-(BOOL)deleteCartData
{
  [self deleteUserFilterResponseData];
  const char *dbpath = [databasePath UTF8String];
  if (sqlite3_open(dbpath, &database) == SQLITE_OK)
  {
    NSString *queryStr = [NSString stringWithFormat:@"DELETE from UserSelectedAddToCartInfo"];
    const char *insert_stmt = [queryStr UTF8String];
    sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
    if (sqlite3_step(statement) == SQLITE_DONE)
    {
      return YES;
    }
    else {
      return NO;
    }
  }return NO;
}

-(BOOL)deleteUserFilterResponseData
{
   [[NSNotificationCenter defaultCenter] postNotificationName:@"hideCartButtonOnLogout" object:nil];
  const char *dbpath = [databasePath UTF8String];
  if (sqlite3_open(dbpath, &database) == SQLITE_OK)
  {
    NSString *queryStr = [NSString stringWithFormat:@"DELETE from UserFilterResponseData"];
    const char *insert_stmt = [queryStr UTF8String];
    sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
    if (sqlite3_step(statement) == SQLITE_DONE)
    {
      return YES;
    }
    else {
      return NO;
    }
  }return NO;
}





-(BOOL)deleteRecord:(int)restID andOrderType:(NSString*)orderType
{
  const char *dbpath = [databasePath UTF8String];
  if (sqlite3_open(dbpath, &database) == SQLITE_OK)
  {
    NSString *queryStr = [NSString stringWithFormat:@"DELETE FROM UserSelectedAddToCartInfo WHERE restaurant_Id = '%d' AND orderType = '%@'",restID,orderType];
    const char *insert_stmt = [queryStr UTF8String];
    sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
    if (sqlite3_step(statement) == SQLITE_DONE)
    {
      return YES;
    }
    else {
      return NO;
    }
  }return NO;
}



-(BOOL)deleteRecord:(int)recordID
{
  const char *dbpath = [databasePath UTF8String];
  if (sqlite3_open(dbpath, &database) == SQLITE_OK)
  {
    NSString *queryStr = [NSString stringWithFormat:@"DELETE FROM UserSelectedAddToCartInfo WHERE id = %d",recordID];
    const char *insert_stmt = [queryStr UTF8String];
    sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
    if (sqlite3_step(statement) == SQLITE_DONE)
    {
      return YES;
    }
    else {
      return NO;
    }
  }return NO;
}


-(BOOL)deleteRecordAfterPayment:(int)recordID
{
  const char *dbpath = [databasePath UTF8String];
  if (sqlite3_open(dbpath, &database) == SQLITE_OK)
  {
    NSString *queryStr = [NSString stringWithFormat:@"DELETE FROM UserSelectedAddToCartInfo WHERE restaurant_ID = %d",recordID];
    const char *insert_stmt = [queryStr UTF8String];
    sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
    if (sqlite3_step(statement) == SQLITE_DONE)
    {
      return YES;
    }
    else {
      return NO;
    }
  }return NO;
}

- (NSArray*)getALlCartData:(int)restaurant_Id
{
  NSMutableArray *cartDataArray = [[NSMutableArray alloc]init];
  const char *dbpath = [databasePath UTF8String];
  if (sqlite3_open(dbpath, &database) == SQLITE_OK)
  {
    sqlite3_stmt *stmt;
    NSString *queryStr = [NSString stringWithFormat:@"SELECT * FROM UserSelectedAddToCartInfo WHERE restaurant_Id = '%d'",restaurant_Id];
    if (sqlite3_prepare(database, [queryStr UTF8String], -1, &stmt, nil) == SQLITE_OK)
    {
      while (sqlite3_step(stmt) == SQLITE_ROW)
      {
        USerSelectedCartData *addCart = [[USerSelectedCartData alloc]init];
        
        NSInteger unique_id = sqlite3_column_int(stmt, 0);
        addCart.unique_id = unique_id;
        
        NSInteger reastuarant_id = sqlite3_column_int(stmt, 1);
        addCart.restaurant_Id = reastuarant_id;
        
        NSInteger sub_category_id = sqlite3_column_int(stmt, 2);
        addCart.subCategory_Id = sub_category_id;
        
        
        char *reastuarant_namechar = (char*)sqlite3_column_text(stmt, 3);
        NSString *reastuarant_name = [NSString stringWithUTF8String:reastuarant_namechar];
        addCart.reasturant_Name = reastuarant_name;
        
        char *category_Namechar = (char*)sqlite3_column_text(stmt, 4);
        if (category_Namechar!=nil) {
          NSString *category_Name = [NSString stringWithUTF8String:category_Namechar];
          addCart.category_Name = category_Name;
        }
        
        char *sub_category_Namechar = (char*)sqlite3_column_text(stmt, 5);
        if (sub_category_Namechar!=nil) {
          NSString *sub_category_Name = [NSString stringWithUTF8String:sub_category_Namechar];
          addCart.sub_category_Name = sub_category_Name;
        }
        
        char *cust_idchar = (char*)sqlite3_column_text(stmt, 6);
        if (cust_idchar!=nil) {
          NSString *cust_id = [NSString stringWithUTF8String:cust_idchar];
          addCart.cust_id = cust_id;
        }
        
        char *cust_optionchar = (char*)sqlite3_column_text(stmt, 7);
        if (cust_optionchar!=nil) {
          NSString *cust_option = [NSString stringWithUTF8String:cust_optionchar];
          addCart.cust_option = cust_option;
        }
        
        char *cust_pricechar = (char*)sqlite3_column_text(stmt, 8);
        NSString *cust_price = [NSString stringWithUTF8String:cust_pricechar];
        addCart.cust_price = cust_price;
        
        char *ccdescriptionchar = (char*)sqlite3_column_text(stmt, 9);
        NSString *ccdescription = [NSString stringWithUTF8String:ccdescriptionchar];
        addCart.cust_description = ccdescription;
        
        
        float subcategoryPrice = (float)sqlite3_column_double(stmt, 10);
        addCart.subCategoryPrice = subcategoryPrice;
        
        
        float min_order_amount = (float)sqlite3_column_double(stmt, 11);
        addCart.MIN_ORDER = min_order_amount;
        
        float delivery_fee = (float)sqlite3_column_double(stmt, 12);
        addCart.delivery_fee = delivery_fee;
        
        char *customizeCuisineStringchar = (char*)sqlite3_column_text(stmt, 13);
        NSString *customizeCuisineString = [NSString stringWithUTF8String:customizeCuisineStringchar];
        addCart.customizeCuisineString = customizeCuisineString;
        
        char *customizeCuisinePricechar = (char*)sqlite3_column_text(stmt, 14);
        NSString *customizeCuisinePrice = [NSString stringWithUTF8String:customizeCuisinePricechar];
        addCart.customizeCuisinePrice = customizeCuisinePrice;
        
        char *customizeCuisineId = (char*)sqlite3_column_text(stmt, 15);
        NSString *customizeCuisineID = [NSString stringWithUTF8String:customizeCuisineId];
        addCart.customizedCuisineId = customizeCuisineID;
        
        char *quantitychar = (char*)sqlite3_column_text(stmt, 16);
        NSString *quantity = [NSString stringWithUTF8String:quantitychar];
        addCart.quantity = quantity;
        
        float ttfp = (float)sqlite3_column_double(stmt, 17);
        addCart.TotalFinalPrice = ttfp;
        
        char *cstatus = (char*)sqlite3_column_text(stmt, 18);
        NSString *ccstatus = [NSString stringWithUTF8String:cstatus];
        addCart.status = ccstatus;
        
        char *ootype = (char*)sqlite3_column_text(stmt, 19);
        NSString *OOtype = [NSString stringWithUTF8String:ootype];
        addCart.ordertype = OOtype;
        
        char *uadd = (char*)sqlite3_column_text(stmt, 20);
        NSString *uuaddress = [NSString stringWithUTF8String:uadd];
        addCart.userEnteredAddress = uuaddress;
        
        char *rsadd = (char*)sqlite3_column_text(stmt, 21);
        NSString *restadd = [NSString stringWithUTF8String:rsadd];
        addCart.rest_Address = restadd;
        
        char *instr = (char*)sqlite3_column_text(stmt, 22);
        NSString *instruct = [NSString stringWithUTF8String:instr];
        addCart.instructions = instruct;
        
        char *sID = (char*)sqlite3_column_text(stmt, 23);
        NSString *sIDstr = [NSString stringWithUTF8String:sID];
        addCart.serverCartID = sIDstr;
        
        char *lId = (char*)sqlite3_column_text(stmt, 24);
        NSString *lIDstr = [NSString stringWithUTF8String:lId];
        addCart.randomCartID = lIDstr;
        
        char *logo = (char*)sqlite3_column_text(stmt, 25);
        NSString *logostr = [NSString stringWithUTF8String:logo];
        addCart.Logo = logostr;
        
        char *dist = (char*)sqlite3_column_text(stmt, 26);
        NSString *diststr = [NSString stringWithUTF8String:dist];
        addCart.distance = diststr;
        
        
        [cartDataArray addObject:addCart];
        
      }
    }
  }
  return cartDataArray;
}


- (UserFiltersResponse*)getUserFilterData:(NSString*)restaurant_Id
{
   UserFiltersResponse *ufp = [[UserFiltersResponse alloc]init];

  const char *dbpath = [databasePath UTF8String];
  if (sqlite3_open(dbpath, &database) == SQLITE_OK)
  {
    sqlite3_stmt *stmt;
    NSString *queryStr = [NSString stringWithFormat:@"SELECT * FROM UserFilterResponseData WHERE ufp_id = '%@'",restaurant_Id];
    if (sqlite3_prepare(database, [queryStr UTF8String], -1, &stmt, nil) == SQLITE_OK)
    {
      while (sqlite3_step(stmt) == SQLITE_ROW)
      {
       
        char *address_search = (char*)sqlite3_column_text(stmt, 1);
        ufp.address_search = [NSString stringWithUTF8String:address_search];
        
        char *closing_time = (char*)sqlite3_column_text(stmt, 2);
        ufp.closing_time = [NSString stringWithUTF8String:closing_time];
        
        char *cuisine_string = (char*)sqlite3_column_text(stmt, 3);
        ufp.cuisine_string = [NSString stringWithUTF8String:cuisine_string];
        
        char *day = (char*)sqlite3_column_text(stmt, 4);
        ufp.day = [NSString stringWithUTF8String:day];
        
        char *delivery_facility = (char*)sqlite3_column_text(stmt, 5);
        ufp.delivery_facility = [NSString stringWithUTF8String:delivery_facility];
        
        char *delivery_time = (char*)sqlite3_column_text(stmt, 6);
        ufp.delivery_time = [NSString stringWithUTF8String:delivery_time];
        
        char *end_dist = (char*)sqlite3_column_text(stmt, 7);
        ufp.end_dist = [NSString stringWithUTF8String:end_dist];
        
        char *fee = (char*)sqlite3_column_text(stmt, 8);
        ufp.fee = [NSString stringWithUTF8String:fee];
        
        char *ufp_id = (char*)sqlite3_column_text(stmt, 9);
        ufp.ufp_id = [NSString stringWithUTF8String:ufp_id];
        
        char *logo = (char*)sqlite3_column_text(stmt, 10);
        ufp.logo = [NSString stringWithUTF8String:logo];
        
        char *min_order_amount = (char*)sqlite3_column_text(stmt, 11);
        ufp.min_order_amount = [NSString stringWithUTF8String:min_order_amount];
        
        char *name = (char*)sqlite3_column_text(stmt, 12);
        ufp.name = [NSString stringWithUTF8String:name];
        
        char *opening_status = (char*)sqlite3_column_text(stmt, 13);
        ufp.opening_status = [NSString stringWithUTF8String:opening_status];
        
        char *opening_time = (char*)sqlite3_column_text(stmt, 14);
        ufp.opening_time = [NSString stringWithUTF8String:opening_time];
        
        char *rating = (char*)sqlite3_column_text(stmt, 15);
        ufp.rating = [NSString stringWithUTF8String:rating];
        
        char *restaurant_status = (char*)sqlite3_column_text(stmt, 16);
        ufp.restaurant_status = [NSString stringWithUTF8String:restaurant_status];
        
        char *start_dist = (char*)sqlite3_column_text(stmt, 17);
        ufp.start_dist = [NSString stringWithUTF8String:start_dist];
        
        char *pkDistance = (char*)sqlite3_column_text(stmt, 18);
        ufp.pkDistance = [NSString stringWithUTF8String:pkDistance];
        
      }
    }
  }
  return ufp;
}


-(BOOL)updateDataIntoDB:(USerSelectedCartData*)cart andQuanity:(int)quantity andPrice:(float)totalFinalPrice{
  
  const char *dbpath = [databasePath UTF8String];
  if (sqlite3_open(dbpath, &database) == SQLITE_OK)
  {
    NSString *queryStr = [NSString stringWithFormat:@"UPDATE UserSelectedAddToCartInfo SET quantity = '%@',TotalFinalPrice= '%f' WHERE id = %ld",cart.quantity,cart.TotalFinalPrice,(long)cart.unique_id];
    const char *insert_stmt = [queryStr UTF8String];
    sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
    if (sqlite3_step(statement) == SQLITE_DONE)
    {
      return YES;
    }
    else {
      return NO;
    }
  }return NO;
  return NO;
}


-(BOOL)updateDataIntoDB:(NSString*)serverCartID andLocalCartID:(NSString*)randomID{
  
  const char *dbpath = [databasePath UTF8String];
  if (sqlite3_open(dbpath, &database) == SQLITE_OK)
  {
    NSString *queryStr = [NSString stringWithFormat:@"UPDATE UserSelectedAddToCartInfo SET serverCartID = '%@' WHERE randomcartID = %@",serverCartID,randomID];
    const char *insert_stmt = [queryStr UTF8String];
    sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
    if (sqlite3_step(statement) == SQLITE_DONE)
    {
      return YES;
    }
    else {
      return NO;
    }
  }return NO;
  return NO;
}

-(BOOL)updateDataIntoDB:(USerSelectedCartData*)cart{
  
  const char *dbpath = [databasePath UTF8String];
  if (sqlite3_open(dbpath, &database) == SQLITE_OK)
  {
    NSString *queryStr = [NSString stringWithFormat:@"UPDATE UserSelectedAddToCartInfo SET customizeCuisinePrice = '%@',customizeCuisineString= '%@',customizedCuisineId = '%@',TotalFinalPrice = '%f',quantity = '%@' WHERE id = %ld",cart.customizeCuisinePrice,cart.customizeCuisineString,cart.customizedCuisineId,cart.TotalFinalPrice,cart.quantity,(long)cart.unique_id];
    const char *insert_stmt = [queryStr UTF8String];
    sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
    if (sqlite3_step(statement) == SQLITE_DONE)
    {
      return YES;
    }
    else {
      return NO;
    }
  }return NO;
  return NO;
}

- (USerSelectedCartData*)getALlCartDataWithID:(int)unique_Id andSubCateforyId:(int)subCatId
{
  USerSelectedCartData *addCart = [[USerSelectedCartData alloc]init];
  //  NSMutableArray *cartDataArray = [[NSMutableArray alloc]init];
  const char *dbpath = [databasePath UTF8String];
  if (sqlite3_open(dbpath, &database) == SQLITE_OK)
  {
    sqlite3_stmt *stmt;
    NSString *queryStr = [NSString stringWithFormat:@"SELECT * FROM UserSelectedAddToCartInfo WHERE id = '%d' AND subCategory_Id = '%d'",unique_Id,subCatId];
    if (sqlite3_prepare(database, [queryStr UTF8String], -1, &stmt, nil) == SQLITE_OK)
    {
      while (sqlite3_step(stmt) == SQLITE_ROW)
      {
        
        
        NSInteger unique_id = sqlite3_column_int(stmt, 0);
        addCart.unique_id = unique_id;
        
        NSInteger reastuarant_id = sqlite3_column_int(stmt, 1);
        addCart.restaurant_Id = reastuarant_id;
        
        NSInteger sub_category_id = sqlite3_column_int(stmt, 2);
        addCart.subCategory_Id = sub_category_id;
        
        
        char *reastuarant_namechar = (char*)sqlite3_column_text(stmt, 3);
        NSString *reastuarant_name = [NSString stringWithUTF8String:reastuarant_namechar];
        addCart.reasturant_Name = reastuarant_name;
        
        char *category_Namechar = (char*)sqlite3_column_text(stmt, 4);
        if (category_Namechar!=nil) {
          NSString *category_Name = [NSString stringWithUTF8String:category_Namechar];
          addCart.category_Name = category_Name;
        }
        
        char *sub_category_Namechar = (char*)sqlite3_column_text(stmt, 5);
        if (sub_category_Namechar!=nil) {
          NSString *sub_category_Name = [NSString stringWithUTF8String:sub_category_Namechar];
          addCart.sub_category_Name = sub_category_Name;
        }
        
        char *cust_idchar = (char*)sqlite3_column_text(stmt, 6);
        if (cust_idchar!=nil) {
          NSString *cust_id = [NSString stringWithUTF8String:cust_idchar];
          addCart.cust_id = cust_id;
        }
        
        char *cust_optionchar = (char*)sqlite3_column_text(stmt, 7);
        if (cust_optionchar!=nil) {
          NSString *cust_option = [NSString stringWithUTF8String:cust_optionchar];
          addCart.cust_option = cust_option;
        }
        
        char *cust_pricechar = (char*)sqlite3_column_text(stmt, 8);
        NSString *cust_price = [NSString stringWithUTF8String:cust_pricechar];
        addCart.cust_price = cust_price;
        
        char *ccdescriptionchar = (char*)sqlite3_column_text(stmt, 9);
        NSString *ccdescription = [NSString stringWithUTF8String:ccdescriptionchar];
        addCart.cust_description = ccdescription;
        
        
        float subcategoryPrice = (float)sqlite3_column_double(stmt, 10);
        addCart.subCategoryPrice = subcategoryPrice;
        
        
        float min_order_amount = (float)sqlite3_column_double(stmt, 11);
        addCart.MIN_ORDER = min_order_amount;
        
        float delivery_fee = (float)sqlite3_column_double(stmt, 12);
        addCart.delivery_fee = delivery_fee;
        
        char *customizeCuisineStringchar = (char*)sqlite3_column_text(stmt, 13);
        NSString *customizeCuisineString = [NSString stringWithUTF8String:customizeCuisineStringchar];
        addCart.customizeCuisineString = customizeCuisineString;
        
        char *customizeCuisinePricechar = (char*)sqlite3_column_text(stmt, 14);
        NSString *customizeCuisinePrice = [NSString stringWithUTF8String:customizeCuisinePricechar];
        addCart.customizeCuisinePrice = customizeCuisinePrice;
        
        char *customizeCuisineId = (char*)sqlite3_column_text(stmt, 15);
        NSString *customizeCuisineID = [NSString stringWithUTF8String:customizeCuisineId];
        addCart.customizedCuisineId = customizeCuisineID;
        
        char *quantitychar = (char*)sqlite3_column_text(stmt, 16);
        NSString *quantity = [NSString stringWithUTF8String:quantitychar];
        addCart.quantity = quantity;
        
        float ttfp = (float)sqlite3_column_double(stmt, 17);
        addCart.TotalFinalPrice = ttfp;
        
        char *cstatus = (char*)sqlite3_column_text(stmt, 18);
        NSString *ccstatus = [NSString stringWithUTF8String:cstatus];
        addCart.status = ccstatus;
        
        char *ootype = (char*)sqlite3_column_text(stmt, 19);
        NSString *OOtype = [NSString stringWithUTF8String:ootype];
        addCart.ordertype = OOtype;
        
        char *uadd = (char*)sqlite3_column_text(stmt, 20);
        NSString *uuaddress = [NSString stringWithUTF8String:uadd];
        addCart.userEnteredAddress = uuaddress;
        
        char *rsadd = (char*)sqlite3_column_text(stmt, 21);
        NSString *restadd = [NSString stringWithUTF8String:rsadd];
        addCart.rest_Address = restadd;
        
        char *instr = (char*)sqlite3_column_text(stmt, 22);
        NSString *instruct = [NSString stringWithUTF8String:instr];
        addCart.instructions = instruct;
        
        char *sID = (char*)sqlite3_column_text(stmt, 23);
        NSString *sIDstr = [NSString stringWithUTF8String:sID];
        addCart.serverCartID = sIDstr;
        
        char *lId = (char*)sqlite3_column_text(stmt, 24);
        NSString *lIDstr = [NSString stringWithUTF8String:lId];
        addCart.randomCartID = lIDstr;
        
        char *logo = (char*)sqlite3_column_text(stmt, 25);
        NSString *logostr = [NSString stringWithUTF8String:logo];
        addCart.Logo = logostr;
        
        char *dist = (char*)sqlite3_column_text(stmt, 26);
        NSString *diststr = [NSString stringWithUTF8String:dist];
        addCart.distance = diststr;
        
      }
    }
  }
  return addCart;
}


- (NSArray*)getALlPendingCartDatatobeAdded:(int)restaurant_Id
{
  NSMutableArray *cartDataArray = [[NSMutableArray alloc]init];
  const char *dbpath = [databasePath UTF8String];
  if (sqlite3_open(dbpath, &database) == SQLITE_OK)
  {
    sqlite3_stmt *stmt;
    NSString *queryStr = [NSString stringWithFormat:@"SELECT * FROM UserSelectedAddToCartInfo WHERE restaurant_Id = '%d' and serverCartID = '0'",restaurant_Id];
    if (sqlite3_prepare(database, [queryStr UTF8String], -1, &stmt, nil) == SQLITE_OK)
    {
      while (sqlite3_step(stmt) == SQLITE_ROW)
      {
        USerSelectedCartData *addCart = [[USerSelectedCartData alloc]init];
        
        NSInteger unique_id = sqlite3_column_int(stmt, 0);
        addCart.unique_id = unique_id;
        
        NSInteger reastuarant_id = sqlite3_column_int(stmt, 1);
        addCart.restaurant_Id = reastuarant_id;
        
        NSInteger sub_category_id = sqlite3_column_int(stmt, 2);
        addCart.subCategory_Id = sub_category_id;
        
        
        char *reastuarant_namechar = (char*)sqlite3_column_text(stmt, 3);
        NSString *reastuarant_name = [NSString stringWithUTF8String:reastuarant_namechar];
        addCart.reasturant_Name = reastuarant_name;
        
        char *category_Namechar = (char*)sqlite3_column_text(stmt, 4);
        if (category_Namechar!=nil) {
          NSString *category_Name = [NSString stringWithUTF8String:category_Namechar];
          addCart.category_Name = category_Name;
        }
        
        char *sub_category_Namechar = (char*)sqlite3_column_text(stmt, 5);
        if (sub_category_Namechar!=nil) {
          NSString *sub_category_Name = [NSString stringWithUTF8String:sub_category_Namechar];
          addCart.sub_category_Name = sub_category_Name;
        }
        
        char *cust_idchar = (char*)sqlite3_column_text(stmt, 6);
        if (cust_idchar!=nil) {
          NSString *cust_id = [NSString stringWithUTF8String:cust_idchar];
          addCart.cust_id = cust_id;
        }
        
        char *cust_optionchar = (char*)sqlite3_column_text(stmt, 7);
        if (cust_optionchar!=nil) {
          NSString *cust_option = [NSString stringWithUTF8String:cust_optionchar];
          addCart.cust_option = cust_option;
        }
        
        char *cust_pricechar = (char*)sqlite3_column_text(stmt, 8);
        NSString *cust_price = [NSString stringWithUTF8String:cust_pricechar];
        addCart.cust_price = cust_price;
        
        char *ccdescriptionchar = (char*)sqlite3_column_text(stmt, 9);
        NSString *ccdescription = [NSString stringWithUTF8String:ccdescriptionchar];
        addCart.cust_description = ccdescription;
        
        
        float subcategoryPrice = (float)sqlite3_column_double(stmt, 10);
        addCart.subCategoryPrice = subcategoryPrice;
        
        
        float min_order_amount = (float)sqlite3_column_double(stmt, 11);
        addCart.MIN_ORDER = min_order_amount;
        
        float delivery_fee = (float)sqlite3_column_double(stmt, 12);
        addCart.delivery_fee = delivery_fee;
        
        char *customizeCuisineStringchar = (char*)sqlite3_column_text(stmt, 13);
        NSString *customizeCuisineString = [NSString stringWithUTF8String:customizeCuisineStringchar];
        addCart.customizeCuisineString = customizeCuisineString;
        
        char *customizeCuisinePricechar = (char*)sqlite3_column_text(stmt, 14);
        NSString *customizeCuisinePrice = [NSString stringWithUTF8String:customizeCuisinePricechar];
        addCart.customizeCuisinePrice = customizeCuisinePrice;
        
        char *customizeCuisineId = (char*)sqlite3_column_text(stmt, 15);
        NSString *customizeCuisineID = [NSString stringWithUTF8String:customizeCuisineId];
        addCart.customizedCuisineId = customizeCuisineID;
        
        char *quantitychar = (char*)sqlite3_column_text(stmt, 16);
        NSString *quantity = [NSString stringWithUTF8String:quantitychar];
        addCart.quantity = quantity;
        
        float ttfp = (float)sqlite3_column_double(stmt, 17);
        addCart.TotalFinalPrice = ttfp;
        
        char *cstatus = (char*)sqlite3_column_text(stmt, 18);
        NSString *ccstatus = [NSString stringWithUTF8String:cstatus];
        addCart.status = ccstatus;
        
        char *ootype = (char*)sqlite3_column_text(stmt, 19);
        NSString *OOtype = [NSString stringWithUTF8String:ootype];
        addCart.ordertype = OOtype;
        
        char *uadd = (char*)sqlite3_column_text(stmt, 20);
        NSString *uuaddress = [NSString stringWithUTF8String:uadd];
        addCart.userEnteredAddress = uuaddress;
        
        char *rsadd = (char*)sqlite3_column_text(stmt, 21);
        NSString *restadd = [NSString stringWithUTF8String:rsadd];
        addCart.rest_Address = restadd;
        
        char *instr = (char*)sqlite3_column_text(stmt, 22);
        NSString *instruct = [NSString stringWithUTF8String:instr];
        addCart.instructions = instruct;
        
        char *sID = (char*)sqlite3_column_text(stmt, 23);
        NSString *sIDstr = [NSString stringWithUTF8String:sID];
        addCart.serverCartID = sIDstr;
        
        char *lId = (char*)sqlite3_column_text(stmt, 24);
        NSString *lIDstr = [NSString stringWithUTF8String:lId];
        addCart.randomCartID = lIDstr;
        
        char *logo = (char*)sqlite3_column_text(stmt, 25);
        NSString *logostr = [NSString stringWithUTF8String:logo];
        addCart.Logo = logostr;
        
        char *dist = (char*)sqlite3_column_text(stmt, 26);
        NSString *diststr = [NSString stringWithUTF8String:dist];
        addCart.distance = diststr;
        
        [cartDataArray addObject:addCart];
        
      }
    }
  }
  return cartDataArray;
}


- (NSDictionary*)getALlRestuarants
{
  const char *dbpath = [databasePath UTF8String];
  NSMutableDictionary  *dict  = [[NSMutableDictionary alloc]init];
  if (sqlite3_open(dbpath, &database) == SQLITE_OK)
  {
    sqlite3_stmt *stmt;
    NSString *queryStr = [NSString stringWithFormat:@"SELECT DISTINCT(reasturant_Name), restaurant_Id from UserSelectedAddToCartInfo GROUP BY reasturant_Name"];
    if (sqlite3_prepare(database, [queryStr UTF8String], -1, &stmt, nil) == SQLITE_OK)
    {
      while (sqlite3_step(stmt) == SQLITE_ROW)
      {
        char *rest_Name= (char*)sqlite3_column_text(stmt, 0);
        NSString *rName = [NSString stringWithUTF8String:rest_Name];
        
        NSInteger r_id = sqlite3_column_int(stmt, 1);
        [dict setValue:[NSNumber numberWithInteger:r_id] forKey:rName];
      }
    }
  }
  return dict;
}

- (int)getALlRestuarantswhereOrderIs:(NSString*)OrderMode andRestuarantId:(int)rID
{
  int count = 0;
  const char *dbpath = [databasePath UTF8String];
  if (sqlite3_open(dbpath, &database) == SQLITE_OK)
  {
    
     NSString *sqlStatement = [NSString stringWithFormat:@"SELECT COUNT(*) FROM UserSelectedAddToCartInfo WHERE restaurant_Id = '%d' and orderType = '%@' ",rID,OrderMode];
    sqlite3_stmt *statement;
    
    if( sqlite3_prepare_v2(database, [sqlStatement UTF8String], -1, &statement, NULL) == SQLITE_OK )
    {
      //Loop through all the returned rows (should be just one)
      while( sqlite3_step(statement) == SQLITE_ROW )
      {
        count = sqlite3_column_int(statement, 0);
      }
    }
    else
    {
      NSLog( @"Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(database) );
    }

  }
  return count;
}

-(NSString*)getOrderTypeForRestaurantID:(int)rID{
  NSString *orderType;
  const char *dbpath = [databasePath UTF8String];
  if (sqlite3_open(dbpath, &database) == SQLITE_OK)
  {
    sqlite3_stmt *stmt;
    NSString *queryStr = [NSString stringWithFormat:@"SELECT orderType FROM UserSelectedAddToCartInfo WHERE restaurant_Id = '%d'",rID];
    if (sqlite3_prepare(database, [queryStr UTF8String], -1, &stmt, nil) == SQLITE_OK)
    {
      while (sqlite3_step(stmt) == SQLITE_ROW)
      {
        char *orderTypeChar = (char*)sqlite3_column_text(stmt, 0);
        orderType = [NSString stringWithUTF8String:orderTypeChar];

      }
    }
  }
  return orderType;
}


-(BOOL)updateOrderModeIntoDB:(NSString*)restID andOrderMode:(NSString*)orderMode andDistance:(NSString*)dist{

  if ((dist == nil)||(dist == Nil)) {

  const char *dbpath = [databasePath UTF8String];
  if (sqlite3_open(dbpath, &database) == SQLITE_OK)
  {
    NSString *queryStr = [NSString stringWithFormat:@"UPDATE UserSelectedAddToCartInfo SET orderType = '%@' WHERE restaurant_Id = %@",orderMode,restID];
    const char *insert_stmt = [queryStr UTF8String];
    sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
    if (sqlite3_step(statement) == SQLITE_DONE)
    {
      return YES;
    }
    else {
      return NO;
    }
  }return NO;
  }else{
  
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
      NSString *queryStr = [NSString stringWithFormat:@"UPDATE UserSelectedAddToCartInfo SET orderType = '%@',Distance= '%@' WHERE restaurant_Id = %@",orderMode,dist,restID];
      const char *insert_stmt = [queryStr UTF8String];
      sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
      if (sqlite3_step(statement) == SQLITE_DONE)
      {
        return YES;
      }
      else {
        return NO;
      }
    }return NO;
  
  
  
  }
  return NO;
}

- (NSString*)getDistanceOfRestuarants:(NSString*)restID
{
  NSString *rDist;
  const char *dbpath = [databasePath UTF8String];
//  NSMutableDictionary  *dict  = [[NSMutableDictionary alloc]init];
  if (sqlite3_open(dbpath, &database) == SQLITE_OK)
  {
    sqlite3_stmt *stmt;
    NSString *queryStr = [NSString stringWithFormat:@"SELECT pkDistance from UserFilterResponseData WHERE ufp_id = %@",restID];
    if (sqlite3_prepare(database, [queryStr UTF8String], -1, &stmt, nil) == SQLITE_OK)
    {
      while (sqlite3_step(stmt) == SQLITE_ROW)
      {
        char *dist= (char*)sqlite3_column_text(stmt, 0);
        rDist = [NSString stringWithUTF8String:dist];
      }
    }
  }
  return rDist;
}

@end
