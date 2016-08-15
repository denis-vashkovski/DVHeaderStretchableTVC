//
//  UITableViewController+HeaderStretchable.h
//  DVHeaderStretchableTVC_Example
//
//  Created by Denis Vashkovski on 15/08/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol UITableViewHeaderStretchable <NSObject>
@optional
- (CGFloat)dv_heightForParallaxView;
- (UIView *)dv_viewForParallaxView;
- (void)dv_reloadParallaxData;
@end

@interface UITableViewController(HeaderStretchable)<UITableViewHeaderStretchable>

@end
