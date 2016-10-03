//
//  FilterOperations.h
//  NikhilSwrevalslideMenu
//
//  Created by Sudarshan on 7/21/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseOpeartion.h"
@interface FilterOperations : BaseOpeartion
+(FilterOperations*)getSharedInstance;
@property(nonatomic,strong)NSMutableArray *selectedCusinesArray;
@property(nonatomic,strong)NSMutableArray *selectedFeaturesArray;
@property(nonatomic,assign)int ratings;
@property(nonatomic,assign)double pricing;
@property(nonatomic,assign)int delivery_status;
@property(nonatomic,strong)NSString *address;
@property(nonatomic,strong)NSString *sorting;
@property(nonatomic,strong)NSString *action1;
@property(nonatomic,strong)NSString *search;
@property(nonatomic,assign)NSString *min_order_amount;
@end



