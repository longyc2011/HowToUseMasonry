//
//  UIView+VariableMargin.h
//  HowToUseMasonry
//
//  Created by Stevens Sun on 2016/12/4.
//  Copyright © 2016年 shangbin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"

@interface UIView (VariableMargin)
- (void)distributeViewsAlongAxis:(MASAxisType)axisType
           withSpaceWeightArrays:(NSArray*)spaceWeightArray
                andSubViewsArray:(NSArray*)subViews;
- (void)distributeSpacingHorizontallyWith:(NSArray*)views;
- (void)distributeSpacingVerticallyWith:(NSArray*)views;
@end
