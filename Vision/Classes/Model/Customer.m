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
@dynamic customerName;
@dynamic customerName2;
@dynamic fax;
@dynamic grade;
@dynamic groupName;
@dynamic groupType;
@dynamic id_customer;
@dynamic id_practice;
@dynamic id_user;
@dynamic isMain;
@dynamic postcode;
@dynamic province;
@dynamic sap_no;
@dynamic tel;
@dynamic website;
@synthesize practice;

- (void)loadPracticeAndValues
{
    NSManagedObjectContext *context = [User managedObjectContextForData];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Practice"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"practiceCode == %@", self.id_practice];
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

+ (NSArray *)allCustomers
{
    NSManagedObjectContext *context = [User managedObjectContextForData];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Customer"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    [fetchRequest setResultType:NSManagedObjectResultType];
    
    NSArray *customers = [context executeFetchRequest:fetchRequest error:nil];
    for (Customer *customer in customers)
        [customer loadPracticeAndValues];
    
    return customers;
}

+ (NSArray *)allGroups
{
    NSManagedObjectContext *context = [User managedObjectContextForData];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Customer"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    [fetchRequest setResultType:NSManagedObjectResultType];
    
    // Sort
    NSSortDescriptor *sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"groupName" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDesc]];
    
    NSMutableArray *groups = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSString *group = nil;
    for (Customer *customer in [context executeFetchRequest:fetchRequest error:nil])
    {
        if (!group || ![group isEqualToString:customer.groupName])
        {
            group = customer.groupName;
            [groups addObject:group];
        }
    }
    
    return groups;
}

+ (NSArray *)allCountries
{
    NSManagedObjectContext *context = [User managedObjectContextForData];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Customer"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    [fetchRequest setResultType:NSManagedObjectResultType];
    
    // Sort
    NSSortDescriptor *sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"country" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDesc]];
    
    NSMutableArray *countries = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSString *country = nil;
    for (Customer *customer in [context executeFetchRequest:fetchRequest error:nil])
    {
        if (!country || ![country isEqualToString:customer.country])
        {
            country = customer.country;
            [countries addObject:country];
        }
    }
    
    return countries;
}

+ (NSArray *)allCounties
{
    NSManagedObjectContext *context = [User managedObjectContextForData];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Customer"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    [fetchRequest setResultType:NSManagedObjectResultType];
    
    // Sort
    NSSortDescriptor *sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"province" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDesc]];
    
    NSMutableArray *counties = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSString *province = nil;
    for (Customer *customer in [context executeFetchRequest:fetchRequest error:nil])
    {
        if (!province || ![province isEqualToString:customer.province])
        {
            province = customer.province;
            [counties addObject:province];
        }
    }
    
    return counties;
}


+ (NSArray *)searchCustomerIDsWithField:(NSString *)aField andValue:(NSString *)aValue
{
    NSManagedObjectContext *context = [User managedObjectContextForData];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Customer"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@ == %%@", aField], aValue];
    [fetchRequest setPredicate:predicate];
    
    NSArray *customers = [context executeFetchRequest:fetchRequest error:nil];
    
    NSMutableArray *customerIDs = [[NSMutableArray alloc] initWithCapacity:customers.count];
    for (Customer *customer in customers)
        [customerIDs addObject:customer.id_customer];
    
    return customerIDs;
}

+ (NSArray *)searchCustomersWithField:(NSString *)aField andKey:(NSString *)aKey
{
    NSManagedObjectContext *context = [User managedObjectContextForData];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Customer"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@ CONTAINS[cd] %%@", aField], aKey];
    [fetchRequest setPredicate:predicate];
    
    return [context executeFetchRequest:fetchRequest error:nil];
}


+ (NSString *)CustomerNameFromID:(NSString *)id_customer
{
    NSManagedObjectContext *context = [User managedObjectContextForData];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Customer"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id_customer == %@", id_customer];
    [fetchRequest setPredicate:predicate];
    
    NSArray *customers = [context executeFetchRequest:fetchRequest error:nil];
    if ([customers count] != 1)
        return nil;
    
    Customer *customer = (Customer *)[customers objectAtIndex:0];

    return customer.customerName;
}

@end
