//
//  DVHeaderStretchableTVC.m
//  DVHeaderStretchableTVC_Example
//
//  Created by Denis Vashkovski on 15/08/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import "DVHeaderStretchableTVC.h"

@interface DVHeaderStretchableTVC ()
@property (nonatomic, strong) id observerContentOffset;
@end

@implementation DVHeaderStretchableTVC

#define VIEW_STRETCHABLE_TAG 9191
- (void)dv_reloadStretchableData {
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

#define CONTENT_OFFSET_KEYPATH @"contentOffset"
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self isNeedPrepareStretchableView]) {
        [self dv_reloadStretchableData];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([self isNeedPrepareStretchableView]) {
        [self.tableView addObserver:self forKeyPath:CONTENT_OFFSET_KEYPATH options:NSKeyValueObservingOptionNew context:nil];
        self.observerContentOffset = @(YES);
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.observerContentOffset) {
        [self.tableView removeObserver:self forKeyPath:CONTENT_OFFSET_KEYPATH];
        self.observerContentOffset = nil;
    }
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
    
    UIView *stretchableView = [[UIView alloc] initWithFrame:CGRectMake(.0,
                                                                    -heightStretchableView,
                                                                    self.tableView.frame.size.width,
                                                                    heightStretchableView)];
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
