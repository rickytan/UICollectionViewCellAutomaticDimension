// UICollectionView+RTAutosizing.m
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

#import <objc/runtime.h>
#import "UICollectionView+RTAutosizing.h"

@interface NSCache (RTAutosizing) <RTCollectionViewCellHeightCache>
@end

@implementation NSCache (RTAutosizin)

- (void)setHeight:(CGFloat)height forKey:(id<NSCopying>)key
{
    [self setObject:@(height) forKey:key];
}

- (CGFloat)heightForKey:(id<NSCopying>)key
{
#if CGFLOAT_IS_DOUBLE
    return [[self objectForKey:key] doubleValue];
#else
    return [[self objectForKey:key] floatValue];
#endif
}

- (BOOL)heightCacheExistsForKey:(id<NSCopying>)key
{
    return !![self objectForKey:key];
}

- (void)invalidateHeightForKey:(id<NSCopying>)key
{
    [self removeObjectForKey:key];
}

- (void)invalidateAllHeight
{
    [self removeAllObjects];
}

@end

@implementation UICollectionView (RTAutosizing)

- (void)setTemplateCellCache:(NSCache *)templateCellCache
{
    objc_setAssociatedObject(self, @selector(templateCellCache), templateCellCache, OBJC_ASSOCIATION_RETAIN);
}

- (NSCache<Class, UICollectionViewCell *> *)templateCellCache
{
    return objc_getAssociatedObject(self, @selector(templateCellCache));
}

- (id<RTCollectionViewCellHeightCache>)rt_heightCache
{
    id<RTCollectionViewCellHeightCache> cache = objc_getAssociatedObject(self, @selector(rt_heightCache));
    if (!cache) {
        cache = [[NSCache alloc] init];
        objc_setAssociatedObject(self, @selector(rt_heightCache), cache, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return cache;
}

- (CGSize)rt_sizeForItemAtIndexPath:(NSIndexPath *)indexPath
                          cellClass:(Class)cls
                         setupBlock:(void (^)(__kindof UICollectionViewCell *))setupBlock
{
    if (!self.templateCellCache) {
        self.templateCellCache = [[NSCache alloc] init];
    }

    UICollectionViewCell *cell = [self.templateCellCache objectForKey:cls];
    if (!cell) {
        cell = [[cls alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 240)];
        cell.contentView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.templateCellCache setObject:cell
                                   forKey:cls];
    }

    if (cell && setupBlock) {
        [cell prepareForReuse];
        setupBlock(cell);
    }

    return [cell.contentView rt_expectedSizeConstrainedToWidth:self.bounds.size.width];
}

- (CGFloat)rt_heightForItemAtIndexPath:(NSIndexPath *)indexPath
                             withWidth:(CGFloat)width
                             cellClass:(Class)cls
                            setupBlock:(void (^)(__kindof UICollectionViewCell *))setupBlock
{
    if (!self.templateCellCache) {
        self.templateCellCache = [[NSCache alloc] init];
    }

    UICollectionViewCell *cell = [self.templateCellCache objectForKey:cls];
    if (!cell) {
        cell = [[cls alloc] initWithFrame:CGRectMake(0, 0, width, 240)];
        cell.contentView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.templateCellCache setObject:cell
                                   forKey:cls];
    }

    if (cell && setupBlock) {
        [cell prepareForReuse];
        setupBlock(cell);
    }

    return [cell.contentView rt_expectedSizeForWidth:width].height;
}

- (CGFloat)rt_heightForItemAtIndexPath:(NSIndexPath *)indexPath
                            cacheByKey:(id<NSCopying>)key
                             withWidth:(CGFloat)width
                             cellClass:(Class)cls
                            setupBlock:(void (^)(__kindof UICollectionViewCell *))setupBlock
{
    if (![self.rt_heightCache heightCacheExistsForKey:key]) {
        CGFloat height = [self rt_heightForItemAtIndexPath:indexPath
                                                 withWidth:width
                                                 cellClass:cls
                                                setupBlock:setupBlock];
        [self.rt_heightCache setHeight:height forKey:key];
        return height;
    }
    return [self.rt_heightCache heightForKey:key];
}

@end

@implementation UIView (RTAutosizing)

- (CGSize)rt_expectedSizeConstrainedToWidth:(CGFloat)width
{
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:self
                                                                       attribute:NSLayoutAttributeWidth
                                                                       relatedBy:NSLayoutRelationLessThanOrEqual
                                                                          toItem:nil
                                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                                      multiplier:1.f
                                                                        constant:width];
    [self addConstraint:widthConstraint];
    CGSize size = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    [self removeConstraint:widthConstraint];
    return size;
}

- (CGSize)rt_expectedSizeForWidth:(CGFloat)width
{
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:self
                                                                       attribute:NSLayoutAttributeWidth
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:nil
                                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                                      multiplier:1.f
                                                                        constant:width];
    [self addConstraint:widthConstraint];
    CGSize size = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    [self removeConstraint:widthConstraint];
    return size;
}

@end
