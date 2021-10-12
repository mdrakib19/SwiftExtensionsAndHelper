import UIKit

extension UISearchBar {
    
    var textField: UITextField? {
        return value(forKey: "searchField") as? UITextField
    }
    
    func setSearchIcon(image: UIImage) {
        setImage(image, for: .search, state: .normal)
    }
    
    func setClearIcon(image: UIImage) {
        setImage(image, for: .clear, state: .normal)
    }
    
    func customise(searchIcon: UIImage?, placeholderText: String, placeholderColor: UIColor, cornerRadious: CGFloat, backgroundColor: UIColor, placeholderFont: String = "System", placeholderFontSize: CGFloat = 17.0) {
        if let sIcon = searchIcon {
            self.setImage(sIcon, for: .search, state: .normal)
        }

        if let textField = self.textField {
            textField.backgroundColor = .clear
            textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder ?? placeholderText, attributes: [NSAttributedString.Key.foregroundColor : placeholderColor, NSAttributedString.Key.font: UIFont(name: placeholderFont, size: placeholderFontSize) ?? UIFont.systemFont(ofSize: 17.0)])
        }

        self.backgroundImage = UIImage()
        self.layer.cornerRadius = cornerRadious
        self.backgroundColor = .white
    }
}
