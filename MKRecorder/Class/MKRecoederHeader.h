

#ifndef MKRecoederHeader_h
#define MKRecoederHeader_h
#import "MKTool.h"

#define singleton_interface(class) + (instancetype)shared##class;

#define singleton_implementation(class) \
static class *_instance; \
\
+ (id)allocWithZone:(struct _NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
\
return _instance; \
} \
\
+ (instancetype)shared##class \
{ \
if (_instance == nil) { \
_instance = [[class alloc] init]; \
} \
\
return _instance; \
}


#endif /* MKRecoederHeader_h */
