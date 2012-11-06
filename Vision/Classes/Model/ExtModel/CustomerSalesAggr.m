//
//  CustomerSalesAggr.m
//  Vision
//
//  Created by Jin on 11/6/12.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import "CustomerSalesAggr.h"

#import "User.h"
#import "Customer.h"
#import "umfundiCommon.h"
#import "CustomerSalesAggrPerCustomer.h"

@implementation CustomerSalesAggr

@synthesize monthArray;
@synthesize aggrPerCustomers;

- (id)initWithYTDorMAT:(BOOL)isYTD isFull:(BOOL)isFull
{
    self = [super init];
    if (self)
    {
        NSInteger currentMonth;
        if (isYTD || isFull)
            currentMonth = 1;
        else
            currentMonth = [[User loginUser] monthForData];
        
        monthArray = [NSArray arrayWithObjects:[umfundiCommon monthString:currentMonth],
                      [umfundiCommon monthString:currentMonth + 1],
                      [umfundiCommon monthString:currentMonth + 2],
                      [umfundiCommon monthString:currentMonth + 3],
                      [umfundiCommon monthString:currentMonth + 4],
                      [umfundiCommon monthString:currentMonth + 5],
                      [umfundiCommon monthString:currentMonth + 6],
                      [umfundiCommon monthString:currentMonth + 7],
                      [umfundiCommon monthString:currentMonth + 8],
                      [umfundiCommon monthString:currentMonth + 9],
                      [umfundiCommon monthString:currentMonth + 10],
                      [umfundiCommon monthString:currentMonth + 11], nil];
    }
    
    return self;
}

+ (CustomerSalesAggr *)aggrFromAggrPerCustomersArray:(NSArray *)aggrPerCustomers YTDorMAT:(BOOL)isYTD isFull:(BOOL)isFull
{
    CustomerSalesAggr *aggr = [[CustomerSalesAggr alloc] initWithYTDorMAT:isYTD isFull:isFull];
    aggr.aggrPerCustomers = aggrPerCustomers;
    return aggr;
}


+ (CustomerSalesAggr *)CustomerSalesGroupByGroupFrom:(NSString *)aField andValue:(NSString *)aValue YTDorMAT:(BOOL)isYTD isFull:(BOOL)isFull
{
    NSManagedObjectContext *context = [User managedObjectContextForData];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:isYTD ? @"SALES_REPORT_by_Products_YTD" : @"SALES_REPORT_by_Products_MAT"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setResultType:NSDictionaryResultType];
    
    // Sort
    NSSortDescriptor *sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"id_customer" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDesc]];
    
    NSString *format = [NSString stringWithFormat:@"%@ == %%@", aField];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:format, aValue];
    [fetchRequest setPredicate:predicate];
    
    NSArray *reports = [context executeFetchRequest:fetchRequest error:nil];
    
    return [CustomerSalesAggr aggrFromAggrPerCustomersArray:[CustomerSalesAggrPerCustomer CustomerSalesGroupByGroupFrom:reports YTDorMAT:isYTD isFull:isFull] YTDorMAT:isYTD isFull:isFull];
}

+ (CustomerSalesAggr *)CustomerSalesGroupByGroupFromCustomers:(NSString *)aField andValue:(NSString *)aValue YTDorMAT:(BOOL)isYTD isFull:(BOOL)isFull
{
    NSArray *filteredCustomers = [Customer searchCustomerIDsWithField:aField andValue:aValue];
    
    NSManagedObjectContext *context = [User managedObjectContextForData];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:isYTD ? @"SALES_REPORT_by_Products_YTD" : @"SALES_REPORT_by_Products_MAT"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setResultType:NSDictionaryResultType];
    
    // Sort
    NSSortDescriptor *sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"id_customer" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDesc]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id_customer in %@", filteredCustomers];
    [fetchRequest setPredicate:predicate];
    
    NSArray *reports = [context executeFetchRequest:fetchRequest error:nil];

    return [CustomerSalesAggr aggrFromAggrPerCustomersArray:[CustomerSalesAggrPerCustomer CustomerSalesGroupByGroupFrom:reports YTDorMAT:isYTD isFull:isFull] YTDorMAT:isYTD isFull:isFull];
}

@end
