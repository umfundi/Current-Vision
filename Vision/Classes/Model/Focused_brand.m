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
    
    return [context executeFetchRequest:fetchRequest error:nil];
}

@end
