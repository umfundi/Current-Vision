//
//  NSArray+BinarySearch.h
//  ShinobiControls_Source
//
//  Created by  on 27/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SGridRowStruct.h"

@interface NSArray (SGridBinarySearch)

- (NSUInteger) binarySearchNSNumberArrayForInt:(int) intToLookFor;
- (NSUInteger) binarySearchNSValueArrayForRow:(SGridRow) rowToLookFor;
- (NSUInteger) binarySearchNSArrayOfCellsForCol:(int) colIndex;
- (NSUInteger) binarySearchNSArrayOfNSArrayOfCellsForRow:(SGridRow) rowToLookFor;

@end
