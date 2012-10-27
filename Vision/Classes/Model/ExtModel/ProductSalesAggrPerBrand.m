//
//  ProductSalesAggrPerBrand.m
//  Vision
//
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import "ProductSalesAggrPerBrand.h"

#import "User.h"
#import "Product.h"
#import "Customer.h"
#import "ProductSalesAggrPerYear.h"

@implementation ProductSalesAggrPerBrand

@synthesize brand;
@synthesize aggrPerYears;

+ (NSArray *)ProductSalesGroupByBrandFrom:(NSString *)aField andValue:(NSString *)aValue YTDorMAT:(BOOL)isYTD
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
    
    NSMutableDictionary *sales = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    for (NSDictionary *report in reports)
    {
        NSString *id_product = [report objectForKey:@"id_product"];
        NSString *brand = [Product BrandFromProductID:id_product];
        
        NSString *period = [report objectForKey:@"period"];
        NSRange seperator_range = [period rangeOfString:@"-"];
        if (seperator_range.location != NSNotFound)
        {
            period = [period substringFromIndex:seperator_range.location + 1];
            
            seperator_range = [period rangeOfString:@"/"];
            if (seperator_range.location != NSNotFound)
                period = [period substringFromIndex:seperator_range.location + 1];
        }
        
        ProductSalesAggrPerBrand *aggrPerBrand = [sales objectForKey:brand];
        if (!aggrPerBrand)
        {
            aggrPerBrand = [[ProductSalesAggrPerBrand alloc] init];
            aggrPerBrand.brand = brand;
            
            [sales setObject:aggrPerBrand forKey:brand];
        }
        
        ProductSalesAggrPerYear *aggrPerYear;
        for (aggrPerYear in aggrPerBrand.aggrPerYears)
        {
            if ([aggrPerYear.year isEqualToString:period])
                break;
        }
        
        if (!aggrPerYear)
        {
            aggrPerYear = [[ProductSalesAggrPerYear alloc] init];
            aggrPerYear.year = period;
            
            [aggrPerBrand addAggrPerYear:aggrPerYear];
        }
        
        [aggrPerYear addProductSale:report YTDorMAT:isYTD];
    }

    for (ProductSalesAggrPerBrand *aggrPerBrand in sales.allValues)
    {
        for (ProductSalesAggrPerYear *aggrPerYear in aggrPerBrand.aggrPerYears)
            [aggrPerYear finishAdd];
    }
    
    
    /* Add Total */
    ProductSalesAggrPerBrand *totalAggr = [[ProductSalesAggrPerBrand alloc] init];
    totalAggr.brand = @"Total";
    
    for (ProductSalesAggrPerBrand *aggrPerCustomer in sales.allValues)
    {
        for (ProductSalesAggrPerYear *aggrPerYear in aggrPerCustomer.aggrPerYears)
        {
            ProductSalesAggrPerYear *totalAggrPerYear;
            for (totalAggrPerYear in totalAggr.aggrPerYears)
            {
                if ([aggrPerYear.year isEqualToString:totalAggrPerYear.year])
                    break;
            }
            
            if (!totalAggrPerYear)
            {
                totalAggrPerYear = [[ProductSalesAggrPerYear alloc] init];
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
    for (ProductSalesAggrPerYear *aggrPerYear in totalAggr.aggrPerYears)
        [aggrPerYear finishAdd];
    
    NSMutableArray *productSales = [[NSMutableArray alloc] initWithArray:sales.allValues];
    [productSales insertObject:totalAggr atIndex:0];
    
    /* Growth */
    for (ProductSalesAggrPerBrand *aggrPerCustomer in productSales)
    {
        ProductSalesAggrPerYear *prvAggrPerYear = nil;
        double prvVal;
        for (ProductSalesAggrPerYear *aggrPerYear in aggrPerCustomer.aggrPerYears)
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
    
    return productSales;
}

+ (NSArray *)ProductSalesGroupByBrandFromCustomers:(NSString *)aField andValue:(NSString *)aValue YTDorMAT:(BOOL)isYTD
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
    
    NSMutableDictionary *sales = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    for (NSDictionary *report in reports)
    {
        NSString *id_product = [report objectForKey:@"id_product"];
        NSString *brand = [Product BrandFromProductID:id_product];
        
        NSString *period = [report objectForKey:@"period"];
        NSRange seperator_range = [period rangeOfString:@"-"];
        if (seperator_range.location != NSNotFound)
        {
            period = [period substringFromIndex:seperator_range.location + 1];
            
            seperator_range = [period rangeOfString:@"/"];
            if (seperator_range.location != NSNotFound)
                period = [period substringFromIndex:seperator_range.location + 1];
        }
        
        ProductSalesAggrPerBrand *aggrPerBrand = [sales objectForKey:brand];
        if (!aggrPerBrand)
        {
            aggrPerBrand = [[ProductSalesAggrPerBrand alloc] init];
            aggrPerBrand.brand = brand;
            
            [sales setObject:aggrPerBrand forKey:brand];
        }
        
        ProductSalesAggrPerYear *aggrPerYear;
        for (aggrPerYear in aggrPerBrand.aggrPerYears)
        {
            if ([aggrPerYear.year isEqualToString:period])
                break;
        }
        
        if (!aggrPerYear)
        {
            aggrPerYear = [[ProductSalesAggrPerYear alloc] init];
            aggrPerYear.year = period;
            
            [aggrPerBrand addAggrPerYear:aggrPerYear];
        }
        
        [aggrPerYear addProductSale:report YTDorMAT:isYTD];
    }
    
    for (ProductSalesAggrPerBrand *aggrPerBrand in sales.allValues)
    {
        for (ProductSalesAggrPerYear *aggrPerYear in aggrPerBrand.aggrPerYears)
            [aggrPerYear finishAdd];
    }
    
    
    /* Add Total */
    ProductSalesAggrPerBrand *totalAggr = [[ProductSalesAggrPerBrand alloc] init];
    totalAggr.brand = @"Total";
    
    for (ProductSalesAggrPerBrand *aggrPerCustomer in sales.allValues)
    {
        for (ProductSalesAggrPerYear *aggrPerYear in aggrPerCustomer.aggrPerYears)
        {
            ProductSalesAggrPerYear *totalAggrPerYear;
            for (totalAggrPerYear in totalAggr.aggrPerYears)
            {
                if ([aggrPerYear.year isEqualToString:totalAggrPerYear.year])
                    break;
            }
            
            if (!totalAggrPerYear)
            {
                totalAggrPerYear = [[ProductSalesAggrPerYear alloc] init];
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
    for (ProductSalesAggrPerYear *aggrPerYear in totalAggr.aggrPerYears)
        [aggrPerYear finishAdd];
    
    NSMutableArray *productSales = [[NSMutableArray alloc] initWithArray:sales.allValues];
    [productSales insertObject:totalAggr atIndex:0];
    
    /* Growth */
    for (ProductSalesAggrPerBrand *aggrPerCustomer in productSales)
    {
        ProductSalesAggrPerYear *prvAggrPerYear = nil;
        double prvVal;
        for (ProductSalesAggrPerYear *aggrPerYear in aggrPerCustomer.aggrPerYears)
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
    
    return productSales;
}


- (void)addAggrPerYear:(ProductSalesAggrPerYear *)aggrPerYear
{
    if (!aggrPerYears)
        aggrPerYears = [[NSMutableArray alloc] initWithCapacity:0];
    
    [aggrPerYears addObject:aggrPerYear];
}

@end
