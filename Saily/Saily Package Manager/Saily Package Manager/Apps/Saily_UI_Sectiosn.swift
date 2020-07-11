//
//  Saily_UI_Sectiosn.swift
//  Saily Package Manager
//
//  Updated by Brecken Lusk on 6/6/19.
//  Copyright © 2019 Saily Team. All rights reserved.
//

import UIKit

class Saily_UI_Sectiosn: UITableViewController {

    var is_root_sections = false
    var data_source = [repo_section_C]()
    var nav_title = "All Packages".localized()
    
    func push_data_source(d: [repo_section_C]) {
        self.data_source = d
        self.tableView.reloadData()
    }
    
    func set_root_section() {
        self.is_root_sections = true
    }
    
    func set_title(title: String) {
        self.nav_title = title
        self.title = nav_title
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = nav_title
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let new = Saily_UI_Packages()
        if (is_root_sections) {
            if (indexPath.section == 0) {
                let neww = Saily_UI_Search()
                self.navigationController?.pushViewController(neww)
                return
            }else{
                new.push_data(d: Saily.repos_root.repos[indexPath.section - 1].section_root[indexPath.row].packages)
            }
        }else{
            if (indexPath.row == 0) {
                var p = [packages_C]()
                for item in data_source {
                    for pp in item.packages {
                        p.append(pp)
                    }
                }
                new.push_data(d: p)
            }else{
                new.push_data(d: self.data_source[indexPath.row - 1].packages)
            }
        }
        new.tableView.separatorColor = .lightGray
        new.title = "Packages".localized()
        self.navigationController?.pushViewController(new)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        if (self.is_root_sections) {
            return Saily.repos_root.repos.count + 1
        }
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (is_root_sections) {
            if (section == 0) {
                return 1
            }
            return Saily.repos_root.repos[section - 1].section_root.count
        }
        return self.data_source.count + 1
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (is_root_sections) {
            if (section == 0) {
                return "All Categories".localized()
            }
            return Saily.repos_root.repos[section - 1].name
        }else{
            return nil
        }
    }
    
    var cells_identify_index = 0
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell_id = UUID().uuidString + cells_identify_index.description;
        cells_identify_index += 1
        let cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: cell_id)
        
        if (self.is_root_sections) {
            if (indexPath.section == 0) {
                var p_count = 0
                for repo in Saily.repos_root.repos {
                    for sections in repo.section_root {
                        p_count += sections.packages.count
                    }
                }
                cell.textLabel?.text = "         " + "All Packages".localized()
                cell.detailTextLabel?.text = "            " + "This section contains ".localized() + p_count.description + " packages.".localized()
                cell.detailTextLabel?.textColor = .lightGray
                let imageView = UIImageView()
                imageView.image = #imageLiteral(resourceName: "PackageCar.png")
                cell.addSubview(imageView)
                imageView.snp.makeConstraints { (c) in
                    c.top.equalTo(cell.contentView.snp.top).offset(14)
                    c.right.equalTo(cell.textLabel!.snp.left).offset(26)
                    c.width.equalTo(28)
                    c.height.equalTo(28)
                }
                let next = UIImageView()
                next.image = #imageLiteral(resourceName: "next.png")
                cell.addSubview(next)
                next.snp.makeConstraints { (c) in
                    c.top.equalTo(cell.contentView.snp.top).offset(23)
                    c.right.equalTo(cell.snp.right).offset(-16)
                    c.width.equalTo(14)
                    c.height.equalTo(14)
                }
                return cell
            }
            
            cell.textLabel?.text = "         " + Saily.repos_root.repos[indexPath.section - 1].section_root[indexPath.row].name
            cell.detailTextLabel?.text = "            " + "This section contains ".localized() + Saily.repos_root.repos[indexPath.section - 1].section_root[indexPath.row].packages.count.description + " packages.".localized()
            cell.detailTextLabel?.textColor = .lightGray
        }else{
            if (indexPath.row == 0) {
                var p_count = 0
                for section in self.data_source {
                    p_count += section.packages.count
                }
                cell.textLabel?.text = "         " + "All Packages".localized()
                cell.detailTextLabel?.text = "            " + "This repo contains ".localized() + p_count.description + " packages.".localized()
                cell.detailTextLabel?.textColor = .lightGray
                let imageView = UIImageView()
                imageView.image = #imageLiteral(resourceName: "PackageCar.png")
                cell.addSubview(imageView)
                imageView.snp.makeConstraints { (c) in
                    c.top.equalTo(cell.contentView.snp.top).offset(14)
                    c.right.equalTo(cell.textLabel!.snp.left).offset(26)
                    c.width.equalTo(28)
                    c.height.equalTo(28)
                }
                let next = UIImageView()
                next.image = #imageLiteral(resourceName: "next.png")
                cell.addSubview(next)
                next.snp.makeConstraints { (c) in
                    c.top.equalTo(cell.contentView.snp.top).offset(23)
                    c.right.equalTo(cell.snp.right).offset(-16)
                    c.width.equalTo(14)
                    c.height.equalTo(14)
                }
                return cell
            }
            cell.textLabel?.text = "         " + self.data_source[indexPath.row - 1].name
            cell.detailTextLabel?.text = "            " + "This section contains ".localized() + self.data_source[indexPath.row - 1].packages.count.description + " packages.".localized()
            cell.detailTextLabel?.textColor = .lightGray
        }
        
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "Folder.png")
        cell.addSubview(imageView)
        imageView.snp.makeConstraints { (c) in
            c.top.equalTo(cell.contentView.snp.top).offset(14)
            c.right.equalTo(cell.textLabel!.snp.left).offset(26)
            c.width.equalTo(28)
            c.height.equalTo(28)
        }
        let next = UIImageView()
        next.image = #imageLiteral(resourceName: "next.png")
        cell.addSubview(next)
        next.snp.makeConstraints { (c) in
            c.top.equalTo(cell.contentView.snp.top).offset(23)
            c.right.equalTo(cell.snp.right).offset(-16)
            c.width.equalTo(14)
            c.height.equalTo(14)
        }
        
        return cell
    }


}
