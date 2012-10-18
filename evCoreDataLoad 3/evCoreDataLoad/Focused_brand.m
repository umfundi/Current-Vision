//
//  Focused_brand.m
//  evCoreDataLoad
//
//  Created by Ian Molesworth on 25/09/2012.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import "Focused_brand.h"


@implementation Focused_brand

@dynamic brand_name;
@dynamic rank;
@dynamic brand_class;

- (void) fromJSONObject:(id) object
{
    self.brand_name = [object objectForKey:@"BRAND_NAME"] ? [object objectForKey:@"BRAND_NAME"] : @"";
    self.brand_class = [object objectForKey:@"CLASS"] ? [object objectForKey:@"CLASS"] : @"";
    self.rank = [object objectForKey:@"RANK"] ? [object objectForKey:@"RANK"] : @"";
}
@end
