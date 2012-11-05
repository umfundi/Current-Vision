//
//  Products.h
//  Vision
//
//  Created by Ian Molesworth on 15/09/2012.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Product : NSManagedObject

@property (nonatomic, retain) NSString * brand;
@property (nonatomic, assign) NSInteger datecrea;
@property (nonatomic, retain) NSString * group1;
@property (nonatomic, retain) NSString * group2;
@property (nonatomic, retain) NSString * group3;
@property (nonatomic, retain) NSString * group4;
@property (nonatomic, retain) NSString * group5;
@property (nonatomic, retain) NSString * group6;
@property (nonatomic, retain) NSString * pcode;
@property (nonatomic, retain) NSString * pname;
@property (nonatomic, retain) NSString * size;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * pclass;

+ (NSArray *)AllProducts;

+ (Product *)ProductFromProductID:(NSString *)id_product;
+ (NSArray *)AllProductsFromBrand:(NSString *)brand;

@end
