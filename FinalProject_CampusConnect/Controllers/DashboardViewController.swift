//
//  DashboardViewController.swift
//  FinalProject_CampusConnect
//
//  Created by Mann Mehta.
//

import UIKit

struct DashboardItem {
    let iconName: String  // image name from Assets.xcassets
    let title: String
    let segueID: String
}

class DashboardViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!

    let items: [DashboardItem] = [
        DashboardItem(iconName: "calendar", title: "Event Calendar", segueID: "goToEventCalendar"),
        DashboardItem(iconName: "compass", title: "Campus Map", segueID: "goToMap"),
        DashboardItem(iconName: "group", title: "Study Groups", segueID: "goToStudyGroups"),
        DashboardItem(iconName: "document", title: "Resources", segueID: "goToResources"),
        DashboardItem(iconName: "combo-chart", title: "GPA Calculator", segueID: "goToCoursePlanner"),
        DashboardItem(iconName: "user-male-circle", title: "Profile", segueID: "goToProfile")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "CampusConnect"

        collectionView.dataSource = self
        collectionView.delegate = self

        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = .zero // Disable auto-sizing
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dashboardCell", for: indexPath) as! DashboardCollectionViewCell
        let item = items[indexPath.row]

        cell.iconImageView.image = UIImage(named: item.iconName)
        cell.titleLabel.text = item.title

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        performSegue(withIdentifier: item.segueID, sender: self)
    }

    // Two-column fixed grid layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let columns: CGFloat = 2
        let spacing: CGFloat = 16
        let totalSpacing = spacing * (columns + 1)
        let itemWidth = (collectionView.bounds.width - totalSpacing) / columns
        return CGSize(width: itemWidth, height: itemWidth * 1.1) // Maintain card ratio
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }

    @IBAction func unwindToDashboard(_ segue: UIStoryboardSegue) {
        print("⬅️ Unwound back to Dashboard from \(segue.source)")
    }
}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


