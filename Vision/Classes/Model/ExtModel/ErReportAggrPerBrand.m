//
//  ErReportAggrPerBrand.m
//  Vision
//
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import "ErReportAggrPerBrand.h"

#import "User.h"
#import "Customer.h"
#import "Product.h"
#import "Focused_brand.h"
#import "ErReportAggrPerYear.h"

@implementation ErReportAggrPerBrand

@synthesize brand;
@synthesize aggrPerYears;

+ (NSArray *)ErReportGroupByBrandFrom:(NSString *)aField andValue:(NSString *)aValue YTDorMAT:(BOOL)isYTD
{
    NSManagedObjectContext *context = [User managedObjectContextForData];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:isYTD ? @"SALES_REPORT_by_Products_YTD" : @"SALES_REPORT_by_Products_MAT"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setResultType:NSDictionaryResultType];
    
    // Sort
    NSSortDescriptor *sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"id_product" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDesc]];
    
    NSString *format = [NSString stringWithFormat:@"%@ == %%@", aField];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:format, aValue];
    [fetchRequest setPredicate:predicate];
    
    NSArray *reports = [context executeFetchRequest:fetchRequest error:nil];
    
    return [ErReportAggrPerBrand ErReportGroupByBrandFrom:reports YTDorMAT:isYTD];
}

+ (NSArray *)ErReportGroupByBrandFromCustomers:(NSString *)aField andValue:(NSString *)aValue YTDorMAT:(BOOL)isYTD
{
    NSArray *filteredCustomers = [Customer searchCustomerIDsWithField:aField andValue:aValue];
    
    NSManagedObjectContext *context = [User managedObjectContextForData];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:isYTD ? @"SALES_REPORT_by_Products_YTD" : @"SALES_REPORT_by_Products_MAT"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setResultType:NSDictionaryResultType];
    
    // Sort
    NSSortDescriptor *sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"id_product" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDesc]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id_customer in %@", filteredCustomers];
    [fetchRequest setPredicate:predicate];
    
    NSArray *reports = [context executeFetchRequest:fetchRequest error:nil];
    
    return [ErReportAggrPerBrand ErReportGroupByBrandFrom:reports YTDorMAT:isYTD];
}

+ (NSArray *)ErReportGroupByBrandFrom:(NSArray *)reports YTDorMAT:(BOOL)isYTD
{
    NSMutableDictionary *sales = [[NSMutableDictionary alloc] initWithCapacity:0];
    NSMutableDictionary *totalSales = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    BOOL isCompanion = [[User loginUser].data isEqualToString:@"companion"];
    
    for (NSDictionary *report in reports)
    {
        NSString *id_product = [report objectForKey:@"id_product"];
        NSString *pclass = [Product ClassFromProductID:id_product];
        NSString *brand = [Product BrandFromProductID:id_product];
        NSString *class = [Focused_brand brandClassFromName:brand];
        if (![class isEqualToString:@"FOCUSED"] && ![class isEqualToString:isCompanion ? @"companion" : @"ruminant"])
            continue;
        
        NSString *period = [report objectForKey:@"period"];
        NSRange seperator_range = [period rangeOfString:@"-"];
        if (seperator_range.location != NSNotFound)
        {
            period = [period substringFromIndex:seperator_range.location + 1];
            
            seperator_range = [period rangeOfString:@"/"];
            if (seperator_range.location != NSNotFound)
                period = [period substringFromIndex:seperator_range.location + 1];
        }
        
        ErReportAggrPerBrand *totalAggrPerClass = [totalSales objectForKey:pclass];
        if (!totalAggrPerClass)
        {
            totalAggrPerClass = [[ErReportAggrPerBrand alloc] init];
            totalAggrPerClass.brand = pclass;
            
            [totalSales setObject:totalAggrPerClass forKey:pclass];
        }
        
        ErReportAggrPerBrand *aggrPerBrand = [sales objectForKey:brand];
        if (!aggrPerBrand)
        {
            aggrPerBrand = [[ErReportAggrPerBrand alloc] init];
            aggrPerBrand.brand = brand;
            
            [sales setObject:aggrPerBrand forKey:brand];
        }
        
        ErReportAggrPerYear *aggrPerYear;
        for (aggrPerYear in totalAggrPerClass.aggrPerYears)
        {
            if ([aggrPerYear.year isEqualToString:period])
                break;
        }
        if (!aggrPerYear)
        {
            aggrPerYear = [[ErReportAggrPerYear alloc] init];
            aggrPerYear.year = period;
            
            [totalAggrPerClass addAggrPerYear:aggrPerYear];
        }
        [aggrPerYear addErReport:report YTDorMAT:isYTD];

        
        for (aggrPerYear in aggrPerBrand.aggrPerYears)
        {
            if ([aggrPerYear.year isEqualToString:period])
                break;
        }
        
        if (!aggrPerYear)
        {
            aggrPerYear = [[ErReportAggrPerYear alloc] init];
            aggrPerYear.year = period;
            
            [aggrPerBrand addAggrPerYear:aggrPerYear];
        }
        
        [aggrPerYear addErReport:report YTDorMAT:isYTD];
    }
    
    for (ErReportAggrPerBrand *aggrPerBrand in totalSales.allValues)
    {
        for (ErReportAggrPerYear *aggrPerYear in aggrPerBrand.aggrPerYears)
            [aggrPerYear finishAdd];
    }
    
    for (ErReportAggrPerBrand *aggrPerBrand in sales.allValues)
    {
        for (ErReportAggrPerYear *aggrPerYear in aggrPerBrand.aggrPerYears)
            [aggrPerYear finishAdd];
    }
    
    
    NSMutableArray *erReport = [[NSMutableArray alloc] initWithArray:sales.allValues];
    
    /* Add Total */
    if ([sales count] != 0)
    {
        ErReportAggrPerBrand *totalAggr = [[ErReportAggrPerBrand alloc] init];
        totalAggr.brand = @"Total";
        
        for (ErReportAggrPerBrand *aggrPerCustomer in sales.allValues)
        {
            for (ErReportAggrPerYear *aggrPerYear in aggrPerCustomer.aggrPerYears)
            {
                ErReportAggrPerYear *totalAggrPerYear;
                for (totalAggrPerYear in totalAggr.aggrPerYears)
                {
                    if ([aggrPerYear.year isEqualToString:totalAggrPerYear.year])
                        break;
                }
                
                if (!totalAggrPerYear)
                {
                    totalAggrPerYear = [[ErReportAggrPerYear alloc] init];
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
        for (ErReportAggrPerYear *aggrPerYear in totalAggr.aggrPerYears)
            [aggrPerYear finishAdd];
        
        [erReport insertObject:totalAggr atIndex:0];
    }
    [erReport addObjectsFromArray:totalSales.allValues];

    /* Growth */
    for (ErReportAggrPerBrand *aggrPerCustomer in erReport)
    {
        ErReportAggrPerYear *prvAggrPerYear = nil;
        double prvVal;
        for (ErReportAggrPerYear *aggrPerYear in aggrPerCustomer.aggrPerYears)
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
    
    for (ErReportAggrPerBrand *aggrPerCustomer in totalSales.allValues)
    {
        while (aggrPerCustomer.aggrPerYears.count > 1)
            [aggrPerCustomer.aggrPerYears removeLastObject];
        
        ErReportAggrPerYear *aggrPerYear = [aggrPerCustomer.aggrPerYears lastObject];
        aggrPerYear.year = [@"Total " stringByAppendingString:aggrPerCustomer.brand];
        
        aggrPerCustomer.brand = nil;
    }

    return erReport;
}

- (void)addAggrPerYear:(ErReportAggrPerYear *)aggrPerYear
{
    if (!aggrPerYears)
        aggrPerYears = [[NSMutableArray alloc] initWithCapacity:0];
    
    [aggrPerYears addObject:aggrPerYear];
}

@end
