//
//  LyricView.m
//  Magic
//
//  Created by mxl on 16/1/11.
//  Copyright © 2016年 mxl. All rights reserved.
//

#import "LyricView.h"
#import <CoreText/CoreText.h>

@implementation LyricView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    NSArray *arr = [_lyricWord componentsSeparatedByString:@"\n"];
    NSString *str = arr[0];
    NSInteger length = [str length];
    [self drawText:length];
}

- (void)drawText:(NSInteger)length {
    
    NSMutableAttributedString *mutableString = [[NSMutableAttributedString alloc] initWithString:_lyricWord];
    [mutableString addAttribute:(id)kCTForegroundColorAttributeName value:(id)[UIColor redColor] range:NSMakeRange(0, length)];
    

    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)@"HiraKakuProN-W6", 14, NULL);
    
    [mutableString addAttribute:(id)kCTFontAttributeName value:(__bridge id _Nonnull)(fontRef) range:NSMakeRange(0, length)];
    
    CTFramesetterRef framesetterRef = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)mutableString);
    
    // 创建绘图路径
    CGMutablePathRef mutablePathRef = CGPathCreateMutable();
    // 创建绘图范围 (第二个参数是反转动作)
    CGPathAddRect(mutablePathRef, NULL, CGRectMake(10, 10, self.bounds.size.width - 20, self.bounds.size.height - 20));
    // 根据字符串和绘图路径得到 frame
    CTFrameRef frame = CTFramesetterCreateFrame(framesetterRef, CFRangeMake(0, 0), mutablePathRef, NULL);
    // 拿到绘图的上下文对象
    CGContextRef contenxtRef = UIGraphicsGetCurrentContext();
    
    /**
     *  翻转坐标系
     */
    CGContextSetTextMatrix(contenxtRef, CGAffineTransformIdentity);
    // 让 x,y 轴进行移动
    CGContextTranslateCTM(contenxtRef, 0, self.bounds.size.height);
    // 缩放 x, y 轴 让 y 轴旋转180°
    CGContextScaleCTM(contenxtRef, 1, -1.0);
    CGContextSetTextMatrix(contenxtRef, CGAffineTransformIdentity);
    
    
    CTFrameDraw(frame, contenxtRef);
    
    // 使用 create 创建的需要释放掉
    CFRelease(fontRef);
    CFRelease(framesetterRef);
    CFRelease(mutablePathRef);
    CFRelease(frame);
}


@end
