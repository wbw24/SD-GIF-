//
//  ViewController.m
//  SD-GIF优化
//
//  Created by 汪博文 on 2017/1/24.
//  Copyright © 2017年 汪博文. All rights reserved.
//

#import "ViewController.h"
#import <UIImage+GIF.h>
#import "WBWebImage.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imageViews;
@property (weak, nonatomic) IBOutlet WBWebImage *webImage;

@end

@implementation ViewController

//- (void)viewDidLoad {
//    [super viewDidLoad];
//    for (int i = 0; i < _imageViews.count; i++) {
//        NSString *fileName = [NSString stringWithFormat:@"%d",i+1];
//        UIImage *gifIMG = [UIImage sd_animatedGIFNamed:fileName];
//        UIImageView *imageView = _imageViews[i];
//        imageView.image = gifIMG;
//    }
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    for (int i = 0; i < _imageViews.count; i++) {
        NSURL *gifURL = [[NSBundle mainBundle] URLForResource:[NSString stringWithFormat:@"%d.gif",i+1] withExtension:nil];
        //使用自己优化的gif控件
        WBWebImage *imageView = _imageViews[i];
        [imageView WB_downloadIMGOrGif:gifURL];
    }
    NSURL *gifURL = [[NSBundle mainBundle] URLForResource:@"1.gif" withExtension:nil];

    //使用自己优化的gif控件
    [self.webImage WB_downloadIMGOrGif:gifURL];
}

@end























