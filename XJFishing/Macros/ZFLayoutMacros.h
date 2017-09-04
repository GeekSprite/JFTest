//
//  Header.h
//  GiftGame
//
//  Created by Ruozi on 8/10/16.
//  Copyright © 2016 Ruozi. All rights reserved.
//

#ifndef Header_h
#define Header_h

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height


#define DesignBaseWidth    375.0
#define DesignBaseHeight   667.0
#define ScreenWidthRatio  (SCREEN_WIDTH / DesignBaseWidth)
#define ScreenHeightRatio  (SCREEN_HEIGHT / DesignBaseHeight)

#define SQDesignBaseWidth  414.0
#define SQDesignBaseHeight 736.0

#define SQScreenWidthRatio  (SCREEN_WIDTH / SQDesignBaseWidth)
#define SQScreenHeightRatio  (SCREEN_HEIGHT / SQDesignBaseHeight)

#define TopBarButtonSize    CGSizeMake(36.0f, 36.0f)
#define CoinCountViewHeight 40.0f

#define kTopNaviBarAndStatusBarHeight 64.0f

#define kNaviBarHeight 44.0f
#define kStatusBarHeight 20.0f

#define IconCornerRadiusRatio (240.0 / 1024.0)

#endif /* Header_h */
