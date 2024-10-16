//
//  DiffableViewController.swift
//  uikit_tableview
//
//  Created by Rahul Chauhan on 13/07/24.
//

import Foundation
import UIKit

class DiffableDataSource: UITableViewDiffableDataSource<Continents, Country> {
    init(tableView: UITableView) {
        super.init(tableView: tableView) { tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(withIdentifier: CountryCell.reuseIdentifier, for: indexPath) as! CountryCell
            cell.name.text = itemIdentifier.name
            cell.code.text = itemIdentifier.name
            return cell
        }
    }
    
    //    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    //        guard let user = self.itemIdentifier(for: IndexPath(item: 0, section: section)) else { return nil }
    //        return self.snapshot().sectionIdentifier(containingItem: user)?.name
    //    }
    
    //MARK: IT does not work and override in diffable datasource
    //    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    //        guard let header = tableView.dequeueReusableHeaderFooterView(
    //            withIdentifier: SectionHeaderReusableView.reuseIdentifier) as? SectionHeaderReusableView
    //        else {
    //            return nil
    //        }
    //
    ////        if section == Section.allContacts.rawValue {
    ////            header.titleLabel.text = "Your Contacts"
    ////        } else {
    ////            header.titleLabel.text = "Friends Contacts"
    ////        }
    //
    //        header.title.text = "SECTIONS HEADER"
    //
    //        return header
    //    }
}


class DiffableViewController: UIViewController {
    
    var countries = [Country]()
    var continents = [Continents]()
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .yellow
        tableView.register(CountryCell.self, forCellReuseIdentifier: CountryCell.reuseIdentifier)
        tableView.register(SectionHeaderReusableView.self, forHeaderFooterViewReuseIdentifier: SectionHeaderReusableView.reuseIdentifier)
        return tableView
    }()
    private lazy var dataSource = DiffableDataSource(tableView: tableView)
    var snapshot = NSDiffableDataSourceSnapshot<Continents, Country>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.delegate = self
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        URLSession.shared.dataTask(with: URLRequest(url: URL(string: "https://api.first.org/data/v1/countries")!)) { [weak self] data, response, error in
            guard let self = self else {return}
            do {
                let responesData = try JSONSerialization.jsonObject(with: data!,
                                                                    options: .mutableContainers) as! NSDictionary
                if let countriesData = responesData["data"] as? [String: [String: String]] {
                    countriesData.forEach { item in
                        self.countries.append(Country(name: item.value["country"] ?? "",
                                                      region: item.value["region"] ?? ""))
                    }
                }
                
                let regions = Set(countries.map({$0.region}))
                continents = regions.sorted().map({ category -> Continents in
                    return Continents(name: category)
                })
                snapshot.appendSections(continents)
                for section in continents {
                    let items = self.countries.filter { country in
                        country.region == section.name
                    }
                    let sortedItems = items.sorted { first, second in
                        first.name < second.name
                    }
                    snapshot.appendItems(sortedItems, toSection: section)
                }
                dataSource.apply(snapshot, animatingDifferences: false)
            } catch (let error) {
                print(error)
            }
            //MARK: This is used for request params serialisation at url request
            //            let serilizationData = JSONDecoder().decode(JSONSerialization.data(withJSONObject: data, options: .prettyPrinted), from: response)
            
        }.resume()
    }
}

extension DiffableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: SectionHeaderReusableView.reuseIdentifier) as? SectionHeaderReusableView
        else {
            return nil
        }
        guard let country = dataSource.itemIdentifier(for: IndexPath(item: 0, section: section)) else {return nil}
//        header.title.text = snapshot.sectionIdentifier(containingItem: country)?.
//        let sectionObject = snapshot.sectionIdentifiers[section]
//        header.title.text = sectionObject.name
        header.title.text = country.region
        return header
    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 100
//    }

}
