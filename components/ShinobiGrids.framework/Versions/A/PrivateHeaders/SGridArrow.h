
#import "SGridArrowOrientation.h"

@interface SGridArrow : UIImageView {
    SGridArrowOrientation orientation;
    CGPoint futureCenter;
	CGSize cellSize;
}

- (id) initWithOrientation:(SGridArrowOrientation)initOrientation withImage:(UIImage*) imageForArrow userControlsOrientation:(BOOL) userControlsOrientation;

- (void) addToCell:(SGridCell *)cell;

- (void) pulse;
- (void) fadeIn;
- (void) fadeOut;

@end
