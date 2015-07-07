//
//  ViewController.m
//  myMusicDemo
//
//  Created by Mac OS X on 7/3/15.
//  Copyright (c) 2015 Mac OS X. All rights reserved.
//

#import "ViewController.h"

static int musicNumber = 0;

@interface ViewController ()
{
    UIImageView *backgroundView;
    NSTimer *timer;
    BOOL isSec;
    int mode;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self musicDataURL];
    isSec = YES;
    mode = 0;

    //AlertView判断是否有歌
    if (_musicArray.count==0)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"请在沙盒中music文件夹添加 mp3 文件" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
    else
    {
        [self initAudioPlayer];
    }
}

#pragma mark -- initUI
- (void)initUI
{
    
    self.view.backgroundColor = [UIColor grayColor];
    backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    backgroundView.image = [UIImage imageNamed:@"朴树-平凡之路.jpg"];
    [self.view addSubview:backgroundView];
    backgroundView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddVolume)];
    [backgroundView addGestureRecognizer:tap];
    
    //init button
    _offBut = [[UIButton alloc] initWithFrame:CGRectMake(10, 30, 50, 50)];
    [_offBut setImage:[UIImage imageNamed:@"OFF.png"] forState:UIControlStateNormal];
    [_offBut addTarget:self action:@selector(OFF) forControlEvents:UIControlEventTouchUpInside];
    
    _modeBut = [[UIButton alloc] initWithFrame:CGRectMake(260, 30, 50, 50)];
    [_modeBut setImage:[UIImage imageNamed:@"all.png"] forState:UIControlStateNormal];
    [_modeBut addTarget:self action:@selector(changeMode) forControlEvents:UIControlEventTouchUpInside];
    
    _menuBut = [[UIButton alloc] initWithFrame:CGRectMake(10, 420, 50, 50)];
    [_menuBut setImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
    [_menuBut addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    
    _upBut = [[UIButton alloc] initWithFrame:CGRectMake(70, 420, 50, 50)];
    [_upBut setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [_upBut addTarget:self action:@selector(upMusic) forControlEvents:UIControlEventTouchUpInside];
    
    _playBtu = [[UIButton alloc] initWithFrame:CGRectMake(155, 420, 50, 50)];
    [_playBtu setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
    [_playBtu addTarget:self action:@selector(playOrPause) forControlEvents:UIControlEventTouchUpInside];
    
    _nextBut = [[UIButton alloc] initWithFrame:CGRectMake(240, 420, 50, 50)];
    [_nextBut setImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
    [_nextBut addTarget:self action:@selector(nextMusic) forControlEvents:UIControlEventTouchUpInside];
    
    _volumeBut = [[UIButton alloc] initWithFrame:CGRectMake(10, 360, 50, 50)];
    [_volumeBut setImage:[UIImage imageNamed:@"labalan.png"] forState:UIControlStateNormal];
    [_volumeBut addTarget:self action:@selector(showVolume) forControlEvents:UIControlEventTouchUpInside];
    
    _changeBGBut = [[UIButton alloc] initWithFrame:CGRectMake(240, 360, 50, 50)];
    [_changeBGBut setImage:[UIImage imageNamed:@"apple.png"] forState:UIControlStateNormal];
    [_changeBGBut addTarget:self action:@selector(changeBGImage) forControlEvents:UIControlEventTouchUpInside];
    
    [backgroundView addSubview:_offBut];
    [backgroundView addSubview:_modeBut];
    [backgroundView addSubview:_menuBut];
    [backgroundView addSubview:_upBut];
    [backgroundView addSubview:_playBtu];
    [backgroundView addSubview:_nextBut];
    [backgroundView addSubview:_volumeBut];
    [backgroundView addSubview:_changeBGBut];
    
    //init Label
    UIColor *color = [UIColor whiteColor];
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, 180, 60)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = color;
//    _titleLabel.text = @"";
//    _titleLabel.font = [UIFont systemFontOfSize:10];
    _musicDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 30, 180, 60)];
    _musicDataLabel.textAlignment = NSTextAlignmentCenter;
    _musicDataLabel.textColor = color;
//    _musicDataLabel.text = @"00/00";
//    _musicDataLabel.font = [UIFont systemFontOfSize:10];
    _currentTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, 60, 40)];
    _currentTimeLabel.textAlignment = NSTextAlignmentCenter;
    _currentTimeLabel.textColor = color;
//    _currentTimeLabel.text = @"0:00";
    _totalTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(260, 70, 60, 40)];
    _totalTimeLabel.textAlignment = NSTextAlignmentCenter;
    _totalTimeLabel.textColor = color;
//    _totalTimeLabel.text = @"0:00";
    _lrcLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 315, self.view.frame.size.width, 60)];
    _lrcLabel.textAlignment = NSTextAlignmentCenter;
//    _lrcLabel.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"apple.png"]];
    _lrcLabel.textColor = [UIColor colorWithRed:0.8 green:0.6 blue:0.5 alpha:1];
//    _lrcLabel.text = @"没有歌词，快去添加吧！";
    [backgroundView addSubview:_titleLabel];
    [backgroundView addSubview:_musicDataLabel];
    [backgroundView addSubview:_currentTimeLabel];
    [backgroundView addSubview:_totalTimeLabel];
    [backgroundView addSubview:_lrcLabel];
    
    //init slider
    _progressSlider = [[UISlider alloc] initWithFrame:CGRectMake(75, 85, 180, 10)];
    [_progressSlider addTarget:self action:@selector(updateSliderProgress) forControlEvents:UIControlEventValueChanged];
    
    _volumeSlider = [[UISlider alloc] initWithFrame:CGRectMake(- 60, 240, 180, 30)];
    _volumeSlider.thumbTintColor = [UIColor lightGrayColor];
    _volumeSlider.value = 0.5;
    _volumeSlider.minimumValue = 0.0;
    _volumeSlider.maximumValue = 1;
    _volumeSlider.hidden = YES;
    _volumeSlider.transform = CGAffineTransformMakeRotation(- M_PI/2);
    [_volumeSlider addTarget:self action:@selector(changeVolume) forControlEvents:UIControlEventValueChanged];
    [_volumeSlider setMinimumTrackImage:[[UIImage imageNamed:@"higlightedBarBackground"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4, 0, 0)] forState:UIControlStateNormal];
    [_volumeSlider setMaximumTrackImage:[[UIImage imageNamed:@"trackBackground"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 4)] forState:UIControlStateNormal];
    [backgroundView addSubview:_progressSlider];
    [backgroundView addSubview:_volumeSlider];

   

    //init singerView
    _singerView = [[UIImageView alloc] initWithFrame:CGRectMake(55, 110, 220, 220)];
    _singerView.backgroundColor = [UIColor clearColor];
    _singerView.layer.borderWidth = 0.5;
    _singerView.layer.borderColor = [UIColor yellowColor].CGColor;
    _singerView.layer.cornerRadius = _singerView.frame.size.width/2;
    [backgroundView addSubview:_singerView];
    
}

#pragma mark -- data deal
- (NSURL *)musicDataURL
{
    NSURL *musicURL = nil;
    NSFileManager *manager = [NSFileManager defaultManager];//1.管理员
    NSString *home = NSHomeDirectory();//2.home目录
    NSString *creatPath = [home stringByAppendingPathComponent: @"music"];//3.添加文件夹
    BOOL bo = [manager createDirectoryAtPath:creatPath withIntermediateDirectories:YES attributes:nil error:nil];//4.creat
    NSAssert(bo, @"creat error");
    NSString *musicPath = [NSString stringWithFormat:@"%@/music",home,nil];
    NSLog(@"path = %@",musicPath);
    NSArray *musicArray = [[NSArray alloc] init];
    musicArray = [manager contentsOfDirectoryAtPath:musicPath error:nil];
    _musicArray = [NSMutableArray array];
    if (musicArray.count == 0) {
        return nil;
    }
    else{
        for (int i = 0; i < musicArray.count; i++) {
            NSString *str = [[NSString alloc] init];
            str = [musicArray objectAtIndex:i];
            if ([[str pathExtension] isEqualToString:@"mp3"]) {
                NSUInteger x = str.length - 4;
                NSRange range = {0,x};
                str = [str substringWithRange:range];
                [_musicArray addObject:str];
                
            }
        }
        NSString *strURL = [[NSString alloc] initWithFormat:@"%@/music/%@.mp3",home,[_musicArray objectAtIndex:musicNumber]];
        musicURL = [[NSURL alloc] initFileURLWithPath:strURL];
    }

    
    return musicURL;
}

#pragma mark -- init LRCData

- (void)initLRCData
{
    NSString *lrcPath = [[NSString alloc] initWithFormat:@"%@/music/%@.lrc",NSHomeDirectory(),[_musicArray objectAtIndex:musicNumber],nil];//1.取得lrc路径
    NSString *contentStr = [NSString stringWithContentsOfFile:lrcPath encoding:NSUTF8StringEncoding error:nil];//2.封装
    NSArray *array = [contentStr componentsSeparatedByString:@"\n"];//3.把lrc分行封装到数组
    for (int i = 0; i < array.count; i++) {
        NSString *lineLRCStr = [array objectAtIndex:i];//4.取出每一行
        NSArray *lineLRCArray  = [lineLRCStr componentsSeparatedByString:@"]"];
        if ([lineLRCArray[0] length] > 8) {
            NSString *str1 = [lineLRCStr substringWithRange:NSMakeRange(3, 1)];
            NSString *str2 = [lineLRCStr substringWithRange:NSMakeRange(6, 1)];
            if ([str1 isEqualToString:@":"] && [str2 isEqualToString:@"."]) {
                NSString *lrcStr = [lineLRCArray objectAtIndex:1];
                NSString *time = [[lineLRCArray objectAtIndex:0] substringWithRange:NSMakeRange(1, 5)];//分割区间求歌词时间
                [_lrcDictionary setObject:lrcStr forKey:time]; //把时间 和 歌词 加入词典
                [_lrcArray addObject:time];

            }
        }

    }
    
}

#pragma mark -- init audioPlayer
- (void)initAudioPlayer
{
    if ([self musicDataURL] != nil) {
        
        //1.init musicURL to player
       _player=[[AVAudioPlayer alloc] initWithContentsOfURL:[self musicDataURL] error:nil];;
        [_player prepareToPlay];
        [_player play];
        _player.delegate = self;
        
        //2.music name Label text
        _titleLabel.text = [_musicArray objectAtIndex:musicNumber];
        
        
        //3.music DataLabel text
        _musicDataLabel.text = [NSString stringWithFormat:@"%d/%lu",musicNumber + 1,(unsigned long)_musicArray.count,nil];
        
        //4.取得歌曲的total time
        int Min = _player.duration/60;
        int sec = (int)_player.duration % 60;
        _totalTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d",Min,sec,nil];
        _player.volume = _volumeSlider.value;
        
       //5.update slider progress
        timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(autoUpdateSliderProgress) userInfo:nil repeats:YES];
    }
}


#pragma mark -- button and slider action

- (void)updateSliderProgress
{
    _player.currentTime = _progressSlider.value * _player.duration;
}

- (void)autoUpdateSliderProgress
{
    //1.update current time label
    
    int min2 = _player.duration / 60;
    int sec2 = (int)_player.duration % 60;
    int min1 = _player.currentTime / 60;
    int sec1 = (int)_player.currentTime % 60;
    int min = min2 - min1;
    int sec = sec2 - sec1;
        if (sec < 60 && sec > 0) {
            sec = sec2 - sec1;
        }
        else if (sec < 0 ) {
            sec = 60 + sec;
            min -= 1;
        }
        

    
   _totalTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d",min,sec,nil];
    _currentTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d",min1,sec1,nil];
    
    
    //2.update slider progress
    _progressSlider.value = _player.currentTime / _player.duration;
    
    //3. update lrc progress
    
}

- (void)hiddVolume
{
    _volumeSlider.hidden = YES;
    NSLog(@"changeVolume-------");
}

- (void)showVolume
{
    _volumeSlider.hidden = NO;

}

- (void)changeVolume
{
    NSLog(@"changeVolume-------");
    _player.volume = _volumeSlider.value;
    if (_volumeSlider.state == UIControlStateSelected) {
//        [timer setFireDate:[NSDate distantFuture]];
    }
    else{
       [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(hiddVolume) userInfo:nil repeats:NO];
    }
    
}

- (void)OFF
{
    NSLog(@"end-------");
    exit(5);
}

- (void)changeMode
{
    NSLog(@"changeMode-------");
    if (mode == 0)
    {
        [_modeBut setImage:[UIImage imageNamed:@"single.png"] forState:UIControlStateNormal];
        mode=1;
    }
    else if (mode == 1)
    {
        
        [_modeBut setImage:[UIImage imageNamed:@"random.png"] forState:UIControlStateNormal];
        mode=2;
    }
    else
    {
        [_modeBut setImage:[UIImage imageNamed:@"all.png"] forState:UIControlStateNormal];
        mode=0;
    }
}

- (void)changeBGImage
{
    NSLog(@"changeBGImage-------");

}

- (void)showMenu
{
    NSLog(@"showMenu-------");

}

- (void)upMusic
{
    NSLog(@"upMusic-------");

    if (musicNumber == 0) {
        musicNumber = _musicArray.count - 1;
        [self initAudioPlayer];
    }
    else{
        musicNumber --;
        [self initAudioPlayer];
    }
    if (mode == 2) {
        musicNumber = rand()%_musicArray.count;
        [self initAudioPlayer];
    }
    else{
        if (musicNumber == 0)
        {
            musicNumber = _musicArray.count - 1;
            [self initAudioPlayer];
        }
        else
        {
            musicNumber --;
            [self initAudioPlayer];
        }
    }

}

- (void)playOrPause
{
    NSLog(@"playOrPause-------");
    if (_player.playing) {
        [_playBtu setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
        [_player pause];
        [timer setFireDate:[NSDate distantFuture]];//timer pause method
        
    }
    else{
        [_playBtu setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
        [_player play];
        [timer setFireDate:[NSDate distantPast]];//timer play method
    }

}

- (void)nextMusic
{
    NSLog(@"nextMusic-------");
    if (mode == 2) {
        musicNumber = rand()%_musicArray.count;
        [self initAudioPlayer];
    }
    else{
        if (musicNumber == _musicArray.count - 1)
        {
            musicNumber = 0;
            [self initAudioPlayer];
        }
        else
        {
            musicNumber++;
            [self initAudioPlayer];
        }
    }
    

}

#pragma mark -- audioEnd do

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (mode==0)
    {
        if (musicNumber== _musicArray.count-1)
        {
            sleep(0);
        }
        else
        {
            musicNumber++;
            [self initAudioPlayer];
        }
    }
    else if (mode==1)
    {
        [self initAudioPlayer];
    }
    else if(mode == 2)
    {
        musicNumber = rand()%(_musicArray.count);
        [self initAudioPlayer];
    }

}






@end
