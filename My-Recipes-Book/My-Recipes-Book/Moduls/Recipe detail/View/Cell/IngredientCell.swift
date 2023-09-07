//
//  IngredientCell.swift
//  My-Recipes-Book
//
//  Created by Kirill Taraturin on 28.08.2023.
//

import UIKit

final class IngredientCell: UITableViewCell{
    
    // MARK: - Public UI Properties
    lazy var ingredientImageView: UIImageView = {
        var ingredientImageView = UIImageView()
        return ingredientImageView
    }()
    
    lazy var ingredientNameLabel: UILabel = {
        var ingrLabel = UILabel()
        ingrLabel.textColor = .black
        ingrLabel.font = UIFont(name: "Poppins-Bold", size: 15)
        ingrLabel.numberOfLines = 0
        ingrLabel.adjustsFontSizeToFitWidth = true
        ingrLabel.minimumScaleFactor = 0.5
        return ingrLabel
    }()
    
    lazy var weightLabel: UILabel = {
        var weightLabel = UILabel()
        weightLabel.textAlignment = .left
        weightLabel.adjustsFontSizeToFitWidth = true
        weightLabel.minimumScaleFactor = 0.5
        weightLabel.font = UIFont.systemFont(ofSize: 15)
        weightLabel.textColor = .systemGray
        return weightLabel
    }()
    
    // MARK: - Public Properties for checkBox
    var isButtonPressed: Bool = false {
        didSet {
            checkBoxButton.tintColor = isButtonPressed ? .red : .black
        }
    }
    
    var buttonTapHandler: ((Bool) -> Void)?
    
    // MARK: - Private UI Properties
    private lazy var mainView: UIView = {
        var mainView = UIView()
        mainView.backgroundColor = #colorLiteral(red: 0.9450981021, green: 0.9450979829, blue: 0.9450979829, alpha: 1)
        mainView.layer.cornerRadius = 10
        return mainView
    }()
    
    private lazy var squareView: UIView = {
        var squareView = UIView()
        squareView.backgroundColor = .white
        squareView.layer.cornerRadius = 10
        return squareView
    }()
    
    private lazy var checkBoxButton: UIButton = {
        var checkBox = UIButton(type: .system)
        checkBox.setImage(UIImage(named: "blackCheckBox"), for: .normal)
        checkBox.tintColor = .black
        checkBox.addTarget(
            self,
            action: #selector(checkBoxDidTapped),
            for: .touchUpInside
        )
        return checkBox
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.color = .gray
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override Methods
    override func setSelected(_ selected: Bool, animated: Bool) {
        // отключаем выделение ячейки
    }
    
    // MARK: - Public Methods
    func configure(with ingredient: Ingredient?) {
        guard let ingredient = ingredient else { return }
        
        ingredientNameLabel.text = ingredient.name
        weightLabel.text = "\(ingredient.amount) \(ingredient.unit)"
        
        RecipeManager.shared.fetchIngredientImage(from: ingredient.image) { [weak self] result in
            switch result {
            case .success(let image):
                self?.ingredientImageView.image = UIImage(data: image)
                self?.activityIndicator.stopAnimating()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: - Private Actions
    @objc private func checkBoxDidTapped() {
        isButtonPressed.toggle()
        buttonTapHandler?(isButtonPressed)
    }
    
    // MARK: - Private Methods
    private func addViews() {
        contentView.addSubview(mainView)
        mainView.addSubview(squareView)
        squareView.addSubview(ingredientImageView)
        ingredientImageView.addSubview(activityIndicator)
        mainView.addSubview(ingredientNameLabel)
        mainView.addSubview(checkBoxButton)
        mainView.addSubview(weightLabel)
    }
    
    private func setupConstraints() {
        mainView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-10)
            make.right.equalToSuperview().offset(-16)
        }
        
        squareView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
        
        ingredientImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.left.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-5)
            make.bottom.equalToSuperview().offset(-5)
        }
        
        ingredientNameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(squareView)
            make.left.equalTo(squareView.snp.right).offset(10)
            make.right.equalTo(weightLabel.snp.left).offset(-10)
        }
        
        checkBoxButton.snp.makeConstraints { make in
            make.centerY.equalTo(squareView)
            make.right.equalTo(mainView.snp.right).offset(-16)
            make.width.equalTo(25)
        }
        
        weightLabel.snp.makeConstraints { make in
            make.centerY.equalTo(squareView)
            make.right.equalTo(checkBoxButton.snp.left).offset(-5)
            make.width.equalTo(80)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.centerX.equalTo(ingredientImageView.snp.centerX)
            make.centerY.equalTo(ingredientImageView.snp.centerY)
        }
    }
}
