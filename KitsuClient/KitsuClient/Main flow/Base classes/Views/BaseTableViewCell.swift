//
//  BaseTableViewCell.swift
//  KitsuClient
//
//  Created by Александр Харин on /93/23.
//

import UIKit
import Combine

class BaseTableViewCell: UITableViewCell {
    
    var subscriptions = Set<AnyCancellable>()
    
    static let identifier = "FeedCell"

    lazy var posterImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .center
        iv.layer.cornerRadius = 15
        iv.clipsToBounds = true
        iv.backgroundColor = .gray
        return iv
    }()
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.numberOfLines = 0
        label.text = "ERROR"
        return label
    }()
    lazy var likeCountLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 1
        label.text = "0000"
        label.textAlignment = .center
        return label
    }()
    lazy var likeImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "star")
        iv.contentMode = .scaleAspectFit
        iv.tintColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        return iv
    }()
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 1
        label.text = "04-02-1998"
        label.textAlignment = .left
        return label
    }()
    lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 1
        label.text = "84.91 / 100"
        label.textAlignment = .left
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let views = [posterImage, titleLabel, likeCountLabel, likeImage, ratingLabel, dateLabel]
        setupUI(views)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        posterImage.image = nil
        subscriptions.removeAll()
    }
    
    func configureCell(viewModel: BaseTableViewCellViewModelProtocol) {
        titleLabel.text = viewModel.title
        likeCountLabel.text = viewModel.likes
        dateLabel.text = viewModel.getDate(viewModel.dateString)
        ratingLabel.text = viewModel.getRating(viewModel.rating)
        
        if let url = viewModel.getPosterURL() {
            viewModel.pictureLoader.loadPicture(url)
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print("Could not load poster image,error in future publisher: \(error)")
                    }
                } receiveValue: {[unowned self] data in
                    self.posterImage.image = UIImage(data: data)
                }.store(in: &subscriptions)

        }
        
        
    }
    
    //MARK: - setupUI
    private func setupUI(_ views: [UIView]) {
        self.backgroundColor = .clear
        selectionStyle = .none
        
        views.forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            posterImage.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 6),
            posterImage.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 12),
            posterImage.widthAnchor.constraint(equalToConstant: 110),
            posterImage.heightAnchor.constraint(equalToConstant: 156),
            
            titleLabel.topAnchor.constraint(equalTo: posterImage.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: posterImage.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -12),
            
            likeCountLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -6),
            likeCountLabel.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -6),
            likeCountLabel.widthAnchor.constraint(equalToConstant: 44),
            
            likeImage.widthAnchor.constraint(equalToConstant: 32),
            likeImage.heightAnchor.constraint(equalToConstant: 32),
            likeImage.bottomAnchor.constraint(equalTo: likeCountLabel.topAnchor),
            likeImage.centerXAnchor.constraint(equalTo: likeCountLabel.centerXAnchor),
            
            ratingLabel.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -6),
            ratingLabel.leadingAnchor.constraint(equalTo: posterImage.trailingAnchor, constant: 12),
            ratingLabel.trailingAnchor.constraint(equalTo: likeCountLabel.leadingAnchor, constant: -6),
            
            dateLabel.bottomAnchor.constraint(equalTo: ratingLabel.topAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: ratingLabel.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: ratingLabel.trailingAnchor),
            
        ])
    }

}
