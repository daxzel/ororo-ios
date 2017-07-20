//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

#import <UIKit/UIKit.h>

@interface LDAlignmentImageView : UIImageView

typedef enum LDImageVerticalAlignment{
    LDImageVerticalAlignmentTop,
    LDImageVerticalAlignmentCenter,
    LDImageVerticalAlignmentBottom
} LDImageVerticalAlignment;

typedef enum LDImageHorizontalAlignment{
    LDImageHorizontalAlignmentLeft,
    LDImageHorizontalAlignmentCenter,
    LDImageHorizontalAlignmentRight
} LDImageHorizontalAlignment;

typedef enum LDImageContentMode{
    LDImageContentModeScaleAspectFill,
    LDImageContentModeScaleAspectFit,
    LDImageContentModeScaleToFill,
    LDImageContentModeOriginalSize
} LDImageContentMode;

@property (nonatomic) LDImageVerticalAlignment imageVerticalAlignment;
@property (nonatomic) LDImageHorizontalAlignment imageHorizontalAlignment;
@property (nonatomic) LDImageContentMode imageContentMode;

@end
