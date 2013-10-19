//
//  ViewController.m
//  MP3GetBacker
//
//  Created by VisiKard MacBook Pro on 9/17/13.
//  Copyright (c) 2013 VLong. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://sveinbjorn.org/files/code/jsid3/al.mp3"]];
//    [request addValue:@"256" forHTTPHeaderField:@"Range"];
//    [request setHTTPMethod:@"GET"];
//    
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
//        NSLog(@"Finish %@", data);
//    }];
    
    NSURL *urlPath = [NSURL URLWithString:@"http://dl5.mp3.zdn.vn/CXomynY30XeljW9/b3524714dfc311d6745a74245445ea53/52393350/2013/09/18/9/a/9ad9f661b6470aa21c12bd9f46293fef.mp3?filename=2pac%20high%20speed%20-%20lukelan.mp3"];
    AVAsset *asset = [AVAsset assetWithURL:urlPath];
    for (AVMetadataItem *metadataItem in asset.commonMetadata) {
        if ([metadataItem.commonKey isEqualToString:@"title"]){
            NSLog(@"title %@", metadataItem.value);
            self.titleLabel.text = (NSString *)metadataItem.value;
        } else if ([metadataItem.commonKey isEqualToString:@"albumName"]) {
            NSLog(@"artist %@", metadataItem.value);
        } else if ([metadataItem.commonKey isEqualToString:@"artist"]) {
            NSLog(@"artist %@", metadataItem.value);
            self.artistLabel.text = (NSString *)metadataItem.value;
        } else if ([metadataItem.commonKey isEqualToString:@"genre"]) {
            NSLog(@"genre %@", metadataItem.value);
        } else if ([metadataItem.commonKey isEqualToString:@"artwork"]) {
            NSDictionary *dict = (NSDictionary *)metadataItem.value;
            UIImage *image = [UIImage imageWithData:dict[@"data"]];
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
            self.imageView.image = image;
        }
    }
    NSArray *metaDataItems = [asset metadataForFormat:asset.availableMetadataFormats[0]];
    for (AVMetadataItem *item in metaDataItems) {
        NSLog(@"Key %@ - Value %@", item.commonKey, item.value);
    }

    
    CMTime duration = asset.duration;
    float durationSeconds = CMTimeGetSeconds(duration);
    NSLog(@"Duration %f", durationSeconds);
    NSLog(@"Lyrics %@", asset.lyrics);
//
//    NSURL *fileURL = [NSURL fileURLWithPath:@"http://sveinbjorn.org/files/code/jsid3/al.mp3"];
//    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:fileURL options:nil];
//    
//    NSArray *keys = [NSArray arrayWithObjects:@"commonMetadata", nil];
//    [asset loadValuesAsynchronouslyForKeys:keys completionHandler:^{
//        NSArray *artworks = [AVMetadataItem metadataItemsFromArray:asset.commonMetadata
//                                                           withKey:AVMetadataCommonKeyArtwork
//                                                          keySpace:AVMetadataKeySpaceCommon];
//        
//        for (AVMetadataItem *item in artworks) {
//            if ([item.keySpace isEqualToString:AVMetadataKeySpaceID3]) {
//                NSDictionary *dict = [item.value copyWithZone:nil];
//                self.imageView.image = [UIImage imageWithData:[dict objectForKey:@"data"]];
//            } else if ([item.keySpace isEqualToString:AVMetadataKeySpaceiTunes]) {
//                self.imageView.image = [UIImage imageWithData:[item.value copyWithZone:nil]];
//            }
//        }
//    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
