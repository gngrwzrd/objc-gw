
#ifndef PragmaHelpers_h
#define PragmaHelpers_h

#define IgnorePerformSelectorLeakWarningPush \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"")

#define IgnorePerformSelectorLeakWarningPop \
_Pragma("clang diagnostic pop")

#endif
