//
//  ProductSalesAggrPerBrand.m
//  Vision
//
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import "ProductSalesAggrPerYear.h"
#import "Product.h"

@implementation ProductSalesAggrPerYear

@synthesize year;
@synthesize jan, janString;
@synthesize feb, febString;
@synthesize mar, marString;
@synthesize totq1;
@synthesize apr, aprString;
@synthesize may, mayString;
@synthesize jun, junString;
@synthesize totq2;
@synthesize jul, julString;
@synthesize aug, augString;
@synthesize sep, sepString;
@synthesize totq3;
@synthesize oct, octString;
@synthesize nov, novString;
@synthesize dec, decString;
@synthesize totq4;
@synthesize value, growth;
@synthesize qty, qtygrowth;

- (void)addProductSale:(NSDictionary *)productSale YTDorMAT:(BOOL)isYTD
{
    jan += [[productSale objectForKey:@"m_11val"] doubleValue];
    feb += [[productSale objectForKey:@"m_10val"] doubleValue];
    mar += [[productSale objectForKey:@"m_9val"] doubleValue];
    apr += [[productSale objectForKey:@"m_8val"] doubleValue];
    may += [[productSale objectForKey:@"m_7val"] doubleValue];
    jun += [[productSale objectForKey:@"m_6val"] doubleValue];
    jul += [[productSale objectForKey:@"m_5val"] doubleValue];
    aug += [[productSale objectForKey:@"m_4val"] doubleValue];
    sep += [[productSale objectForKey:@"m_3val"] doubleValue];
    oct += [[productSale objectForKey:@"m_2val"] doubleValue];
    nov += [[productSale objectForKey:@"m_1val"] doubleValue];
    dec += [[productSale objectForKey:@"m0val"] doubleValue];
}

- (void)finishAdd
{
    janString = [NSString stringWithFormat:@"%.0f", round(jan)];
    febString = [NSString stringWithFormat:@"%.0f", round(feb)];
    marString = [NSString stringWithFormat:@"%.0f", round(mar)];
    totq1 = [NSString stringWithFormat:@"%.0f", round(jan + feb + mar)];
    aprString = [NSString stringWithFormat:@"%.0f", round(apr)];
    mayString = [NSString stringWithFormat:@"%.0f", round(may)];
    junString = [NSString stringWithFormat:@"%.0f", round(jun)];
    totq2 = [NSString stringWithFormat:@"%.0f", round(apr + may + jun)];
    julString = [NSString stringWithFormat:@"%.0f", round(jul)];
    augString = [NSString stringWithFormat:@"%.0f", round(aug)];
    sepString = [NSString stringWithFormat:@"%.0f", round(sep)];
    totq3 = [NSString stringWithFormat:@"%.0f", round(jul + aug + sep)];
    octString = [NSString stringWithFormat:@"%.0f", round(oct)];
    novString = [NSString stringWithFormat:@"%.0f", round(nov)];
    decString = [NSString stringWithFormat:@"%.0f", round(dec)];
    totq4 = [NSString stringWithFormat:@"%.0f", round(oct + nov + dec)];
    value = [NSString stringWithFormat:@"%.0f", round(jan + feb + mar + apr + may + jun + jul + aug + sep + oct + nov + dec)];
//#warning growth in ProductSales
//    growth = [NSString stringWithFormat:@"%.0f%%", round(0)];
//#warning qty in ProductSales
//    qty = [NSString stringWithFormat:@"%.0f%%", round(0)];
//#warning growth in ProductSales
//    qtygrowth = [NSString stringWithFormat:@"%.0f%%", round(0)];
}

@end
