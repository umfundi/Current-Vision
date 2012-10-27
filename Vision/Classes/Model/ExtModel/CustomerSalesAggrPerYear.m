//
//  CustomerSalesAggrPerYear.m
//  Vision
//
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import "CustomerSalesAggrPerYear.h"

@implementation CustomerSalesAggrPerYear

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

- (void)addCustomerSale:(NSDictionary *)customerSale YTDorMAT:(BOOL)isYTD
{
    jan += [[customerSale objectForKey:@"m_11val"] doubleValue];
    feb += [[customerSale objectForKey:@"m_10val"] doubleValue];
    mar += [[customerSale objectForKey:@"m_9val"] doubleValue];
    apr += [[customerSale objectForKey:@"m_8val"] doubleValue];
    may += [[customerSale objectForKey:@"m_7val"] doubleValue];
    jun += [[customerSale objectForKey:@"m_6val"] doubleValue];
    jul += [[customerSale objectForKey:@"m_5val"] doubleValue];
    aug += [[customerSale objectForKey:@"m_4val"] doubleValue];
    sep += [[customerSale objectForKey:@"m_3val"] doubleValue];
    oct += [[customerSale objectForKey:@"m_2val"] doubleValue];
    nov += [[customerSale objectForKey:@"m_1val"] doubleValue];
    dec += [[customerSale objectForKey:@"m0val"] doubleValue];
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
//#warning qty in ProductSales
//    qty = [NSString stringWithFormat:@"%.0f%%", round(0)];
//#warning growth in ProductSales
//    qtygrowth = [NSString stringWithFormat:@"%.0f%%", round(0)];
}

@end
