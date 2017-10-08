//
//  ArticleTableViewCell.swift
//  DiseasePrediction
//
//  Created by Partenhauser Andreas on 08.10.17.
//  Copyright © 2017 BurdaHackday. All rights reserved.
//

import UIKit

class ArticleTableViewCell: UITableViewCell, AddableNib {
    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var articleTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func update(with article: Article) {
        articleTitleLabel.text = article.title
        self.articleImage.image = nil
        if let urlString = article.imageUrl, let url = URL(string: urlString) {
            DispatchQueue.global(qos: .userInitiated).async {
                if let data = try? Data(contentsOf: url) {
                    let loadedImage = UIImage(data: data)
                    DispatchQueue.main.async {
                        self.articleImage.image = loadedImage
                    }
                }
            }
        }
    }
}
