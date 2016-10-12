//
//  FHImageViewerTransition.m
//  Demo
//
//  Created by MADAO on 16/10/10.
//  Copyright © 2016年 MADAO. All rights reserved.
//

#import "FHImageViewerTransition.h"

static CGFloat const kAnimationDuration = 0.5f;
static CGFloat const kNavigationHeight = 64.f;
@implementation FHImageViewerTransition

- (instancetype)initWithTranFromView:(UIImageView *)transFromView
{
    if (self = [super init]) {
        self.transFromView = transFromView;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return kAnimationDuration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *containerView = [transitionContext containerView];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];

    //Get the beginning UIView of transition
    if (self.transFromView != nil) {
        UIView *tempView;
        if ([self.transFromView isKindOfClass:[UITableView class]]) {
            UITableView *transFromTableView = (UITableView *)self.transFromView;
            UITableViewCell *transiFromCell = [transFromTableView cellForRowAtIndexPath:[transFromTableView indexPathForSelectedRow]];
            tempView = transiFromCell;
        }
        else if ([self.transFromView isKindOfClass:[UICollectionView class]]){
            UICollectionView *transFromCollectionView = (UICollectionView *)self.transFromView;
            UICollectionViewCell *transFromCell = [transFromCollectionView cellForItemAtIndexPath:[[transFromCollectionView indexPathsForSelectedItems] firstObject]];
            tempView = transFromCell;
        }else{
            tempView = self.transFromView;
        }
        //Take a snapShot of the transFromView
        UIView *snapShotView = [tempView snapshotViewAfterScreenUpdates:NO];
        
        //Get rootView
        UIView *rootView = tempView;
        while (rootView.superview) {
            rootView = rootView.superview;
            if ([rootView isKindOfClass:[UITableViewCell class]] || [rootView isKindOfClass:[UICollectionViewCell class]] || [fromVC.view.subviews containsObject:rootView]){
                break;
            }
        }
        snapShotView.frame = [containerView convertRect:tempView.frame fromView:rootView];
        
        //Set ending view
        toVC.view.frame = [transitionContext finalFrameForViewController:toVC];
        toVC.view.alpha = 0;
        //Add two views to containView
        
        [containerView addSubview:snapShotView];
        [containerView addSubview:toVC.view];

        //Calculate the ending View's size according to the image size
        UIWindow *window = [UIApplication sharedApplication].windows.lastObject;
        CGFloat imageHeight = window.frame.size.width * self.transFromView.image.size.height/self.transFromView.image.size.width;
        CGRect endingSize;
        if (toVC.navigationController && toVC.navigationController.navigationBarHidden == NO){
            endingSize = CGRectMake(0, (window.frame.size.height - imageHeight + kNavigationHeight)/2.f, window.frame.size.width , imageHeight);
        }else{
            endingSize = CGRectMake(0, (window.frame.size.height - imageHeight)/2.f,  window.frame.size.width, imageHeight);
        }
 
        //Animation
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            toVC.view.alpha = 1;
            snapShotView.frame = endingSize;
        } completion:^(BOOL finished) {
            snapShotView.hidden = YES;
        }];
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }else{
        return;
    }
    
}

@end
