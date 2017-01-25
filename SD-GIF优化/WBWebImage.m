//
//  WBWebImage.m
//  SD-GIF优化
//
//  Created by 汪博文 on 2017/1/25.
//  Copyright © 2017年 汪博文. All rights reserved.
//

#import "WBWebImage.h"
#import <SDWebImageManager.h>
#import <NSData+ImageContentType.h>
#import <UIImage+GIF.h>
#import <ImageIO/ImageIO.h>

@implementation WBWebImage {
    //记录当前是第几张gif
    NSInteger _currentIndex;
    //定时器
    NSTimer *_timer;
    //gif图片的二进制数据
    NSData *_data;
}

- (void)WB_downloadIMGOrGif:(NSURL *)url {
    //1.根据url去下载图片的二进制数据
    //2.根据图片的类型判断如果是gif特殊处理
    //3.如果是其他类型,直接显示
    
    _timer = [NSTimer timerWithTimeInterval:0.12 target:self selector:@selector(updateIMG) userInfo:nil repeats:YES];
    [self downloadIMGData:url];
}
- (void)updateIMG {
    //不断的调用生成gif的方法,并且不断的赋值给imageView
    self.image = [self wb_animatedGIFWithData:_data];
}

//下载图片
- (void)downloadIMGData:(NSURL *)url {
    //从管理者进行查找
    [[SDWebImageManager sharedManager].imageDownloader downloadImageWithURL:url options:0 progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        if (error) {
            NSLog(@"下载错误%@",error);
            return;
        }
        //根据图片的类型进行判断;
        //UI操作放在主线程
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if ([[NSData sd_contentTypeForImageData:data] isEqualToString:@"image/gif"]) {
                //据图片的类型判断如果是gif特殊处理
                _data = data;
                [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
            } else {
                
                self.image = image;
            }

        }];
    }];
}
//原始代码是把所有的gif全部加载处理完毕才去播放,内存占用过多
//修改: 开启一个定时器,不断的去gif中取出对应的单张图片
- (UIImage *)wb_animatedGIFWithData:(NSData *)data {
    if (!data) {
        return nil;
    }
    
    //类型转换
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    //几张图片
    size_t count = CGImageSourceGetCount(source);
    //返回的变量
    UIImage *animatedImage;
    
    if (count <= 1) {
        animatedImage = [[UIImage alloc] initWithData:data];
    }
    else {
        
        //取出gif中的单张图片
        CGImageRef image = CGImageSourceCreateImageAtIndex(source, _currentIndex % count, NULL);
        _currentIndex ++;
        //类型的转换
        animatedImage = [UIImage imageWithCGImage:image scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
        
            CGImageRelease(image);
    }
    
    CFRelease(source);
    
    return animatedImage;
}


@end























