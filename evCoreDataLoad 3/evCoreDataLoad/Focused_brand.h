//
//  Focused_brand.h
//  evCoreDataLoad
//
//  Created by Ian Molesworth on 25/09/2012.
//  Copyright (c) 2012 Ian Molesworth. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Focused_brand : NSManagedObject

@property (nonatomic, retain) NSString * brand_name;
@property (nonatomic, retain) NSString * rank;
@property (nonatomic, retain) NSString * brand_class;

- (void) fromJSONObject:(id) object;
@end
