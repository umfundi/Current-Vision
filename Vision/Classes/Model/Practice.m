//
//  Practices.m
//  Vision
//
//  Created by Ian Molesworth on 15/09/2012.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import "Practice.h"

#import "Customer.h"
#import "User.h"

@implementation Practice

@dynamic add1;
@dynamic add2;
@dynamic brick;
@dynamic city;
@dynamic country;
@dynamic fax;
@dynamic isActive;
@dynamic postcode;
@dynamic practiceCode;
@dynamic practiceName;
@dynamic province;
@dynamic sap_no;
@dynamic tel;

@synthesize customers;

- (void)loadCustomers
{
    NSManagedObjectContext *context = [User managedObjectContextForData];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Customer"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id_practice == %@", self.practiceCode];
    [fetchRequest setPredicate:predicate];

    NSArray *results = [context executeFetchRequest:fetchRequest error:nil];
    self.customers = [NSSet setWithArray:results];
    NSLog(@"%@", self.customers);
}

+ (NSArray *)searchPracticesWithField:(NSString *)aField andKey:(NSString *)aKey
{
    NSManagedObjectContext *context = [User managedObjectContextForData];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Practice"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@ CONTAINS[cd] %%@", aField], aKey];
    [fetchRequest setPredicate:predicate];
    
    return [context executeFetchRequest:fetchRequest error:nil];
}

@end
