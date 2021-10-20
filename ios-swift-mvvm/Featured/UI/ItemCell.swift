//
//  ItemCell.swift
//  ios-swift-mvvm
//
//  Created by Andrés Villagomez Ríos on 20/10/21.
//

import UIKit

class ItemCell: UICollectionViewCell {
    /// Cell Reuse Identifier
    static let identifier = "ItemCell"
    
    /// Cell Model
    struct Model {
        let name: String
        let price: Float
        let discount: Int
        let image: String
        
        var url: URL? {
            return URL(string: image.replacingOccurrences(of: "http:", with: "https:"))
        }
    }
    
    /// Properties
    private lazy var itemNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: DesignConstants.itemNameFontSize, weight: .bold)
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var itemPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: DesignConstants.itemPriceFontSize, weight: .bold)
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .red
        return imageView
    }()
    
    var onReuse: () -> Void = {}
    
    /// Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildCell()
        addLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        imageView.image = nil
        onReuse()
    }
    
    /// Cell configuration
    private func buildCell() {
        contentView.addSubview(imageView)
        contentView.addSubview(itemNameLabel)
        contentView.addSubview(itemPriceLabel)
    }
    
    private func addLayout() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 1)
        ])
        NSLayoutConstraint.activate([
            itemNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: DesignConstants.labelMargin),
            itemNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DesignConstants.labelMargin),
            itemNameLabel.trailingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: DesignConstants.labelMargin * -1)
        ])
        NSLayoutConstraint.activate([
            itemPriceLabel.topAnchor.constraint(equalTo: itemNameLabel.bottomAnchor, constant: DesignConstants.labelMargin),
            itemPriceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DesignConstants.labelMargin),
            itemPriceLabel.trailingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: DesignConstants.labelMargin * -1)
        ])
    }
    
    func configureWith(_ model: Model) {
        itemNameLabel.text = model.name
        itemPriceLabel.text = model.price.asCurrency(locale: Locale(identifier: "es_MX"))
        let token = ImageLoader.shared.loadImage(model.url!) { result in
            do {
                let image = try result.get()
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            } catch {
                print(error)
            }
        }
        onReuse = {
            if let token = token {
                ImageLoader.shared.cancelLoad(token)
            }
        }
    }
    
}

private extension ItemCell {
    enum DesignConstants {
        static let itemNameFontSize: CGFloat = 18.0
        static let itemPriceFontSize: CGFloat = 16.0
        static let labelMargin: CGFloat = 8.0
    }
}
