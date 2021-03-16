//
//  ViewController.swift
//  PhotoUpDater
//
//  Created by Khurram Shahzad on 09/04/2020.
//  Copyright © 2020 Khurram Shahzad. All rights reserved.
//

import UIKit
import Photos
import SnapKit
import DKImagePickerController

class ViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var photoLibraryBtn: UIButton!
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var changeDateBtn: UIButton!
    
    // MARK: - iVars
    
    var pickerController = DKImagePickerController()
    var selectedAssets: [DKAsset]?
    var datePicker : UIDatePicker = UIDatePicker()
    
    // MARK: - ViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        checkForPhotoLibraryAccess()
    }
    
    // MARK: - Helper Method
    
    private func setupUI() {
        setupPhotosCollectionView()
        setupBottomButtons()
    }
    
    private func setupPhotosCollectionView() {
        // Register collection view custom cell
        collectionView.register(UINib(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ImageCollectionViewCell")
        // Sets collection view delegate & data source
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func setupBottomButtons() {
        // Sets bottom buttons corner radius
        self.photoLibraryBtn.layer.cornerRadius = 6.0
        self.resetBtn.layer.cornerRadius = 6.0
        self.changeDateBtn.layer.cornerRadius = 6.0
    }
    
    private func checkForPhotoLibraryAccess() {
        // Check if user access status to Photo Library
        let status = PHPhotoLibrary.authorizationStatus()
        // If not allowed then shows pop-up to allow it
        if status == .notDetermined  {
            PHPhotoLibrary.requestAuthorization({status in
            })
        }
    }
    
    private func showDatePicker() {
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.date = Date()
        
        let alert = UIAlertController(title: "Change Date\n\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)
        alert.view.addSubview(datePicker)
        // date picker constraints to fit inside alert view
        datePicker.snp.makeConstraints { (make) in
            make.centerX.equalTo(alert.view)
            // set to 28 to also show Change Date title
            make.top.equalTo(alert.view).offset(28)
        }
        
        let ok = UIAlertAction(title: "Ok", style: .default) { (action) in
            // If user press ok, then function call
            // To change the slected pictures dates
            
            let sDate = self.datePicker.date.getString(format: "yyyy-MM-dd hh:mm:ss").getDateString(fromFormat: "yyyy-MM-dd hh:mm:ss" , toFormat: "yyyy-MM-dd hh:mm:ss").getDate(toFormat: "yyyy-MM-dd hh:mm:ss")
            
            self.changeSelectedImagesDate(updatedDate: sDate ?? Date())
        }
        
        // If user tap cancel nothing happens
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    private func changeSelectedImagesDate(updatedDate: Date) {
        if let assets = self.selectedAssets {
            for asset in assets {
                self.setChange(forAsset: asset.originalAsset ?? PHAsset(), updatedDate: updatedDate)
            }
            let msg = assets.count == 1 ? "Photo" : "Photos"
            self.showSuccessAlert(title: "\(msg) Date Updated", message: "\(assets.count) \(msg) updated to \n \(updatedDate.getString(format: "dd MMM yyyy"))")
        }
    }
    
    func AlbumPermissions() -> Int {
        
        switch PHPhotoLibrary.authorizationStatus() {
            
        case .notDetermined:
            //PHAuthorizationStatus.NotDetermined
            
            PHPhotoLibrary.requestAuthorization { (status:PHAuthorizationStatus) -> Void in
                print(status)
            }
            return 0
        case .restricted:
            //PHAuthorizationStatus.Restricted
            return 1
        case .denied:
            //PHAuthorizationStatus.Denied
            return 2
        case .authorized:
            //PHAuthorizationStatus.Authorized
            return 3
        case .limited:
            //PHAuthorizationStatus.Limited
            return 4
        @unknown default:
            fatalError()
        }}
    
    private func openGallary() {
        // Opens the photo gallery to select pics
        let res = AlbumPermissions()
        if res == 3 {
            // 3 means allowd to access photo gallery
            self.openPickerView()
        }
    }
    
    private func openPickerView() {
        // shows the photos gallery
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            // user selects the images and returns to the app
            // set selected assets and reloads the collectionView to show them
            self.selectedAssets = assets
            self.collectionView.reloadData()
            
            // Reads and shows the selected photos creation dates
            if !assets.isEmpty {
                let title = assets.count > 1 ? "Current Photos Dates" : "Current Photo Date"
                var message: String = ""
                for asset in assets {
                    message += "\(asset.originalAsset?.creationDate?.getString(format: "dd MMMM yyyy").description ?? "")\n"
                }
                self.showSelectedDatesAlert(title: title, message: message)
            }
        }
        
        if let assets = self.selectedAssets {
            // If user selects some photos
            // then again taps on Photo Gallery button
            // then these photos will be selected
            // to helps user that these photos are already selected
            pickerController.select(assets: assets)
        }
        
        // user can select only photos
        pickerController.assetType = .allPhotos
        pickerController.allowMultipleTypes = false
        pickerController.allowsLandscape = false
        pickerController.UIDelegate = AssetClickHandler()
        pickerController.modalPresentationStyle = .fullScreen
        
        self.present(pickerController, animated: true) {}
    }
    
    private func showSelectedDatesAlert(title: String, message: String) {
        let alert = Utility.shared.showAlert(title: title, message: message, cancelButton: false, completion: {
            
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showSuccessAlert(title: String, message: String) {
        let alert = Utility.shared.showAlert(title: title, message: message, cancelButton: false, completion: {
            self.resetAll()
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    // Resets all to default
    private func resetAll() {
        self.selectedAssets?.removeAll()
        self.pickerController = DKImagePickerController()
        self.collectionView.reloadData()
    }
    
    // MARK: - IBActions
    
    @IBAction func openGalleryBtnDidTapped(_ sender: UIButton) {
        openGallary()
    }
    
    @IBAction func changeActionDidTapped(_ sender: UIButton) {
        if let assets = self.selectedAssets {
            if assets.count > 0 {
                self.showDatePicker()
            }
        }
    }
    
    @IBAction func resetBtnDidTapped(_ sender: UIButton) {
        self.resetAll()
    }
}

// MARK: - setChange Function

extension ViewController {
    // Function to perform creation date change
    func setChange(forAsset: PHAsset, updatedDate: Date) {
        PHPhotoLibrary.shared().performChanges({
            //Asset is the photo that PHAset wants to modify
            let request = PHAssetChangeRequest(for: forAsset)
            // Set the creation date to user updated date
            request.creationDate = updatedDate
        }) { (success, error) in
            if success == true {
                print("modified successfully")
            }
        }
    }
}

// MARK: - DKImagePickerControllerBaseUIDelegate

class AssetClickHandler: DKImagePickerControllerBaseUIDelegate {
    override func imagePickerController(_ imagePickerController: DKImagePickerController, didSelectAssets: [DKAsset]) {
        //Tap to select asset
        //Use this place for asset selection customisation
        print("didClickAsset for selection")
    }
    
    override func imagePickerController(_ imagePickerController: DKImagePickerController, didDeselectAssets: [DKAsset]) {
        //Tap to deselect asset
        //Use this place for asset deselection customisation
        print("didClickAsset for deselection")
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let photosCount = self.selectedAssets?.count ?? 0
        if photosCount == 0 {
            // If photo selected then shows No selected Photo
            // as a background view for collection view
            if let collectionViewBackgroundView = Bundle.main.loadNibNamed("NoImageSelectedCell", owner: nil, options: [:])?.first as? NoImageSelectedCell {
                collectionViewBackgroundView.frame = collectionView.frame
                self.collectionView.backgroundView = collectionViewBackgroundView
            }
            
            return 0
        } else {
            collectionView.backgroundView = nil
            return self.selectedAssets?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as? ImageCollectionViewCell else { fatalError("Unexpected Table View Cell")
        }
        
        let asset = self.selectedAssets![indexPath.row]
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        asset.fetchImage(with: layout.itemSize.toPixel(), completeBlock: { image, info in
            cell.contentImageView.image = image
        })
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: ((collectionView.frame.size.width - 10) / 4), height: collectionView.frame.size.width / 4)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
