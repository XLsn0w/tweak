//
//  Saily_UI_Search.swift
//  Saily Package Manager
//
//  Updated by Brecken Lusk on 6/6/19.
//  Copyright © 2019 Saily Team. All rights reserved.
//

import UIKit


class Saily_UI_Search: UITableViewController, UISearchControllerDelegate, UISearchBarDelegate {
    
    private var should_search = 0
    private var container = [packages_C]()
    private var timer: Timer? = nil
    private var searchtext = ""
    private var in_search = false
    private var in_reload = false
    
    func startTimer() {
        if (timer != nil) {
            return
        }
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updataSecond), userInfo: nil, repeats: true)
        timer!.fire()
    }
    
    func wait_s(end_call: @escaping () -> ()) {
        while (self.in_search || self.in_reload) {
            usleep(50000)
        }
        self.in_search = true
        self.in_reload = true
        end_call()
    }
    
    @objc func updataSecond() {
        if (should_search < 0) {
            stopTimer()
            return
        }
        Saily.operation_quene.search_queue.addOperation {
            if (self.searchtext == "") {
                self.stopTimer()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    DispatchQueue.main.async {
                        self.in_reload = true
                        self.tableView.reloadData {
                            self.should_search = -1
                            self.in_search = false
                            self.in_reload = false
                        }
                    }
                }
                return
            }
            let ss = DispatchSemaphore(value: 0)
            self.wait_s {
                ss.signal()
            }
            ss.wait()
            if (self.timer == nil) {
                return
            }
            var index = 0
            self.container = Saily.root_packages
            if (self.searchtext == "") {
                DispatchQueue.main.async {
                    self.stopTimer()
                    self.in_reload = true
                    self.tableView.reloadData {
                        self.should_search = -1
                        self.in_search = false
                        self.in_reload = false
                    }
                }
                return
            }
            for item in self.container {
                if (!(item.info["Package".uppercased()]?.uppercased().contains(self.searchtext.uppercased()) ?? false)
                    && !(item.info["Name".uppercased()]?.uppercased().contains(self.searchtext.uppercased()) ?? false)) {
                    if (self.container.count == 0) {
                        break
                    }else{
                        self.container.remove(at: index)
                    }
                }else{
                    index += 1
                }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData {
                    self.in_search = false
                    self.in_reload = false
                }
            }
            self.should_search -= 1
        }
    }
    
    func stopTimer() {
        if timer != nil {
            timer!.invalidate()
            timer = nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mySearchcontroller = UISearchController(searchResultsController: nil)
        mySearchcontroller.searchBar.placeholder = "Search".localized()
        mySearchcontroller.searchBar.delegate = self
        definesPresentationContext = true
        self.navigationItem.searchController = mySearchcontroller
        self.navigationItem.hidesSearchBarWhenScrolling = false
        
        self.tableView.separatorColor = .clear
        
        self.title = "Search".localized()
        
        let bgView = UIView()
        self.tableView.backgroundView = bgView
        
        let mafufu = UIImageView()
        let which_mafumafu = 0 // Int.random(in: 0..<2)
        print("[*] Today, we have mafumafu at: " + which_mafumafu.description)
        switch which_mafumafu {
//        case 1:
//            mafufu.image = #imageLiteral(resourceName: "mafufulove.png")
        default:
            mafufu.image = #imageLiteral(resourceName: "mafumafu.png")
        }
        mafufu.contentMode = .scaleAspectFit
        self.tableView.backgroundView?.addSubview(mafufu)
        mafufu.snp.makeConstraints { (c) in
            c.bottom.equalTo(self.tableView.backgroundView!.snp.bottom).offset(0 - (self.tabBarController?.tabBar.frame.height ?? 50))
            c.left.equalTo(self.tableView.backgroundView!.snp.left)
            c.right.equalTo(self.tableView.backgroundView!.snp.right)
            c.height.equalTo(128)
        }
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        self.should_search = 0
        self.tableView.reloadData {
            self.in_reload = false
        }
        return
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchtext = searchText
        self.should_search = 1
        startTimer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.navigationItem.searchController?.isActive = false
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return container.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // find us a cell
        let idCell = "theCell";
        let cell = tableView.dequeueReusableCell(withIdentifier: idCell) ?? UITableViewCell.init(style: .subtitle, reuseIdentifier: "theCell")
        
//        print("[*] The PACKAGE is: " + (container[indexPath.row].info["Package".uppercased()] ?? "") + " | " + (container[indexPath.row].info["Name".uppercased()] ?? ""))
        
        if (container[indexPath.row].info["Name".uppercased()] == nil || container[indexPath.row].info["Name".uppercased()] == "") {
            cell.textLabel?.text = "         " + (container[indexPath.row].info["Package".uppercased()] ?? "")
        }else{
            cell.textLabel?.text = "         " + (container[indexPath.row].info["Name".uppercased()] ?? "")
        }
        cell.detailTextLabel?.text = "            " + (container[indexPath.row].info["Description".uppercased()] ?? "Description Unavailable".localized())
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
        let package = self.container[indexPath.row]
        
        self.tableView.deselectRow(at: indexPath, animated: true)
        let name = self.tableView.cellForRow(at: indexPath)?.textLabel?.text ?? ""
        print("[*] Selected package named: " + name + " with father repo: " + self.container[indexPath.row].fater_repo.ress.major)
        
        let storyboard_ins = UIStoryboard(name: "Main", bundle: nil)
        
//        if (package.info["SileoDepiction".uppercased()] != nil && package.info["SileoDepiction".uppercased()] != "") {
//            let sb = storyboard_ins.instantiateViewController(withIdentifier: "Saily_UI_Tweak_Native_ID") as? Saily_UI_Tweak_Native
//            sb?.this_package = package
//            self.navigationController?.pushViewController(sb!)
//            print("[*] Pushing to native controller.")
//            return
//        }
        
        let sb = storyboard_ins.instantiateViewController(withIdentifier: "Saily_UI_Tweak_Webkit_ID") as? Saily_UI_Tweak_Webkit
        sb?.this_package = package
        self.navigationController?.pushViewController(sb!)
        print("[*] Pushing to WebKit controller.")
    }
}


