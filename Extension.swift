//
//  Extension.swift
//  Goubba
//
//  Created by Pulkit Jalani on 19/08/20.
//  Copyright © 2020 Pulkit Jalani. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

extension UIView {
    func addDashedBorder() {
        let color = UIColor.black.cgColor
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: 165, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 2
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [9,5]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 0).cgPath
        
        self.layer.addSublayer(shapeLayer)
    }
    
    func addBorder(borderWidth: CGFloat, borderColor: UIColor) {
        self.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
    }
}


extension UITextView {
    func addDoneCancelToolbar(onDone: (target: Any, action: Selector)? = nil, onCancel: (target: Any, action: Selector)? = nil) {
        let onCancel = onCancel ?? (target: self, action: #selector(cancelButtonTapped))
        let onDone = onDone ?? (target: self, action: #selector(doneButtonTapped))
        
        let toolbar: UIToolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.items = [
            UIBarButtonItem(title: "Cancel", style: .plain, target: onCancel.target, action: onCancel.action),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: onDone.target, action: onDone.action)
        ]
        toolbar.sizeToFit()
        
        self.inputAccessoryView = toolbar
    }
    
    // Default actions:
    @objc func doneButtonTapped() { self.resignFirstResponder() }
    @objc func cancelButtonTapped() { self.resignFirstResponder() }
}


extension UITextField {
    func addDoneCancelToolbar(onDone: (target: Any, action: Selector)? = nil, onCancel: (target: Any, action: Selector)? = nil) {
        let onCancel = onCancel ?? (target: self, action: #selector(cancelButtonTapped))
        let onDone = onDone ?? (target: self, action: #selector(doneButtonTapped))
        
        let toolbar: UIToolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.items = [
            UIBarButtonItem(title: "Cancel", style: .plain, target: onCancel.target, action: onCancel.action),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: onDone.target, action: onDone.action)
        ]
        toolbar.sizeToFit()
        
        self.inputAccessoryView = toolbar
    }
    
    // Default actions:
    @objc func doneButtonTapped() { self.resignFirstResponder() }
    @objc func cancelButtonTapped() { self.resignFirstResponder() }
}


@IBDesignable class TextViewWithPlaceholder: UITextView {
    
    override var text: String! {
        get {
            if showingPlaceholder {
                return ""
            } else { return super.text }
        }
        set {
            if showingPlaceholder {
                removePlaceholderFormatting()
            }
            super.text = newValue
        }
    }
    @IBInspectable var placeholderText: String = ""
    @IBInspectable var placeholderTextColor: UIColor = .black
    private var showingPlaceholder: Bool = true
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        if text.isEmpty {
            showPlaceholderText()
        }
    }
    
    override public func becomeFirstResponder() -> Bool {
        if showingPlaceholder {
            text = nil
            removePlaceholderFormatting()
        }
        return super.becomeFirstResponder()
    }
    
    override public func resignFirstResponder() -> Bool {
        if text.isEmpty {
            showPlaceholderText()
        }
        return super.resignFirstResponder()
    }
    
    private func showPlaceholderText() {
        text = placeholderText
        showingPlaceholder = true
        textColor = placeholderTextColor
    }
    
    private func removePlaceholderFormatting() {
        showingPlaceholder = false
        textColor = nil
    }
}

extension UITextField {
    
    enum PaddingSpace {
        case left(CGFloat)
        case right(CGFloat)
        case equalSpacing(CGFloat)
    }
    
    func addPadding(padding: PaddingSpace) {
        
        self.leftViewMode = .always
        self.layer.masksToBounds = true
        
        switch padding {
            
        case .left(let spacing):
            let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
            self.leftView = leftPaddingView
            self.leftViewMode = .always
            
        case .right(let spacing):
            let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
            self.rightView = rightPaddingView
            self.rightViewMode = .always
            
        case .equalSpacing(let spacing):
            let equalPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
            // left
            self.leftView = equalPaddingView
            self.leftViewMode = .always
            // right
            self.rightView = equalPaddingView
            self.rightViewMode = .always
        }
    }
}


class TidyTextField: UITextField {
    
    @IBInspectable var leftImage: UIImage? = nil
    @IBInspectable var leftPadding: CGFloat = 0
    @IBInspectable var rightPadding: CGFloat = 0
    @IBInspectable var gapPadding: CGFloat = 0
    
    private var textPadding: UIEdgeInsets {
        let p: CGFloat = leftPadding + gapPadding + (leftView?.frame.width ?? 0)
        let q: CGFloat = rightPadding + gapPadding + (leftView?.frame.width ?? 0)
        
        return UIEdgeInsets(top: 0, left: p, bottom: 0, right: q)
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textPadding)
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var r = super.leftViewRect(forBounds: bounds)
        r.origin.x += leftPadding
        return r
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    
    private func setup() {
        if let image = leftImage {
            if leftView != nil { return } // critical!
            
            let im = UIImageView()
            im.contentMode = .scaleAspectFit
            im.image = image
            
            leftViewMode = UITextField.ViewMode.always
            leftView = im
            
        } else {
            leftViewMode = UITextField.ViewMode.never
            leftView = nil
        }
    }
}





extension UILabel {
    func underline() {
        guard let text = self.text else { return }
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
        let underlineAttributedString = NSAttributedString(string: text, attributes: underlineAttribute)
        self.attributedText = underlineAttributedString
    }
}


extension UIView {
    func setHeight(_ h:CGFloat, animateTime:TimeInterval?=nil) {

        if let c = self.constraints.first(where: { $0.firstAttribute == .height && $0.relation == .equal }) {
            c.constant = CGFloat(h)

            if let animateTime = animateTime {
                UIView.animate(withDuration: animateTime, animations:{
                    self.superview?.layoutIfNeeded()
                })
            }
            else {
                self.superview?.layoutIfNeeded()
            }
        }
    }
}


@IBDesignable class PaddingLabel: UILabel {

    @IBInspectable var topInset: CGFloat = 5.0
    @IBInspectable var bottomInset: CGFloat = 5.0
    @IBInspectable var leftInset: CGFloat = 7.0
    @IBInspectable var rightInset: CGFloat = 7.0

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }

    override var bounds: CGRect {
        didSet {
            // ensures this works within stack views if multi-line
            preferredMaxLayoutWidth = bounds.width - (leftInset + rightInset)
        }
    }
}

final class MovingTitleOnFocusTextField: SkyFloatingLabelTextField {

    override func becomeFirstResponder() -> Bool {
        setTitleVisible(true, animated: true)
        super.placeholder = ""
        super.titleFont = UIFont(name: "Montserrat-Arabic-SemiBold", size: 12.0)!
        return super.becomeFirstResponder()
    }

    override func resignFirstResponder() -> Bool {
        setTitleVisible(hasText || hasErrorMessage)
        if(!hasText){
            super.placeholder = super.title
        }
        return super.resignFirstResponder()
    }
}
