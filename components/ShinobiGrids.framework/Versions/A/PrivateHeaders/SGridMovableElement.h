// SGridMovableElement.h
#import <Foundation/Foundation.h>

@class SGridLayerContent;
@class SGridLayer;
@class ShinobiGrid;

@protocol SGridMovableElement <NSObject>

@property (nonatomic, assign, getter = isCollapsed) BOOL    collapsed;

- (CGPoint) center; 
- (void)    setCenter:(CGPoint)center pinMovement:(BOOL) pinMovement;
- (void)    adjustYPositionOfCentreBy:(NSNumber *) amountToAdjustBy;
- (void)    removeFromContent;
- (void)    bringToFront;
- (void)    sendToBack;

@end
