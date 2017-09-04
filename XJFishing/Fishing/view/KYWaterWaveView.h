
#import <UIKit/UIKit.h>

@interface KYWaterWaveView : UIView

/**
 *  The speed of wave 波浪的快慢
 */
@property (nonatomic,assign)CGFloat waveSpeed;

/**
 *  The amplitude of wave 波浪的震荡幅度
 */
@property (nonatomic,assign)CGFloat waveAmplitude; // 波浪的震荡幅度

@property (nonatomic,strong)UIColor *waveColor;

/**
 *  Start waving
 */
- (void)wave;

/**
 *  Stop waving
 */
- (void)stop;

@end
