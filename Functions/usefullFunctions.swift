
// Rakibul Hasan

// MARK: - Table View

// Table view header dynamic height set
override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    if let headerView = cardTypeTableView.tableHeaderView {
        
        let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        var headerFrame = headerView.frame
        
        //Comparison necessary to avoid infinite loop
        if height != headerFrame.size.height {
            headerFrame.size.height = height
            headerView.frame = headerFrame
            cardTypeTableView.tableHeaderView = headerView
        }
    }
    
    if let footerView = cardTypeTableView.tableFooterView {
        
        let height = footerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        var footerFrame = footerView.frame
        
        //Comparison necessary to avoid infinite loop
        if height != footerView.size.height {
            footerView.size.height = height
            footerView.frame = footerFrame
            cardTypeTableView.tableHeaderView = footerView
        }
    }
}




// MARK: - UILabel

// attributed text set on uilabel
func setAttributedTextLbl() {
    let termsOfUseTxt = "terms_text".localized()
    let privacyPolicyTxt = "privacy_policy".localized()
    
    let fullText = "\(termsOfUseTxt) and \(privacyPolicyTxt)"
    
    let attributedString = NSMutableAttributedString(attributedString: NSAttributedString(string: fullText))
    let attributes: [NSAttributedString.Key : Any] = [
        NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
        NSAttributedString.Key.font: UIFont(name: "Montserrat-SemiBold", size: 12.0)!,
        NSAttributedString.Key.foregroundColor: UIColor(hex: 0x92479D)
    ]
    
    let range1 = (fullText as NSString).range(of: termsOfUseTxt)
    attributedString.addAttributes(attributes, range: range1)
    
    let range2 = (fullText as NSString).range(of: privacyPolicyTxt)
    attributedString.addAttributes(attributes, range: range2)
    
    termsOfUseAndPrivacyLbl.attributedText = attributedString
    termsOfUseAndPrivacyLbl.isUserInteractionEnabled = true
    termsOfUseAndPrivacyLbl.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(tapLabel(gesture:))))
}

// Tap action for attributed label
@objc func tapLabel(gesture: UITapGestureRecognizer) {
    let text = (termsOfUseAndPrivacyLbl.text)!
    let termsTxt = "terms_text".localized()
    let privcyText = "privacy_policy".localized()
    let termsRange = (text as NSString).range(of: termsTxt)
    let privacyRange = (text as NSString).range(of: privcyText)
    
    if gesture.didTapAttributedTextInLabel(label: termsOfUseAndPrivacyLbl, inRange: termsRange) {
        UIApplication.shared.open(URL(string: "https://goubba.com/terms")!)
    } else if gesture.didTapAttributedTextInLabel(label: termsOfUseAndPrivacyLbl, inRange: privacyRange) {
        UIApplication.shared.open(URL(string: "https://goubba.com/privacy")!)
    }
}
