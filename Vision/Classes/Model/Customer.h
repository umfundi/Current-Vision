//
//  Customers.h
//  Vision
//
//  Created by Ian Molesworth on 15/09/2012.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@class Practice;
@class CustomerAggr;

@interface Customer : NSManagedObject
{
    CustomerAggr *aggr;
}

@property (nonatomic, retain) NSString * address1;
@property (nonatomic, retain) NSString * address2;
@property (nonatomic, retain) NSString * address3;
@property (nonatomic, retain) NSString * brick;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSString * customerName;
@property (nonatomic, retain) NSString * customerName2;
@property (nonatomic, retain) NSString * fax;
@property (nonatomic, retain) NSString * grade;
@property (nonatomic, retain) NSString * groupName;
@property (nonatomic, retain) NSString * groupType;
@property (nonatomic, retain) NSString * id_customer;
@property (nonatomic, retain) NSString * id_practice;
@property (nonatomic, retain) NSString * id_user;
@property (nonatomic, retain) NSString * isMain;
@property (nonatomic, retain) NSString * postcode;
@property (nonatomic, retain) NSString * province;
@property (nonatomic, retain) NSString * sap_no;
@property (nonatomic, retain) NSString * tel;
@property (nonatomic, retain) NSString * website;
@property (nonatomic, retain) Practice *practice;

- (void)loadPracticeAndValues;
- (CustomerAggr *)aggrValue;

+ (Customer *)firstCustomer;

@end
