
#ifndef objc_gw_NSLog_Geom_h
#define objc_gw_NSLog_Geom_h

#define NSLogPoint(point) (NSLog(@"%f %f",point.x,point.y))
#define NSLogPointWithLabel(label,point) (NSLog(@"%@: %f %f",label,point.x,point.y))
#define NSLogSize(size) (NSLog(@"%f %f",size.width,size.height))
#define NSLogSizeWithLabel(label,size) (NSLog(@"%@: %f %f",label,size.width,size.height))
#define NSLogRect(rect) (NSLog(@"%f %f %f %f",rect.origin.x,rect.origin.y,rect.size.width,rect.size.height))
#define NSLogRectWithLabel(label,rect) (NSLog(@"%@: %f %f %f %f",label,rect.origin.x,rect.origin.y,rect.size.width,rect.size.height))

#endif
