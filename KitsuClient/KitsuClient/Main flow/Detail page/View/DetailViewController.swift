//
//  DetailViewController.swift
//  KitsuClient
//
//  Created by Александр Харин on /103/23.
//

import UIKit
import Combine

class DetailViewController: UIViewController {
    
    var viewModel: DetailViewModelProtocol
    var dataTask: URLSessionDataTask?
    
    var subscriptions = Set<AnyCancellable>()
    
    let scroll = UIScrollView()
    let contentView = UIView()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        label.numberOfLines = 0
        label.text = "TITLE title TITLE title TITLE"
        return label
    }()
    lazy var posterImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .center
        iv.layer.cornerRadius = 15
        iv.clipsToBounds = true
        iv.backgroundColor = .gray
        return iv
    }()
    
    //MARK: - labels grid
    private lazy var averageRatingLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Average rating: "
        l.numberOfLines = 1
        l.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        
        l.textColor = .label
        return l
    }()
    private lazy var averageRatingLabelValue: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Average rating: "
        l.numberOfLines = 1
        l.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        
        l.textColor = .label
        return l
    }()
    private lazy var ageRatingLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Age rating guide: "
        l.numberOfLines = 1
        l.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        
        l.textColor = .label
        return l
    }()
    private lazy var ageRatingLabelValue: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Age rating guide: "
        l.numberOfLines = 1
        l.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        
        l.textColor = .label
        return l
    }()
    private lazy var statusLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Status: "
        l.numberOfLines = 1
        l.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        
        l.textColor = .label
        return l
    }()
    private lazy var statusLabelValue: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Status: "
        l.numberOfLines = 1
        l.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        
        l.textColor = .label
        return l
    }()
    private lazy var startDateLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Start airing at: "
        l.numberOfLines = 1
        l.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        
        l.textColor = .label
        return l
    }()
    private lazy var startDateLabelValue: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Start airing at: "
        l.numberOfLines = 1
        l.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        
        l.textColor = .label
        return l
    }()
    private lazy var endDateLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Finish airing at: "
        l.numberOfLines = 1
        l.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        
        l.textColor = .label
        return l
    }()
    private lazy var endDateLabelValue: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Finish airing at: "
        l.numberOfLines = 1
        l.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        
        l.textColor = .label
        return l
    }()
    private lazy var partsLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Episodes: "
        l.numberOfLines = 1
        l.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        
        l.textColor = .label
        return l
    }()
    private lazy var partsLabelValue: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Episodes: "
        l.numberOfLines = 1
        l.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        
        l.textColor = .label
        return l
    }()
    private lazy var partsLenghtLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Episode lenght: "
        l.numberOfLines = 1
        l.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        
        l.textColor = .label
        return l
    }()
    private lazy var partsLenghtLabelValue: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Episode lenght: "
        l.numberOfLines = 1
        l.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        
        l.textColor = .label
        return l
    }()
    private lazy var synopsysLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Synopsis: "
        l.numberOfLines = 0
        l.font = UIFont.systemFont(ofSize: 16, weight: .light)
        
        l.textColor = .label
        return l
    }()
    
    //MARK: - Stacks
    private lazy var labelsVStrack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.addArrangedSubview(averageRatingLabel)
        stack.addArrangedSubview(ageRatingLabel)
        stack.addArrangedSubview(statusLabel)
        stack.addArrangedSubview(startDateLabel)
        stack.addArrangedSubview(endDateLabel)
        stack.addArrangedSubview(partsLabel)
        stack.addArrangedSubview(partsLenghtLabel)
        return stack
    }()
    private lazy var labelsValueVStrack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.contentMode = .scaleAspectFit
        stack.addArrangedSubview(averageRatingLabelValue)
        stack.addArrangedSubview(ageRatingLabelValue)
        stack.addArrangedSubview(statusLabelValue)
        stack.addArrangedSubview(startDateLabelValue)
        stack.addArrangedSubview(endDateLabelValue)
        stack.addArrangedSubview(partsLabelValue)
        stack.addArrangedSubview(partsLenghtLabelValue)
        return stack
    }()
    private lazy var labelsGridStrack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.addArrangedSubview(labelsVStrack)
        stack.addArrangedSubview(labelsValueVStrack)
        return stack
    }()
    
    //MARK: - life cycle
    init(
        viewModel: DetailViewModelProtocol
    ) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        setupUI()
        configureViews()
    }
    
    deinit {
        dataTask?.cancel()
    }
    
    //MARK: - view bind & configure
    private func bindViewModel() {
        viewModel.pictureData
            .receive(on: DispatchQueue.main)
            .sink {[unowned self] data in
                self.posterImage.image = UIImage(data: data)
            }.store(in: &subscriptions)
    }
    
    private func configureViews() {
        titleLabel.text = viewModel.titleLabel
        averageRatingLabelValue.text = viewModel.getRating(viewModel.averageRatingLabel)
        startDateLabelValue.text = viewModel.startDateLabel
        endDateLabelValue.text = viewModel.endDateLabel
        statusLabelValue.text = viewModel.statusLabel
        ageRatingLabelValue.text = viewModel.ageRatingGuideLabel
        synopsysLabel.text = viewModel.synopsisLabel
        
        partsLabel.text = viewModel.parts
        partsLabelValue.text = viewModel.partsLabel
        partsLenghtLabel.text = viewModel.partsLenght
        partsLenghtLabelValue.text = viewModel.partsLenghtLabel
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(scroll)
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        [titleLabel, posterImage, labelsGridStrack, synopsysLabel].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            scroll.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scroll.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scroll.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            scroll.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            
            contentView.topAnchor.constraint(equalTo: scroll.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scroll.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scroll.widthAnchor),
            contentView.centerXAnchor.constraint(equalTo: scroll.centerXAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
            posterImage.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            posterImage.widthAnchor.constraint(equalToConstant: 284),
            posterImage.heightAnchor.constraint(equalToConstant: 402),
            posterImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            labelsGridStrack.topAnchor.constraint(equalTo: posterImage.bottomAnchor, constant: 6),
            labelsGridStrack.widthAnchor.constraint(lessThanOrEqualTo: scroll.widthAnchor, multiplier: 0.9),
            labelsGridStrack.centerXAnchor.constraint(equalTo: posterImage.centerXAnchor),
            
            synopsysLabel.topAnchor.constraint(equalTo: labelsGridStrack.bottomAnchor, constant: 6),
            synopsysLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12),
            synopsysLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12),
            synopsysLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    
}
