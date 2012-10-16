//
//  CustomerSalesAggrPerGroup.m
//  Vision
//
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import "CustomerSalesAggrPerGroup.h"

#import "User.h"
#import "CustomerSalesAggrPerYear.h"

@implementation CustomerSalesAggrPerGroup

@synthesize group;
@synthesize aggrPerYears;

#warning CustomerSales Group By Group
+ (NSArray *)CustomerSalesGroupByGroupFrom:(NSString *)customer
{
    NSManagedObjectContext *context = [User managedObjectContextForData];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SALES_REPORT_Customer_OrderBy"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setResultType:NSDictionaryResultType];
    
    // Sort
    NSSortDescriptor *sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"groupname" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDesc]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id_customer == %@", customer];
    [fetchRequest setPredicate:predicate];
    
    NSArray *reports = [context executeFetchRequest:fetchRequest error:nil];
    
    NSMutableArray *sales = [[NSMutableArray alloc] initWithCapacity:0];
    
    CustomerSalesAggrPerGroup *aggrPerGroup = [[CustomerSalesAggrPerGroup alloc] init];
    CustomerSalesAggrPerYear *aggrPerYear = [[CustomerSalesAggrPerYear alloc] init];
    for (NSDictionary *report in reports)
    {
        NSString *group = [report objectForKey:@"groupname"];
        NSString *year = @"2012";
        
        if (aggrPerGroup.group == nil)
            aggrPerGroup.group = group;
        else if (![aggrPerGroup.group isEqualToString:group])
        {
            if (aggrPerYear.year)
            {
                [aggrPerYear finishAdd];
                [aggrPerGroup addAggrPerYear:aggrPerYear];
            }
            
            [sales addObject:aggrPerGroup];
            
            aggrPerGroup = [[CustomerSalesAggrPerGroup alloc] init];
            aggrPerGroup.group = group;
        }
        
        if (aggrPerYear.year == nil)
            aggrPerYear.year = year;
        else if (![aggrPerYear.year isEqualToString:year])
        {
            [aggrPerYear finishAdd];
            [aggrPerGroup addAggrPerYear:aggrPerYear];
            
            aggrPerYear = [[CustomerSalesAggrPerYear alloc] init];
            aggrPerYear.year = year;
        }
        
        [aggrPerYear addCustomerSale:report];
    }
    
    if (aggrPerYear.year)
    {
        [aggrPerYear finishAdd];
        [aggrPerGroup addAggrPerYear:aggrPerYear];
    }
    
    if (aggrPerGroup.group)
        [sales addObject:aggrPerGroup];
    
    return sales;
}

- (void)addAggrPerYear:(CustomerSalesAggrPerYear *)aggrPerYear
{
    if (!aggrPerYears)
        aggrPerYears = [[NSMutableArray alloc] initWithCapacity:0];
    
    [aggrPerYears addObject:aggrPerYear];
}

@end
