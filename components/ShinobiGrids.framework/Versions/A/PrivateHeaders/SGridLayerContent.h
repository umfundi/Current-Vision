// SGridLayerContent.h
#import <UIKit/UIKit.h>
#import "ShinobiGrid.h"
#import "SGridSelectableElement.h"
#import "SGridMovableElement.h"

@class SGridLine;
@class SGridSection;

@interface SGridLayerContent : UIView {
}

@property (nonatomic, retain) SGridLayer            *owningLayer;
@property (nonatomic, retain) NSMutableSet          *selectableGridElements;
@property (nonatomic, retain) NSMutableDictionary   *sectionHeaders;

- (id)   initWithLayer:(SGridLayer *) theOwningLayer;
- (void) addCell:(SGridCell *)cellToAdd toView:(BOOL) addToView;
- (void) removeCell:(SGridCell *) removeCell;
- (void) removeCells;
- (void) generateSectionHeadersForSection:(SGridSection *)section atOrigin:(float) yOrigin;
- (void) prepareForReload;

@end
