//
//  Filter_ImageVC.swift
//  Surface
//
//  Created by Nandini Yadav on 19/03/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import Foundation
import UIKit
import Photos
import PhotosUI

class Filter_ImageVC: BaseSurfaceVC , UICollectionViewDataSource,
    UICollectionViewDelegate,
    UICollectionViewDelegateFlowLayout
{
    
    var thumbImage = UIImage()

    var thumbnailImage: CIImage!
    var thumbnailImages: [UIImage?] = []
    var previewImage: UIImage!
    var previewedPhotoIndexPath: IndexPath!
    var ciContext = CIContext(options: nil)
    
    var filters: [(name: String, applier: FilterApplierType?,image:UIImage?)] = [
        (name: "Normal",
         applier: nil,image:nil),
        (name: "Nashville",
         applier: ImageHelper.applyNashvilleFilter,image:nil),
        (name: "Toaster",
         applier: ImageHelper.applyToasterFilter,image:nil),
        (name: "1977",
         applier: ImageHelper.apply1977Filter,image:nil),
        (name: "Clarendon",
         applier: ImageHelper.applyClarendonFilter,image:nil),
      //  (name: "HazeRemoval",
       //  applier: ImageHelper.applyHazeRemovalFilter,image:nil),
        (name: "Chrome",
         applier: ImageHelper.createDefaultFilterApplier(name: "CIPhotoEffectChrome"),image:nil),
        (name: "Fade",
         applier: ImageHelper.createDefaultFilterApplier(name: "CIPhotoEffectFade"),image:nil),
        (name: "Instant",
         applier: ImageHelper.createDefaultFilterApplier(name: "CIPhotoEffectInstant"),image:nil),
        (name: "Mono",
         applier: ImageHelper.createDefaultFilterApplier(name: "CIPhotoEffectMono"),image:nil),
        (name: "Noir",
         applier: ImageHelper.createDefaultFilterApplier(name: "CIPhotoEffectNoir"),image:nil),
        (name: "Process",
         applier: ImageHelper.createDefaultFilterApplier(name: "CIPhotoEffectProcess"),image:nil),
        (name: "Tonal",
         applier: ImageHelper.createDefaultFilterApplier(name: "CIPhotoEffectTonal"),image:nil),
        (name: "Transfer",
         applier: ImageHelper.createDefaultFilterApplier(name: "CIPhotoEffectTransfer"),image:nil),
        (name: "Tone",
         applier: ImageHelper.createDefaultFilterApplier(name: "CILinearToSRGBToneCurve"),image:nil),
        (name: "Linear",
         applier: ImageHelper.createDefaultFilterApplier(name: "CISRGBToneCurveToLinear"),image:nil),
        ]
    
    //MARK:- @IBOutlets
    @IBOutlet weak var preview: UIImageView!
    @IBOutlet var filterCollection: UICollectionView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var collectionSubView: UIView!
    @IBOutlet weak var selectFilterLabel: UILabel!

    
    var targetSize: CGSize {
        let scale = UIScreen.main.scale
        return CGSize(width: preview.bounds.width * scale,
                      height: preview.bounds.height * scale)
    }
    
    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.preview.image = self.previewImage
        self.thumbImage = self.thumbFromImage(self.previewImage)
    }
    
    deinit {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func thumbFromImage(_ img: UIImage) -> UIImage {
//        let width: CGFloat = img.size.width/
//        let height: CGFloat = 150
//        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
//        img.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
//        let smallImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return smallImage!
        let newHeight:CGFloat = 150
        let scale = newHeight / img.size.height
        let newWidth = img.size.width * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        img.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage ?? img
    }
    
    //MARK:- @IBActions
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.showAlert(alert: ConstantString.k_Discard_image_title.localized, msg: ConstantString.k_Discard_image_desc.localized, done: ConstantString.k_discard.localized, cancel: ConstantString.k_Keep.localized, success: { (success) in
            if success {
                Global.getMainQueue {
                    self.popToDismissController()
                }
            }
        })
    }
    
    private func popToDismissController() {
        self.navigationController?.popViewController(animated: true)

    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        let addPostScene = AddPostVC.instantiate(fromAppStoryboard: .Home)
        addPostScene.postImage = self.preview.image
        addPostScene.mediaType = "1"
        self.navigationController?.pushViewController(addPostScene, animated: true)
    }
    
    // MARK:- UICollectionView
    // return cell size UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numRow: Int = 4
        let cellWidth:CGFloat = self.view.bounds.width / CGFloat(numRow) - CGFloat(numRow)
        let cellHeight: CGFloat = CGFloat(140.0)
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    // return num items
    func collectionView(
        _ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.filters.count
    }
    
    // return number of sections
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // return cell
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell: FilterCell = collectionView.dequeueReusableCell(withReuseIdentifier: AppClassID.FilterCell.cellID, for: indexPath) as? FilterCell
            else {
                fatalError("unexpected cell in collection view")
        }
        
        cell.title.text = self.filters[indexPath.item].name
        cell.black_IndicatorView.isHidden = self.previewedPhotoIndexPath != indexPath
        if indexPath.row == 0{
            self.filters[indexPath.row].image = self.thumbImage
            cell.thumbnailImage = self.thumbImage
        }else{
            if let img = self.filters[indexPath.item].image{
                cell.thumbnailImage = img
                cell.loader.isHidden = true
               cell.loader.stopAnimating()
            }else{
                cell.loader.startAnimating()
                cell.loader.isHidden = false
                let filteredImage = self.applyFilter(
                    at: indexPath.item, image: self.thumbImage)
                cell.thumbnailImage = filteredImage
                self.filters[indexPath.item].image = filteredImage
            }
        }
        return cell
    }
    
    // cell is selected
    func collectionView(_ collectionView: UICollectionView,didSelectItemAt indexPath: IndexPath) {
        self.previewedPhotoIndexPath = indexPath
        self.filterCollection.reloadData()
        if indexPath.item != 0 {
            if self.thumbnailImages.count-1 == indexPath.row , let img = self.thumbnailImages[indexPath.row]{
                self.preview.image = img
            } else {
                self.preview.image = self.applyFilter(
                    at: indexPath.item, image: self.previewImage)
            }
        } else {
            self.preview.image = self.previewImage
        }
    }
    
    // MARK: Filter
    func applyFilter(applier: FilterApplierType?, ciImage: CIImage) -> UIImage {
        let outputImage: CIImage? = applier!(ciImage)
        let outputCGImage = self.ciContext.createCGImage(
            (outputImage)!,
            from: (outputImage?.extent)!)
        return UIImage(cgImage: outputCGImage!)
    }
    
    func applyFilter(
        applier: FilterApplierType?, image: UIImage) -> UIImage {
        let ciImage: CIImage? = CIImage(image: image)
        return applyFilter(applier: applier, ciImage: ciImage!)
    }
    
    func applyFilter(at: Int, image: UIImage) -> UIImage {
        let applier: FilterApplierType? = self.filters[at].applier
        return applyFilter(applier: applier, image: image)
    }
}

