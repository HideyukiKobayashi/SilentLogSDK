//
//  SLSConst.h
//  SilentLogSDK
//
//  Created by 四本松和悠 on 2016/01/06.
//  Copyright © 2016年 rei-frontier. All rights reserved.
//

#ifndef SLSConst_h
#define SLSConst_h

typedef NS_ENUM(NSInteger, SLSTrackingPriorityType) {
    SLSTrackingPriorityTypeBestAccuracy         = 0,
    SLSTrackingPriorityTypeEnergySavingAccuracy = 1,
    SLSTrackingPriorityTypeEnergySavingAccuracyAndAutoPause = 2,
};

typedef NS_ENUM(NSInteger, SLSAccountGenderType) {
    SLSAccountGender_Unknown = 0,
    SLSAccountGender_Female  = 1,
    SLSAccountGender_male    = 2,
};


#endif /* SLSConst_h */
