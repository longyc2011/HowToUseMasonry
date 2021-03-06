//
//  UIView+EqualMargin.h
//  HowToUseMasonry
//
//  Created by sharejoy on 16-05-29.
//  Copyright © 2016年 shangbin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (EqualMargin)
- (void)distributeViewsAlongAxis:(MASAxisType)axisType
           withSpaceWeightArrays:(NSArray*)spaceWeightArray
                andSubViewsArray:(NSArray*)subViews;
- (void)distributeSpacingHorizontallyWith:(NSArray*)views;
- (void)distributeSpacingVerticallyWith:(NSArray*)views;

@end
