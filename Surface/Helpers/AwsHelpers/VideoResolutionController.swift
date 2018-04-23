
////  VideoResolutionController.swift
////  VideoResolutionConverter
////
////  Created by Mohammad Umar Khan on 08/08/17.
////  Copyright © 2017 Appinventiv. All rights reserved.

import AVFoundation

enum AVAssetExportPresetResolution : String {
    
    case p640_480
    case p960_540
    case p1280_720
    case p1920_1080
    case p3840_2160
    case lowQuality
    case mediumQuality
    case highestQuality

    var rawValue : String {
        
        switch self {
    /*
    AVAssetExportPresetLowQuality
    //MARK: It Specifies a low quality QuickTime file..
    AVAssetExportPresetMediumQuality
    //MARK: Specifies a medium quality QuickTime file.
    AVAssetExportPresetHighestQuality
    //MARK: Specifies a highest quality QuickTime file.
    AVAssetExportPreset640x480
    //MARK:It specifies the resolution to 640x480.
    AVAssetExportPreset960x540
    //MARK:It specifies the resolution to 960x540.
    AVAssetExportPreset1280x720
    //MARK:It specifies the resolution to 1280x720.
    AVAssetExportPreset1920x1080
    //MARK:It specifies the resolution to 1920x1080.
    AVAssetExportPreset3840x2160
    //MARK:It specifies the resolution to 3840x2160.
    */
    case .lowQuality: return AVAssetExportPresetLowQuality
    case .mediumQuality: return AVAssetExportPresetMediumQuality
    case .highestQuality: return AVAssetExportPresetHighestQuality
    case .p640_480: return AVAssetExportPreset640x480
    case .p960_540: return AVAssetExportPreset960x540
    case .p1280_720: return AVAssetExportPreset1280x720
    case .p1920_1080: return AVAssetExportPreset1920x1080
    case .p3840_2160: return AVAssetExportPreset3840x2160
            
        }
    }
}

class VideoResolutionController {
    
    //MARK: Video Resolution Converter Method...
    //MARK: ==================================
    func convertVideoResolution(withInputURL inputURL: URL,
                                outputURL: URL,
                                resolution : AVAssetExportPresetResolution,
                                completionHandler: @escaping (_: AVAssetExportSession) -> Void) {
        
        try? FileManager.default.removeItem(at: outputURL)
        
        let asset = AVURLAsset(url: inputURL, options: nil)
        
        guard let exportSession = AVAssetExportSession(asset: asset, presetName: resolution.rawValue) else {
            return
        }
        
        exportSession.outputURL = outputURL
        exportSession.outputFileType = AVFileType.mov
        exportSession.exportAsynchronously(completionHandler: {(_: Void) -> Void in
            
            completionHandler(exportSession)
        })
        
    }
    
    //MARK: Converting resolutions...
    //MARK: ==========================
    func convertVideo(videoUrl: URL, saveTo: String) {
        
        let outputURL = URL(fileURLWithPath: saveTo, isDirectory: true)
        
        //Change 'resolution' to get the required resolution type
        convertVideoResolution(withInputURL: videoUrl,
                               outputURL: outputURL,
                               resolution: .mediumQuality,
                               completionHandler: {(_ exportSession: AVAssetExportSession) -> Void in
                                
                                
        })
        
    }
}

