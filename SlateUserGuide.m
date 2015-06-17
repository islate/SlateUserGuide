//
//  SlateUserGuide.m
//  SlateCore
//
//  Created by Xiangjian Meng on 13-12-4.
//  Copyright (c) 2013年 Modern Mobile Digital Media Company Limited. All rights reserved.
//

#import "SlateUserGuide.h"

@interface SlateUserGuide () <UIScrollViewDelegate>

@property (nonatomic, copy) void(^completionBlock)(void);


- (instancetype)initWithImageNames:(NSArray *)imageNames;

- (void)showWithCompletion:(void(^)(void))completion;

@end

@implementation SlateUserGuide
{
    NSMutableArray *_imageArray;
    UIScrollView *_guideScrollView;
}

+ (void)showWithImageNames:(NSArray *)imageNames identifier:(NSString *)identifier
{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:identifier])
    {
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        
        SlateUserGuide *guide = [[SlateUserGuide alloc] initWithImageNames:imageNames];
        [guide showWithCompletion:^{
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:identifier];
            [[UIApplication sharedApplication] setStatusBarHidden:NO];
        }];
    }
}

- (void)dealloc
{
    _guideScrollView.delegate = nil;
}

- (instancetype)initWithImageNames:(NSArray *)imageNames
{
    self = [super init];
    if (self) {
        [self createImageArrayWithImageNames:imageNames];
    }
    return self;
}

- (void)createImageArrayWithImageNames:(NSArray *)imageNames
{
    if (!imageNames || [imageNames count] == 0) {
        return;
    }
    
    _imageArray = [[NSMutableArray alloc] init];
    
    for (NSString *imagename in imageNames) {
        
        UIImage *image = [UIImage imageNamed:imagename];
        
        if (image)
        {
            [_imageArray addObject:image];
        }
    }
}

- (void)showWithCompletion:(void (^)(void))completion
{
    if (_guideScrollView) {
        return;
    }
    
    if (_imageArray && [_imageArray count] > 0) {
        
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        
        if (window) {
            
            CGSize windowSize = window.bounds.size;
            
            self.frame = window.bounds;
            
            _guideScrollView = [[UIScrollView alloc] initWithFrame:window.bounds];
            _guideScrollView.delegate = self;
            _guideScrollView.pagingEnabled = YES;
            _guideScrollView.backgroundColor = [UIColor clearColor];
            _guideScrollView.showsHorizontalScrollIndicator = NO;
            _guideScrollView.bounces = NO;
            
            int count = [_imageArray count];
            
            _guideScrollView.contentSize = CGSizeMake(windowSize.width * (count + 1), windowSize.height);
            
            for (int i = 0; i < count; i ++) {
                //逐个添加image
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(windowSize.width * i, 0, windowSize.width, windowSize.height)];
                
                imageView.image = [_imageArray objectAtIndex:i];
                
                [_guideScrollView addSubview:imageView];
                
                UIPageControl *page = [[UIPageControl alloc] initWithFrame:CGRectMake(0, imageView.bounds.size.height - 60, imageView.bounds.size.width, 30)];
                page.numberOfPages = count;
                page.currentPage = i;
                [imageView addSubview:page];
            }
            
            //最后一个添加一个空白的imageview
            UIImageView *clearImageView = [[UIImageView alloc] initWithFrame:CGRectMake(windowSize.width * count, 0, windowSize.width, windowSize.height)];
            clearImageView.backgroundColor = [UIColor clearColor];
            [_guideScrollView addSubview:clearImageView];
            
            [self addSubview:_guideScrollView];
            [window addSubview:self];
            
            self.completionBlock = completion;
        }
        
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat remainWidth = scrollView.contentSize.width - scrollView.contentOffset.x - scrollView.bounds.size.width;
    
    if (remainWidth < (scrollView.bounds.size.width / 2) && remainWidth >= 0) {
        CGFloat alpha = remainWidth /(scrollView.bounds.size.width / 2);
        scrollView.alpha = alpha;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat remainWidth = scrollView.contentSize.width - scrollView.contentOffset.x - scrollView.bounds.size.width;
    
    if (remainWidth < (scrollView.bounds.size.width / 2)) {
        
        if (self.completionBlock) {
            self.completionBlock();
        }
        
        if (self && self.superview) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self removeFromSuperview];
            });
        }
        
    }
}

@end
