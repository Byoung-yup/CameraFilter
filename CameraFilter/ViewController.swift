//
//  ViewController.swift
//  CameraFilter
//
//  Created by 김병엽 on 2023/01/19.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var applyFilterButton: UIButton!
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let navC = segue.destination as? UINavigationController,
              let photosCVC = navC.viewControllers.first as? PhotoCollectionViewController else {
            fatalError()
        }
        
        photosCVC.selectedPhoto.subscribe { [weak self] photo in
            
            DispatchQueue.main.async {
                self?.updateUI(with: photo)
            }
            
        }.disposed(by: disposeBag)
        
    }
    
    private func updateUI(with image: UIImage) {
        
        photoImageView.image = image
        applyFilterButton.isHidden = false
        
    }
    
    @IBAction func applyFilterButtonPressed() {
        
        guard let sourceImage = photoImageView.image else {
            return
        }
        
        FilterService().applyFilter(to: sourceImage)
            .subscribe { filteredImage in
                
                DispatchQueue.main.async {
                    self.photoImageView.image = filteredImage
                }
            }.disposed(by: disposeBag)
    }
}

