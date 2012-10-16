//
//  Customers.m
//  Vision
//
//  Created by Ian Molesworth on 15/09/2012.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import "Customer.h"

#import "User.h"
#import "Practice.h"
#import "SALES_REPORT_Customer_OrderBy.h"
#import "CustomerAggr.h"

@implementation Customer

@dynamic address1;
@dynamic address2;
@dynamic address3;
@dynamic brick;
@dynamic city;
@dynamic country;
@dynamic customername;
@dynamic customername2;
@dynamic fax;
@dynamic grade;
@dynamic groupname;
@dynamic grouptype;
@dynamic id_customer;
@dynamic id_practice;
@dynamic id_user;
@dynamic ismain;
@dynamic postcode;
@dynamic province;
@dynamic sap_no;
@dynamic tel;
@dynamic website;
@dynamic practice;

- (void)loadPracticeAndValues
{
    NSManagedObjectContext *context = [User managedObjectContextForData];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Practice"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"practicecode == %@", self.id_practice];
    [fetchRequest setPredicate:predicate];
    
    NSArray *array = [context executeFetchRequest:fetchRequest error:nil];
    if ([array count] > 0)
        self.practice = [array objectAtIndex:0];
    NSLog(@"%@", array);
    
    aggr = [CustomerAggr AggrFrom:self.id_customer];
}

- (CustomerAggr *)aggrValue
{
    return aggr;
}


+ (Customer *)firstCustomer
{
    NSManagedObjectContext *context = [User managedObjectContextForData];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Customer"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setFetchLimit:1];

    NSArray *customers = [context executeFetchRequest:fetchRequest error:nil];
    if ([customers count] > 0)
        return [customers objectAtIndex:0];
    
    return nil;
}

@end
