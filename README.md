# MKRecorder

  ### 1、情景
  >公司项目需要接入发送语音的功能，项目涉及录音、转码，然后发送给服务器。项目中每次只需要录制一条语音，存在沙河，新录制的音频文件都将替换上一次旧的的音频文件。
  目前功能是已经完工上线，得空做一个简单的录音demo，在这里，会将每次录的音频文件缓存至沙河MKAudioFile文件夹当中，再将MKAudioFile文件
  夹下面的音频文件以列表形式展示出来。
  整个过程是没有特别技术难点，内容涉及单利设计模式、AVAudioRecorder的使用、沙河路径下文件存取。皆为基础内容，在这里分享下！
  
  ### 2、正文（AVAudioRecorder的使用）
  
  >/** 录音器**/
  
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
 

>/** 录音设置**/

    -(NSDictionary *)recorderSettings{

    NSMutableDictionary * settingsDic = [NSMutableDictionary dictionary];
    
    [settingsDic setObject:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];//格式
    
    [settingsDic setObject:@(1000) forKey:AVSampleRateKey];//采样率
    
    [settingsDic setObject:@(1) forKey:NSKeyValueChangeNewKey];//单声道
    
    [settingsDic setObject:@(8) forKey:AVLinearPCMBitDepthKey];//采样点
    
    [settingsDic setObject:@(YES) forKey:AVLinearPCMIsFloatKey];//浮点采样
    
    return settingsDic;
    
    }
>/** 创建录音存储文件夹**/

    -(void)creatAudioFile{

    NSString * filePath = [NSString stringWithFormat:@"%@/MKAudioFile",SanboxPath];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
    
        [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
        
    }
    
}

>/** 录音文件名**/

    -(NSURL *)getAudioName{

    NSDate * date = [NSDate date];
    
    NSDateFormatter * matter = [[NSDateFormatter alloc]init];
    
    [matter setDateFormat:@"ddHHmmss"];
    
    NSString * dateString = [matter stringFromDate:date];

    NSString * audioPath = [NSString stringWithFormat:@"%@/MKAudioFile/",SanboxPath];
    
    audioPath = [audioPath stringByAppendingString:[NSString stringWithFormat:@"MKAudio%@.caf",dateString]];
    
    return [NSURL URLWithString:audioPath];
    
    }

### 2、结尾

>仔细观察过我手机（魅族）上面的录音APP，简洁好用又漂亮，例如类似水波浪的表示分贝的动效，感觉不错，得空再加上。


