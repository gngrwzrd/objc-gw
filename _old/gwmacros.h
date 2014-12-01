
#ifndef objc_categories_mac_GWCategories_h
#define objc_categories_mac_GWCategories_h

#define SuppressPerformSelectorLeakWarning(code) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
code; \
_Pragma("clang diagnostic pop") \
} while (0)

#endif
