//
//  DVHeaderStretchableTVC.h
//  DVHeaderStretchableTVC_Example
//
//  Created by Denis Vashkovski on 15/08/16.
//  Copyright © 2016 Denis Vashkovski. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DVHeaderStretchableTVCDelegate <NSObject>
@optional
- (CGFloat)dv_heightForStretchableView;
- (UIView *)dv_viewForStretchableView;
- (void)dv_reloadStretchableData;
@end

@interface DVHeaderStretchableTVC : UITableViewController<DVHeaderStretchableTVCDelegate>

@end
