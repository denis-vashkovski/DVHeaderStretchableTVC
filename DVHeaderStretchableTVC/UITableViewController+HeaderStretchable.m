//
//  UITableViewController+HeaderStretchable.m
//  DVHeaderStretchableTVC_Example
//
//  Created by Denis Vashkovski on 15/08/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import "UITableViewController+HeaderStretchable.h"

#import <objc/runtime.h>

@interface UITableViewController(HeaderStretchable_Private)
@property (nonatomic, strong) id observerContentOffset;
@end
@implementation UITableViewController(HeaderStretchable_Private)
- (id)observerContentOffset {
    return objc_getAssociatedObject(self, @selector(observerContentOffset));
}
- (void)setObserverContentOffset:(id)observerContentOffset {
    objc_setAssociatedObject(self, @selector(observerContentOffset), observerContentOffset, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end

#define VIEW_STRETCHABLE_TAG 9191
#define CONTENT_OFFSET_KEYPATH @"contentOffset"
@implementation UITableViewController(HeaderStretchable)

+ (void)addSwizzlingSelector:(SEL)swizzledSelector originalSelector:(SEL)originalSelector {
    Class class = [self class];
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    if (class_addMethod(class,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod))) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self addSwizzlingSelector:@selector(hs_viewDidLoad) originalSelector:@selector(viewDidLoad)];
        [self addSwizzlingSelector:@selector(hs_viewWillAppear:) originalSelector:@selector(viewWillAppear:)];
        [self addSwizzlingSelector:@selector(hs_viewWillDisappear:) originalSelector:@selector(viewWillDisappear:)];
    });
}

#pragma mark - Swizzling methods
- (void)hs_viewDidLoad {
    [self hs_viewDidLoad];
    
    if ([self isNeedPrepareStretchableView]) {
        [self reloadStretchableData];
    }
}

- (void)hs_viewWillAppear:(BOOL)animated {
    [self hs_viewWillAppear:animated];
    
    if ([self isNeedPrepareStretchableView]) {
        [self.tableView addObserver:self forKeyPath:CONTENT_OFFSET_KEYPATH options:NSKeyValueObservingOptionNew context:nil];
        self.observerContentOffset = @(YES);
    }
}

- (void)hs_viewWillDisappear:(BOOL)animated {
    [self hs_viewWillDisappear:animated];
    
    if (self.observerContentOffset) {
        [self.tableView removeObserver:self forKeyPath:CONTENT_OFFSET_KEYPATH];
        self.observerContentOffset = nil;
    }
}

- (void)reloadStretchableData {
    if (![self isNeedPrepareStretchableView]) {
        return;
    }
    
    UIView *stretchableView = [self.tableView viewWithTag:VIEW_STRETCHABLE_TAG];
    if (stretchableView) {
        [stretchableView removeFromSuperview];
        
        UIEdgeInsets contentinsetst = self.tableView.contentInset;
        contentinsetst.top = .0;
        [self.tableView setContentInset:contentinsetst];
    }
    
    [self prepareStretchableView];
}

#pragma mark - Observer
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (![CONTENT_OFFSET_KEYPATH isEqualToString:keyPath] || ![self isNeedPrepareStretchableView]) {
        return;
    }
    
    CGFloat yOffset = [[change objectForKey:@"new"] CGPointValue].y;
    if (yOffset >= -self.dv_heightForStretchableView) {
        return;
    }
    
    UIView *stretchableView = [self.tableView viewWithTag:VIEW_STRETCHABLE_TAG];
    if (stretchableView) {
        CGRect frameNew = stretchableView.frame;
        frameNew.origin.y = yOffset;
        frameNew.size.height = -yOffset;
        
        [stretchableView setFrame:frameNew];
    }
}

#pragma mark - Utils
- (void)prepareStretchableView {
    CGFloat heightStretchableView = self.dv_heightForStretchableView;
    UIView *view = nil;
    if ((heightStretchableView <= .0) || !(view = self.dv_viewForStretchableView)) {
        return;
    }
    
    UIView *stretchableView = [[UIView alloc] initWithFrame:CGRectMake(.0, -heightStretchableView, self.tableView.frame.size.width, heightStretchableView)];
    [stretchableView setBackgroundColor:[UIColor clearColor]];
    [stretchableView setTag:VIEW_STRETCHABLE_TAG];
    [self.tableView addSubview:stretchableView];
    
    [stretchableView addSubview:view];
    
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [stretchableView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
    [stretchableView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
    
    UIEdgeInsets contentInset = self.tableView.contentInset;
    contentInset.top += heightStretchableView;
    [self.tableView setContentInset:contentInset];
    [self.tableView setContentOffset:CGPointMake(.0, -contentInset.top)];
}

- (BOOL)isNeedPrepareStretchableView {
    return [self respondsToSelector:@selector(dv_heightForStretchableView)] && [self respondsToSelector:@selector(dv_viewForStretchableView)];
}

@end
