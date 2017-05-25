
#import <Foundation/Foundation.h>
#import "MKRecoederHeader.h"
#import <AVFoundation/AVFoundation.h>


@interface MKTool : NSObject

singleton_interface(MKTool)

-(void)creatAudioFile;

-(NSURL *)getAudioName;

-(NSDictionary *)recorderSettings;

-(__kindof NSArray <NSString *> *)getAudiosName;

-(AVPlayerItem *)playerItem:(NSString *)audioName;


@end
