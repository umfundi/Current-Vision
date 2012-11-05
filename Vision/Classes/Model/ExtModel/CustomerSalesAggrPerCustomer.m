//
//  CustomerSalesAggrPerGroup.m
//  Vision
//
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import "CustomerSalesAggrPerCustomer.h"

#import "User.h"
#import "Customer.h"
#import "Practice.h"
#import "CustomerSalesAggrPerYear.h"

@implementation CustomerSalesAggrPerCustomer

@synthesize id_customer;
@synthesize customerName;
@synthesize aggrPerYears;

+ (NSArray *)CustomerSalesGroupByGroupFrom:(NSString *)aField andValue:(NSString *)aValue YTDorMAT:(BOOL)isYTD
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
    
    NSMutableArray *sales = [[NSMutableArray alloc] initWithCapacity:0];

    CustomerSalesAggrPerCustomer *aggrPerGroup = [[CustomerSalesAggrPerCustomer alloc] init];
    for (NSDictionary *report in reports)
    {
        NSString *id_customer = [report objectForKey:@"id_customer"];
        NSString *period = [report objectForKey:@"period"];
        
        NSRange seperator_range = [period rangeOfString:@"-"];
        if (seperator_range.location != NSNotFound)
        {
            period = [period substringFromIndex:seperator_range.location + 1];
            
            seperator_range = [period rangeOfString:@"/"];
            if (seperator_range.location != NSNotFound)
                period = [period substringFromIndex:seperator_range.location + 1];
        }
        
        if (aggrPerGroup.id_customer == nil)
        {
            aggrPerGroup.id_customer = id_customer;
            aggrPerGroup.customerName = [Customer CustomerNameFromID:id_customer];
        }
        else if (![aggrPerGroup.id_customer isEqualToString:id_customer])
        {
            for (CustomerSalesAggrPerYear *aggrPerYear in aggrPerGroup.aggrPerYears)
                [aggrPerYear finishAdd];
            
            [sales addObject:aggrPerGroup];
            
            aggrPerGroup = [[CustomerSalesAggrPerCustomer alloc] init];
            aggrPerGroup.id_customer = id_customer;
            aggrPerGroup.customerName = [Customer CustomerNameFromID:id_customer];
        }
        
        CustomerSalesAggrPerYear *aggrPerYear;
        for (aggrPerYear in aggrPerGroup.aggrPerYears)
        {
            if ([aggrPerYear.year isEqualToString:period])
                break;
        }
        
        if (!aggrPerYear)
        {
            aggrPerYear = [[CustomerSalesAggrPerYear alloc] init];
            aggrPerYear.year = period;
            
            [aggrPerGroup addAggrPerYear:aggrPerYear];
        }

        [aggrPerYear addCustomerSale:report YTDorMAT:isYTD];
    }
    
    for (CustomerSalesAggrPerYear *aggrPerYear in aggrPerGroup.aggrPerYears)
        [aggrPerYear finishAdd];
    
    if (aggrPerGroup.id_customer)
        [sales addObject:aggrPerGroup];
    
    
    /* Add Total */
    if ([sales count] > 0)
    {
        CustomerSalesAggrPerCustomer *totalAggr = [[CustomerSalesAggrPerCustomer alloc] init];
        totalAggr.customerName = @"Total";
        
        for (CustomerSalesAggrPerCustomer *aggrPerCustomer in sales)
        {
            for (CustomerSalesAggrPerYear *aggrPerYear in aggrPerCustomer.aggrPerYears)
            {
                CustomerSalesAggrPerYear *totalAggrPerYear;
                for (totalAggrPerYear in totalAggr.aggrPerYears)
                {
                    if ([aggrPerYear.year isEqualToString:totalAggrPerYear.year])
                        break;
                }
                
                if (!totalAggrPerYear)
                {
                    totalAggrPerYear = [[CustomerSalesAggrPerYear alloc] init];
                    totalAggrPerYear.year = aggrPerYear.year;
                    [totalAggr addAggrPerYear:totalAggrPerYear];
                }
                
                totalAggrPerYear.jan += aggrPerYear.jan;
                totalAggrPerYear.feb += aggrPerYear.feb;
                totalAggrPerYear.mar += aggrPerYear.mar;
                totalAggrPerYear.apr += aggrPerYear.apr;
                totalAggrPerYear.may += aggrPerYear.may;
                totalAggrPerYear.jun += aggrPerYear.jun;
                totalAggrPerYear.jul += aggrPerYear.jul;
                totalAggrPerYear.aug += aggrPerYear.aug;
                totalAggrPerYear.sep += aggrPerYear.sep;
                totalAggrPerYear.oct += aggrPerYear.oct;
                totalAggrPerYear.nov += aggrPerYear.nov;
                totalAggrPerYear.dec += aggrPerYear.dec;
            }
        }
        for (CustomerSalesAggrPerYear *aggrPerYear in totalAggr.aggrPerYears)
            [aggrPerYear finishAdd];

        [sales insertObject:totalAggr atIndex:0];
    }
    
    /* Growth */
    for (CustomerSalesAggrPerCustomer *aggrPerCustomer in sales)
    {
        CustomerSalesAggrPerYear *prvAggrPerYear = nil;
        double prvVal;
        for (CustomerSalesAggrPerYear *aggrPerYear in aggrPerCustomer.aggrPerYears)
        {
            if (prvAggrPerYear == nil)
            {
                aggrPerYear.growth = @"";
                prvAggrPerYear = aggrPerYear;
                prvVal = aggrPerYear.jan + aggrPerYear.feb + aggrPerYear.mar + aggrPerYear.apr + aggrPerYear.may + aggrPerYear.jun + aggrPerYear.jul + aggrPerYear.aug + aggrPerYear.sep + aggrPerYear.oct + aggrPerYear.nov + aggrPerYear.sep;
                continue;
            }
            
            double curVal = aggrPerYear.jan + aggrPerYear.feb + aggrPerYear.mar + aggrPerYear.apr + aggrPerYear.may + aggrPerYear.jun + aggrPerYear.jul + aggrPerYear.aug + aggrPerYear.sep + aggrPerYear.oct + aggrPerYear.nov + aggrPerYear.sep;
            if (prvVal == 0)
                aggrPerYear.growth = @"";
            else
                aggrPerYear.growth = [NSString stringWithFormat:@"%.0f%%", round((curVal / prvVal - 1) * 100)];
        }
    }
    
    return sales;
}

+ (NSArray *)CustomerSalesGroupByGroupFromCustomers:(NSString *)aField andValue:(NSString *)aValue YTDorMAT:(BOOL)isYTD
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
    
    NSMutableArray *sales = [[NSMutableArray alloc] initWithCapacity:0];
    
    CustomerSalesAggrPerCustomer *aggrPerCustomer = [[CustomerSalesAggrPerCustomer alloc] init];
    CustomerSalesAggrPerYear *aggrPerYear = [[CustomerSalesAggrPerYear alloc] init];
    for (NSDictionary *report in reports)
    {
        NSString *id_customer = [report objectForKey:@"id_customer"];
        NSString *period = [report objectForKey:@"period"];
        
        NSRange seperator_range = [period rangeOfString:@"-"];
        if (seperator_range.location != NSNotFound)
        {
            period = [period substringFromIndex:seperator_range.location + 1];
            
            seperator_range = [period rangeOfString:@"/"];
            if (seperator_range.location != NSNotFound)
                period = [period substringFromIndex:seperator_range.location + 1];
        }
        
        if (aggrPerCustomer.id_customer == nil)
        {
            aggrPerCustomer.id_customer = id_customer;
            aggrPerCustomer.customerName = [Customer CustomerNameFromID:id_customer];
        }
        else if (![aggrPerCustomer.id_customer isEqualToString:id_customer])
        {
            for (CustomerSalesAggrPerYear *aggrPerYear in aggrPerCustomer.aggrPerYears)
                [aggrPerYear finishAdd];
            
            [sales addObject:aggrPerCustomer];
            
            aggrPerCustomer = [[CustomerSalesAggrPerCustomer alloc] init];
            aggrPerCustomer.id_customer = id_customer;
            aggrPerCustomer.customerName = [Customer CustomerNameFromID:id_customer];
        }
        
        CustomerSalesAggrPerYear *aggrPerYear;
        for (aggrPerYear in aggrPerCustomer.aggrPerYears)
        {
            if ([aggrPerYear.year isEqualToString:period])
                break;
        }
        
        if (!aggrPerYear)
        {
            aggrPerYear = [[CustomerSalesAggrPerYear alloc] init];
            aggrPerYear.year = period;
            
            [aggrPerCustomer addAggrPerYear:aggrPerYear];
        }
        
        [aggrPerYear addCustomerSale:report YTDorMAT:isYTD];
    }
    
    if (aggrPerYear.year)
    {
        [aggrPerYear finishAdd];
        [aggrPerCustomer addAggrPerYear:aggrPerYear];
    }
    
    if (aggrPerCustomer.id_customer)
        [sales addObject:aggrPerCustomer];
    
    
    /* Add Total */
    if ([sales count] > 0)
    {
        CustomerSalesAggrPerCustomer *totalAggr = [[CustomerSalesAggrPerCustomer alloc] init];
        totalAggr.customerName = @"Total";
        
        for (CustomerSalesAggrPerCustomer *aggrPerCustomer in sales)
        {
            for (CustomerSalesAggrPerYear *aggrPerYear in aggrPerCustomer.aggrPerYears)
            {
                CustomerSalesAggrPerYear *totalAggrPerYear;
                for (totalAggrPerYear in totalAggr.aggrPerYears)
                {
                    if ([aggrPerYear.year isEqualToString:totalAggrPerYear.year])
                        break;
                }
                
                if (!totalAggrPerYear)
                {
                    totalAggrPerYear = [[CustomerSalesAggrPerYear alloc] init];
                    totalAggrPerYear.year = aggrPerYear.year;
                    [totalAggr addAggrPerYear:totalAggrPerYear];
                }
                
                totalAggrPerYear.jan += aggrPerYear.jan;
                totalAggrPerYear.feb += aggrPerYear.feb;
                totalAggrPerYear.mar += aggrPerYear.mar;
                totalAggrPerYear.apr += aggrPerYear.apr;
                totalAggrPerYear.may += aggrPerYear.may;
                totalAggrPerYear.jun += aggrPerYear.jun;
                totalAggrPerYear.jul += aggrPerYear.jul;
                totalAggrPerYear.aug += aggrPerYear.aug;
                totalAggrPerYear.sep += aggrPerYear.sep;
                totalAggrPerYear.oct += aggrPerYear.oct;
                totalAggrPerYear.nov += aggrPerYear.nov;
                totalAggrPerYear.dec += aggrPerYear.dec;
            }
        }
        for (CustomerSalesAggrPerYear *aggrPerYear in totalAggr.aggrPerYears)
            [aggrPerYear finishAdd];

        [sales insertObject:totalAggr atIndex:0];
    }
    
    /* Growth */
    for (CustomerSalesAggrPerCustomer *aggrPerCustomer in sales)
    {
        CustomerSalesAggrPerYear *prvAggrPerYear = nil;
        double prvVal;
        for (CustomerSalesAggrPerYear *aggrPerYear in aggrPerCustomer.aggrPerYears)
        {
            if (prvAggrPerYear == nil)
            {
                aggrPerYear.growth = @"";
                prvAggrPerYear = aggrPerYear;
                prvVal = aggrPerYear.jan + aggrPerYear.feb + aggrPerYear.mar + aggrPerYear.apr + aggrPerYear.may + aggrPerYear.jun + aggrPerYear.jul + aggrPerYear.aug + aggrPerYear.sep + aggrPerYear.oct + aggrPerYear.nov + aggrPerYear.sep;
                continue;
            }
            
            double curVal = aggrPerYear.jan + aggrPerYear.feb + aggrPerYear.mar + aggrPerYear.apr + aggrPerYear.may + aggrPerYear.jun + aggrPerYear.jul + aggrPerYear.aug + aggrPerYear.sep + aggrPerYear.oct + aggrPerYear.nov + aggrPerYear.sep;
            if (prvVal == 0)
                aggrPerYear.growth = @"";
            else
                aggrPerYear.growth = [NSString stringWithFormat:@"%.0f%%", round((curVal / prvVal - 1) * 100)];
        }
    }

    return sales;
}


- (void)addAggrPerYear:(CustomerSalesAggrPerYear *)aggrPerYear
{
    if (!aggrPerYears)
        aggrPerYears = [[NSMutableArray alloc] initWithCapacity:0];
    
    [aggrPerYears addObject:aggrPerYear];
}

@end
