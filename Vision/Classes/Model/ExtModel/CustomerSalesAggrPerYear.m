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

- (void)addCustomerSale:(NSDictionary *)customerSale
{
    jan += [[customerSale objectForKey:@"janval"] doubleValue];
    feb += [[customerSale objectForKey:@"febval"] doubleValue];
    mar += [[customerSale objectForKey:@"marval"] doubleValue];
    apr += [[customerSale objectForKey:@"aprval"] doubleValue];
    may += [[customerSale objectForKey:@"mayval"] doubleValue];
    jun += [[customerSale objectForKey:@"junval"] doubleValue];
    jul += [[customerSale objectForKey:@"julval"] doubleValue];
    aug += [[customerSale objectForKey:@"augval"] doubleValue];
    sep += [[customerSale objectForKey:@"sepval"] doubleValue];
    oct += [[customerSale objectForKey:@"octval"] doubleValue];
    nov += [[customerSale objectForKey:@"novval"] doubleValue];
    dec += [[customerSale objectForKey:@"decval"] doubleValue];
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
#warning value in ProductSales
    value = [NSString stringWithFormat:@"%.0f%%", round(0)];
#warning growth in ProductSales
    growth = [NSString stringWithFormat:@"%.0f%%", round(0)];
#warning qty in ProductSales
    qty = [NSString stringWithFormat:@"%.0f%%", round(0)];
#warning growth in ProductSales
    qtygrowth = [NSString stringWithFormat:@"%.0f%%", round(0)];
}

@end
