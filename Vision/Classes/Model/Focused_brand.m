//
//  FocusedBrands.m
//  Vision
//
//  Created by Ian Molesworth on 15/09/2012.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import "Focused_brand.h"

#import "User.h"


@implementation Focused_brand

@dynamic brand_class;
@dynamic brand_name;
@dynamic rank;

+ (NSArray *)AllBrands
{
    NSManagedObjectContext *context = [User managedObjectContextForData];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Focused_brand"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"brand_name <> %@", @"-"];
    [fetchRequest setPredicate:predicate];

    // Sort
    NSSortDescriptor *sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"brand_name" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDesc]];
    
    return [context executeFetchRequest:fetchRequest error:nil];
}


+ (NSString *)brandClassFromName:(NSString *)brandName
{
    NSManagedObjectContext *context = [User managedObjectContextForData];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Focused_brand"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"brand_name == %@", brandName];
    [fetchRequest setPredicate:predicate];
    
    NSArray *brands = [context executeFetchRequest:fetchRequest error:nil];
    if ([brands count] != 1)
        return nil;
    
    Focused_brand *brand = (Focused_brand *)[brands objectAtIndex:0];
    
    return brand.brand_class;
}

@end
