// SGridDelegate.h
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SGridRowStruct.h"
#import "SGridArrowOrientation.h"

typedef enum {
    SGridLineOrientationVertical,
    SGridLineOrientationHorizontal
} SGridLineOrientation;

@class ShinobiGrid;
@class SGridCell;
@class SGridAutoCell;
@class SGridLineStyle;
@class SGridColRowStyle;
@class SGridCoord;
@class SGridSectionHeaderStyle;

/** The delegate of a ShinobiGrid object must adopt the SGridDelegate protocol. The delegate concerns itself with the style of rows, columns and gridlines and can receive notifications that a cell is about to be selected (via a single tap) or that a cell has been edited (via a double-tap).
 
 The delegate should only be used for styling where you wish to provide a style for a particular row, column or gridline, or where each row/column/gridline is to have its own distinct style. If you wish to apply a uniform row/column/gridline style for the entire grid then the properites `defaultRowStyle`, `defaultColumnStyle` and `defaultGridLineStyle` of your ShinobiGrid object are designed for this purpose and provide better performance than use of the delegate.
 
 @warning *Important* In certain cases row styles and column styles can conflict (a cell can belong to a row and column that have been given different styles). In this case the style is applied based on the `BOOL` `rowStylesTakePriority` property of the ShinobiGrid object.*/
@protocol SGridDelegate <UIScrollViewDelegate>

@optional
#pragma mark -
#pragma mark Columns and Row Styling
/** @name Styling Rows and Columns*/

/** Asks the delegate for the style to be used for a particular row within the ShinobiGrid object.
 
 Note that rows and sections are zero-indexed.
 
 @param grid The grid that is requesting the style.
 @param rowIndex The row within `grid` that is requesting the row style.
 @param sectionIndex The section that the row belongs to.
 
 @return The SGridColRowStyle object representing the style that will be applied to row at `rowIndex` of section at `sectionIndex` within `grid`.*/
- (SGridColRowStyle *)shinobiGrid:(ShinobiGrid *)grid styleForRowAtIndex:          (int)rowIndex inSection:(int) sectionIndex;

/** Asks the delegate for the style to be used for a particular column within the ShinobiGrid object.
 
 Note that columns are zero-indexed.
 
 @param grid The grid that is requesting the column style.
 @param colIndex The column within `grid` that is requesting the style.
 
 @return The SGridColRowStyle object representing the style that will be applied to column at `colIndex` within `grid`.*/
- (SGridColRowStyle *)shinobiGrid:(ShinobiGrid *)grid styleForColAtIndex:          (int)colIndex;




#pragma mark -
#pragma mark Gridline Styling
/** @name Styling Gridlines*/

/** Asks the delegate for the style to be used for a particular horizontal gridline within the ShinobiGrid object. 
 
 Gridlines are zero indexed - where the first horizontal grid line for a section appears underneath the first row of a section. Note that horizontal gridlines are zero-indexed within sections (that is to say that the first gridline in any section has a `gridLineIndex` of `0`). The last row of a section also has a gridline appear underneath it (unlike the last column of a grid). Returning `nil` for a particular gridline will result in the `defaultGridLineStyle` property of your ShinobiGrid object being applied.
 
 @param grid The grid that is requesting the horizontal gridline style.
 @param gridLineIndex The horizontal gridline for the section within `grid` that is requesting the style.
 @param sectionIndex The section that the horizontal gridline belongs to.
 
 @return The SGridLineStyle object representing the style that will be applied to the gridline at `gridLineIndex` with `orientation`.*/
- (SGridLineStyle *)  shinobiGrid:(ShinobiGrid *)grid     styleForHorizontalGridLineAtIndex: (int)gridLineIndex inSection:(int) sectionIndex;

/** Asks the delegate for the style to be used for a particular vertical gridline within the ShinobiGrid object. 
 
 Gridlines are zero indexed - where the first vertical grid line appears to the right of the first column of cells. Returning `nil` for a particular gridline will result in the `defaultGridLineStyle` property of your ShinobiGrid object being applied.
 
 @param grid The grid that is requesting the vertical gridline style.
 @param gridLineIndex The vertical gridline within `grid` that is requesting the style.
 
 @return The SGridLineStyle object representing the style that will be applied to the gridline at `gridLineIndex` with `orientation`.*/
- (SGridLineStyle *)  shinobiGrid:(ShinobiGrid *)grid     styleForVerticalGridLineAtIndex:   (int)gridLineIndex;

#pragma mark -
#pragma mark Sections
/** @name Asks the delegate for the style to be used for a particular sections header. 
 
 Use this method if you wish to specify different styles for each section header. If you wish to style all section headers uniformly then use the `defaultSectionHeaderStyle` property of your ShinobiGrid object for better performance. Section headers are zero-indexed.
 
 @param grid The grid which owns the section that is requesting the header style.
 @param sectionIndex The index of the section that is requesting the header style.
 
 @return An object representing the style that will be applied to the section at `sectionIndex` of `grid`.*/
- (SGridSectionHeaderStyle *)shinobiGrid:(ShinobiGrid *)grid styleForSectionHeaderAtIndex:(int) sectionIndex;

#pragma mark -
#pragma mark Grid Layout/Render Notifications

/** @name Grid Layout/Render Notifications*/

/** Tells the delegate that the grid has finished laying out.
 
 The grid lays out, and subsequently calls this method, upon initial render/layout, section collapse/expand and device rotation.
 
 @param The grid which has finished laying out/rendering.*/
- (void) didFinishLayingOutShinobiGrid:(ShinobiGrid*) grid;

#pragma mark -
#pragma mark Section Notifications

/** @name Receiving Section Expand and Collapse Notifications*/

/** Tells the delegate that a section within the ShinobiGrid object is about to be expanded.
 
 @param grid The grid which contains the section that is about to expand.
 @param index The index of the section that is about to expand.
 */
- (void) shinobiGrid:(ShinobiGrid *)grid willExpandSectionAtIndex: (NSUInteger)sectionIndex;

/** Tells the delegate that a section within the ShinobiGrid object has expanded.
 
 @param grid The grid which contains the section that has expanded.
 @param index The index of the section that has expanded.
 */
- (void) shinobiGrid:(ShinobiGrid *)grid didExpandSectionAtIndex: (NSUInteger)sectionIndex;

/** Tells the delegate that a section within the ShinobiGrid object is about to be collapsed.
 
 @param grid The grid which contains the section that is about to collapse.
 @param index The index of the section that is about to collapse.
 */
- (void) shinobiGrid:(ShinobiGrid *)grid willCollapseSectionAtIndex:(NSUInteger)sectionIndex;

/** Tells the delegate that a section within the ShinobiGrid object has collapsed.
 
 @param grid The grid which contains the section that has collapsed.
 @param index The index of the section that has collapsed.
 */
- (void) shinobiGrid:(ShinobiGrid *)grid didCollapseSectionAtIndex:(NSUInteger)sectionIndex;

#pragma mark -
#pragma mark Selection/Editing Notifications
/** @name Receiving Cell Selection and Cell Editing Notifications*/

/** Tells the delegate that a cell within the ShinobiGrid object has been selected.
 
 @param grid The grid which contains the cell that has been selected.
 @param gridCoord The coordinate of the cell that has been selected.
 
 */
- (void) shinobiGrid:(ShinobiGrid *)grid willSelectCellAtCoord:(const SGridCoord *) gridCoord;

/** Tells the delegate that a cell within the ShinobiGrid object is about to be selected.
 
 This method gives the delegate an opportunity to apply a custom selection style/animation to the cell or another part of the grid.
 
 @param grid The grid which contains the cell that is about to be selected.
 @param gridCoord The coordinate of the cell that is about to be selected.
 
 */
- (void) shinobiGrid:(ShinobiGrid *)grid didSelectCellAtCoord: (const SGridCoord *) gridCoord;

/** Tells the delegate that a cell within the ShinobiGrid object is about to be deselected.
 
 @param grid The grid containing the cell that will be deselected.
 @param gridCoord The coordinate of the cell that is about to be deselected.*/
- (void) shinobiGrid:(ShinobiGrid *)grid willDeselectCellAtCoord:(const SGridCoord *)gridCoord;

/** Tells the delegate that a cell within the ShinobiGrid object has been deselected.
 
 @param grid The grid containing the cell that has been deselected.
 @param gridCoord The coordinate of the cell that has been deselected.*/
- (void) shinobiGrid:(ShinobiGrid *)grid didDeselectCellAtCoord:(const SGridCoord *)gridCoord;

/** Tells the delegate that a cell within the ShinobiGrid grid object will begin editing.
 
 @param grid The grid which contains the cell that will begin editing.
 @param cell The cell within `grid` that will begin editing.*/
- (void) shinobiGrid:(ShinobiGrid *)grid willCommenceEditingAutoCell:(const SGridAutoCell *) cell;

/** Informs the delegate that a cell within the ShinobiGrid object has been edited.
 
 This method gives the delegate an opportunity to feed back any changes that the user makes to the grid to the data source. Note that this delegate method only works in conjunction with SGridAutoCell (or its descendants).
 
 @param grid The grid which contains the cell that has been edited.
 @param cell The cell within `grid` that has been edited.*/
- (void) shinobiGrid:(ShinobiGrid *)grid didFinishEditingAutoCell:(const SGridAutoCell *) cell;


#pragma mark -
#pragma mark Column Resizing Notifications
/** @name Column Resizing Notifications*/
/** Tells the delegate that a column is about to begin resizing.
 
 This method will be called once before any resizing actually takes place.
 
 @param grid The grid that contains the column that is about to begin resizing.
 @param columnIndex The index of the column that is about to begin resizing.*/
- (void) shinobiGrid:(ShinobiGrid *)grid willBeginResizingColumnAtIndex:(NSUInteger) columnIndex;

/** Tells the delegate that a column will resize to a new width.
 
 This method is called continously as a user's pinch gesture changes. Each call to this method is made just prior to changing a columns width. If you want the width to be set to something other than `newWidth` then see the method `shinobiGrid:widthForResizingColAtIndex:`.
 
 @param grid The grid containing the column that will be resized.
 @param columnIndex The index of the column that will be resized.
 @param currentWidth The width that the column at `columnIndex` currently has.
 @param newWidth The width that the column at `columnIndex` will change to.
 @param xCenter The center, in pixels, of the column that is about to begin resizing.
 */

- (void)      shinobiGrid:(ShinobiGrid *)grid 
  willResizeColumnAtIndex:(NSUInteger)columnIndex 
                fromWidth:(float) currentWidth 
                  toWidth:(float) newWidth
              withXCenter:(float) xCenter;

/** Asks the grid for the width that a column that is currently being resized should be set to.
 
 @param grid The grid requesting the width for the resizing column.
 @param columnIndex The index of the column that is being resized.
 @param currentWidth The current width of the resizing column.
 @param targetWidth The width that the resizing column will be set to if this method had not been implemented (or `nil` is returned from this method).
 
 @return An NSNumber object that represents the width that the resizing column will be set to. Return nil if you wish for the target width to be set.*/
- (NSNumber*) shinobiGrid:(ShinobiGrid*) grid widthForResizingColAtIndex:(NSUInteger) columnIndex withCurrentWidth:(float) currentWidth targetWidth:(float) targetWidth;

/** Tells the delegate that a column has resized to a new width.
 
 This method is called continously as a user's pinch gesture changes. Each call to this method is made just after a column's width has changed.
 
 @param grid The grid containing the column that has been resized.
 @param columnIndex The index of the column that has been resized.
 @param oldWidth The width that the column at `columnIndex` used to be before the resize.
 @param newWidth The width that the column at `columnIndex` now has.*/
- (void)   shinobiGrid:(ShinobiGrid *)grid 
didResizeColumnAtIndex:(NSUInteger) columnIndex 
             fromWidth:(float) oldWidth 
               toWidth:(float) newWidth;


#pragma mark -
#pragma mark Column and Row Reordering Notifications
/** @name Column and Row Reordering Notifications*/
/** Informs the delegate that two columns within the ShinobiGrid object have been switched.
 
 This method gives the delegate an opportunity to update the data source appropriately.
 
 @param grid The grid that contains the columns that have been switched.
 @param colIndexSwitched The first switched column.
 @param colIndexSwitchedWith The second switched column.
 
 @warning *Important* When a user drags and drops a column this only reorders the currently visible cells. Therefore it is important to update your data source so that when scrolling/panning takes place, the cells that become visible appear in the correct order.*/

- (void) shinobiGrid:(ShinobiGrid *)grid colAtIndex:(int) colIndexSwitched hasBeenSwitchedWithColAtIndex:(int) colIndexSwitchedWith;

/** Informs the delegate that two rows within the ShinobiGrid object have been switched.
 
 This method gives the delegate an opportunity to update the data source appropriately.
 
 @param grid The grid that contains the columns that have been switched.
 @param rowSwitched The first switched row.
 @param rowSwitchedWith The second switched row.
 
 @warning *Important* When a user drags and drops a row this only reorders the currently visible cells. Therefore it is important to update your data source so that when scrolling/panning takes place, the cells that become visible appear in the correct order.*/
- (void) shinobiGrid:(ShinobiGrid *)grid row: (SGridRow) rowSwitched hasBeenSwitchedWithRow: (SGridRow) rowSwitchedWith;


#pragma mark -
#pragma mark Reordering Arrow Notifications
/** @name Reordering Arrow Notifications*/
/** Asks the delegate for an image that will be used for an arrow that is displayed when the user initiates the drag/drop of a column/row.
 
 @param grid The grid that is requesting the arrow image.
 @param orientation The orientation of the image that is being requested - this signifies whether the arrow is pointing up, down, left or right.
 @param gridCoord The coordinates of the cell that will display the arrow image.
 
 @return A UIImage that will be used for the arrow in the cell at `gridCoord` that points in the direction `orientation`.*/
- (UIImage*) shinobiGrid:(ShinobiGrid*) grid arrowImageForOrientation:(SGridArrowOrientation) orientation forCellAtCoord:(const SGridCoord*)gridCoord;

/** Asks the delegate for the offset of an arrow image that is going to be displayed due to the user having initiated the drag/drop of a column/row. 
 
 This method allows you to provide an offset that will change the position of the arrow image that is about to be displayed.
 
 @param grid The gird that is requesting the offset.
 @param orientation The orientation of the arrow that will have the offset applied to it.
 @param gridCoord The coordintates of the cell that will display the arrow image.
 
 @return A CGPoint that represents the offset that will be applied to the arrow in the cell at `gridCoord` that points in the direction `orientation`.*/
- (CGPoint) shinobiGrid:(ShinobiGrid*) grid offsetForArrowImageWithOrientation:(SGridArrowOrientation) orientation forCellAtCoord:(const SGridCoord*)gridCoord;

@end
