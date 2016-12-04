//
//  UIView+VariableMargin.m
//  HowToUseMasonry
//
//  Created by Stevens Sun on 2016/12/4.
//  Copyright © 2016年 shangbin. All rights reserved.
//

#import "UIView+VariableMargin.h"

@implementation UIView (VariableMargin)
- (void)distributeViewsAlongAxis:(MASAxisType)axisType
           withSpaceWeightArrays:(NSArray*)spaceWeightArray
                andSubViewsArray:(NSArray*)subViews {
  if (spaceWeightArray.count <= subViews.count) {
    NSAssert(spaceWeightArray.count <= subViews.count,
             @"subViews to distribute need to smaller than spaceArray");
    return;
  }
  //判断传入的spaceWeightArray 是否全部为0，如果全部为0，按照等间距处理
  BOOL isSpaceWeightArrayAllZero = YES;
  NSMutableArray* array =
      [NSMutableArray arrayWithCapacity:spaceWeightArray.count];
  for (NSNumber* spaceWeight in spaceWeightArray) {
    CGFloat spaceWeightFloat = [spaceWeight floatValue];
    if (spaceWeightFloat <= 0.01) {
      [array addObject:@1];
      continue;
    } else {
      isSpaceWeightArrayAllZero = NO;
      break;
    }
  }

  if (isSpaceWeightArrayAllZero) {
    spaceWeightArray = array;
  }

  __weak __typeof(&*self) ws = self;

  BOOL isFirstSpaceView = YES;
  BOOL isSelectFirstNotZeroWeight = NO;
  BOOL isMASAxisTypeHorizontal = NO;
  CGFloat normalizeWeight = 0;
  UIView* lastSpace;
  int index = 0;

  UIView* firstSpace;

  isMASAxisTypeHorizontal = (axisType == MASAxisTypeHorizontal);

  if (!isMASAxisTypeHorizontal) {
    subViews = [[subViews reverseObjectEnumerator] allObjects];

    spaceWeightArray = [[spaceWeightArray reverseObjectEnumerator] allObjects];
  }

  for (NSNumber* spaceWeight in spaceWeightArray) {
    UIView* spaceView = [UIView new];
    // spaceView.backgroundColor = [UIColor cyanColor];
    CGFloat spaceWeightFloat = [spaceWeight floatValue];

    [self addSubview:spaceView];

    if (spaceWeightFloat >= 0.01 && !isSelectFirstNotZeroWeight) {
      isSelectFirstNotZeroWeight = YES;
      firstSpace = spaceView;
      normalizeWeight = spaceWeightFloat;
    }

    if (isSelectFirstNotZeroWeight) {
      spaceWeightFloat = 1.0 * spaceWeightFloat / normalizeWeight;
    }

    if (isFirstSpaceView) {
      isFirstSpaceView = NO;
      lastSpace = spaceView;

      [spaceView mas_makeConstraints:^(MASConstraintMaker* make) {
        if (isSelectFirstNotZeroWeight) {
          make.width.equalTo(firstSpace).multipliedBy(spaceWeightFloat);
          make.height.equalTo(firstSpace).multipliedBy(spaceWeightFloat);
        } else {
          make.width.equalTo(@0);
          make.height.equalTo(@0);
        }
        if (isMASAxisTypeHorizontal) {
          make.left.equalTo(ws.mas_left);
          make.height.equalTo(spaceView.mas_width).priorityLow();
          make.top.equalTo(ws.mas_top).priorityLow();
        } else {
          make.bottom.equalTo(ws.mas_bottom).priorityLow();
          make.width.equalTo(spaceView.mas_height).priorityLow();
          make.left.equalTo(ws.mas_left);
        }

      }];

    } else {
      UIView* realView = subViews[index - 1];
      [realView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(lastSpace.mas_right).priorityLow();
        make.bottom.equalTo(lastSpace.mas_top).priorityLow();

      }];

      [spaceView mas_makeConstraints:^(MASConstraintMaker* make) {
        if (isSelectFirstNotZeroWeight) {
          make.width.equalTo(firstSpace)
              .multipliedBy(spaceWeightFloat)
              .priorityLow();
          make.height.equalTo(firstSpace)
              .multipliedBy(spaceWeightFloat)
              .priorityLow();
        } else {
          make.width.equalTo(@0).priorityLow();
          make.height.equalTo(@0).priorityLow();
        }
        if (isMASAxisTypeHorizontal) {
          make.left.equalTo(realView.mas_right);

          make.top.equalTo(realView.mas_top).with.priorityLow();

          make.height.equalTo(spaceView.mas_width);
        } else {
          make.bottom.equalTo(realView.mas_top).priorityLow();
          make.left.equalTo(realView.mas_left);
          make.width.equalTo(realView.mas_width);
        }

      }];

      lastSpace = spaceView;
    }

    index++;
  }

  [lastSpace mas_makeConstraints:^(MASConstraintMaker* make) {
    make.right.equalTo(ws.mas_right).priorityLow();
    make.top.equalTo(ws.mas_top);
  }];
}

- (void)distributeSpacingHorizontallyWith:(NSArray*)views {
  NSMutableArray* array = [NSMutableArray arrayWithCapacity:(views.count + 1)];

  const long count = views.count;

  for (long i = 0; i < count; i++) {
    [array addObject:@1];
  }

  [self distributeViewsAlongAxis:MASAxisTypeHorizontal
           withSpaceWeightArrays:array
                andSubViewsArray:views];
}
- (void)distributeSpacingVerticallyWith:(NSArray*)views {
  NSMutableArray* array = [NSMutableArray arrayWithCapacity:(views.count + 1)];

  const long count = views.count;

  for (long i = 0; i < count; i++) {
    [array addObject:@1];
  }

  [self distributeViewsAlongAxis:MASAxisTypeVertical
           withSpaceWeightArrays:array
                andSubViewsArray:views];
}
@end
