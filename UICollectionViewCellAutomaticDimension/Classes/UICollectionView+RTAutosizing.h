// UICollectionView+RTAutosizing.h
//
// Copyright (c) 2017 Ricky Tan
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <UIKit/UIKit.h>


@protocol RTCollectionViewCellHeightCache <NSObject>
@required
- (void)setHeight:(CGFloat)height forKey:(id<NSCopying>)key;
- (CGFloat)heightForKey:(id<NSCopying>)key;
- (BOOL)heightCacheExistsForKey:(id<NSCopying>)key;
- (void)invalidateHeightForKey:(id<NSCopying>)key;
- (void)invalidateAllHeight;

@end

/**

 */
@interface UICollectionView (RTAutosizing)
@property (nonatomic, strong, readonly) id<RTCollectionViewCellHeightCache> rt_heightCache;

- (CGSize)rt_sizeForItemAtIndexPath:(NSIndexPath *)indexPath
                          cellClass:(Class)cls
                         setupBlock:(NS_NOESCAPE void(^)(__kindof UICollectionViewCell * cell))setupBlock;

- (CGFloat)rt_heightForItemAtIndexPath:(NSIndexPath *)indexPath
                             withWidth:(CGFloat)width
                             cellClass:(Class)cls
                            setupBlock:(NS_NOESCAPE void(^)(__kindof UICollectionViewCell * cell))setupBlock;

- (CGFloat)rt_heightForItemAtIndexPath:(NSIndexPath *)indexPath
                            cacheByKey:(id<NSCopying>)key
                             withWidth:(CGFloat)width
                             cellClass:(Class)cls
                            setupBlock:(NS_NOESCAPE void(^)(__kindof UICollectionViewCell * cell))setupBlock;

@end

@interface UIView (RTAutosizing)

- (CGSize)rt_expectedSizeConstrainedToWidth:(CGFloat)width;
- (CGSize)rt_expectedSizeForWidth:(CGFloat)width;

@end
