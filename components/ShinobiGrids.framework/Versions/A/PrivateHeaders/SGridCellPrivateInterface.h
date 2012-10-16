// SGridCellPrivateInterface.h
#import <Foundation/Foundation.h>
#import "SGridMovableElement.h"
#import "SGridSelectableElement.h"
#import "SGridOwnedElement.h"

@interface SGridCell (hidden) <SGridMovableElement, SGridOwnedElement>

@property (nonatomic, assign) ShinobiGrid *grid;

- (void) resetForReuse;
- (void) setSelected:(BOOL)isSelected;
- (void) pulse;

//return YES if this cell is in the last row of the section that it belongs to
- (BOOL) isInLastRowOfOwnSection;
- (BOOL) isInFirstRowOfOwnSection;
- (BOOL) isInLastSection;
- (BOOL) isInLastRowOfLastSection;
- (BOOL) isInLastRowOfLastUncollapsedSection;
- (BOOL) isInFirstRowOfFirstUncollapsedSection;

//returns the layer that the cell belongs to
- (SGridLayer *) owningLayer;

//sets the layer that the cell belongs to
- (void) setOwningLayer:(SGridLayer *) newSGridLayer;

//these methods are private as we are limiting the users ability to freeze cells to the methods 'freezeColsToTheLeftOfAndIncludingIndex:' and 'freezeRowsAboveAndIncludingIndex:'
- (BOOL) verticallyFrozen;
- (void) setVerticallyFrozen:(BOOL)freezeVertically;
- (BOOL) horizontallyFrozen;
- (void) setHorizontallyFrozen:(BOOL)freezeHorizontally;

@property (nonatomic, assign) BOOL beingDragged;
@property (nonatomic, retain, readwrite) SGridCoord *gridCoord;

@property (nonatomic, assign) BOOL useOwnBackgroundColor;
@property (nonatomic, retain) UIColor *deselectedColor;

@end
