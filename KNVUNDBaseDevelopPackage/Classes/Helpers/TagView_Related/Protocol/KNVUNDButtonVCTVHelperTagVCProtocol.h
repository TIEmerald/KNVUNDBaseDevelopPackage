//
//  KNVUNDButtonVCTVHelperTagVCProtocol.h
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 8/2/18.
//

#ifndef KNVUNDButtonVCTVHelperTagVCProtocol_h
#define KNVUNDButtonVCTVHelperTagVCProtocol_h

@protocol KNVUNDButtonVCTVHelperTagVCProtocol <NSObject>

@optional
// Normally, if you want to handle some function while the tag view appears or disappear, you'd better implement these methods.
//  Actually, If this tag view controller will appear or disappear will triger the super method for UIViewController, too.
//      I leave these methods in here is used to perform some function you want to perform only while the tag view controller switched..
//      Perhaps, these methods are redundant... You can remove these methods later...
- (void)tagViewControllerWillAppear;
- (void)tagViewControllerDidAppear;
- (void)tagViewControllerWillDisappear;

@end

#endif /* KNVUNDButtonVCTVHelperTagVCProtocol_h */
