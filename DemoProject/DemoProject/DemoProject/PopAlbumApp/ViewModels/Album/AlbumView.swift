/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

class AlbumView: UIView {
    
    private var coverImageView: UIImageView!
    private var indicatorView: UIActivityIndicatorView!
    private var valueObservation: NSKeyValueObservation!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    init(frame: CGRect, coverUrl: String) {
        super.init(frame: frame)
        commonInit()
        
        // OBSERVER PATTERN:  one object notifies other objects of any state changes.
        // notification here is the publisher object and obeserver objects will listen to all the notification posts
        NotificationCenter.default
            .post(name: .BLDownloadImage, object: self, userInfo: ["imageView": coverImageView as Any, "coverUrl" : coverUrl])
    }
    
    private func commonInit() {
        // Setup the background
        backgroundColor = .black
        
        // Create the cover image view
        coverImageView = UIImageView()
        coverImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(coverImageView)
        
        // OBSERVER PATTERN: subcribing to NSKeyValueObservation to be  notiffied if the coverImageview value changed
        // using (\.image) key path expression that enables this mechanism.
        // In Swift 4, a key path expression has the following form:
        // \<type>.<property>.<subproperty>
        valueObservation = coverImageView.observe(\.image, options: [.new]) { [unowned self] observed, change in
            // The trailing closure specifies the closure that is executed every time an observed property changes.
            // We basically stop the spinner when the image property changes.
            // This way, when an image is loaded, the spinner will stop spinning.
            if change.newValue is UIImage {
                self.indicatorView.stopAnimating()
            }
        }
        // Create the indicator view
        indicatorView = UIActivityIndicatorView()
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.style = .whiteLarge
        indicatorView.startAnimating()
        addSubview(indicatorView)
        
        NSLayoutConstraint.activate([
            coverImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            coverImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            coverImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            coverImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            indicatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            indicatorView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            ])
    }
    
    func highlightAlbum(_ didHighlightView: Bool) {
        if didHighlightView == true {
            backgroundColor = .white
        } else {
            backgroundColor = .black
        }
    }
    
    deinit {
        // Always remember to remove your observers when they're deinited, or else your app will crash when the subject tries to send messages to these non-existent observers! In this case the valueObservation will be deinited when the album view is, so the observing will stop then.
        valueObservation = nil
        indicatorView = nil
    }
}
