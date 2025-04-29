//
//  StudyGroupViewController.swift
//  FinalProject_CampusConnect
//
//  Created by Mann Mehta.
//

import UIKit

class StudyGroupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet weak var groupFinderTitleLabel: UILabel!
    @IBOutlet weak var groupSearchBar: UISearchBar!
    @IBOutlet weak var groupTableView: UITableView!

    var groups: [StudyGroup] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        groupTableView.delegate = self
        groupTableView.dataSource = self
        groupSearchBar.delegate = self

        // Load all groups
        groups = GroupMatchingAlgorithm.fetchGroups()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        groups = GroupMatchingAlgorithm.fetchGroups()
        groupTableView.reloadData()
    }

    // MARK: - Search Filter
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        groups = GroupMatchingAlgorithm.fetchGroups(filter: searchText)
        groupTableView.reloadData()
    }

    // MARK: - Create Group Navigation
    @IBAction func createGroupTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "goToCreateGroup", sender: self)
    }

    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let group = groups[indexPath.row]
        let cell = UITableViewCell()
        cell.textLabel?.text = "\(group.course ?? "") – Members: \(group.currentMembers)/\(group.maxMembers)"
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedGroup = groups[indexPath.row]
        performSegue(withIdentifier: "goToGroupDetail", sender: selectedGroup)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToGroupDetail",
           let detailVC = segue.destination as? GroupDetailViewController,
           let selectedGroup = sender as? StudyGroup {
            detailVC.group = selectedGroup
        }
    }

    @IBAction func unwindToStudyGroups(_ segue: UIStoryboardSegue) {
        print("⬅️ Returned to Study Groups from \(segue.source)")
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
