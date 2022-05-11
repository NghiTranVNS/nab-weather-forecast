//
//  BaseView.swift
//  mvl
//
//  Created by nghitran on 18/02/2022.
//

import Foundation
import UIKit
import SnapKit

class BaseView: UIView {
    
    @IBOutlet weak var contentView: UIView!;
    
    var baseNib: UINib? {
        let key = self.nameOfClass
        let nib = UINib.init(nibName: key, bundle: nil)
        return nib
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
        self.addConstraintForContent()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, useContentView: Bool) {
        self.init(frame: frame)
        if useContentView {
            self.setupView()
            self.addConstraintForContent()
        }
    }
    
    convenience init (withFrameForPopup frame: CGRect) {
        self.init(frame: frame)
    }
    
    deinit {
        print("========== " + self.nameOfClass + " deinit ==========")
    }
    
    func setupView() {
        let mainBundle = Bundle.main
        let key = self.nameOfClass
        guard mainBundle.path(forResource: key, ofType: "nib") == nil else  {
            guard self.contentView != nil else {
                if let nib = self.baseNib {
                    self.contentView = nib.instantiate(withOwner: self, options: nil).last as? UIView
                }
                
                return
            }
            
            return
        }
    }
    
    func addConstraintForContent() {
        guard self.contentView == nil else {
            self.addSubview(self.contentView!)
            self.contentView!.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(self).offset(0)
                make.left.equalTo(self).offset(0)
                make.bottom.equalTo(self).offset(0)
                make.right.equalTo(self).offset(0)
            }
            return
        }
    }
}
