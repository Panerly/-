//
//  UULineChart.m
//  UUChartDemo
//
//  Created by 2014-763 on 15/3/12.
//  Copyright (c) 2015年 meilishuo. All rights reserved.
//

#import "SCLineChart.h"
#import "SCColor.h"
#import "SCChartLabel.h"
#import "SCTool.h"

@implementation SCLineChart
{
    UILabel *disLabel;
    UIView *popView;
    NSMutableArray *arr;
    NSMutableArray *popDateArr;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.clipsToBounds = YES;
#warning mark - add PopView 此处添加弹出视图
        //PopView
        popView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 165, 30)];
        [popView setBackgroundColor:[UIColor lightGrayColor]];
        [popView setAlpha:0.0f];
        
        disLabel = [[UILabel alloc]initWithFrame:popView.frame];
        disLabel.numberOfLines = 0;
        disLabel.font = [UIFont systemFontOfSize:12];
        [disLabel setTextAlignment:NSTextAlignmentCenter];
        
        [popView addSubview:disLabel];
        [self addSubview:popView];
    }
    return self;
}

-(void)setYValues:(NSArray *)yValues
{
    _yValues = yValues;
    [self setYLabels:yValues];
}

-(void)setYLabels:(NSArray *)yLabels
{
    CGFloat max = 0;
    CGFloat min = 1000000000;
    NSInteger rowCount = 0; // 自动计算每个图表适合的行数
    for (NSArray * ary in yLabels) {
        for (NSString *valueString in ary) {
            CGFloat value = [valueString floatValue];
            if (value > max) {
                max = value;
            }
            if (value < min) {
                min = value;
            }
        }
    }
    if (self.showRange) {
        _yValueMin = min;
    }else{
        _yValueMin = 0;
    }
    _yValueMax = max;
    
    if (_chooseRange.max!=_chooseRange.min) { // 自定义数值范围
        _yValueMax = _chooseRange.max;
        _yValueMin = _chooseRange.min;
    } else { // 自动计算数值范围和合适的行数
        rowCount = [SCTool rowCountWithValueMax:_yValueMax] == 0 ? 5 : [SCTool rowCountWithValueMax:_yValueMax];
        _yValueMax = [SCTool rangeMaxWithValueMax:_yValueMax] == 0 ? 100 : [SCTool rangeMaxWithValueMax:_yValueMax];
        _yValueMin = 0;
    }
    
    float level = (_yValueMax-_yValueMin) /rowCount; // 每个区间的差值
    CGFloat chartCavanHeight = self.frame.size.height - UULabelHeight*3;
    CGFloat levelHeight = chartCavanHeight /rowCount; // 每个区间的高度
    for (int i=0; i<rowCount+1; i++) {
        SCChartLabel * label = [[SCChartLabel alloc] initWithFrame:CGRectMake(0.0,chartCavanHeight-i*levelHeight+5, UUYLabelwidth, UULabelHeight)];
		label.text = [NSString stringWithFormat:@"%g",level * i+_yValueMin]; // 每个区间的值
		[self addSubview:label];
    }
    if ([super respondsToSelector:@selector(setMarkRange:)]) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(UUYLabelwidth, (1-(_markRange.max-_yValueMin)/(_yValueMax-_yValueMin))*chartCavanHeight+UULabelHeight, self.frame.size.width-UUYLabelwidth, (_markRange.max-_markRange.min)/(_yValueMax-_yValueMin)*chartCavanHeight)];
        view.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.1];
        [self addSubview:view];
    }

    //画横线
    for (int i=0; i<rowCount+1; i++) {
        if ([_ShowHorizonLine[i] integerValue]>0) {
            
            CAShapeLayer *shapeLayer = [CAShapeLayer layer];
            UIBezierPath *path = [UIBezierPath bezierPath];
            [path moveToPoint:CGPointMake(UUYLabelwidth,UULabelHeight+i*levelHeight)];
            [path addLineToPoint:CGPointMake(self.frame.size.width,UULabelHeight+i*levelHeight)];
            [path closePath];
            shapeLayer.path = path.CGPath;
            shapeLayer.strokeColor = [[[UIColor blackColor] colorWithAlphaComponent:0.1] CGColor];
            shapeLayer.fillColor = [[UIColor whiteColor] CGColor];
            shapeLayer.lineWidth = 1;
            [self.layer addSublayer:shapeLayer];
        }
    }
}


-(void)setXLabels:(NSArray *)xLabels
{
#warning mark - add collect_dt 此处添加弹出视图的抄收时间
    _xLabels = xLabels;
    popDateArr = [NSMutableArray array];
    [popDateArr removeAllObjects];
    
    if (xLabels) {
        for (NSArray *ar in _xLabels) {
            [popDateArr addObject:ar];
        }
        
    }
    CGFloat num = 0;
    if (xLabels.count>=100) {
        num=100.0;
    }else if (xLabels.count<=1){
        num=1.0;
    }else{
        num = xLabels.count;
    }
    _xLabelWidth = (self.frame.size.width - UUYLabelwidth)/num;
    
    for (int i=0; i<xLabels.count; i++) {
        NSString *labelText = xLabels[i];
        SCChartLabel * label = [[SCChartLabel alloc] initWithFrame:CGRectMake(i * _xLabelWidth+UUYLabelwidth, self.frame.size.height - UULabelHeight, _xLabelWidth, UULabelHeight)];
        label.font = [UIFont systemFontOfSize:6];
        label.text = labelText;
        [self addSubview:label];
    }
    
    //画竖线
    for (int i=0; i<xLabels.count+1; i++) {
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(UUYLabelwidth+i*_xLabelWidth,UULabelHeight)];
        [path addLineToPoint:CGPointMake(UUYLabelwidth+i*_xLabelWidth,self.frame.size.height-2*UULabelHeight)];
        [path closePath];
        shapeLayer.path = path.CGPath;
        shapeLayer.strokeColor = [[[UIColor blackColor] colorWithAlphaComponent:0.1] CGColor];
        shapeLayer.fillColor = [[UIColor whiteColor] CGColor];
        shapeLayer.lineWidth = 1;
        [self.layer addSublayer:shapeLayer];
    }
}

-(void)setColors:(NSArray *)colors
{
	_colors = colors;
}
- (void)setMarkRange:(CGRange)markRange
{
    _markRange = markRange;
}
- (void)setChooseRange:(CGRange)chooseRange
{
    _chooseRange = chooseRange;
}
- (void)setShowHorizonLine:(NSMutableArray *)ShowHorizonLine
{
    _ShowHorizonLine = ShowHorizonLine;
}


-(void)strokeChart
{
    for (int i=0; i<_yValues.count; i++) {
        NSArray *childAry = _yValues[i];
        if (childAry.count==0) {
            return;
        }
        //获取最大最小位置
        CGFloat max = [childAry[0] floatValue];
        CGFloat min = [childAry[0] floatValue];
        NSInteger max_i = 0;
        NSInteger min_i = 0;
        
        for (int j=0; j<childAry.count; j++){
            CGFloat num = [childAry[j] floatValue];
            if (max<=num){
                max = num;
                max_i = j;
            }
            if (min>=num){
                min = num;
                min_i = j;
            }
        }
        
        //划线
        CAShapeLayer *_chartLine = [CAShapeLayer layer];
        _chartLine.lineCap = kCALineCapRound;
        _chartLine.lineJoin = kCALineJoinBevel;
        _chartLine.fillColor   = [[UIColor whiteColor] CGColor];
        _chartLine.lineWidth   = 2.0;
        _chartLine.strokeEnd   = 0.0;
        [self.layer addSublayer:_chartLine];
        
        UIBezierPath *progressline = [UIBezierPath bezierPath];
        CGFloat firstValue = [[childAry objectAtIndex:0] floatValue];
        CGFloat xPosition = (UUYLabelwidth + _xLabelWidth/2.0);
        CGFloat chartCavanHeight = self.frame.size.height - UULabelHeight*3;
        
        float grade = ((float)firstValue-_yValueMin) / ((float)_yValueMax-_yValueMin);
       
        //第一个点
        BOOL isShowMaxAndMinPoint = YES;
        if (self.ShowMaxMinArray) {
            if ([self.ShowMaxMinArray[i] intValue]>0) {
                isShowMaxAndMinPoint = (max_i==0 || min_i==0)?NO:YES;
            }else{
                isShowMaxAndMinPoint = YES;
            }
        }
        [self addPoint:CGPointMake(xPosition, chartCavanHeight - grade * chartCavanHeight+UULabelHeight)
                 index:i
                isShow:isShowMaxAndMinPoint
                 value:firstValue];

        
        [progressline moveToPoint:CGPointMake(xPosition, chartCavanHeight - grade * chartCavanHeight+UULabelHeight)];
        [progressline setLineWidth:2.0];
        [progressline setLineCapStyle:kCGLineCapRound];
        [progressline setLineJoinStyle:kCGLineJoinRound];
        NSInteger index = 0;
        
        arr = [[NSMutableArray alloc] init];
        [arr removeAllObjects];

        for (NSString * valueString in childAry) {
            
            float grade =([valueString floatValue]-_yValueMin) / ((float)_yValueMax-_yValueMin);
            [arr addObject:valueString];
            if (index != 0) {
                
                CGPoint point = CGPointMake(xPosition+index*_xLabelWidth, chartCavanHeight - grade * chartCavanHeight+UULabelHeight);
                [progressline addLineToPoint:point];
                
                BOOL isShowMaxAndMinPoint = YES;
                if (self.ShowMaxMinArray) {
                    if ([self.ShowMaxMinArray[i] intValue]>0) {
                        isShowMaxAndMinPoint = (max_i==index || min_i==index)?NO:YES;
                    }else{
                        isShowMaxAndMinPoint = YES;
                    }
                }
                [progressline moveToPoint:point];
                [self addPoint:point
                         index:i
                        isShow:isShowMaxAndMinPoint
                         value:[valueString floatValue]];
                
//                [progressline stroke];
#warning mark - add Btn 此处添加触摸事件
                //添加触摸点
                UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
                
                [bt setBackgroundColor:[UIColor clearColor]];
                
                [bt setFrame:CGRectMake(0, 0, 16, 16)];
                bt.layer.cornerRadius = 8;
                [bt setCenter:point];
                
                bt.tag = index;
                [bt addTarget:self
                       action:@selector(btAction:)
             forControlEvents:UIControlEventTouchUpInside];
                
                [self addSubview:bt];
            }
            index += 1;
            
        }
        
        _chartLine.path = progressline.CGPath;
        if ([[_colors objectAtIndex:i] CGColor]) {
            _chartLine.strokeColor = [[_colors objectAtIndex:i] CGColor];
        }else{
            _chartLine.strokeColor = [SCGreen CGColor];
        }
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnimation.duration = childAry.count*0.1;
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
        pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
        pathAnimation.autoreverses = NO;
        [_chartLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
        
        _chartLine.strokeEnd = 1.0;
    }
}
- (void)btAction:(UIButton *)button
{
    
    NSInteger length = [popDateArr[button.tag] length];
    NSLog(@"%ld",(long)length);
    //此处根据数据源显示的frame大小
    if (length<4) {
        popView.frame = CGRectMake(0, 0, 85, 30);
        disLabel.frame = popView.frame;
        [disLabel setText:[NSString stringWithFormat:@"读数:%@\n时间:请放大",arr[button.tag]]];
    } else if (length >= 4 && length < 15){
        popView.frame = CGRectMake(0, 0, 11*length, 30);
        disLabel.frame = popView.frame;
        [disLabel setText:[NSString stringWithFormat:@"读数:%@\n时间:%@",arr[button.tag],popDateArr[button.tag]]];
    }
    
    else{
    popView.frame = CGRectMake(0, 0, 150, 30);
    disLabel.frame = popView.frame;
    [disLabel setText:[NSString stringWithFormat:@"读数:%@\n时间:%@",arr[button.tag],popDateArr[button.tag]]];
    }
    
    UIButton *bt = (UIButton*)button;
    popView.center = CGPointMake(bt.center.x, bt.center.y - popView.frame.size.height/2);
    popView.layer.cornerRadius = 5;
    [popView setAlpha:1.0f];
    [UIView animateWithDuration:2.0f animations:^{
        [popView setAlpha:0.0f];
    }];
}
- (void)addPoint:(CGPoint)point index:(NSInteger)index isShow:(BOOL)isHollow value:(CGFloat)value
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(5, 5, 8, 8)];
    view.center = point;
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 4;
    view.layer.borderWidth = 2;
    view.layer.borderColor = [[_colors objectAtIndex:index] CGColor]?[[_colors objectAtIndex:index] CGColor]:SCGreen.CGColor;
    
    if (isHollow) {
        view.backgroundColor = [UIColor whiteColor];
    }else{
        view.backgroundColor = [_colors objectAtIndex:index]?[_colors objectAtIndex:index]:SCGreen;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(point.x-UUTagLabelwidth/2.0, point.y-UULabelHeight*2, UUTagLabelwidth, UULabelHeight)];
        label.font = [UIFont systemFontOfSize:10];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = view.backgroundColor;
        label.text = [NSString stringWithFormat:@"%d",(int)value];
        [self addSubview:label];
    }
    
    [self addSubview:view];
}

+ (CGSize)sizeOfString:(NSString *)text withWidth:(float)width font:(UIFont *)font
{
    NSInteger ch;
    CGSize size = CGSizeMake(width, MAXFLOAT);
    
    if ([text respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSDictionary *tdic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
        size = [text boundingRectWithSize:size
                                  options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                               attributes:tdic
                                  context:nil].size;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        size = [text sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
#pragma clang diagnostic pop
    }
    ch = size.height;
    
    return size;
}


@end
