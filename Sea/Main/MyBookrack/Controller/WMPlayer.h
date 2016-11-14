

#import <UIKit/UIKit.h>
#import "Masonry.h"

@import MediaPlayer;
@import AVFoundation;

@interface WMPlayer : UIView
/**
 *  播放器player
 */
@property(nonatomic,retain)AVPlayer *player;
/**
 *playerLayer,可以修改frame
 */
@property(nonatomic,retain)AVPlayerLayer *playerLayer;
/**
 *  底部操作工具栏
 */
@property (nonatomic,strong)UIImageView *palyImageView;
@property(nonatomic,retain)UIView *bottomView;
@property(nonatomic,retain)UISlider *progressSlider;
@property(nonatomic,retain)UISlider *volumeSlider;
@property(nonatomic,copy) NSString *videoURLStr;
/**
 *  BOOL值判断当前的状态
 */
@property(nonatomic,assign)BOOL isFullscreen;
/**
 *  显示播放时间的UILabel
 */
@property(nonatomic,retain)UILabel *timeLabel;
/**
 *  控制全屏的按钮
 */
@property(nonatomic,retain)UIButton *fullScreenBtn;
/**
 *  播放暂停按钮
 */
@property(nonatomic,retain)UIButton *playOrPauseBtn;
/**
 *  关闭按钮
 */
@property(nonatomic,retain)UIButton *closeBtn;

/* playItem */
@property (nonatomic, retain) AVPlayerItem *currentItem;
/**
 *  初始化WMPlayer的方法
 *
 *  @param frame       frame
 *  @param videoURLStr URL字符串，包括网络的和本地的URL
 *
 *  @return id类型，实际上就是WMPlayer的一个对象
 */
- (id)initWithFrame:(CGRect)frame videoURLStr:(NSString *)videoURLStr image:(UIImage *)image;
@end

