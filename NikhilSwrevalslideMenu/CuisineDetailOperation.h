//
//  CuisineDetailOperation.h
//  NikhilSwrevalslideMenu
//
//  Created by Sudarshan on 7/24/16.
//  Copyright © 2016 Nikhil Boriwale. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseOpeartion.h"
@interface CuisineDetailOperation : BaseOpeartion
@property(nonatomic,strong)NSString *selectedId;
@end

@interface CuisineDetailResponse : NSObject

@property(nonatomic,strong)NSString *customizable;
@property(nonatomic,strong)NSString *cdescription;
@property(nonatomic,strong)NSString *cuisine_id;
@property(nonatomic,strong)NSString *price;
@property(nonatomic,strong)NSString *sub_category;
@property(nonatomic,strong)NSString *rest_id;
@end