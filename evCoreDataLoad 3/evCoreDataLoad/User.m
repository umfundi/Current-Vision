//
//  User.m
//  evCoreDataLoad
//
//  Created by Ian Molesworth on 26/09/2012.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import "User.h"


@implementation User

@dynamic id_user;
@dynamic country;
@dynamic login;
@dynamic data;
@dynamic password;
@dynamic accesslevel;
@dynamic datalocation;
@dynamic timestamp;

- (void) fromJSONObject:(id) object
{
    self.accesslevel = [object objectForKey:@"accessLevel"] ? [object objectForKey:@"accessLevel"] : @"";
    self.country = [object objectForKey:@"country"] ? [object objectForKey:@"country"] : @"";
    self.data = [object objectForKey:@"data"] ? [object objectForKey:@"data"] : @"";
    self.id_user = [object objectForKey:@"id_user"] ? [object objectForKey:@"id_user"] : @"";
    self.login = [object objectForKey:@"login"] ? [object objectForKey:@"login"] : @"";
    self.password = [object objectForKey:@"password"] ? [object objectForKey:@"password"] : @"";
    self.datalocation = [object objectForKey:@"datalocation"] ? [object objectForKey:@"datalocation"] : @"";
    self.timestamp = [object objectForKey:@"timestamp"] ? [object objectForKey:@"timestamp"] : @"";
}

@end
