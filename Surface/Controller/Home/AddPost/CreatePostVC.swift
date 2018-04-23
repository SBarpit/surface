
import UIKit
import AVFoundation
import Photos
import SCRecorder

enum PostType{
    case Photo
    case Video
    case Gallery
    case None
    static var type = PostType.None
}

protocol GoToImageCropper : class {
    func goToImageCropper(image:UIImage)
    func takeVideoToCaptionVc(url:AVURLAsset)
    func takeVideoFromCameraToCaptionVc(url:URL)
}

class CreatePostVC : BaseSurfaceVC {
    
    var galleryVC :ChoosePostFromGalleryVC?
    var cameraVC : PostFromCameraVC?
    var createPostType = PostType.None
    var isCameraRemove:Bool = false
    var selectedAsset: PHAsset?
    
    //MARK:- IBOutlets
    //==================
    
    @IBOutlet weak var buttonTopView: UIView!
    @IBOutlet weak var cameraSubView: UIView!
    @IBOutlet weak var createPostScrollView : UIScrollView!
    @IBOutlet weak var selectedViewCenter: NSLayoutConstraint!
    @IBOutlet weak var selectedTabView: UIView!
    @IBOutlet weak var videoButton: UIButton!
    @IBOutlet weak var galleryButton: UIButton!
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var cameraOptionOverLayView: UIView!
    @IBOutlet weak var nextButton: UIButton!
    
    //MARK:- view life cycle
    //========================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.SetupSubView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.galleryVC?.addObserVers()
        if isCameraRemove && (self.createPostType == .Photo ||  self.createPostType == .Video){
            //self.addCammeraVc(origin: CGPoint(x: 0, y: 0) , type: self.createPostType)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.galleryVC?.removeObservers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        URLCache.shared.removeAllCachedResponses()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.cameraOptionOverLayView.vertical_Gradient_Color(colors: [ #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0).cgColor , #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.6953125).cgColor], locations: [0.0 , 0.80])
    }
    
    // Hide status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        Global.removeChahe()
        Global.clearTempDirectory()
    }
    
    //MARK:- @IBActions
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        if let duration = self.cameraVC?.getRecordedDuration() , duration > 0.0 , createPostType == .Video{
            self.showAlert(alert: ConstantString.k_Discard_video_title.localized, msg: ConstantString.k_Discard_video_desc.localized, done: ConstantString.k_discard.localized, cancel: ConstantString.k_Keep.localized, success: { (success) in
                if success{
                    self.cameraVC?.deInitialize_Recorder()
                    Global.getMainQueue {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            })
        }else{
            self.cameraVC?.deInitialize_Recorder()
            self.dismiss(animated: true, completion: nil)
        }
        self.buttonTopView.backgroundColor = .clear
        
    }
    
    //MARK:- gallery button tapped
    //================================
    @IBAction func galleryButtonTapped(_ sender: UIButton) {
        self.moveToGallery()
    }
    
    //MARK:- photo button tapped
    //===============================
    @IBAction func photoButtontapped(_ sender: UIButton) {
        self.moveToPhoto()
    }
    
    //MARK:- video button tapped
    //=============================
    @IBAction func videoButtontapped(_ sender: UIButton) {
        self.moveToVideo()
    }
    
    
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        
        if self.createPostType == .Video{
            if let duration = self.cameraVC?.getRecordedDuration() , duration > 0.0{
                Global.getMainQueue {
                    self.sendVideo_for_filter()
                }
            }else {
                
                Global.showToast(msg: ConstantString.k_first_record_video.localized)
                return
            }
        }else if self.createPostType == .Gallery{
            
            self.moveToNext()
        }
    }
}

extension CreatePostVC{
    
    //MARK:- Set up sub view
    //=========================
    func SetupSubView(){
        //self.createPostScrollView.backgroundColor = .black
        self.createPostScrollView.delegate = self
        self.createPostScrollView.isPagingEnabled = true
        self.createPostScrollView.contentSize = CGSize(width: 2*Global.screenWidth, height: Global.screenHeight)
        
        self.addCammeraVc(origin: CGPoint(x: 0, y: 0))
        self.cameraOptionOverLayView.isHidden = true
        self.cameraVC?.captureButton.isHidden = true
        self.cameraVC?.timeView.isHidden = true
        self.addGalleryVC()
        self.nextButton.isHidden = true
        self.createPostScrollView.showsVerticalScrollIndicator = false
        self.createPostScrollView.showsHorizontalScrollIndicator = false
        self.createPostType = .Photo
        self.view.bringSubview(toFront: self.closeButton)
        self.view.bringSubview(toFront: self.nextButton)
    }
    
    //MARK:- Add gallery vc
    ///=========================
    func addGalleryVC(){
        self.galleryVC = ChoosePostFromGalleryVC.instantiate(fromAppStoryboard: .Home)
        self.createPostScrollView.frame = (self.galleryVC?.view.frame)!
        self.createPostScrollView.addSubview((self.galleryVC?.view)!)
        self.galleryVC?.view.frame.size.height = self.createPostScrollView.frame.height - 64
        self.galleryVC?.view.frame.origin = CGPoint(x: Global.screenWidth, y: 64)
        self.galleryVC?.delegate = self
    }
    
    //MARK:- add post vc
    //====================
    func addCammeraVc(origin :CGPoint , type:PostType = .Photo){
        self.closeButton.setImage(#imageLiteral(resourceName: "icCameraCross"), for: .normal)
        self.cameraVC = PostFromCameraVC.instantiate(fromAppStoryboard: .Home)
        self.cameraVC?.imageCropper = self
        self.cameraVC?.postType = type
        self.createPostScrollView.frame = (self.cameraVC?.view.frame)!
        self.cameraVC?.view.frame.size.height = self.createPostScrollView.frame.height
        self.cameraVC?.view.frame.origin = origin
        self.createPostScrollView.addSubview((self.cameraVC?.view)!)
        self.cameraVC?.postDelegate = self
        self.view.bringSubview(toFront: self.closeButton)
        self.view.bringSubview(toFront: self.nextButton)
        self.cameraOptionOverLayView.isHidden = true
        self.addChildViewController(self.cameraVC!)
        self.view.layoutIfNeeded()
    }
    
    func removeCameraVc(){
        if self.cameraVC != nil{
            self.cameraVC?.removeFromParentViewController()
            self.cameraVC?.view.removeFromSuperview()
            self.cameraVC?.deInitialize_Recorder()
            self.cameraVC = nil
        }
    }
    
    //MARK:- sendVideo_for_filter
    private func sendVideo_for_filter(){
        self.cameraVC?.recorder?.session?.mergeSegments(usingPreset: AVAssetExportPresetHighestQuality, completionHandler: { ( url, error) in
            if let err = error{
                // appLoader.stop()
                Global.showToast(msg: err.localizedDescription)
            }else{
                Global.getMainQueue {
                    guard let videoUrl = url else {return}
                    let videoFilterScene = Filter_Video_VC.instantiate(fromAppStoryboard: .Home)
                    let asset = AVAsset(url: videoUrl)
                    videoFilterScene.videoAsset = asset
                    
                    Global.print_Debug(self.createPostType)
                    videoFilterScene.create_PostType = self.createPostType
                    self.cameraVC?.timeLabel.text = "00:00"
                    self.cameraVC?.recorder?.session?.removeAllSegments()
                    self.isCameraRemove = true
                    if let flushBtn_state =  self.cameraVC?.flashbutton.isSelected , flushBtn_state{
                        self.cameraVC?.isFlashAvailable()
                    }
                    
                    self.navigationController?.pushViewController(videoFilterScene, animated: true)
                }
            }
        })
    }
    
    private func moveToGallery() {
        if let _ = self.selectedAsset{
             self.nextButton.isHidden = false
        }else{
            self.nextButton.isHidden = true
        }
       
        self.closeButton.setImage(#imageLiteral(resourceName: "icHomeShareWithinAppPopupCross"), for: .normal)
        self.cameraOptionOverLayView.isHidden = false
        self.createPostScrollView.setContentOffset(CGPoint(x: Global.screenWidth, y: 0), animated: true)
        self.createPostType = .Gallery
        self.cameraVC?.stopRecording()
        self.removeCameraVc()
        self.nextButton.isEnabled = true
        
        UIView.animate(withDuration: 0.2) {
            self.selectedViewCenter.constant = self.galleryButton.w * 2
            self.view.layoutIfNeeded()
        }
        self.buttonTopView.backgroundColor = .black
    }
    
    private func moveToPhoto() {
        self.createPostScrollView.setContentOffset(CGPoint(x: 0 , y: 0), animated: true)
        
        if self.cameraVC == nil{
            self.addCammeraVc(origin: CGPoint(x: 0, y: 0))
        }
        self.cameraVC?.postType = .Photo
        self.cameraVC?.timeView.isHidden = true
        self.nextButton.isHidden = true
        self.cameraVC?.recorder?.pause()
        self.cameraVC?.stopRecording()
        self.galleryVC?.player?.pause()
        self.cameraVC?.capturePhotoButton.isHidden = false
        self.cameraVC?.captureButton.isHidden = true
        self.cameraVC?.recorder?.captureSessionPreset = AVCaptureSession.Preset.photo.rawValue
        self.createPostType = .Photo
        self.cameraVC?.flashbutton.isSelected = false
        cameraVC?.isFlashAvailable()
        
        if self.cameraVC?.recorder?.device == AVCaptureDevice.Position.front{
            self.cameraVC?.flashbutton.isSelected = false
            self.cameraVC?.recorder?.flashMode = .off
        }
        UIView.animate(withDuration: 0.2) {
            self.selectedViewCenter.constant =  0
            self.view.layoutIfNeeded()
        }
        self.buttonTopView.backgroundColor = .clear
    }
    
    //MARK: - Scrollview scroll/navigation methods -
    private func moveToVideo() {
        
        if let duration = self.cameraVC?.getRecordedDuration() , duration > 0.0{
            Global.getMainQueue {
                self.sendVideo_for_filter()
            }
        }else {
            
            self.nextButton.isHidden = false
        }
        
        self.createPostScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        if self.cameraVC == nil{
            self.addCammeraVc(origin: CGPoint(x:0 , y: 0))
        }
        self.cameraVC?.postType = .Video
        self.cameraVC?.timeView.isHidden = false
        self.nextButton.isHidden = true
        self.galleryVC?.player?.pause()
        self.cameraVC?.capturePhotoButton.isHidden = true
        self.cameraVC?.captureButton.isHidden = false
        self.createPostType = .Video
        self.cameraVC?.flashbutton.isSelected = false
        cameraVC?.isTorchAvailable()
        if self.cameraVC?.recorder?.device == AVCaptureDevice.Position.front{
            self.cameraVC?.flashbutton.isSelected = false
            self.cameraVC?.recorder?.flashMode = .off
        }
        self.cameraVC?.recorder?.captureSessionPreset = AVCaptureSession.Preset.high.rawValue
        UIView.animate(withDuration: 0.2) {
            self.selectedViewCenter.constant = self.videoButton.w
            self.view.layoutIfNeeded()
        }
        self.buttonTopView.backgroundColor = .clear

    }
}

//MAK:- scro;;view delegate
//================================
extension CreatePostVC : UIScrollViewDelegate{
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        let fractionalPage = Int (scrollView.contentOffset.x / Global.screenWidth);
//        switch fractionalPage {
//        case 0:
//            self.moveToPhoto()
//        case 1:
//            self.moveToVideo()
//        case 2:
//            self.moveToGallery()
//        default:
//            break
//        }
    }
}

//MARK:- selecte_Asset_FromGalleryDelegate / GoToImageCropper
extension CreatePostVC : GoToImageCropper , selecte_Asset_FromGalleryDelegate , createPostFromCameraDelegate{
    func updateNextButton() {
        self.nextButton.isHidden = false
    }
    
    
    func goToImageCropper(image: UIImage) {
        
    }
    
    func takeVideoFromCameraToCaptionVc(url: URL) {
        //        let vc = VideoCaptionVC.instantiate(fromAppStoryboard: .Home)
        //        vc.videoUrl = url
        //       // vc.videoExtension = "mov"
        //        self.navigationController?.pushViewController(vc)
    }
    
    func takeVideoToCaptionVc(url: AVURLAsset) {
        
        //        let vc = VideoTrimmingVC.instantiate(fromAppStoryboard: .Home)
        //
        //        vc.asset = url
        //
        //        self.navigationController?.pushViewController(vc)
        
    }
    
    // selected Asset from Gallery
    func selected_Assets( phAsset: PHAsset) {
        self.selectedAsset = phAsset
        self.nextButton.isHidden = false
    }
    
    func moveToNext(){
        
        guard let ass = self.selectedAsset else {
            return
        }
        if ass.mediaType == .image{
            let imageFilterScene = Filter_ImageVC.instantiate(fromAppStoryboard: .Home)
            
            let imgManager = PHImageManager.default()
            
            let reqOptions = PHImageRequestOptions()
            var i = 0
            DispatchQueue.global(qos: .background).async {
                
                let imageSize = CGSize(width: ass.pixelWidth,
                                       height: ass.pixelHeight)
                imgManager.requestImage(for: ass , targetSize: imageSize, contentMode: PHImageContentMode.default, options: reqOptions, resultHandler: { (image, _) in
                    DispatchQueue.main.async {
                        guard let img = image else{ return }
                        if i == 1{
                            DispatchQueue.main.async {
                                imageFilterScene.thumbnailImage = CIImage(cgImage:img.cgImage!)
                                imageFilterScene.previewImage = img
                                self.navigationController?.pushViewController(imageFilterScene, animated: true)
                            }
                        }
                        i += 1
                    }
                })
            }
            
        }else if ass.mediaType == .video{
            PHCachingImageManager().requestAVAsset(forVideo: ass, options: nil, resultHandler: {(asset: AVAsset?, audioMix: AVAudioMix?, info: [AnyHashable : Any]?) in
                guard let asset = asset as? AVURLAsset else {
                    Global.print_Debug("Asset not found")
                    return
                }
                Global.getMainQueue {
                    let videoFilterScene = Filter_Video_VC.instantiate(fromAppStoryboard: .Home)
                    let avAsset = AVAsset(url: asset.url)
                    videoFilterScene.videoAsset = avAsset
                    videoFilterScene.video_url = asset.url
                    self.navigationController?.pushViewController(videoFilterScene, animated: true)
                }
            })
        }
    }
    
    func createPostFromCamera(post: Any) {
        if let img = post as? UIImage{
            Global.print_Debug("\(img)")
            let imageFilterScene = Filter_ImageVC.instantiate(fromAppStoryboard: .Home)
            let fixOrientationImg = Global.fixOrientationOfImage(image: img)
            imageFilterScene.thumbnailImage = CIImage(cgImage:(fixOrientationImg?.cgImage!)!)
            imageFilterScene.previewImage = fixOrientationImg
            self.navigationController?.pushViewController(imageFilterScene, animated: true)
        }else{
            self.alert_With_Ok_Action(msg: "Failed to capture photo", done: ConstantString.k_OK.localized, success: { (success) in
                
            })
        }
    }
}

