//
//  TYSnapshotScroll.m
//  TYSnapshotScroll
//
//  Created by apple on 16/12/28.
//  Copyright © 2016年 TonyReet. All rights reserved.
//

#import "TYSnapshotScroll.h"
#import "WKWebView+TYSnapshot.h"
#import "UIScrollView+TYSnapshot.h"
#import "UIView+TYSnapshot.h"

@implementation TYSnapshotScroll

+ (void )screenSnapshot:(UIView *)snapshotView finishBlock:(void(^)(UIImage *snapShotImage))finishBlock{
    [self screenSnapshot:snapshotView needMask:YES addMaskAfterBlock:nil finishBlock:finishBlock];
}

+ (void )screenSnapshot:(UIView *)snapshotView addMaskAfterBlock:(void(^)(void))addMaskAfterBlock finishBlock:(void(^)(UIImage *snapShotImage))finishBlock{
    BOOL needMask = addMaskAfterBlock?YES:NO;
    [self screenSnapshot:snapshotView needMask:needMask addMaskAfterBlock:addMaskAfterBlock finishBlock:finishBlock];
}
    
+ (void )screenSnapshot:(UIView *)snapshotView needMask:(BOOL)needMask addMaskAfterBlock:(void(^)(void))addMaskAfterBlock finishBlock:(void(^)(UIImage *snapShotImage))finishBlock{
    UIView *snapshotFinalView = snapshotView;
    
    if([snapshotView isKindOfClass:[WKWebView class]]){
        //WKWebView
        snapshotFinalView = (WKWebView *)snapshotView;
        
    }else if([snapshotView isKindOfClass:[UIWebView class]]){
        
        //UIWebView
        UIWebView *webView = (UIWebView *)snapshotView;
        snapshotFinalView = webView.scrollView;
    }else if([snapshotView isKindOfClass:[UIScrollView class]] ||
             [snapshotView isKindOfClass:[UITableView class]] ||
             [snapshotView isKindOfClass:[UICollectionView class]]
             ){
        //ScrollView
        snapshotFinalView = (UIScrollView *)snapshotView;
    }else{
        NSLog(@"不支持的类型");
    }
  
    [snapshotView screenSnapshotNeedMask:needMask addMaskAfterBlock:addMaskAfterBlock finishBlock:^(UIImage * _Nonnull snapShotImage) {
        if (snapShotImage != nil && finishBlock) {
            finishBlock(snapShotImage);
        }
    }];
}

+(void )screenSnapshotWithMultipleScroll:(UIView *)snapshotView modifyLayoutBlock:(void(^)(CGFloat extraHeight))modifyLayoutBlock finishBlock:(void(^)(UIImage *snapShotImage))finishBlock  {
   [TYSnapshotScroll scrollViewGetTotalExtraHeight:snapshotView finishBlock:^(CGFloat subScrollViewExtraHeight) {

       !modifyLayoutBlock?:modifyLayoutBlock(subScrollViewExtraHeight);

       [TYSnapshotScroll screenSnapshot:snapshotView finishBlock:^(UIImage *snapShotImage) {
           !finishBlock?:finishBlock(snapShotImage);
       }];
   }];
}

+ (void )scrollViewGetTotalExtraHeight:(UIView *)view finishBlock:(void(^)(CGFloat subScrollViewExtraHeight))finishBlock{
    
    if (![view isKindOfClass:[UIScrollView class]]){
        !finishBlock?:finishBlock(0);
        return;
    };

    UIScrollView *scrollView = (UIScrollView *)view;
    [scrollView subScrollViewTotalExtraHeight:^(CGFloat subScrollViewExtraHeight) {
        !finishBlock?:finishBlock(subScrollViewExtraHeight);
    }];
}



@end
