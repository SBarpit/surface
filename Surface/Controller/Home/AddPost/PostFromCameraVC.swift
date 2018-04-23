

import UIKit
import Photos
import AVFoundation
import SCRecorder

protocol createPostFromCameraDelegate :class{
    func createPostFromCamera(post :Any)
    func updateNextButton()
}

class PostFromCameraVC: UIViewController {

    //MARK:- variables
    //=====================
    //var camera : LLSimpleCamera?
    weak var imageCropper : GoToImageCropper?
    private var videoTimer : Timer?
    
    var seconds = 0.5
   
    var postType = PostType.None
    weak var postDelegate : createPostFromCameraDelegate?
    
    let videoMaxDuration : Float64 = 60.0
    var recorder:SCRecorder?
    var recordSession: SCRecordSession? {
        get{
            let session = SCRecordSession()
            session.fileType = AVFileType.mov.rawValue
            return session
        }
    }
    
    //var cameraOption = PostType.None
    //var captureOnlyVideo = PostType.None
    
    //MARK:- iboutlets
    //====================
    @IBOutlet weak var frontorRearButton: UIButton!
    @IBOutlet weak var flashbutton: UIButton!
    @IBOutlet weak var captureButton: UIButton!
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var redDotImageView: UIImageView!
    @IBOutlet weak var cameraSubView: UIView!
    @IBOutlet weak var captureSubView: UIView!
    @IBOutlet weak var capturePhotoButton: UIButton!
    
    //MARK:- view life cycle
    //====================
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpSubView()
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.flashbutton.isSelected = false
        self.postType == .Photo ? self.isFlashAvailable() : self.isTorchAvailable()
        self.loadCamera()
        self.flashButtonSetup()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.flashbutton.isSelected = false
        self.postType == .Photo ? self.isFlashAvailable() : self.isTorchAvailable()
        if let rec = self.recorder{
            rec.stopRunning()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if let timer = videoTimer{
            timer.invalidate()
            self.seconds = 0
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        Global.removeChahe()
        Global.clearTempDirectory()
        deInitialize_Recorder()
    }
    

    
    deinit {
        deInitialize_Recorder()
    }
    
    // MARK: Orientation
    override var shouldAutorotate : Bool {
        return false
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.portrait, UIInterfaceOrientationMask.landscapeLeft, UIInterfaceOrientationMask.landscapeRight, UIInterfaceOrientationMask.portraitUpsideDown]
    }
    
    override var preferredInterfaceOrientationForPresentation : UIInterfaceOrientation {
        return .portrait
    }
    
    //MARK:- Front or rear button tapped
    //=====================================
    @IBAction func rontOrRearButtonTapped(_ sender: UIButton) {
        self.recorder?.switchCaptureDevices()
        self.frontorRearButton.isSelected = !self.frontorRearButton.isSelected
        self.flashButtonSetup()
        if self.recorder?.device == AVCaptureDevice.Position.front{
            self.flashbutton.isSelected = false
            self.recorder?.flashMode = .off
        }
    }
    
   //MARK:- capture button tapped
    //==============================
    @IBAction func capturePhotoButtonTapped(_ sender: UIButton) {
        self.recorder?.capturePhoto({ (error, image) in
            Global.getMainQueue {
                self.postDelegate?.createPostFromCamera(post: image as Any)
            }
        })
    }

    @IBAction func flashButtonTapped(_ sender: UIButton) {
        self.flashbutton.isSelected = !self.flashbutton.isSelected
        self.postType == .Photo ? self.isFlashAvailable() : self.isTorchAvailable()
    }
}


//MARK:- private functions
//============================
 extension PostFromCameraVC{

    //MARK:- set up your view
    //========================
    func setUpSubView(){
        URLCache.shared.removeAllCachedResponses()
        self.redDotImageView.cornerRadius(radius: redDotImageView.h/2)
        timeView.backgroundColor = .clear
        timeView.isHidden = postType == .Photo
        timeLabel.text = "00:00"
        
        //add recording gesture to camera view
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress_OnCaptureButton(_:)))
        gesture.minimumPressDuration = 0.4
        gesture.delegate = self
        self.captureButton.addGestureRecognizer(gesture)
        Global.delayWithSeconds(0.1){
            //initialize the camera
            self.loadCamera()
            self.flashButtonSetup()
        }
    }
    
    @objc private func updateTimer(){
        if seconds > 0{
            seconds -= 0.5
        }else{
            seconds = 0.5
            animate_redDotView()
        }
    }

    func animate_redDotView(){
        UIView.animate(withDuration: 0.01) {
            self.redDotImageView.isHidden = !self.redDotImageView.isHidden
        }
    }
    
    //MARK:- load Camera
    func loadCamera() {
        if self.recorder == nil{
            self.recorder = SCRecorder.shared()
        
            func prepareSession(){
                //prepare the recorder session
                if self.recorder?.session != nil{
                    self.recorder?.unprepare()
                    self.recorder?.session = nil
                }
                self.recorder?.session = self.recordSession
                self.recorder?.startRunning()
                self.recorder?.maxRecordDuration = CMTimeMakeWithSeconds(self.videoMaxDuration, 1)
                self.recorder?.captureSessionPreset = postType == .Video ?  AVCaptureSession.Preset.high.rawValue : AVCaptureSession.Preset.photo.rawValue
            }
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
                //camera is allowed to access for this app
                self.recorder?.device = AVCaptureDevice.Position.back
                self.recorder?.delegate = self
                let videoConfiguration = self.recorder?.videoConfiguration
                videoConfiguration?.enabled = true
                //videoConfiguration?.size = self.view.frame.size
                videoConfiguration?.shouldKeepOnlyKeyFrames = false
                 self.cameraSubView.frame.origin.x = 0.0
                  self.cameraSubView.frame.origin.y = 0.0
                
                self.cameraSubView.frame.size.width = Global.screenWidth
                self.cameraSubView.frame.size.height = Global.screenHeight
                self.recorder?.previewView = self.cameraSubView
                self.recorder?.initializeSessionLazily = false;
                do {
                    try self.recorder?.prepare()
                    prepareSession()
                }catch let error{
                    Global.print_Debug(error.localizedDescription)
                }
            }else{
                //camera is not available
                Global.getMainQueue {
                    self.alert_With_Ok_Action(alertTitle: "", msg: "Camera not available", done: ConstantString.k_OK.localized, success: { (success) in
                        
                    })
                }
            }
        }else{
            
            self.recorder?.startRunning()

        }
    }

    @objc fileprivate func handleLongPress_OnCaptureButton(_ touchDetecttor: UIGestureRecognizer)
    {
        if self.postType == .Video{
            if touchDetecttor.state == UIGestureRecognizerState.began{
                if self.getRecordedDuration() >= self.videoMaxDuration{
                    Global.getMainQueue {
                        Global.showToast(msg: ConstantString.k_video_maxLenght_error.localized)
                        self.stopRecording()
                    }
                }else{
                    self.startRecording()
                    self.recorder?.record()
                }
            }else if touchDetecttor.state == UIGestureRecognizerState.ended{
                self.recorder?.pause()
                self.flashButtonSetup()
                self.frontorRearButton.isHidden = false
                self.stopRecording()
            }
        }
    }
    
    func stopRecording(){
        Global.delayWithSeconds(0.0, completion: {
            self.seconds = 0
            self.videoTimer?.invalidate()
            UIView.animate(withDuration: 0.2, animations: {
                //self.timeLabel.text = "00:00"
            }) { (success) in
                self.flashbutton.isHidden = false
                self.frontorRearButton.isHidden = false
            }
        })
    }
    
     func startRecording(){
        Global.delayWithSeconds(0.0, completion: {
            self.seconds = 1
            if self.videoTimer == nil{
                self.videoTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self,   selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
            }
            self.videoTimer?.fire()
            self.flashbutton.isHidden = true
            self.frontorRearButton.isHidden = true
        })
    }
    
    //MARK:- Enable or disable flash button according to camera
     func flashButtonSetup(){
        guard let recorder = self.recorder, recorder.deviceHasFlash else{
            self.flashbutton.isHidden = true
            return
        }
        self.flashbutton.isHidden = recorder.device == AVCaptureDevice.Position.back ? false : true
    }
    
    //MARK:- check if flash is available
     func isFlashAvailable(){
        let mode = self.flashbutton.isSelected == true ? AVCaptureDevice.FlashMode.on : AVCaptureDevice.FlashMode.off
      
        if let device = AVCaptureDevice.default(for: AVMediaType.video), device.hasFlash {
            let isFlashSupported = device.isFlashAvailable
            if isFlashSupported {
                do {
                    try device.lockForConfiguration()
                    device.flashMode = mode //TODO: need to update
                    device.unlockForConfiguration()
                }catch {
                    Global.print_Debug(ConstantString.k_error_In_Torch_mode.localized)
                }
            }else if mode == AVCaptureDevice.FlashMode.on{
                Global.showToast(msg: ConstantString.k_tourch_not_Avail.localized)
            }
        }
    }
    
    func isTorchAvailable() {
        let mode = self.flashbutton.isSelected == true ? AVCaptureDevice.TorchMode.on : AVCaptureDevice.TorchMode.off
        if let device = AVCaptureDevice.default(for: AVMediaType.video), device.hasFlash {
            do {
                if (device.hasTorch) {
                    try device.lockForConfiguration()
                    device.torchMode = mode
                    device.unlockForConfiguration()
                }
            }catch{
                //DISABEL FLASH BUTTON HERE IF ERROR
                print("Device tourch Flash Error ");
            }
        }
    }

    //MARK:- get Recorded Duration
    func getRecordedDuration() -> Float64 {
        guard let session = self.recorder?.session else {
            return 0.0
        }
        let currentTime = session.duration
        return CMTimeGetSeconds(currentTime)
    }
    
     func startRecordingTimer(){
        self.postDelegate?.updateNextButton()
        let duration = self.getRecordedDuration()
        if duration < self.videoMaxDuration{
            let seconds = String(format: "%.0f", duration).toInt() ?? 0
            let sec = seconds % 60 < 10 ? "0\(seconds % 60)" : "\(seconds % 60)"
            self.timeLabel.text = "0\(seconds/60):\(sec)"
       
        }else{
            self.recorder?.pause()
            Global.showToast(msg: ConstantString.k_video_maxLenght_error.localized)
            self.stopRecording()
        }
    }
    
    //MARK:-  deInitialize_Recorder
    func deInitialize_Recorder(){
        self.timeLabel.text = "00:00"
        self.recorder?.stopRunning()
        self.recorder?.unprepare()
        self.recorder?.session?.cancel(nil)
        self.recorder?.session?.deinitialize()
    }
}

//MARK:-  UIGestureRecognizerDelegate
extension PostFromCameraVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}

//MARK:- SCRecorder Delegate Methods
extension PostFromCameraVC: SCRecorderDelegate {
    func recorder(_ recorder: SCRecorder, didAppendVideoSampleBufferIn session: SCRecordSession)
    {
        startRecordingTimer()
    }
    
    // Called when the recorder has completed a segment in a session
    func recorder(_ recorder: SCRecorder, didComplete segment: SCRecordSessionSegment?, in session: SCRecordSession, error: Error?) {
    }
    
    //Called when a session has reached the maxRecordDuration
    func recorder(_ recorder: SCRecorder, didComplete session: SCRecordSession) {
        self.stopRecording()
        self.recorder?.pause()
    }
}
