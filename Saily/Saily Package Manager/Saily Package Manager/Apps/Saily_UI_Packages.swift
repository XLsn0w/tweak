//
//  Saily_UI_Packages.swift
//  Saily Package Manager
//
//  Updated by Brecken Lusk on 6/6/19.
//  Copyright © 2019 Saily Team. All rights reserved.
//

import UIKit


class Saily_UI_Packages: UITableViewController, UISearchControllerDelegate, UISearchBarDelegate {

    private var data_source = [packages_C]()
    private var data_source_FUCK = [packages_C]()
    
    func push_data(d: [packages_C]) {
        self.data_source = d
        self.data_source_FUCK = d
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mySearchcontroller = UISearchController(searchResultsController: nil)
        mySearchcontroller.obscuresBackgroundDuringPresentation = false
        mySearchcontroller.searchBar.placeholder = "Search".localized()
        mySearchcontroller.searchBar.delegate = self
        definesPresentationContext = true
        self.navigationItem.searchController = mySearchcontroller
        
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        self.data_source = self.data_source_FUCK
        self.tableView.reloadData()
        return
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.data_source = self.data_source_FUCK
        if (searchText == "") {
            self.tableView.reloadData()
            return
        }
        var index = 0
        for item in self.data_source {
            if (!(item.info["Package".uppercased()]?.uppercased().contains(searchText.uppercased()) ?? false)
                && !(item.info["Name".uppercased()]?.uppercased().contains(searchText.uppercased()) ?? false)) {
                self.data_source.remove(at: index)
            }else{
                index += 1
            }
        }
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data_source.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // find us a cell
        let idCell = "theCell";
        let cell = tableView.dequeueReusableCell(withIdentifier: idCell) ?? UITableViewCell.init(style: .subtitle, reuseIdentifier: "theCell")
        
//        print("[*] The PACKAGE is: " + (data_source[indexPath.row].info["Package".uppercased()] ?? "") + " | " + (data_source[indexPath.row].info["Name".uppercased()] ?? ""))
        
        if (data_source[indexPath.row].info["Name".uppercased()] == nil || data_source[indexPath.row].info["Name".uppercased()] == "") {
            cell.textLabel?.text = "         " + (data_source[indexPath.row].info["Package".uppercased()] ?? "")
        }else{
            cell.textLabel?.text = "         " + (data_source[indexPath.row].info["Name".uppercased()] ?? "")
        }
        cell.detailTextLabel?.text = "            " + (data_source[indexPath.row].info["Description".uppercased()] ?? "No Description Available".localized())
        cell.detailTextLabel?.textColor = .lightGray
        
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "tweakIcon.png")
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

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let name = self.tableView.cellForRow(at: indexPath)?.textLabel?.text ?? ""
        print("[*] Selected package named: " + name + " with father repo: " + self.data_source[indexPath.row].fater_repo.ress.major)
        let package = self.data_source[indexPath.row]
        
        let storyboard_ins = UIStoryboard(name: "Main", bundle: nil)
        
//        if (package.info["SileoDepiction".uppercased()] != nil && package.info["SileoDepiction".uppercased()] != "") {
//            let sb = storyboard_ins.instantiateViewController(withIdentifier: "Saily_UI_Tweak_Native_ID") as? Saily_UI_Tweak_Native
//            sb?.this_package = package
//            self.navigationController?.pushViewController(sb!)
//            print("[*] Pushing to native controller.")
//            return
//        }
//        
        let sb = storyboard_ins.instantiateViewController(withIdentifier: "Saily_UI_Tweak_Webkit_ID") as? Saily_UI_Tweak_Webkit
        sb?.this_package = package
        self.navigationController?.pushViewController(sb!)
        print("[*] Pushing to WebKit controller.")
    }
    
}
