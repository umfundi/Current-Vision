//
//  Practices.h
//  Vision
//
//  Created by Ian Molesworth on 15/09/2012.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Customer;
@class PracticeAggr;

@interface Practice : NSManagedObject
{
    PracticeAggr *aggr;
}

@property (nonatomic, retain) NSString * add1;
@property (nonatomic, retain) NSString * add2;
@property (nonatomic, retain) NSString * brick;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSString * fax;
@property (nonatomic, assign) NSInteger isActive;
@property (nonatomic, retain) NSString * postcode;
@property (nonatomic, retain) NSString * practiceCode;
@property (nonatomic, retain) NSString * practiceName;
@property (nonatomic, retain) NSString * province;
@property (nonatomic, retain) NSString * sap_no;
@property (nonatomic, retain) NSString * tel;

@property (nonatomic, retain) NSSet *customers;

+ (Practice *)firstPractice;
+ (NSArray *)allPractices;

- (void)loadCustomers;
- (void)loadAggrValues;
- (PracticeAggr *)aggrValue;

+ (NSString *)PracticeNameFrom:(NSString *)id_practice;

+ (NSArray *)searchPracticesWithField:(NSString *)aField andKey:(NSString *)aKey;

@end

@interface Practice (CoreDataGeneratedAccessors)

- (void)addCustomerObject:(Customer *)value;
- (void)removeCustomerObject:(Customer *)value;
- (void)addCustomer:(NSSet *)values;
- (void)removeCustomer:(NSSet *)values;

@end
