//
//  FHImageViewerTransition.m
//  Demo
//
//  Created by MADAO on 16/10/10.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "FHImageViewerTransition.h"

@interface FHImageViewerTransition()

@property (nonatomic, assign, readwrite) NSTimeInterval animationDuration;

@end

@implementation FHImageViewerTransition

- (instancetype)initWithTranFromView:(UIImageView *)transFromView transToView:(UIImageView *)transToView animationDuration:(NSTimeInterval)animationDuration
{
    if (self = [super init]) {
        self.transFromView = transFromView;
        self.transToView = transToView;
        self.animationDuration = animationDuration;
    }
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return self.animationDuration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *containerView = [transitionContext containerView];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    //Get the beginning UIView of transition
    if (self.transFromView != nil) {
        UIView *tempView = self.transFromView;
    
        //Get rootView
        UIView *rootView = tempView;
        while (rootView.superview) {
            rootView = rootView.superview;
            if ([rootView isKindOfClass:[UITableViewCell class]] || [rootView isKindOfClass:[UICollectionViewCell class]] || [fromVC.view.subviews containsObject:rootView]){
                break;
            }
        }
        UIView * snapShotView = [tempView snapshotViewAfterScreenUpdates:NO];
        snapShotView.frame = [containerView convertRect:tempView.frame fromView:rootView];
        self.transFromView.hidden = YES;
        toVC.view.alpha = 0;
        
        //Add two views to containView
        [containerView addSubview:snapShotView];
        [containerView addSubview:toVC.view];

#warning to recalculator rect;
        CGRect endFrame = self.transToView.frame;
        if (self.transToView.contentMode == UIViewContentModeScaleAspectFit) {
            CGFloat scale = self.transToView.image.size.height/self.transToView.image.size.width/1.f;
            CGFloat newHeight = (self.transToView.frame.size.width) *scale;
            endFrame = CGRectMake(0, (self.transToView.frame.size.height - newHeight)/2.f, self.transToView.frame.size.width, newHeight);
        }
        
        //Animation
        @weakify(snapShotView)
        @weakify(toVC)
        @WEAKSELF;
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            weak_snapShotView.frame = endFrame;
        } completion:^(BOOL finished) {
            weakSelf.transFromView.hidden = NO;
            weak_toVC.view.alpha = 1;
            [weak_snapShotView removeFromSuperview];
        }];
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }else{
        return;
    }
}

@end
