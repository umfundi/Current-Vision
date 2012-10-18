//
//  SALES_REPORT_Dashboard.m
//  evCoreDataLoad
//
//  Created by Jiang Xiong on 9/28/12.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import "SALES_REPORT_Dashboard.h"


@implementation SALES_REPORT_Dashboard

@dynamic ptype;
@dynamic brand;
@dynamic dl;
@dynamic id_user;
@dynamic matvalcur;
@dynamic matvalprv;
@dynamic ytdvalcur;
@dynamic ytdvalprv;
@dynamic mvalcur;
@dynamic mvalprv;

- (void) fromJSONObject:(id) object
{
    self.id_user = [object objectForKey:@"id_user"] ? [object objectForKey:@"id_user"] : @"";
    self.ptype = [object objectForKey:@"ptype"] ? [object objectForKey:@"ptype"] : @"";
    self.brand = [object objectForKey:@"brand"] ? [object objectForKey:@"brand"] : @"";
    self.dl = [object objectForKey:@"DL"] ? [object objectForKey:@"DL"] : @"";
    self.matvalcur = [object objectForKey:@"matvalcur"] ? [object objectForKey:@"matvalcur"] : @"";
    self.matvalprv = [object objectForKey:@"matvalprv"] ? [object objectForKey:@"matvalprv"] : @"";
    self.ytdvalcur = [object objectForKey:@"ytdvalcur"] ? [object objectForKey:@"ytdvalcur"] : @"";
    self.ytdvalprv = [object objectForKey:@"ytdvalprv"] ? [object objectForKey:@"ytdvalprv"] : @"";
    self.mvalcur = [object objectForKey:@"mvalcur"] ? [object objectForKey:@"mvalcur"] : @"";
    self.mvalprv = [object objectForKey:@"mvalprv"] ? [object objectForKey:@"mvalprv"] : @"";
}

@end
