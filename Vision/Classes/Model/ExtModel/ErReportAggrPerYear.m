//
//  ErReportAggrPerYear.m
//  Vision
//
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import "ErReportAggrPerYear.h"

@implementation ErReportAggrPerYear

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

- (void)addErReport:(NSDictionary *)erReport
{
    jan += [[erReport objectForKey:@"janval"] doubleValue];
    feb += [[erReport objectForKey:@"febval"] doubleValue];
    mar += [[erReport objectForKey:@"marval"] doubleValue];
    apr += [[erReport objectForKey:@"aprval"] doubleValue];
    may += [[erReport objectForKey:@"mayval"] doubleValue];
    jun += [[erReport objectForKey:@"junval"] doubleValue];
    jul += [[erReport objectForKey:@"julval"] doubleValue];
    aug += [[erReport objectForKey:@"augval"] doubleValue];
    sep += [[erReport objectForKey:@"sepval"] doubleValue];
    oct += [[erReport objectForKey:@"octval"] doubleValue];
    nov += [[erReport objectForKey:@"novval"] doubleValue];
    dec += [[erReport objectForKey:@"decval"] doubleValue];
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
#warning value in ErReport
    value = [NSString stringWithFormat:@"%.0f%%", round(0)];
#warning growth in ErReport
    growth = [NSString stringWithFormat:@"%.0f%%", round(0)];
#warning qty in ErReport
    qty = [NSString stringWithFormat:@"%.0f%%", round(0)];
#warning growth in ErReport
    qtygrowth = [NSString stringWithFormat:@"%.0f%%", round(0)];
}

@end
