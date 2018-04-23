//
//  Filter_Video_VC.swift
//  Surface
//
//  Created by Nandini Yadav on 19/03/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import Photos

class Filter_Video_VC: BaseSurfaceVC {
    
    //MARK:- ENUMS
    //============
    enum AIFilter : Int {
        
        case NoEffect = 0
        case Chrome
        case Fade
        case Instant
        case Noir
        case Process
        case Tonal
        case Transfer
        case Sepia
        case ColorInvert
        case Nashville
        //case Toaster
        case Filter1977
        case Clarendon
        case HazeRemoval
        
        init(rawValue : Int) {
            
            switch rawValue {
                
            case 1: self = .Chrome
            case 2: self = .Fade
            case 3: self = .Instant
            case 4: self = .Noir
            case 5: self = .Process
            case 6: self = .Tonal
            case 7: self = .Transfer
            case 8: self = .Sepia
            case 9: self = .ColorInvert
            case 10: self = .Nashville
            //case 11: self = .Toaster
            case 11: self = .Filter1977
            case 12: self = .Clarendon
            case 13: self = .HazeRemoval
            default: self = .NoEffect
                
            }
        }
        
        var displayName : String {
            
            switch self {
                
            case .NoEffect:
                return "Original"
            case .Chrome:
                return "Chrome"
            case .Fade:
                return "Fade"
            case .Instant:
                return "Instant"
            case .Noir:
                return "Noir"
            case .Process:
                return "Process"
            case .Tonal:
                return "Tonal"
            case .Transfer:
                return "Transfer"
            case .Sepia:
                return "Sepia"
            case .ColorInvert:
                return "Invert"
            case .Nashville:
                return "Nashville"
            //            case .Toaster:
            //                return "Toaster"
            case .Filter1977:
                return "Filter1977"
            case .Clarendon:
                return "Clarendon"
            case .HazeRemoval:
                return "HazeRemoval"
            }
        }
        
        var CIFilterName : String {
            
            switch self {
                
            case .NoEffect:
                return "No_Effect"
            case .Chrome:
                return "CIPhotoEffectChrome"
            case .Fade:
                return "CIPhotoEffectFade"
            case .Instant:
                return "CIPhotoEffectInstant"
            case .Noir:
                return "CIPhotoEffectNoir"
            case .Process:
                return "CIPhotoEffectProcess"
            case .Tonal:
                return "CIPhotoEffectTonal"
            case .Transfer:
                return "CIPhotoEffectTransfer"
            case .Sepia:
                return "CISepiaTone"
            case .ColorInvert:
                return "CIColorInvert"
            case .Nashville:
                return "Nashville"
                //            case .Toaster:
            //                return "Nashville"
            case .Filter1977:
                return "Nashville"
            case .Clarendon:
                return "Nashville"
            case .HazeRemoval:
                return "Nashville"
            }
        }
        
        static var count : Int {
            
            var max = 1
            
            while AIFilter(rawValue: max) != .NoEffect {
                max = max + 1
            }
            return max
        }
    }
    
    let filters: [(name: String, applier: FilterApplierType?)] = [
        (name: "Normal",
         applier: nil),
        (name: "Chrome",
         applier: ImageHelper.createDefaultFilterApplier(name: "CIPhotoEffectChrome")),
        (name: "Fade",
         applier: ImageHelper.createDefaultFilterApplier(name: "CIPhotoEffectFade")),
        (name: "Instant",
         applier: ImageHelper.createDefaultFilterApplier(name: "CIPhotoEffectInstant")),
        (name: "Noir",
         applier: ImageHelper.createDefaultFilterApplier(name: "CIPhotoEffectNoir")),
        (name: "Process",
         applier: ImageHelper.createDefaultFilterApplier(name: "CIPhotoEffectProcess")),
        (name: "Tonal",
         applier: ImageHelper.createDefaultFilterApplier(name: "CIPhotoEffectTonal")),
        (name: "Transfer",
         applier: ImageHelper.createDefaultFilterApplier(name: "CIPhotoEffectTransfer")),
        (name: "Toaster",
         applier: ImageHelper.applyToasterFilter),
        (name: "Clarendon",
       //  applier: ImageHelper.applyClarendonFilter),
      //  (name: "HazeRemoval",
         applier: ImageHelper.applyHazeRemovalFilter),
        (name: "1977",
         applier: ImageHelper.apply1977Filter),
        (name: "Mono",
         applier: ImageHelper.createDefaultFilterApplier(name: "CIPhotoEffectMono")),
        (name: "Nashville",
         applier: ImageHelper.applyNashvilleFilter),
    
//        (name: "Tone",
//         applier: ImageHelper.createDefaultFilterApplier(name: "CILinearToSRGBToneCurve")),
//        (name: "Linear",
      //   applier: ImageHelper.createDefaultFilterApplier(name: "CISRGBToneCurveToLinear")),
        ]
    
    //MARK:- Properties
    var diapatchgroup = DispatchGroup()

    var ciContext = CIContext(options: nil)
    var previewedVideoIndexPath: IndexPath!
    var thumbnailImage: CIImage!
    var thumbnailImages: [UIImage?] = []

    var videoAsset : AVAsset?
    var video_url:URL?
    var create_PostType = PostType.None
    
    var player: AVPlayer!
    var avpController = AVPlayerViewController()
    var videoComposition : AVVideoComposition?
    var isNavigationBarHidden : Bool!
     var item :AVPlayerItem!
    
    //MARK:- @IBOutlets
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var selectFilterLabel: UILabel!
    @IBOutlet weak var videoPlayerView: UIView!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var filtersCollectionView: UICollectionView!
    @IBOutlet weak var playVideoButton: UIButton!
    
    //MARK:- View Life Cycle
    //======================
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying(_:)),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player.currentItem)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
   
    
    private func initialSetup(){
        guard let videoAsset = self.videoAsset else {
            Global.print_Debug("Asset is not found")
            return
        }
        self.setVideo(item: videoAsset)
        
        self.playVideoButton.isSelected = true
    
        self.avpController = AVPlayerViewController()
        self.avpController.videoGravity = AVLayerVideoGravity.resizeAspect.rawValue
        avpController.view.frame = self.videoPlayerView.frame
        self.addChildViewController(avpController)
        self.videoPlayerView.addSubview(avpController.view)
        
        self.filtersCollectionView.dataSource = self
        self.filtersCollectionView.delegate = self
        
        self.playVideo(filterName: AIFilter.NoEffect.CIFilterName)
    
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tapOnVideoView(_:)))
        self.videoPlayerView.addGestureRecognizer(tapGesture)
        
       
    }
    
    //MARK:- set video to image view
    //===================================
    func setVideo(item : AVAsset){
        
        DispatchQueue.global(qos: .background).async {
            
//            PHCachingImageManager().requestAVAsset(forVideo: item,options: nil, resultHandler: {(asset, audioMix, info) in
//                if let video = asset as? AVURLAsset{
            
                    let assetImgGenerate :  AVAssetImageGenerator!
                    //let ast = AVAsset(url: video.url)
                    
                    assetImgGenerate = AVAssetImageGenerator(asset: item)
                    assetImgGenerate.appliesPreferredTrackTransform = true
                    
                    let time : CMTime = CMTimeMakeWithSeconds(1, Int32(NSEC_PER_SEC))
                    
                    if let cgImage = try? assetImgGenerate.copyCGImage(at: time, actualTime: nil) {
                        
                            self.thumbnailImage = CIImage(cgImage: cgImage)
                        
                        for filter in self.filters{
                            if filter.applier == nil{
                                let img = UIImage(ciImage: self.thumbnailImage)
                                self.thumbnailImages.append(img)
                            }
                            else{
                            let uiImage = self.applyFilter(
                                applier: filter.applier,
                                ciImage: self.thumbnailImage)
                            self.thumbnailImages.append(uiImage)
                            }
                            DispatchQueue.main.async {
                                self.filtersCollectionView.reloadData()
                            }
                        }
                    }
               // }
           // })
        }
    }
    
    // MARK: Filter
    func applyFilter(
        applier: FilterApplierType?, ciImage: CIImage) -> UIImage {
        let outputImage: CIImage? = applier!(ciImage)
        
        let outputCGImage = self.ciContext.createCGImage(
            (outputImage)!,
            from: (outputImage?.extent)!)
        return UIImage(cgImage: outputCGImage!)
    }
    
    fileprivate func playorigionalVideo(filterName : String) {
        guard let avAsset = self.videoAsset else {return}
        
        self.videoComposition = AVMutableVideoComposition(asset: avAsset, applyingCIFiltersWithHandler: { request in
            let source = request.sourceImage.clampedToExtent()
            request.finish(with: source, context: nil)
        })
        item.videoComposition = self.videoComposition
        self.player.replaceCurrentItem(with: item)
    }
    
    
    fileprivate func playVideo(filterName : String) {
        guard let avAsset = self.videoAsset else {return}
        
        if let filter = CIFilter(name: filterName) {
            self.videoComposition = AVVideoComposition(asset: avAsset, applyingCIFiltersWithHandler: { request in
                // Clamp to avoid blurring transparent pixels at the image edges
                let source = request.sourceImage.clampedToExtent()
                filter.setValue(source, forKey: kCIInputImageKey)
                
                filter.setDefaults()
                // Crop the blurred output to the bounds of the original image
                let output = filter.outputImage!.cropped(to: request.sourceImage.extent)
                
                // Provide the filter output to the composition
                request.finish(with: output, context: nil)
            })
        }
        if self.player == nil{
            item = AVPlayerItem(asset: avAsset)
            item.videoComposition = self.videoComposition
            self.player = AVPlayer(playerItem: item)
            self.avpController.player = self.player
            self.player.play()
        }else{
            item.videoComposition = self.videoComposition
            self.player.replaceCurrentItem(with: item)
        }
       
        
    }
    
    fileprivate func playwithCustomFilterVideo(filterName : AIFilter) {
         guard let avAsset = self.videoAsset else {return}
        self.videoComposition = AVVideoComposition(asset: avAsset, applyingCIFiltersWithHandler: { request in
            // Clamp to avoid blurring transparent pixels at the image edges
            let source = request.sourceImage.clampedToExtent()
            
            var outputImage:CIImage?=nil
            if filterName == .Clarendon{
                outputImage = ImageHelper.applyClarendonFilter(foregroundImage: source)!
            }else if filterName == .Filter1977{
                outputImage = ImageHelper.apply1977Filter(ciImage: source)!
            }else if filterName == .HazeRemoval{
                outputImage = ImageHelper.applyHazeRemovalFilter(image: source)!
            }else if filterName == .Nashville{
                outputImage = ImageHelper.applyNashvilleFilter(foregroundImage: source)!
            }
            if let out = outputImage{
                request.finish(with: out, context: nil)
            }
        })
        
        if self.player == nil{
            item = AVPlayerItem(asset: avAsset)
            item.videoComposition = self.videoComposition
            self.player = AVPlayer(playerItem: item)
            self.avpController.player = self.player
            self.player.play()
        }else{
            item.videoComposition = self.videoComposition
            self.player.replaceCurrentItem(with: item)
        }
    }
    
    fileprivate func saveVideo(){
        
        self.diapatchgroup.enter()
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let outputurl = documentsURL.appendingPathComponent("finalvideo.mp4")
        var ur = outputurl
        
        guard let avAsset = self.videoAsset else {return}
        self.convertVideo(toMPEG4FormatForVideo: avAsset as! AVURLAsset, outputURL: outputurl) { (session) in
            
            ur = session.outputURL!
            self.diapatchgroup.leave()
            let addPostScene = AddPostVC.instantiate(fromAppStoryboard: .Home)
            addPostScene.videoAsset = self.videoAsset
            addPostScene.videoUrl = ur
            addPostScene.videoComposition = self.videoComposition
            addPostScene.add_postType = self.create_PostType
            addPostScene.mediaType = "2"
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(addPostScene, animated: true)
            }
        }
        self.diapatchgroup.wait()
    }
    
    func convertVideo(toMPEG4FormatForVideo asset: AVURLAsset, outputURL: URL, handler : @escaping (_ session : AVAssetExportSession) -> Void){
        
        do {
            try FileManager.default.removeItem(at: outputURL as URL)
        }
        catch {}
        
        let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality)
        exportSession?.outputURL = outputURL as URL
        exportSession?.outputFileType = AVFileType.mp4
        exportSession?.exportAsynchronously(completionHandler: {
            handler(exportSession!)
        })
    }
    
    //MARK:- @IBActions
    @objc private func playerDidFinishPlaying(_ note: NSNotification) {
        Global.print_Debug("Video Finished")
      //  self.playVideoButton.isSelected = false
        self.player.play()
        self.player.seek(to: CMTime(seconds: 0.0, preferredTimescale: 1))
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
         self.player.pause()
         self.saveVideo()
    }
    
    @IBAction func playVideoButtonTapped(_ sender: UIButton) {
        self.playPauseVideo()
    }
    
    @objc private func tapOnVideoView(_ sender:UITapGestureRecognizer) {
        self.playPauseVideo()
    }
    
    private func playPauseVideo() {
        if self.player != nil , !self.playVideoButton.isSelected{
            self.player.play()
            self.playVideoButton.isSelected = true
        }else{
            self.player.pause()
            self.playVideoButton.isSelected = false
        }
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
         self.player.pause()
        if self.create_PostType == .Video {
            self.showAlert(alert: ConstantString.k_Discard_video_title.localized, msg: ConstantString.k_Discard_video_desc.localized, done: ConstantString.k_discard.localized, cancel: ConstantString.k_Keep.localized, success: { (success) in
                if success {
                    Global.getMainQueue {
                        self.popToDismissController()
                    }
                }
            })
        } else {
           self.popToDismissController()
        }
    }
    
    func popToDismissController(){
        self.navigationController?.popViewController(animated: true)
//
//        let viewController :[UIViewController] = (self.navigationController?.viewControllers)!
//        for createPostVC in viewController{
//            if(createPostVC is CreatePostVC){
//                createPostVC.dismiss(animated: true, completion: nil)
//            }
//        }
    }
}

//MARK:- UICollectionViewDataSource
extension Filter_Video_VC : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return AIFilter.count
        return self.filters.count

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        guard let cell: FilterCell = collectionView.dequeueReusableCell(withReuseIdentifier: AppClassID.FilterCell.cellID, for: indexPath) as? FilterCell
            else {
                fatalError("unexpected cell in collection view")
        }
        cell.title.text = self.filters[indexPath.item].name
        cell.black_IndicatorView.isHidden = self.previewedVideoIndexPath != indexPath
        if self.thumbnailImages.count > indexPath.item{
        if let img = thumbnailImages[indexPath.item]{
            cell.thumbnailImage = img
            cell.loader.isHidden = true
            cell.loader.stopAnimating()

        }else{
            cell.loader.startAnimating()
            cell.loader.isHidden = false
            }
        }else{
            cell.loader.startAnimating()
            cell.loader.isHidden = false
        }
        
//        printElapsedTime(title:"\(indexPath.item)-cell", startTime: startTime)
//        let filter = AIFilter(rawValue: indexPath.item)
//        cell.filterNameLabel.text = filter.displayName
        return cell
    }
    
}

//MARK:- UICollectionViewDelegate
extension Filter_Video_VC : UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let numRow: Int = 4
        let cellWidth:CGFloat = self.view.bounds.width / CGFloat(numRow) - CGFloat(numRow)
        let cellHeight: CGFloat = CGFloat(130.0)
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.previewedVideoIndexPath = indexPath
        filtersCollectionView.reloadData()
        self.playVideoButton.isSelected = true
        let filter = AIFilter(rawValue:indexPath.item)
        if indexPath.item == 0{
            
//            if self.player == nil{
//                item = AVPlayerItem(asset: self.videoAsset!)
//                item.videoComposition = self.videoComposition
//                self.player = AVPlayer(playerItem: item)
//                self.avpController.player = self.player
//                self.player.play()
//            }else{
//                item.videoComposition = self.videoComposition
//                self.player.replaceCurrentItem(with: item)
//            }
            playorigionalVideo(filterName:AIFilter.NoEffect.displayName)
        }else{
        if filter == .Filter1977{
            self.playwithCustomFilterVideo(filterName: filter)
        }else if filter == .Nashville{
            self.playwithCustomFilterVideo(filterName: filter)
            //        }else if filter == .Toaster{
            //            self.playwithCustomFilterVideo(filterName: filter)
        }else if filter == .Clarendon{
            self.playwithCustomFilterVideo(filterName: filter)
        }else if filter == .HazeRemoval{
            self.playwithCustomFilterVideo(filterName: filter)
        }else{
            self.playVideo(filterName: AIFilter(rawValue: indexPath.item).CIFilterName)
            }
        }
    }
}


class VideoFiltersCollectionCell : UICollectionViewCell {
    
    @IBOutlet weak var blackIndicatorView: UIView!
    @IBOutlet weak var filterNameLabel: UILabel!
    
}

