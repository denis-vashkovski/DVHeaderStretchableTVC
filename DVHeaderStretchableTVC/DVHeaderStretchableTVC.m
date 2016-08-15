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

#define VIEW_PARALLAX_TAG 9191
- (void)dv_reloadParallaxData {
    if (![self isNeedPrepareParallaxView]) {
        return;
    }
    
    UIView *parallaxView = [self.tableView viewWithTag:VIEW_PARALLAX_TAG];
    if (parallaxView) {
        [parallaxView removeFromSuperview];
        
        UIEdgeInsets contentinsetst = self.tableView.contentInset;
        contentinsetst.top = .0;
        [self.tableView setContentInset:contentinsetst];
    }
    
    [self prepareParallaxView];
}

#define CONTENT_OFFSET_KEYPATH @"contentOffset"
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self isNeedPrepareParallaxView]) {
        [self dv_reloadParallaxData];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([self isNeedPrepareParallaxView]) {
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
    if (![CONTENT_OFFSET_KEYPATH isEqualToString:keyPath] || ![self isNeedPrepareParallaxView]) {
        return;
    }
    
    CGFloat yOffset = [[change objectForKey:@"new"] CGPointValue].y;
    if (yOffset >= -self.dv_heightForParallaxView) {
        return;
    }
    
    UIView *parallaxView = [self.tableView viewWithTag:VIEW_PARALLAX_TAG];
    if (parallaxView) {
        CGRect frameNew = parallaxView.frame;
        frameNew.origin.y = yOffset;
        frameNew.size.height = -yOffset;
        
        [parallaxView setFrame:frameNew];
    }
}

#pragma mark - Utils
- (void)prepareParallaxView {
    CGFloat heightParallaxView = self.dv_heightForParallaxView;
    UIView *view = nil;
    if ((heightParallaxView <= .0) || !(view = self.dv_viewForParallaxView)) {
        return;
    }
    
    UIView *parallaxView = [[UIView alloc] initWithFrame:CGRectMake(.0,
                                                                    -heightParallaxView,
                                                                    self.tableView.frame.size.width,
                                                                    heightParallaxView)];
    [parallaxView setBackgroundColor:[UIColor clearColor]];
    [parallaxView setTag:VIEW_PARALLAX_TAG];
    [self.tableView addSubview:parallaxView];
    
    [parallaxView addSubview:view];
    
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [parallaxView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
    [parallaxView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)]];
    
    UIEdgeInsets contentInset = self.tableView.contentInset;
    contentInset.top += heightParallaxView;
    [self.tableView setContentInset:contentInset];
    [self.tableView setContentOffset:CGPointMake(.0, -contentInset.top)];
}

- (BOOL)isNeedPrepareParallaxView {
    return [self respondsToSelector:@selector(dv_heightForParallaxView)] && [self respondsToSelector:@selector(dv_viewForParallaxView)];
}

@end
