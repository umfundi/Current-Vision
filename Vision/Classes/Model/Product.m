//
//  Products.m
//  Vision
//
//  Created by Ian Molesworth on 15/09/2012.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import "Product.h"

#import "User.h"

@implementation Product

@dynamic brand;
@dynamic datecrea;
@dynamic group1;
@dynamic group2;
@dynamic group3;
@dynamic group4;
@dynamic group5;
@dynamic group6;
@dynamic pcode;
@dynamic pname;
@dynamic size;
@dynamic status;
@dynamic type;
@dynamic pclass;

+ (NSArray *)AllProducts
{
    NSManagedObjectContext *context = [User managedObjectContextForData];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Product"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    // Sort
    NSSortDescriptor *sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"pname" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDesc]];
    
    return [context executeFetchRequest:fetchRequest error:nil];
}


+ (Product *)ProductFromProductID:(NSString *)id_product
{
    NSManagedObjectContext *context = [User managedObjectContextForData];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Product"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"pcode == %@", id_product];
    [fetchRequest setPredicate:predicate];
    
    NSArray *products = [context executeFetchRequest:fetchRequest error:nil];
    if ([products count] != 1)
        return nil;
    
    return (Product *)[products objectAtIndex:0];
}

+ (NSArray *)AllProductsFromBrand:(NSString *)brand
{
    NSManagedObjectContext *context = [User managedObjectContextForData];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Product"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"brand == %@", brand];
    [fetchRequest setPredicate:predicate];
    
    return [context executeFetchRequest:fetchRequest error:nil];
}

@end
