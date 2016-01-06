//
//  SocialMessage.m
//  Copyright (c) 2013 Lee Crossley - http://ilee.co.uk
//

#import "SocialMessage.h"

@implementation SocialMessage

- (void) send:(CDVInvokedUrlCommand*)command {

  [self.commandDelegate runInBackground:^{

    if ( !NSClassFromString(@"UIActivityViewController") ) {
      CDVPluginResult * pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"not available"];
      [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
      return;
    }

    NSMutableDictionary *args = [command.arguments objectAtIndex:0];
    NSString *messageString = [args objectForKey:@"text"];
    NSString *urlString = [args objectForKey:@"url"];
    NSString *imageString = [args objectForKey:@"image"];
    NSString *subjectString = [args objectForKey:@"subject"];
    NSArray *activityTypes = [[args objectForKey:@"activityTypes"] componentsSeparatedByString:@","];
    NSMutableArray *activityItems = [NSMutableArray new];

    if ( messageString ) {
      [activityItems addObject:messageString];
    }

    if ( urlString ) {
      NSURL *formattedUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@", urlString]];
      [activityItems addObject:formattedUrl];
    }

    if ( imageString ) {
      UIImage *imageFromUrl = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", imageString]]]];
      [activityItems addObject:imageFromUrl];
    }

    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:Nil];
    if ( subjectString != nil ) {
      [activityVC setValue:subjectString forKey:@"subject"];
    }

    [activityVC setCompletionHandler:^(NSString *activityType, BOOL completed) {
      NSLog(@"SocialMessage app selected: %@", activityType);
      CDVPluginResult * pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:completed];
      [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];

    NSMutableArray *exclusions = [[NSMutableArray alloc] init];

    if ( ![activityTypes containsObject:@"PostToFacebook"] ) {
      [exclusions addObject: UIActivityTypePostToFacebook];
    }
    if ( ![activityTypes containsObject:@"PostToTwitter"] ) {
      [exclusions addObject: UIActivityTypePostToTwitter];
    }
    if ( ![activityTypes containsObject:@"PostToWeibo"] ) {
      [exclusions addObject: UIActivityTypePostToWeibo];
    }
    if ( ![activityTypes containsObject:@"Message"] ) {
      [exclusions addObject: UIActivityTypeMessage];
    }
    if ( ![activityTypes containsObject:@"Mail"] ) {
      [exclusions addObject: UIActivityTypeMail];
    }
    if ( ![activityTypes containsObject:@"Print"] ) {
      [exclusions addObject: UIActivityTypePrint];
    }
    if ( ![activityTypes containsObject:@"CopyToPasteboard"] ) {
      [exclusions addObject: UIActivityTypeCopyToPasteboard];
    }
    if ( ![activityTypes containsObject:@"AssignToContact"] ) {
      [exclusions addObject: UIActivityTypeAssignToContact];
    }
    if ( ![activityTypes containsObject:@"SaveToCameraRoll"] ) {
      [exclusions addObject: UIActivityTypeSaveToCameraRoll];
    }

    if ( [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ) {
      if ( ![activityTypes containsObject:@"AddToReadingList"] ) {
        [exclusions addObject: UIActivityTypeAddToReadingList];
      }
      if ( ![activityTypes containsObject:@"PostToFlickr"] ) {
        [exclusions addObject: UIActivityTypePostToFlickr];
      }
      if ( ![activityTypes containsObject:@"PostToVimeo"] ) {
        [exclusions addObject: UIActivityTypePostToVimeo];
      }
      if ( ![activityTypes containsObject:@"TencentWeibo"] ) {
        [exclusions addObject: UIActivityTypePostToTencentWeibo];
      }
      if ( ![activityTypes containsObject:@"AirDrop"] ) {
        [exclusions addObject: UIActivityTypeAirDrop];
      }
    }

    if ( [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ) {
      UIButton* invisibleShareButton = [UIButton buttonWithType:UIButtonTypeCustom];
      invisibleShareButton.bounds = CGRectMake(0 ,0, 0, 0);
      activityVC.popoverPresentationController.sourceView = invisibleShareButton;
    }

    activityVC.excludedActivityTypes = exclusions;

    dispatch_async(dispatch_get_main_queue(), ^(void) {
      [self.viewController presentViewController:activityVC animated:YES completion:Nil];
    });

  }];

}

@end
