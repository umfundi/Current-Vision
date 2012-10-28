//
//  FocusedBrands.h
//  Vision
//
//  Created by Ian Molesworth on 15/09/2012.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Focused_brand : NSManagedObject

@property (nonatomic, retain) NSString * brand_class;
@property (nonatomic, retain) NSString * brand_name;
@property (nonatomic, retain) NSString * rank;

+ (NSArray *)AllBrands;

+ (NSString *)brandClassFromName:(NSString *)brandName;

@end
