//
//  FullPhotoViewController.swift
//  PhotoMap
//
//  Created by yurykasper on 21.06.21.
//

import Combine
import UIKit

class FullPhotoViewController: BaseViewController {
    // MARK: - Variables
    private var viewModel: FullPhotoViewModelType?
    private let cancelBag = CancelBag()
    
    // MARK: - @IBOutlet
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var markerImageView: UIImageView!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel?.viewDidDisappearSubject.send()
    }
    
    // MARK: - Helpers
    static func newInstance(viewModel: FullPhotoViewModelType) -> FullPhotoViewController {
        let fullPhotoVC = StoryboardScene.FullPhoto.fullPhotoViewController.instantiate()
        fullPhotoVC.viewModel = viewModel
        return fullPhotoVC
    }
    
    private func bind() {
        guard let viewModel = viewModel as? FullPhotoViewModel else { return }
        
        viewModel.$image
            .assign(to: \.image, on: markerImageView)
            .store(in: cancelBag)
        
        viewModel.$description
            .assign(to: \.text, on: descriptionLabel)
            .store(in: cancelBag)
        
        viewModel.$date
            .assign(to: \.text, on: dateLabel)
            .store(in: cancelBag)
        
        if let navigationBar = navigationController?.navigationBar {
            viewModel.$footerAndNavBarHidden
                .assign(to: \.isHidden, on: navigationBar)
                .store(in: cancelBag)
        }
        
        viewModel.$footerAndNavBarHidden
            .assign(to: \.isHidden, on: footerView)
            .store(in: cancelBag)
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: nil)
        doubleTapGesture.numberOfTapsRequired = 2
        markerImageView.gesture(.tap(doubleTapGesture)).sink(receiveValue: { [weak self] gestureType in
            let gesture = gestureType.get()
            self?.handleDoubleTap(gesture)
        }).store(in: cancelBag)
        
        let singleTap = UITapGestureRecognizer(target: self, action: nil)
        singleTap.require(toFail: doubleTapGesture)
        markerImageView.gesture(.tap(singleTap))
            .subscribe(viewModel.imageTappedSubject)
            .store(in: cancelBag)
    }
}

// MARK: - UIScrollViewDelegate
extension FullPhotoViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return markerImageView
    }
}

// MARK: - UIGestureRecognizerDelegate
extension FullPhotoViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

// MARK: - Double tap functionality
private extension FullPhotoViewController {
    func handleDoubleTap(_ sender: UIGestureRecognizer) {
        let targetView = sender.view
        let scale = min(scrollView.zoomScale * 2, scrollView.maximumZoomScale)
        
        if scale != scrollView.zoomScale {
            let point = sender.location(in: markerImageView)
            
            let scrollSize = scrollView.frame.size
            let size = CGSize(width: scrollSize.width / scrollView.maximumZoomScale,
                              height: scrollSize.height / scrollView.maximumZoomScale)
            let origin = CGPoint(x: point.x - size.width / 2, y: point.y - size.height / 2)
            scrollView.zoom(to: CGRect(origin: origin, size: size), animated: true)
        } else {
            let scale = scrollView.maximumZoomScale
            let center = sender.location(in: targetView)
            let rect = scrollView.zoomRect(for: scale, in: markerImageView, center: center)
            scrollView.zoom(to: rect, animated: true)
        }
    }
}
