// SGridPrivateInterface.h
#import <Foundation/Foundation.h>

#import "SGridMovableElement.h"
#import "SGridSelectableElement.h"

@class SGridLine;
@class SGridSection;
@class SGridLineComposite;
@class SGridCompositeSectionHeader;

void SGridPulseView(UIView *view, UIView *owner);

@interface ShinobiGrid (hidden)

#pragma mark -
#pragma mark DataSource
//loadAndRetrieveCellAtCol:atRow: retrieves the cell whether it is visible or not - be wary of accidentally loading cells that aren't currently meant to be in view
- (SGridCell *)               loadAndRetrieveCellAtCol:(int)colIndex atRow:(SGridRow)row;
- (SGridDataSourceDelegateManager *) dataSourceDelegateManager;
- (void)                      loadAndLayoutVisibleData;
- (void)                      setZoomDelegate:(id<UIScrollViewDelegate>)d;
- (void)                      setPoolDequeCalled:(BOOL)dequeingtons;
- (BOOL)                      poolDequeCalled;
- (void)                      reloadInternal:(BOOL)internal;

#pragma mark -
#pragma mark Styling
- (void)                      privateSetDefaultRowStyle: (SGridColRowStyle *)newDefaultRowStyle;
- (void)                      privateSetDefaultColStyle: (SGridColRowStyle *)newDefaultColStyle;
- (void)                      loadColStyles:(BOOL)loadColStyles andRowStyles:(BOOL)loadRowStyles;
- (void)                      applyStyleToCell: (SGridCell *) cellNeedingStyle;

- (SGridLineComposite *) gridLineHorizontalCompositeAtRow: (SGridRow) rowForLine;
- (SGridLineComposite *) gridLineVerticalCompositeAtIndex: (int) gridLineIndex;
- (SGridLineComposite *) gridLineCompositeBorderForIndex:(int) compositeBorderIndex;

- (float) colStyleSize:(SGridColRowStyle *)colStyle;
- (float) rowStyleSize:(SGridColRowStyle *)rowStyle;
- (float) colStyleSize:(SGridColRowStyle *)colStyle useDefault:(BOOL)useDefault;
- (float) rowStyleSize:(SGridColRowStyle *)rowStyle useDefault:(BOOL)useDefault;

- (SGridArrow*) arrowForOrientation:(SGridArrowOrientation)arrowOrientation atGridCoord:(SGridCoord*) gridCoord;

#pragma mark -
#pragma mark Drawing and Layout
- (SGridLayer*)               layerForCell:(SGridCell*) cellForLayer;
- (void)                      addCellToAppropriateLayer:(SGridCell*) cell;
- (void)                      setContentInset:(UIEdgeInsets)newContentInset;
- (void)                      scrollRectToVisible:(CGRect)frame animated:(BOOL)animated;
- (void)                      tidyRowAndColEdges;
- (void)                      refreshBorder;

#pragma mark -
#pragma mark Layers

- (SGridLayer *) liquidLayer;
- (SGridLayer *) verticallyFrozenLayer;
- (SGridLayer *) horizontallyFrozenLayer;
- (SGridLayer *) staticLayer;

#pragma mark -
#pragma mark Grid Dimensions
- (float)                     currentContentHeightForAllSections;
- (float)                     currentContentHeightUpToAndIncludingSection:(int)sectionToTotalTo;
- (float)                     totalWidthOfVerticalGridLines;
- (float)                     totalHeightOfHorizontalGridLines;
- (void)                      stretchColsIfNeeded;
- (void)                      stretchRowsIfNeeded;

#pragma mark -
#pragma mark Sections
- (SGridRow)                  lastRow;
- (SGridSection *)            lastUncollapsedSection;
- (SGridSection *)            firstUncollapsedSection;
- (void)                      decrementNumberOfCollapsedSections;
- (void)                      setASectionIsCollapsing:(BOOL) sectionIsCollapsing;
- (BOOL)                      aSectionIsCollapsing;

#pragma mark -
#pragma mark Selection and Editing
- (SGridCell *)               selectedCell;
- (SGridCoord *)              selectedCellGridCoord;
- (void)                      setSelectedCell:(SGridCell *)newCell;
- (BOOL)                      respondingToDoubleTap;
- (void)                      setRespondingToDoubleTap:(BOOL)responding;
- (id<SGridSelectableElement>) searchLayer:(SGridLayer *) layer forCellThatContainsPoint:(CGPoint) pointToSearchFor;
- (NSArray *)                 layers;
- (NSArray *)                 layerContents;
- (void)                      setLayersUserInteractionEnabled:(BOOL) enabled;

#pragma mark -
#pragma mark Reordering Columns/Rows/Cells
- (void)                      setHoldToReorder:(UILongPressGestureRecognizer *) gestureRecognizer;
- (void)                      animateGridElement:(id<SGridMovableElement>)line toPosition:(CGPoint)position inFront:(BOOL)inFront fromCurrentState:(BOOL)fromCurrentState;
- (void)                      switchRowsIfNeeded;
- (void)                      switchColsIfNeeded;
- (void)                      switchDraggingRowWithStaticRow:(SGridRow)staticRow      fromCurrentState:(BOOL) fromCurrentState;
- (void)                      switchDraggingColWithStaticCol:(int)staticColIndex fromCurrentState:(BOOL) fromCurrentState;
- (void)                      dragRow:(SGridRow)row      toPosition:(float) newYPosition fromCurrentState: (BOOL) fromCurrentState;
- (void)                      dragCol:(int)colIndex toPosition:(float) newXPosition fromCurrentState: (BOOL) fromCurrentState;
- (BOOL)                      userDragging;
- (BOOL)                      reordering;
- (void)                      resetHoldToReorder;
- (SGridCoordMutable *)       draggingIndex;

#pragma mark -
#pragma mark Keyboard
- (void)                      keyboardWillShow:(NSNotification *) notification;
- (void)                      keyboardWillHide:(NSNotification *) notification;

#pragma mark -
#pragma mark Validity
- (void)                      assertValid;
- (BOOL)                      weHaveSetFrames;
- (void)                      setUserHasAlteredCellFrame:(BOOL)userHasSet;

- (SGridRow)                  lastFrozenRow;
- (void)                      setLastFrozenRow: (SGridRow) newLastFrozenRow;
- (int)                       lastFrozenCol;
- (void)                      setLastFrozenCol: (int) newLastFrozenCol;
- (int)                       numberOfFrozenRows;
- (int)                       numberOfFrozenCols;

#pragma mark -
#pragma mark Methods for Managing Infinite Grid
- (void)     removeSectionFromVisibleRows:(int) sectionIndex;
- (int)      visibleColIndexFromActualIndex:(int) index;
- (int)      visibleRowIndexFromActualRow:(SGridRow) row;
- (int)      firstVisibleColumnIndex;
- (int)      lastVisibleColumnIndex;
- (int)      numberOfVisibleCols;
- (SGridRow) firstVisibleRow;
- (SGridRow) lastVisibleRow;
- (int)      firstVisibleSectionIndex;
- (int)      lastVisibleSectionIndex;
- (BOOL)     bottomRowNeedsAddedToVisibleGrid;
- (BOOL)     topRowNeedsRemovedFromVisibleGrid;

- (void)     removeRowsFromTopAddToBottomIfNeeded;
- (void)     removeRowsFromBottomAddToTopIfNeeded;
- (void)     manageLeftAndRightEdgeCells;
- (void)     removeColsFromRightAddToLeftIfNeeded;
- (void)     removeColsFromLeftAddToRightIfNeeded;
- (void)     manageTopAndBottomEdgeCells;

- (void) printVisibleIndexDebugInfo;
- (CGPoint) lastContentOffset;

#pragma mark Gestures
- (void) cancelGestures;

@end

