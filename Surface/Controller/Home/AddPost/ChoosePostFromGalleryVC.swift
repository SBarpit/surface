

import UIKit
import Photos
import MediaPlayer

protocol selecte_Asset_FromGalleryDelegate: class{
    func selected_Assets(phAsset : PHAsset)
}


class ChoosePostFromGalleryVC : UIViewController {
    
    enum AppendOrignalImage{
        case AppendOrignal
        case None
        
    }
    
    //MARK:- variables
    //====================
    var allPhotosResult : PHFetchResult<AnyObject>?
    var  allMedia = [PHAsset]()
    weak var player : AVPlayer?
    weak var playerLayer : AVPlayerLayer?
    var selectedImage : [Int] = []
    var longPressRecognizer : UITapGestureRecognizer?
    var selectionBegin = false
    var selectedSingleAsset : PHAsset?
    weak var imageCropper : GoToImageCropper?
    var selectedImages : [UIImage] = []
    var selectedVideoUrl : AVURLAsset?
    var lastCretaionDate :Date?
    var scroll = true
    var lastContentOffset : CGFloat = 0.0
    weak var delegate : selecte_Asset_FromGalleryDelegate?
    
    
    
    //MARK:- IBOutlets
    //=====================
    
    @IBOutlet weak var deselectedMediaButton: UIButton!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var galleryCollectionView : UICollectionView!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var galleryImageView: UIImageView!
    @IBOutlet weak var topViewHeight: NSLayoutConstraint!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var galleryTableView: UITableView!
    @IBOutlet weak var tableBackView: UIView!
    
    
    deinit {
        self.removeObservers()
    }
    
    //MARK:- view life cycle
    //=======================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpSubView()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = false
        navigationController?.setNavigationBarHidden(false, animated: true)
        self.addObserVers()
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let _ = self.player{
            self.player?.seek(to: kCMTimeZero)
            self.pauseVideo()
        }
        self.removeObservers()
    }
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        CommonFunctions.removeChahe()
        CommonFunctions.clearTempDirectory()
    }
    
    @IBAction func deselectedButtonTapped(_ sender: UIButton) {
        
        self.selectedImage.removeAll()
        self.selectedImages.removeAll()
        self.selectionBegin = false
        // self.galleryCollectionView.reloadData()
        self.showHideSelectDeselectButton()
        self.deselectedMediaButton.isHidden = true
    }
    
    
    @IBAction func playPauseButtontapped(_ sender: UIButton) {
        self.playPauseButton.isSelected = !self.playPauseButton.isSelected
        self.player?.timeControlStatus == AVPlayerTimeControlStatus.playing ?  self.pauseVideo()
            : self.playVideo()
    }
}


//MARK:- privatefunctions
//========================
fileprivate extension ChoosePostFromGalleryVC{
    
    func setUpSubView(){
        
        self.deselectedMediaButton.isHidden = true
        self.galleryImageView.contentMode = .scaleAspectFit
        self.topView.clipsToBounds = true
        self.playPauseButton.setImage(#imageLiteral(resourceName: "icPostVideoPlay"), for: .normal)
        
        self.getAllMedia()
        self.longPressRecognizer = UITapGestureRecognizer(target: self, action: #selector(ChoosePostFromGalleryVC.longPressOnImage))
        self.tableBackView.frame = CGRect(x: 0, y: 0, width: Global.screenWidth, height: self.view.frame.height + Global.screenWidth)
        self.galleryTableView.contentSize = CGSize(width: Global.screenWidth, height: self.tableBackView.frame.size.height)
        self.topViewHeight.constant = Global.screenWidth
        self.galleryCollectionView.bounces = false
        self.galleryTableView.delegate = self
        self.galleryTableView.dataSource = self
        self.galleryTableView.showsVerticalScrollIndicator = false
        self.galleryCollectionView.showsVerticalScrollIndicator = false
    }
    
    
    //MARK:- get all media
    //=======================
    func getAllMedia() {
        
        self.allPhotosResult = PHFetchResult()
        let fetchOptions = PHFetchOptions()
        fetchOptions.fetchLimit = 15
        fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: false)]
        
        if let date = self.lastCretaionDate{
            fetchOptions.predicate = NSPredicate(format: "(creationDate < %@)", date as CVarArg)
        }
        
        
        guard let result = PHAsset.fetchAssets(with: fetchOptions) as? PHFetchResult<AnyObject> else {
            return
        }
        self.allPhotosResult = result
        if self.allPhotosResult!.count > 0{
            if let photo = self.allPhotosResult?.object(at: self.allPhotosResult!.count - 1) as? PHAsset{
                print(photo)
                if let date = photo.creationDate{
                    lastCretaionDate = date
                }
            }
        }
        if let _ = self.lastCretaionDate{
            
        }else{
            self.allMedia.removeAll(keepingCapacity: false)
        }
        for i in 0..<self.allPhotosResult!.count{
            if let photo = self.allPhotosResult?.object(at: i) as? PHAsset{
                self.allMedia.append(photo)
            }
        }
        self.galleryCollectionView.delegate = self
        self.galleryCollectionView.dataSource = self
        
        self.galleryCollectionView.reloadData()
        
        if self.allPhotosResult!.count > 0 {
            if self.allMedia.count <= 15{
                
                self.displayImageOrVideoOnTopView(indexPath: IndexPath(item: 0, section: 0),isAppend: false)
            }
        }
    }
    
    
    @objc func nextButtonTapped(){
        
        if self.selectedSingleAsset?.mediaType == .image{
            self.imageCropper?.goToImageCropper(image: self.galleryImageView.image!)
        }else{
            
            if let url = self.selectedVideoUrl{
                self.imageCropper?.takeVideoToCaptionVc(url: url)
            }
        }
    }
    
}

//MARK:- Dispaly views on top
extension ChoosePostFromGalleryVC {
    
    //MARK:- display image or video on top view
    //=============================================
    func displayImageOrVideoOnTopView(indexPath : IndexPath,isAppend : Bool){
        
        let asset = self.allMedia[indexPath.item]
        
        self.selectedSingleAsset = asset
        
        if asset.mediaType == .image {
            self.playPauseButton.isHidden = true
            self.displayImageOnTopView(asset: asset, isAppend: isAppend)
        }else if asset.mediaType == .video{
            self.playPauseButton.isHidden = false
            self.displayVideoOnTopView(asset: asset)
        }
    }
    
    //MARK:- Display image on top view
    //===================================
    func displayImageOnTopView(asset : PHAsset,isAppend:Bool){
        
        self.galleryImageView.isHidden = false
        self.videoView.isHidden = true
        
        let imgManager = PHImageManager.default()
        
        let reqOptions = PHImageRequestOptions()
        
        DispatchQueue.global(qos: .background).async {
            
            let imageSize = CGSize(width: asset.pixelWidth,
                                   height: asset.pixelHeight)
            
            var appendOrignal = AppendOrignalImage.None
            
            imgManager.requestImage(for: asset , targetSize: imageSize, contentMode: PHImageContentMode.default, options: reqOptions, resultHandler: { (image, _) in
                DispatchQueue.main.async {
                    
                    guard let img = image else{ return }
                    
                    if appendOrignal == AppendOrignalImage.AppendOrignal{
                        self.galleryImageView.image = image
                        
                        Global.print_Debug("isAppend...\(isAppend)")
                        
                        if isAppend{
                            
                            self.selectedImages.append(self.galleryImageView.image!)
                            Global.print_Debug(self.selectedImage.count)
                            Global.print_Debug(self.selectedImages.count)
                            
                        }
                    }
                    appendOrignal = AppendOrignalImage.AppendOrignal
                }
            })
        }
        self.player?.pause()
        self.player = nil
        self.playerLayer = nil
    }
    
    //MARK:- display video on top view
    //=====================================
    func displayVideoOnTopView(asset : PHAsset){
        
        self.selectedImage.removeAll()
        self.selectedImages.removeAll()
        self.selectionBegin = false
        //self.galleryCollectionView.reloadData()
        self.deselectedMediaButton.isHidden = true
        self.showHideSelectDeselectButton()
        
        PHCachingImageManager().requestAVAsset(forVideo: asset,options: nil, resultHandler: {(asset, audioMix, info) in
            
            DispatchQueue.main.async{
                
                self.player?.seek(to: kCMTimeZero)
                
                if let asset = asset as? AVURLAsset{
                    self.setUpVideo(videoasset: asset)
                    
                    CommonFunctions.delayy(delay: 0.1, closure: {
                        
                        //  self.galleryCollectionView.reloadData()
                        self.showHideSelectDeselectButton()
                        
                    })
                }
            }
        })
        self.galleryImageView.isHidden = true
        self.videoView.isHidden = false
    }
    
    
    func showHideSelectDeselectButton(){
        let visibleItem = self.galleryCollectionView.indexPathsForVisibleItems
        for indexPath in visibleItem{
            guard let cell = self.galleryCollectionView.cellForItem(at: indexPath) as? GalleryCell else { return }
            cell.showHideDeselectButton(isSelectionBegin: self.selectionBegin, selectedImage: self.selectedImage, item: indexPath.item)
        }
    }
}

//MARK:- Manage player
//========================
extension ChoosePostFromGalleryVC{
    
    //MARK:- player didplay to end time
    //==================================
    @objc func playerItemDidPlayToEndTime(sender : Notification){
        
        self.player?.seek(to: kCMTimeZero)
        self.pauseVideo()
    }
    
    //MARK:- Play video when tapped
    //==================================
    func setUpVideo(videoasset : AVURLAsset) {
        if let _ = self.player{
            self.setVideo(url: videoasset.url)
            self.selectedVideoUrl = videoasset
        }else{
            self.player = AVPlayer(url: videoasset.url)
            self.selectedVideoUrl = videoasset
            self.playerLayer = AVPlayerLayer(player: player)
            self.playerLayer?.frame = CGRect(x: 0, y: 0, width: Global.screenWidth, height: Global.screenWidth)
            self.view.bringSubview(toFront: self.videoView)
            self.videoView.clipsToBounds = true
            self.playerLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            self.videoView.layer.addSublayer(self.playerLayer!)
           // self.playVideo()
        }
    }
    
    func setVideo(url : URL) {
        let asset  =  AVAsset(url: url)
        let keys = ["playable","tracks","duration"]
        
        asset.loadValuesAsynchronously(forKeys: keys) {
            let playerItem = AVPlayerItem(asset: asset)
            self.player?.replaceCurrentItem(with: playerItem)
            self.playVideo()
        }
    }
    
    func playVideo(){
        
        DispatchQueue.main.async {
            self.player?.play()
            //self.playPauseButton.setImageForAllStates(#imageLiteral(resourceName: "pauseButton"))
        }
        
        //  self.playPauseButton.isHidden = true
    }
    
    func pauseVideo(){
        
        self.player?.pause()
        //self.playPauseButton.setImageForAllStates(#imageLiteral(resourceName: "playButton"))
    }
    
    //MARK:- Add observers
    //=====================
    func addObserVers(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidPlayToEndTime), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        
    }
    
    //MARK:- remove observers
    //==============================
    func removeObservers(){
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
}

//MARK:- collectionview delegate and datasource
//================================================
extension ChoosePostFromGalleryVC : UICollectionViewDelegate , UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.allMedia.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (Global.screenWidth / 3) - 0.8 , height: (Global.screenWidth / 3) - 0.8  )
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryCell", for: indexPath) as! GalleryCell
        
        //dequeueReusableCell(withReuseIdentifier: GalleryCell.self, for: indexPath)
        
        let photo = self.allMedia[indexPath.item]
        let long = UILongPressGestureRecognizer(target: self, action: #selector(ChoosePostFromGalleryVC.longPressOnImage))
        long.minimumPressDuration = 1.0
        
        cell.playImageView.isHidden = photo.mediaType == .image
        
        if photo.mediaType == .image{
            cell.playImageView.isHidden = true
            
            cell.setPhoto(item: photo)
            cell.galleryImageView.addGestureRecognizer(long)
            cell.showHideDeselectButton(isSelectionBegin: self.selectionBegin, selectedImage: self.selectedImage, item: indexPath.item)
            
        }else if photo.mediaType == .video{
            cell.playImageView.isHidden = false
            cell.setVideo(item: photo)
            cell.deselectButton.isHidden = true
            cell.galleryImageView.removeGestureRecognizer(long)
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //        if self.selectionBegin{
        //            if self.selectedImage.contains(indexPath.item){
        //                let index = self.selectedImage.index(of: indexPath.item)
        //                self.selectedImage.remove(at: index!)
        //                self.selectedImages.remove(at: index!)
        //                self.displayImageOrVideoOnTopView(indexPath: indexPath, isAppend: false)
        //            }else{
        //
        //                if self.selectedImage.count < 3{
        //                    self.selectedImage.append(indexPath.item)
        //                    self.displayImageOrVideoOnTopView(indexPath: indexPath, isAppend: true)
        //                }else{
        //                    //showToastMessage(K_MAXIMUM_PHOTOS_SELECT.localized)
        //                }
        //            }
        //
        //            self.galleryCollectionView.reloadItems(at: [IndexPath(item: indexPath.item, section: 0)])
        //
        //        }else{
        
        let photo = self.allMedia[indexPath.item]
        self.delegate?.selected_Assets(phAsset: photo)
        
        self.galleryTableView.setContentOffset(  CGPoint(x: 0, y: 0), animated: true)
        self.displayImageOrVideoOnTopView(indexPath: indexPath, isAppend: false)
        // }
        
        
        //        if self.selectedImage.isEmpty{
        //
        //            self.deselectedMediaButton.isHidden = true
        //        }else{
        //            self.deselectedMediaButton.isHidden = false
        //
        //        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    }
    
    //MARK:- Long press on asset
    
    @objc func longPressOnImage(sender : UILongPressGestureRecognizer){
        
        if !self.selectionBegin{
            let tapLocation = sender.location(in: self.galleryCollectionView)
            let indexPath : IndexPath = self.galleryCollectionView.indexPathForItem(at: tapLocation)!
            
            self.selectionBegin = true
            
            let asset = self.allMedia[indexPath.item]
            
            if !self.selectedImage.contains(indexPath.item) && asset.mediaType == .image{
                self.selectedImage.removeAll()
                self.selectedImages.removeAll()
                self.selectedImage.append(indexPath.item)
                
                self.displayImageOrVideoOnTopView(indexPath: indexPath,isAppend: true)
                //self.galleryCollectionView.reloadData()
                self.showHideSelectDeselectButton()
            }
        }
        if self.selectedImage.isEmpty{
            
            self.deselectedMediaButton.isHidden = true
        }else{
            self.deselectedMediaButton.isHidden = false
            
        }
    }
}


extension ChoosePostFromGalleryVC : UIScrollViewDelegate{
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.galleryCollectionView{
            
            Global.print_Debug("table...\(scrollView.contentOffset)")
            
        }
    }
    
    func scrollView(_ scrollView: MXScrollView, shouldScrollWithSubView subView: UIScrollView) -> Bool {
        return true
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let endScrolling = scrollView.contentOffset.y + scrollView.contentSize.height
        if endScrolling > scrollView.contentSize.height {
            self.getAllMedia()
        }
    }
    
    
    //    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
    //
    //        if scrollView != self.galleryCollectionView{
    //            return true
    //        }else{
    //
    //            return false
    //        }
    //    }
    
}


class GalleryCell : UICollectionViewCell{
    
    @IBOutlet weak var galleryImageView: UIImageView!
    @IBOutlet weak var overLayView: UIView!
    @IBOutlet weak var deselectButton: UIButton!
    @IBOutlet weak var playImageView: UIImageView!
    
    let imgManager = PHImageManager.default()
    
    override func prepareForReuse() {
        galleryImageView.image = nil
    }
    
    override func awakeFromNib() {
        self.galleryImageView.contentMode = .scaleAspectFill
        self.galleryImageView.clipsToBounds = true
        self.overLayView.isHidden = true
        self.galleryImageView.isUserInteractionEnabled = true
        self.deselectButton.isUserInteractionEnabled = false
    }
    
    //MARK:- hide show deselecte button
    //======================================
    func showHideDeselectButton(isSelectionBegin : Bool,selectedImage : [Int] , item : Int){
        
        if isSelectionBegin{
            self.deselectButton.isHidden = false
            if selectedImage.contains(item){
                
                //self.deselectButton.setImageForAllStates(#imageLiteral(resourceName: "ic_signup_select"))
            }else{
                
                //self.deselectButton.setImageForAllStates(#imageLiteral(resourceName: "deselectCircle"))
                
            }
        }else{
            self.deselectButton.isHidden = true
            
        }
        
        
    }
    
    //MARK:- set photo to image view
    //===================================
    func setPhoto(item : PHAsset){
        
        let h:CGFloat =  (Global.screenWidth / 3) - 0.8
        let size = CGSize(width: h, height: h)
        
        self.imgManager.requestImage(for: item,targetSize: size,
                                     contentMode: .aspectFill,options: nil) {result, info in
                                        
                                        self.galleryImageView.image = result
        }
    }
    
    //MARK:- set video to image view
    //===================================
    func setVideo(item : PHAsset){
        
        DispatchQueue.global(qos: .background).async {
            
            PHCachingImageManager().requestAVAsset(forVideo: item,options: nil, resultHandler: {(asset, audioMix, info) in
                if let video = asset as? AVURLAsset{
                    
                    let assetImgGenerate :  AVAssetImageGenerator!
                    let ast = AVAsset(url: video.url)
                    
                    assetImgGenerate = AVAssetImageGenerator(asset: ast)
                    assetImgGenerate.appliesPreferredTrackTransform = true
                    
                    let time : CMTime = CMTimeMakeWithSeconds(1, Int32(NSEC_PER_SEC))
                    
                    if let cgImage = try? assetImgGenerate.copyCGImage(at: time, actualTime: nil) {
                        
                        let thumbImage = UIImage(cgImage: cgImage)
                        
                        DispatchQueue.main.async {
                            
                            self.galleryImageView.image = thumbImage
                        }
                    }
                }
            })
        }
    }
}



extension ChoosePostFromGalleryVC : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AppClassID.AccountManagementCell.cellID) as? AccountManagementCell else { fatalError("AccountManagementCell not found ") }
        return cell
    }
    
}

