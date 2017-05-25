
#define SanboxPath [NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES)lastObject]

#import "MKTool.h"

@implementation MKTool

singleton_implementation(MKTool)

/** 创建录音存储文件夹**/
-(void)creatAudioFile{
    NSString * filePath = [NSString stringWithFormat:@"%@/MKAudioFile",SanboxPath];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

/** 录音文件名**/
-(NSURL *)getAudioName{
    NSDate * date = [NSDate date];
    NSDateFormatter * matter = [[NSDateFormatter alloc]init];
    [matter setDateFormat:@"ddHHmmss"];
    NSString * dateString = [matter stringFromDate:date];

    NSString * audioPath = [NSString stringWithFormat:@"%@/MKAudioFile/",SanboxPath];
    audioPath = [audioPath stringByAppendingString:[NSString stringWithFormat:@"MKAudio%@.caf",dateString]];
    return [NSURL URLWithString:audioPath];
}

/** 录音列表**/
-(__kindof NSArray <NSString *> *)getAudiosName{
    NSString * audiosFilePath = [NSString stringWithFormat:@"%@/MKAudioFile",SanboxPath];
    NSArray * subFiles = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:audiosFilePath error:nil];
    return subFiles;
}

/** 录音设置**/
-(NSDictionary *)recorderSettings{
    NSMutableDictionary * settingsDic = [NSMutableDictionary dictionary];
    [settingsDic setObject:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];//格式
    [settingsDic setObject:@(1000) forKey:AVSampleRateKey];//采样率
    [settingsDic setObject:@(1) forKey:NSKeyValueChangeNewKey];//单声道
    [settingsDic setObject:@(8) forKey:AVLinearPCMBitDepthKey];//采样点
    [settingsDic setObject:@(YES) forKey:AVLinearPCMIsFloatKey];//浮点采样
    return settingsDic;
}

//当前需播放录音
-(AVPlayerItem *)playerItem:(NSString *)audioName{
    NSString *urlStr= [NSString stringWithFormat:@"%@/MKAudioFile/",SanboxPath];
    urlStr = [urlStr stringByAppendingString:audioName];
    if(urlStr!=nil) {
        NSURL *url=[NSURL fileURLWithPath:urlStr];
        AVPlayerItem  * item = [AVPlayerItem playerItemWithURL:url];
        return item;
    }else
        return nil;
}
@end
