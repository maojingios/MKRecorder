
#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

/** 物理屏幕宽高**/
#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height

#define CachePatch @"mkAudio001.caf"

@interface ViewController ()<AVAudioRecorderDelegate,UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UIButton *startRecoederButton;

@property (strong, nonatomic) AVAudioRecorder * audioRecorder;

@property (strong, nonatomic) UITableView * audioTableView;
@property (strong, nonatomic) NSMutableArray * datasourcesArray;

@property (strong, nonatomic) AVPlayer * audioPlayer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[MKTool sharedMKTool] creatAudioFile];
    [self setAudioSession];
    [self setUp];
}
-(void)setUp{
    [self.view addSubview:self.audioTableView];
    
    [self.startRecoederButton setImage:[UIImage imageNamed:@"start"] forState:UIControlStateNormal];
    [self.startRecoederButton setImage:[UIImage imageNamed:@"stop"] forState:UIControlStateSelected];
    self.startRecoederButton.selected = NO;
}
-(void)setAudioSession{
    AVAudioSession * session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [session setActive:YES error:nil];
    [session overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
}

#pragma mark - <懒加载>
-(NSMutableArray *)datasourcesArray{
    [_datasourcesArray removeAllObjects];
    if (!_datasourcesArray) {
        _datasourcesArray = [NSMutableArray array];
    }
    for (id  obj in [[MKTool sharedMKTool] getAudiosName]){
        [_datasourcesArray addObject:obj];
    }
    return _datasourcesArray;
}
-(UITableView *)audioTableView{

    if (!_audioTableView) {
        _audioTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SCREENH * 0.1, SCREENW, SCREENH * 0.7) style:UITableViewStylePlain];
        _audioTableView.delegate = self;
        _audioTableView.dataSource = self;
        _audioTableView.backgroundColor = [UIColor clearColor];
        _audioTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _audioTableView.rowHeight = 45;
    }
    return _audioTableView;
}
-(AVPlayer *)audioPlayer{
    if (!_audioPlayer) {
        _audioPlayer = [[AVPlayer alloc]init];
    }
    return _audioPlayer;
}

/** 录音器**/
-(AVAudioRecorder *)audioRecorder{
    if (!_audioRecorder) {
        NSError * error = nil;
        _audioRecorder = [[AVAudioRecorder alloc] initWithURL:[[MKTool sharedMKTool] getAudioName] settings:[[MKTool sharedMKTool] recorderSettings] error:&error];
        _audioRecorder.delegate = self;
        _audioRecorder.meteringEnabled = YES;//监听分贝
        if(error){
            NSLog(@"%s",__func__);
            return nil;
        }
    }
    return _audioRecorder;
}

/** 点击录音**/
- (IBAction)startRecord:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    if (sender.selected) {//开始录
        NSLog(@"start");
        if (![self.audioRecorder isRecording]) {
            [self.audioRecorder record];
        }
    }
    
    else{//取消
        NSLog(@"stop");
        if ([self.audioRecorder isRecording]) {
            [self.audioRecorder stop];
        }
        self.audioRecorder = nil;
    }
}

#pragma mark - <delegate>
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    if (flag){[self.audioTableView reloadData];}
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError * __nullable)error{
}

#pragma mark - <tableViewDelegate>
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasourcesArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * cellIdentifier = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = self.datasourcesArray[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.audioTableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.audioPlayer replaceCurrentItemWithPlayerItem:[[MKTool sharedMKTool] playerItem:self.datasourcesArray[indexPath.row]]];
    [self.audioPlayer play];
}

@end
