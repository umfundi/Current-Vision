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

+ (NSArray *)CustomerSalesGroupByGroupFrom:(NSArray *)reports YTDorMAT:(BOOL)isYTD isFull:(BOOL)isFull
{
    NSMutableArray *sales = [[NSMutableArray alloc] initWithCapacity:0];

    CustomerSalesAggrPerCustomer *aggrPerGroup = [[CustomerSalesAggrPerCustomer alloc] init];
    for (NSDictionary *report in reports)
    {
        NSString *id_customer = [report objectForKey:@"id_customer"];
        NSString *period = [report objectForKey:@"period"];
        if (isYTD || isFull)
        {
            NSRange seperator_range = [period rangeOfString:@"-"];
            if (seperator_range.location != NSNotFound)
            {
                period = [period substringFromIndex:seperator_range.location + 1];
                
                seperator_range = [period rangeOfString:@"/"];
                if (seperator_range.location != NSNotFound)
                    period = [period substringFromIndex:seperator_range.location + 1];
            }
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
        CustomerSalesAggrPerYear *prvAggrPerYear;
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
        [aggrPerYear addCustomerSale:report YTDorMAT:isYTD isFull:isFull Year:period];
        
        if (isYTD || isFull)
        {
            NSString *prevYear = [NSString stringWithFormat:@"%d", [period integerValue] - 1];
            for (prvAggrPerYear in aggrPerGroup.aggrPerYears)
            {
                if ([prvAggrPerYear.year isEqualToString:prevYear])
                    break;
            }
            if (!prvAggrPerYear)
            {
                prvAggrPerYear = [[CustomerSalesAggrPerYear alloc] init];
                prvAggrPerYear.year = prevYear;
                
                [aggrPerGroup addAggrPerYear:prvAggrPerYear];
            }
            [prvAggrPerYear addCustomerSale:report YTDorMAT:isYTD isFull:isFull Year:period];
        }
    }
    
    for (CustomerSalesAggrPerYear *aggrPerYear in aggrPerGroup.aggrPerYears)
        [aggrPerYear finishAdd];
    
    if (aggrPerGroup.id_customer)
        [sales addObject:aggrPerGroup];

    if (isYTD || isFull)
    {
        for (CustomerSalesAggrPerCustomer *aggrPerCustomer in sales)
            [aggrPerCustomer.aggrPerYears removeLastObject];
    }
    
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
                
                for (NSInteger i = 0 ; i < 12 ; i ++)
                    totalAggrPerYear.monthValArray[i] += aggrPerYear.monthValArray[i];
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
        double prvVal = 0;
        CustomerSalesAggrPerYear *aggrPerYear;
        for (NSInteger i = aggrPerCustomer.aggrPerYears.count - 1 ; i >= 0 ; i -- )
        {
            aggrPerYear = [aggrPerCustomer.aggrPerYears objectAtIndex:i];
            if (prvAggrPerYear == nil)
            {
                aggrPerYear.growth = @"";
                prvAggrPerYear = aggrPerYear;

                for (NSInteger i = 0 ; i < 12 ; i ++ )
                    prvVal += aggrPerYear.monthValArray[i];
                continue;
            }
            
            double curVal = 0;
            for (NSInteger i = 0 ; i < 12 ; i ++ )
                curVal += aggrPerYear.monthValArray[i];

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
    
    NSInteger index = 0;
    for (CustomerSalesAggrPerYear *aggr in aggrPerYears)
    {
        if ([aggr.year compare:aggrPerYear.year] == NSOrderedAscending)
        {
            [aggrPerYears insertObject:aggrPerYear atIndex:index];
            return;
        }

        index ++;
    }
    
    [aggrPerYears addObject:aggrPerYear];
}

@end
