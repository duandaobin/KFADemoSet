//
//  KFACustomView.m
//  KFAGraphDemo
//
//  Created by 柯梵Aaron on 16/4/7.
//  Copyright © 2016年 柯梵Aaron. All rights reserved.
//

#import "KFACustomView.h"

@implementation KFACustomView

- (void)drawRect:(CGRect)rect {
    
    switch (_type) {
        case KFACustomTypeLine:
        {
            // 获得图形上下文
            CGContextRef context = UIGraphicsGetCurrentContext();
            // 设置线段宽度 默认宽度为1
            CGContextSetLineWidth(context, 10);
            // 设置线段头尾部的样式
            CGContextSetLineCap(context, kCGLineCapRound);
            // 设置线段转折点的样式
            CGContextSetLineJoin(context, kCGLineJoinRound);
            
            // 第1根线段
            // 设置线段颜色
            CGContextSetRGBStrokeColor(context, 1.0, 0, 0, 1.0);
            // 设置起点
            CGContextMoveToPoint(context, 50, 110);
            // 添加一条线段到（100，100）
            CGContextAddLineToPoint(context, 140, 200);
            // 渲染一次
            CGContextStrokePath(context);
            
            // 第2根线段
            CGContextSetRGBStrokeColor(context, 0, 0, 1.0, 1.0);
            CGContextMoveToPoint(context, 240, 290);
            CGContextAddLineToPoint(context, 190, 140);
            CGContextAddLineToPoint(context, 160, 160);
            // 渲染显示在view上面
            CGContextStrokePath(context);
            
            // 虚线
            CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0 green:1.0 blue:0 alpha:1.0].CGColor);
            CGContextSetLineWidth(context, 0.5);
            CGContextMoveToPoint(context, 50, 250);
            CGContextAddLineToPoint(context, 300, 250);
            // 数组元素决定虚线的间隔和每个点的长度,eg:两个元素，2-实现是两个点，3-虚线是3个点
            CGFloat arr[] = {2,3};
            CGContextSetLineDash(context, 0, arr, 2);
            CGContextDrawPath(context, kCGPathStroke);
        }
            break;
        case KFACustomTypeShape:
        {
            // 矩形
            CGContextRef context = UIGraphicsGetCurrentContext();
            // 画矩形
            CGContextAddRect(context, CGRectMake(100, 100, 100, 50));
            // 设置颜色 (实心和空心都可以)
            [[UIColor whiteColor] set];
            
            // 实心
            // 设置实心颜色
//            [[UIColor redColor] setFill];
            // 实心渲染
            CGContextFillPath(context);
            // 空心
            // 设置空心颜色
//            [[UIColor greenColor] setStroke];
            // 空心渲染
//            CGContextStrokePath(context);
            
            // 三角形
            CGContextMoveToPoint(context, 100, 180);
            CGContextAddLineToPoint(context, 200, 180);
            CGContextAddLineToPoint(context, 160, 230);
            // 关闭路径（连接起点和最后一个点）
            CGContextClosePath(context);
            CGContextSetRGBStrokeColor(context, 0, 1.0, 0, 1.0);
            CGContextStrokePath(context);
            
            // 多边形
            CGPoint point1 = CGPointMake(160, 250);
            CGPoint point2 = CGPointMake(210, 300);
            CGPoint point3 = CGPointMake(200, 340);
            CGPoint point4 = CGPointMake(150, 320);
            CGPoint point5 = CGPointMake(120, 280);
            CGPoint pointArr[] = {point1,point2,point3,point4,point5};
            CGContextAddLines(context, pointArr, 5);
            [[UIColor redColor] set];
//            CGContextDrawPath(context, kCGPathFill);
//            CGContextDrawPath(context, kCGPathStroke);
//            CGContextDrawPath(context, kCGPathEOFill);
//            CGContextDrawPath(context, kCGPathEOFillStroke);
            CGContextDrawPath(context, kCGPathFillStroke);
        }
            break;
        case KFACustomTypeCircle:
        {
            // 圆弧
            CGContextRef context = UIGraphicsGetCurrentContext();
            // x:圆心x
            // y:圆心y
            // radius:半径
            // startAngle:开始角度
            // endAngle:结束角度
            // clockwise:绘画反向（0-顺时针，1-逆时针）
            CGContextAddArc(context, 100, 150, 50, M_PI_2, M_PI, 0);
            [[UIColor yellowColor] set];
            CGContextFillPath(context);
//            CGContextStrokePath(context);
            
            // 画圆
            CGContextAddEllipseInRect(context, CGRectMake(150, 100, 100, 100));
            [[UIColor greenColor] set];
//            CGContextFillPath(context);
            CGContextStrokePath(context);
            
            // 贝塞尔曲线
            CGContextMoveToPoint(context, 50, 200);
            CGContextAddQuadCurveToPoint(context, 150, 0, 300, 250);
            [[UIColor redColor] set];
            CGContextStrokePath(context);
        }
            break;
        case KFACustomTypeTextImage:
        {
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGRect rect = CGRectMake(50, 300, 200, 25);
            CGContextAddRect(context, rect);
            [[UIColor greenColor] set];
            CGContextStrokePath(context);
            
            UIImage *image = [UIImage imageNamed:@"1234"];
//            [image drawAtPoint:CGPointMake(50, 100)];
//            [image drawInRect:CGRectMake(50, 100, 200, 200)];
            // 画图
            [image drawAsPatternInRect:CGRectMake(50, 100, 200, 200)];
            NSString *text = @"此图为西月斋主所画";
            // 设置文字属性
            NSMutableDictionary *attribute = [NSMutableDictionary dictionary];
            attribute[NSForegroundColorAttributeName] = [UIColor redColor];
            attribute[NSFontAttributeName] = [UIFont systemFontOfSize:20];
            // 写文字
            [text drawInRect:rect withAttributes:attribute];
        }
            break;
        case KFACustomTypeCut:
        {
            CGContextRef context = UIGraphicsGetCurrentContext();
            
            // 画圆
            CGContextAddEllipseInRect(context, CGRectMake(100, 100, 50, 50));
            // 裁剪
            CGContextClip(context);
            
            // 显示图片
            UIImage *image = [UIImage imageNamed:@"1234"];
            [image drawAtPoint:CGPointMake(100, 100)];
        }
            break;
        default:
        {
            // 图形上下文栈
            CGContextRef context = UIGraphicsGetCurrentContext();
            // 将ctx拷贝一份放到栈中
            CGContextSaveGState(context);
            
            // 设置绘图状态
            CGContextSetLineWidth(context, 10);
            [[UIColor redColor] set];
            CGContextSetLineCap(context, kCGLineCapRound);
            
            // 第1根线
            CGContextMoveToPoint(context, 50, 50);
            CGContextAddLineToPoint(context, 120, 190);
            CGContextStrokePath(context);
            
            // 将栈顶的上下文出栈,替换当前的上下文
            CGContextRestoreGState(context);
            
            // 第2根线
            CGContextMoveToPoint(context, 10, 70);
            CGContextAddLineToPoint(context, 220, 290);
            CGContextStrokePath(context);
        }
            break;
    }
}

- (void)setType:(KFACustomType)type {
    
    _type = type;
    
    [self setNeedsDisplay];
}

@end
