//
//  KFAGraphView.m
//  KFAGraphDemo
//
//  Created by 柯梵Aaron on 16/4/6.
//  Copyright © 2016年 柯梵Aaron. All rights reserved.
//

#import "KFAGraphView.h"

#define kPointNumber 7 // 最多7个点
#define kGraphHeight 150.0 // 图表高度

@interface KFAGraphView ()
{
    NSArray *_pointArr;
}

@end

@implementation KFAGraphView

- (void)drawRect:(CGRect)rect {
    
    // 外围大矩形的绘制
    // 创建路径并获取句柄
    CGMutablePathRef path = CGPathCreateMutable();
    // 指定矩形
    CGRect rectangle = CGRectMake(10.0f, 50.0f, kScreenWidth-20.0f, 223.5f);
    // 将矩形添加到路径中
    CGPathAddRect(path, NULL, rectangle);
    // 获取上下文
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    // 将路径添加到上下文
    CGContextAddPath(currentContext, path);
    
    // 设置矩形填充色
    [[UIColor colorWithRed:1.000 green:1.000 blue:1.000 alpha:1.000] setFill];
    // 矩形边框颜色
    [[UIColor colorWithRGBHex:0x909090] setStroke];
    // 边框宽度
    CGContextSetLineWidth(currentContext, 0.5f);
    
    // 绘制
    CGContextDrawPath(currentContext, kCGPathFillStroke);
    CGPathRelease(path);
    
    // 小矩形的绘制
    CGMutablePathRef smallPath = CGPathCreateMutable();
    CGRect smallRectange = CGRectMake(20.0f, 103.0f, kScreenWidth-72.5, kGraphHeight);
    
    CGPathAddRect(smallPath, NULL, smallRectange);
    CGContextRef smallCurrentContext = UIGraphicsGetCurrentContext();
    CGContextAddPath(smallCurrentContext, smallPath);
    
    [[UIColor colorWithRed:1.000 green:1.000 blue:1.000 alpha:1.000] setFill];
    [[UIColor colorWithRGBHex:0x909090] setStroke];
    CGContextSetLineWidth(smallCurrentContext, 0.5f);
    
    CGContextDrawPath(smallCurrentContext, kCGPathFillStroke);
    CGPathRelease(smallPath);
    
    NSInteger isStart = 0;
    
    for (int i = 0; i < kPointNumber; i++) {
        NSMutableDictionary *md = [NSMutableDictionary dictionary];
        md[NSForegroundColorAttributeName] = [UIColor colorWithRGBHex:0x909090];
        md[NSFontAttributeName] = [UIFont systemFontOfSize:10];
        [[NSString stringWithFormat:@"%02ld",isStart+i] drawInRect:CGRectMake((kScreenWidth-72.5)/(kPointNumber-1)*i+15, 253.5f+5, 50, 15) withAttributes:md];
    }
    
    // 绘制一条直线
    for (int i = 0; i < (kPointNumber-1); i++) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetRGBStrokeColor(context, 0xaa/255.0f, 0xaa/255.0f, 0xaa/255.0f, 1.0);
        // 起点
        CGContextMoveToPoint(context, ((kScreenWidth-72.5)/(kPointNumber-1)) * i + 20.0f, 103.5f);
        // 终点
        CGContextAddLineToPoint(context, ((kScreenWidth-72.5)/(kPointNumber-1)) * i + 20.0f, 253.5f);
        CGContextStrokePath(context);
    }
    
    // 阴影区域
    {
        CGContextRef contextRang = UIGraphicsGetCurrentContext();
        CGContextSetRGBStrokeColor(contextRang, 1, 1, 1, 1.0);
        // 起点
        CGContextMoveToPoint(contextRang, 20.0f, 253.5f);
        CGPoint point;
        for (int i = 0; i < _pointArr.count; i++) {
            NSString *pStr = [_pointArr objectAtIndex:_pointArr.count-i-1];
            point = CGPointFromString(pStr);
            CGContextAddLineToPoint(contextRang, ((kScreenWidth-72.5)/(kPointNumber-1)) * i + 20.0f, point.y);
        }
        CGContextAddLineToPoint(contextRang, ((kScreenWidth-72.5)/(kPointNumber-1)) * (_pointArr.count-1) + 20.0f, 253.5f);
        [[UIColor colorWithRed:115.0/255 green:90.0/255 blue:244.0/255 alpha:0.5] setFill];
        CGContextDrawPath(contextRang, kCGPathFillStroke);
    }
    
    // 折现
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:115.0/255 green:90.0/255 blue:244.0/255 alpha:0.5].CGColor);
        CGPoint point;
        for (int i = 0; i < _pointArr.count; i++) {
            NSString *pStr = [_pointArr objectAtIndex:_pointArr.count-i-1];
            point = CGPointFromString(pStr);
            if (i == 0) {
                CGContextMoveToPoint(context, ((kScreenWidth-72.5)/(kPointNumber-1)) * i + 20.0f, point.y);
            }else {
                CGContextAddLineToPoint(context, ((kScreenWidth-72.5)/(kPointNumber-1)) * i + 20.0f, point.y);
            }
        }
        CGContextStrokePath(context);
    }
    
    // 圆点
    {
        CGContextRef contextPoint = UIGraphicsGetCurrentContext();
        CGPoint point;
        for (int i = 0; i < _pointArr.count; i++) {
            NSString *pStr = [_pointArr objectAtIndex:_pointArr.count-i-1];
            point = CGPointFromString(pStr);
            
            CGContextAddEllipseInRect(contextPoint, CGRectMake(((kScreenWidth-72.5)/(kPointNumber-1)) * i + 20.0f-6.5, point.y-6.5, 13, 13));
            // 填充颜色为白色
            CGContextSetStrokeColorWithColor(contextPoint, [UIColor whiteColor].CGColor);
            // 在context上绘制
            CGContextFillPath(contextPoint);
            
            CGContextAddEllipseInRect(contextPoint, CGRectMake(((kScreenWidth-72.5)/(kPointNumber-1)) * i + 20.0f-6.5, point.y-6.5, 13, 13));
            CGContextSetStrokeColorWithColor(contextPoint, [UIColor colorWithWhite:0.33 alpha:0.2].CGColor);
            CGContextStrokePath(contextPoint);
            
            CGContextAddEllipseInRect(contextPoint, CGRectMake(((kScreenWidth-72.5)/(kPointNumber-1)) * i + 20.0f-4.5, point.y-4.5, 9, 9));
            if (i == _pointArr.count-1) {
                CGContextSetFillColorWithColor(contextPoint, [UIColor colorWithRed:228.0/255 green:186.0/255 blue:36.0/255 alpha:1].CGColor);
            }else {
                CGContextSetFillColorWithColor(contextPoint, [UIColor colorWithRed:115.0/255 green:90.0/255 blue:244.0/255 alpha:1].CGColor);
            }
            CGContextStrokePath(contextPoint);
        }
    }
    
}

- (void)initPoint {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    NSInteger unitFlag = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    for (int i = 0; i < _dataArr.count; i++) {
        if (i >= kPointNumber) {
            break;
        }
        NSString *timeStr = [_dataArr objectAtIndex:i];
        NSDate *date = [formatter dateFromString:timeStr];
        
        NSDateComponents *components = [calendar components:unitFlag fromDate:date];
        float hourTime = components.hour*60;
        float minuteTime = components.minute;
        float totalTime = hourTime+minuteTime;
        float mainAVG = kGraphHeight/(24*60);
        CGFloat yPoint = 253.5f - (totalTime*mainAVG);
        CGPoint point = CGPointMake((kScreenWidth-72.5)*0+14, yPoint);
        NSString *pointStr = NSStringFromCGPoint(point);
        [array addObject:pointStr];
    }
    
    if (array.count < kPointNumber) {
        NSString *pStr = NSStringFromCGPoint(CGPointMake((kScreenWidth-72.5)*0+14, 253.5f));
        [array addObject:pStr];
    }
    _pointArr = array;
}

- (void)setDataArr:(NSArray *)dataArr {
    _dataArr = [dataArr copy];
    
    [self initPoint];
    
    [self setNeedsDisplay];
}

@end
