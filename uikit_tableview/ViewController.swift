//
//  ViewController.swift
//  uikit_tableview
//
//  Created by Rahul Chauhan on 11/07/24.
//

import UIKit


//MARK: SECTION HEADER IS NOT POSSIBLE DIFFABLE WITHOUT CUSTOM DIFFABLE DATA SOARCE
enum CountriesSections {
    case main
}

struct Continents: Hashable {
    let id = UUID()
    let name: String
}

struct Country: Hashable {
    let id = UUID()
    let name: String
    let region: String
}

class SectionHeaderReusableView: UITableViewHeaderFooterView {
    static let reuseIdentifier = "\(SectionHeaderReusableView.self)"
    var title: UILabel = {
        let lable = UILabel()
        lable.textColor = .black
        return lable
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
        addSubview(title)
    }
}

class CountryCell: UITableViewCell {
    
    static let identifier = "\(CountryCell.self)"
    static let reuseIdentifier = "\(CountryCell.self)"
    
    var name: UILabel = {
        let lable = UILabel()
        lable.text = ""
        lable.textColor = .black
        return lable
    }()
    
    let code: UILabel = {
        let lable = UILabel()
        lable.text = ""
        lable.textColor = .black
        return lable
    }()
    
    let hStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        return stack
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    func setupView() {
        hStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(hStack)
        hStack.addArrangedSubview(name)
        hStack.setCustomSpacing(16, after: name)
        NSLayoutConstraint.activate([
            hStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            hStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            hStack.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            hStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
        
    }
}
