//
//  ViewController.h
//  myMusicDemo
//
//  Created by Mac OS X on 7/3/15.
//  Copyright (c) 2015 Mac OS X. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <MediaPlayer/MediaPlayer.h>

@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,AVAudioPlayerDelegate>


@property (nonatomic,strong) AVAudioPlayer *player;
@property (nonatomic,strong) NSMutableArray *musicArray;
@property (nonatomic,strong) NSMutableDictionary *lrcDictionary;
@property (nonatomic,strong) NSMutableArray *lrcArray;
@property (nonatomic,strong) NSURL *musicURL;

@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic,strong) UITableView *lrcTableView;
@property (nonatomic,strong) UIView *singerView;

@property (nonatomic,strong) UIButton *playBtu;
@property (nonatomic,strong) UIButton *upBut;
@property (nonatomic,strong) UIButton *nextBut;
@property (nonatomic,strong) UIButton *menuBut;
@property (nonatomic,strong) UIButton *volumeBut;
@property (nonatomic,strong) UIButton *changeBGBut;
@property (nonatomic,strong) UIButton *offBut;
@property (nonatomic,strong) UIButton *modeBut;

@property (nonatomic) UISlider *progressSlider;
@property (nonatomic) UISlider *volumeSlider;

@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *musicDataLabel;
@property (nonatomic) UILabel *lrcLabel;
@property (nonatomic) UILabel *currentTimeLabel;
@property (nonatomic) UILabel *totalTimeLabel;
@end

