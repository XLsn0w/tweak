//
//  Saily_UI_Settings.swift
//  Saily Package Manager
//
//  Updated by Brecken Lusk on 6/6/19.
//  Copyright © 2019 Saily Team. All rights reserved.
//
import UIKit

import EzPopup

class Saily_UI_Queue: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var container: UIScrollView!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var submit: UIButton!
    
    private var progressBars = [UIProgressView]()
    
    var timer: Timer?
    var tiimer: Timer?
    
    @objc func update_download_progress() {
        if (Saily.operation_container.installs.count < 1 || self.progressBars.count < 1) {
            if (Saily.operation_container.removes.count > 0 && Saily.operation_container.installs.count < 1) {
                submit.setTitle("CONFIRM".localized(), for: .normal)
                submit.isEnabled = true
            }
            return
        }
        var there_is_an_un_finished_fucking_shittttt = false
        for i in 0...(Saily.operation_container.installs.count - 1) {
            if let tmp = Saily.operation_container.installs[i].info["FILENAME"] {
                var download_url = ""
                if (tmp.hasPrefix("http")) {
                    download_url = tmp
                }else if (tmp.hasPrefix("./")) {
                    download_url = Saily.operation_container.installs[i].fater_repo.ress.major + tmp.dropFirst(2).description
                }else{
                    download_url = Saily.operation_container.installs[i].fater_repo.ress.major + tmp
                }
                let file_name = download_url.split(separator: "/").last ?? "ohno?"
                //                print("[*] Checking progress at: " + (Saily.files.quene_install + "/" + file_name + ".progress"))
                if (!Saily_FileU.exists(file_path: Saily.files.quene_install + "/" + file_name)) {
                    if (Saily_FileU.exists(file_path: Saily.files.quene_install + "/" + file_name + ".progress")) {
                        async_update_progress(value: Float(Saily_FileU.simple_read(Saily.files.quene_install + "/" + file_name + ".progress") ?? "1") ?? 1, view: self.progressBars[i])
                        there_is_an_un_finished_fucking_shittttt = true
                    }else{
                        async_update_progress(value: 0, view: self.progressBars[i])
                        there_is_an_un_finished_fucking_shittttt = true
                    }
                }else{
                    if (!Saily_FileU.exists(file_path: Saily.files.quene_install + "/" + file_name + ".progress")) {
                        async_update_progress(value: 1, view: self.progressBars[i])
                    }else{
                        async_update_progress(value: Float(Saily_FileU.simple_read(Saily.files.quene_install + "/" + file_name + ".progress") ?? "1") ?? 1, view: self.progressBars[i])
                        there_is_an_un_finished_fucking_shittttt = true
                    }
                }
            }
        }
        if (there_is_an_un_finished_fucking_shittttt) {
            if (Saily.operation_container.removes.count > 0 && Saily.operation_container.installs.count < 1) {
                submit.setTitle("CONFIRM".localized(), for: .normal)
                submit.isEnabled = true
            }else{
                submit.setTitle("⇣⇣⇣", for: .normal)
                submit.isEnabled = false
            }
        }else{
            submit.setTitle("CONFIRM".localized(), for: .normal)
            submit.isEnabled = true
        }
    }
    
    @objc func recheck() {
        if (Saily.operation_container.installs.count == 0 && Saily.operation_container.removes.count == 0) {
            self.tableview.reloadData()
            
            self.submit.isEnabled = false
            self.submit.setTitle("EMPTY".localized(), for: .normal)
            let mafumafu = UIImageView()
            mafumafu.image = #imageLiteral(resourceName: "mafufulove.png")
            mafumafu.contentMode = .scaleAspectFit
            self.view.addSubview(mafumafu)
            mafumafu.snp.makeConstraints { (x) in
                x.bottom.equalTo(self.view.snp.bottom).offset(8)
                x.centerX.equalTo(self.view.snp.centerX)
                x.width.equalTo(128)
                x.height.equalTo(128)
            }
            
        }
    }
    
    func async_update_progress(value: Float, view: UIProgressView) {
        DispatchQueue.main.async {
            view.setProgress(value, animated: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        timer = nil
        tiimer?.invalidate()
        tiimer = nil
        self.navigationController?.setToolbarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.tableview.dataSource = self
        self.tableview.delegate = self
        
        submit.isEnabled = false
        
        timer = Timer.scheduledTimer(timeInterval: 0.233, target: self, selector: #selector(update_download_progress), userInfo: nil, repeats: true)
        timer?.fire()
        tiimer = Timer.scheduledTimer(timeInterval: 0.233, target: self, selector: #selector(recheck), userInfo: nil, repeats: true)
        tiimer?.fire()
        
        if (Saily.operation_container.installs.count < 1 && Saily.operation_container.removes.count < 1) {
            self.submit.isEnabled = false
            self.submit.setTitle("EMPTY".localized(), for: .normal)
            let mafumafu = UIImageView()
            mafumafu.image = #imageLiteral(resourceName: "mafufulove.png")
            mafumafu.contentMode = .scaleAspectFit
            self.view.addSubview(mafumafu)
            mafumafu.snp.makeConstraints { (x) in
                x.bottom.equalTo(self.view.snp.bottom).offset(8)
                x.centerX.equalTo(self.view.snp.centerX)
                x.width.equalTo(128)
                x.height.equalTo(128)
            }
        }
        
        container.snp.makeConstraints { (x) in
            x.top.equalTo(self.view.snp.top)
            x.bottom.equalTo(self.view.snp.bottom)
            x.left.equalTo(self.view.snp.left)
            x.right.equalTo(self.view.snp.right)
        }
        
        submit.snp.makeConstraints { (x) in
            x.top.equalTo(self.view.snp.top).offset(22)
            x.height.equalTo(30)
            x.right.equalTo(self.view.snp.right).offset(-22)
            x.width.equalTo(66)
        }
        
        label.text = "Operations 📦".localized()
        
        label.snp.makeConstraints { (x) in
            x.height.equalTo(48)
            x.left.equalTo(self.view.snp.left).offset(22)
            x.right.equalTo(self.submit.snp.left).offset(-18)
            x.centerY.equalTo(self.submit.snp.centerY)
        }
        
        tableview.snp.makeConstraints { (x) in
            x.top.equalTo(self.label.snp.bottom).offset(18)
            x.bottom.equalTo(self.view.snp.bottom)
            x.left.equalTo(self.view.snp.left)
            x.right.equalTo(self.view.snp.right)
        }
        
        self.tableview.separatorColor = .clear
        for _ in Saily.operation_container.installs {
            self.progressBars.append(UIProgressView())
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var sections = 0
        if (Saily.operation_container.installs.count > 0) {
            sections += 1
        }
        if (Saily.operation_container.removes.count > 0) {
            sections += 1
        }
        return sections
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 0) {
            if (Saily.operation_container.installs.count > 0) {
                return "Install".localized()
            }
        }
        return "Remove".localized()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            if (Saily.operation_container.installs.count > 0) {
                return Saily.operation_container.installs.count
            }
        }
        return Saily.operation_container.removes.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableview.deselectRow(at: indexPath, animated: true)
    }
    
    var cells_identify_index = 0
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell_id = UUID().uuidString + cells_identify_index.description;
        cells_identify_index += 1
        let cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: cell_id)
        
        if (indexPath.section == 0) {
            if (Saily.operation_container.installs.count > 0) {
                cell.textLabel?.text = "       " + (Saily.operation_container.installs[indexPath.row].info["NAME"] ?? "[Unknown Name]".localized())
                cell.detailTextLabel?.text = "         " + (Saily.operation_container.installs[indexPath.row].info["PACKAGE"] ?? "Error: No ID".localized())
                let progressView = UIProgressView()
                progressView.progress = 0
                progressView.trackTintColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
                progressView.progressTintColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
                cell.addSubview(progressView)
                progressView.snp.makeConstraints { (c) in
                    c.bottom.equalTo(cell.contentView.snp.bottom).offset(0 - progressView.bounds.height)
                    c.left.equalTo(cell.textLabel!.snp.left).offset(0)
                    c.right.equalTo(cell.contentView.snp.right).offset(0)
                    c.height.equalTo(1)
                }
                self.progressBars[indexPath.row] = progressView
            }else{
                cell.textLabel?.text = "       " + (Saily.operation_container.removes[indexPath.row].info["NAME"] ?? "[Unknown Name]".localized())
                cell.detailTextLabel?.text = "         " + (Saily.operation_container.removes[indexPath.row].info["PACKAGE"] ?? "Error: No ID".localized())
            }
        }else{
            cell.textLabel?.text = "       " + (Saily.operation_container.removes[indexPath.row].info["NAME"] ?? "[Unknown Name]".localized())
            cell.detailTextLabel?.text = "         " + (Saily.operation_container.removes[indexPath.row].info["PACKAGE"] ?? "Error: No ID".localized())
        }
        
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "tweakIcon.png")
        cell.addSubview(imageView)
        imageView.snp.makeConstraints { (c) in
            c.top.equalTo(cell.contentView.snp.top).offset(14)
            c.right.equalTo(cell.textLabel!.snp.left).offset(22)
            c.width.equalTo(28)
            c.height.equalTo(28)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            if (Saily.operation_container.installs.count <= 0 || indexPath.section == 1) {
                Saily.operation_container.removes.remove(at: indexPath.row)
                tableView.reloadData {
                    if (Saily.operation_container.installs.count < 1 && Saily.operation_container.removes.count < 1) {
                        self.submit.isEnabled = false
                        self.submit.setTitle("EMPTY".localized(), for: .normal)
                        let mafumafu = UIImageView()
                        mafumafu.image = #imageLiteral(resourceName: "mafufulove.png")
                        mafumafu.contentMode = .scaleAspectFit
                        self.view.addSubview(mafumafu)
                        mafumafu.snp.makeConstraints { (x) in
                            x.bottom.equalTo(self.view.snp.bottom).offset(8)
                            x.centerX.equalTo(self.view.snp.centerX)
                            x.width.equalTo(128)
                            x.height.equalTo(128)
                        }
                    }
                }
                return
            }
            let alert = UIAlertController(title: "Warning".localized(), message: "Removing packages from the queue can be dangerous and can cause missing dependencies, which may result in a bad install status. Are you sure you want to remove the following packages: \n\n\n".localized() + (tableView.cellForRow(at: indexPath)?.textLabel?.text?.dropFirst(7).description ?? "[E]"), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Confirm".localized(), style: .destructive, handler: { (_) in
                if (indexPath.section == 1) {
                    Saily.operation_container.removes.remove(at: indexPath.row)
                }else{
                    if (Saily.operation_container.installs.count <= 0) {
                        Saily.operation_container.removes.remove(at: indexPath.row)
                    }else{
                        Saily.operation_container.installs.remove(at: indexPath.row)
                    }
                }
                tableView.reloadData {
                    if (Saily.operation_container.installs.count < 1 && Saily.operation_container.removes.count < 1) {
                        self.submit.isEnabled = false
                        self.submit.setTitle("EMPTY".localized(), for: .normal)
                        let mafumafu = UIImageView()
                        mafumafu.image = #imageLiteral(resourceName: "mafufulove.png")
                        mafumafu.contentMode = .scaleAspectFit
                        self.view.addSubview(mafumafu)
                        mafumafu.snp.makeConstraints { (x) in
                            x.bottom.equalTo(self.view.snp.bottom).offset(8)
                            x.centerX.equalTo(self.view.snp.centerX)
                            x.width.equalTo(128)
                            x.height.equalTo(128)
                        }
                    }
                }
            }))
            alert.addAction(UIAlertAction(title: "Cancel (Recommended)".localized(), style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func submit(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let new = sb.instantiateViewController(withIdentifier: "Saily_UI_Submitter_ID") as? Saily_UI_Submitter
        
        
        
        let scx = self.view.bounds.width
        let scy = self.view.bounds.height
        
        var popupVC: PopupViewController? = nil
        if (Saily.device.indentifier_human_readable.uppercased().contains("iPad".uppercased())) {
            popupVC = PopupViewController(contentController: new!, popupWidth: scx, popupHeight: scy)
        }else{
            popupVC = PopupViewController(contentController: new!, popupWidth: scx, popupHeight: scx)
        }
        
        if (Saily.operation_container.removes.count > 0) {
            var read = ""
            for item in Saily.operation_container.removes {
                read = (item.info["PACKAGE"] ?? "") + "\n" + read
            }
            Saily_FileU.simple_write(file_path: Saily.files.queue_removes, file_content: read)
        }
        new?.popVC = popupVC
        new?.pusher = self
        popupVC!.canTapOutsideToDismiss = false
        popupVC!.cornerRadius = 10
        popupVC!.shadowEnabled = false
        present(popupVC!, animated: true)
    }
}
