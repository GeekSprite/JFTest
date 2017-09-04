

#import "KYWaterWaveView.h"

@implementation KYWaterWaveView{
    
    CGFloat waterWaveHeight;
    CGFloat waterWaveWidth;
    CGFloat offsetX;
    
    CADisplayLink *waveDisplaylink;
    CAShapeLayer  *waveLayer;
    UIBezierPath *waveBoundaryPath;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (waterWaveHeight == 0) {
        waterWaveHeight = self.waveAmplitude;
        waterWaveWidth  = self.frame.size.width;
    }
}

#pragma mark - public
- (void)wave {
    waveBoundaryPath = [UIBezierPath bezierPath];
    waveLayer = [CAShapeLayer layer];
    waveLayer.fillColor = self.waveColor.CGColor;
    [self.layer addSublayer:waveLayer];
    [self.layer insertSublayer:waveLayer below:self.layer];
    waveDisplaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(getCurrentWave:)];
    [waveDisplaylink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)stop {
    [waveDisplaylink invalidate];
    waveDisplaylink = nil;
}

#pragma mark - helper
- (void)getCurrentWave:(CADisplayLink *)displayLink {
    offsetX += self.waveSpeed;
    waveBoundaryPath = [self getgetCurrentWavePath];
    waveLayer.path = waveBoundaryPath.CGPath;
}
- (UIBezierPath *)getgetCurrentWavePath {
    UIBezierPath *p = [UIBezierPath bezierPath];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, -11, waterWaveHeight);
    CGFloat y = 0.0f;
    for (float x = -10; x <= waterWaveWidth ; x++) {
        y = self.waveAmplitude * sinf((360/waterWaveWidth) * (x * M_PI_2 / 180.0) - offsetX * M_PI / 180) + waterWaveHeight;
        CGPathAddLineToPoint(path, nil, x, y);
    }
    
    CGPathAddLineToPoint(path, nil, waterWaveWidth, self.frame.size.height);
    CGPathAddLineToPoint(path, nil, 0, self.frame.size.height);
    CGPathCloseSubpath(path);
    
    p.CGPath = path;
    CGPathRelease(path);
    return p;
}

@end
