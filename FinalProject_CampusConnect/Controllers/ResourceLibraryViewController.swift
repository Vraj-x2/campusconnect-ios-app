//
//  ResourceLibraryViewController.swift
//  FinalProject_CampusConnect
//
//  Created by Ajay Jesa Odedara.
//


import UIKit
import CoreData
import QuickLook

class ResourceLibraryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIDocumentPickerDelegate, QLPreviewControllerDataSource {

    @IBOutlet weak var resourceTableView: UITableView!

    var resources: [Resource] = []
    var selectedFileURL: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
        resourceTableView.delegate = self
        resourceTableView.dataSource = self
        loadResources()
    }

    // MARK: - Load Resources from Core Data
    func loadResources() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request: NSFetchRequest<Resource> = Resource.fetchRequest()

        do {
            resources = try context.fetch(request)
        } catch {
            print("❌ Failed to fetch resources: \(error)")
        }

        resourceTableView.reloadData()
    }

    // MARK: - Upload Document
    @IBAction func uploadButtonTapped(_ sender: UIButton) {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.pdf, .plainText, .item, .image], asCopy: true)
        picker.delegate = self
        present(picker, animated: true)
    }

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else { return }
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let resource = Resource(context: context)
        resource.id = UUID()
        resource.title = url.lastPathComponent
        resource.fileURL = url.path  // Store as local file path for preview

        do {
            try context.save()
            resources.append(resource)
            resourceTableView.reloadData()
        } catch {
            print("❌ Failed to save resource: \(error)")
        }
    }

    // MARK: - Table View Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resources.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let resource = resources[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "resourceCell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "resourceCell")
        cell.textLabel?.text = resource.title
        return cell
    }

    // MARK: - Table View Selection for Preview
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let resource = resources[indexPath.row]
        if let filePath = resource.fileURL {
            let fileManager = FileManager.default
            let fullPath = URL(fileURLWithPath: filePath)
            if fileManager.fileExists(atPath: fullPath.path) {
                selectedFileURL = fullPath
                let previewController = QLPreviewController()
                previewController.dataSource = self
                present(previewController, animated: true)
            } else {
                print("❌ File does not exist at path: \(fullPath.path)")
            }
        }
    }

    // MARK: - QLPreviewController Data Source
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return selectedFileURL != nil ? 1 : 0
    }

    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return selectedFileURL! as QLPreviewItem
    }

    // MARK: - Unwind
    @IBAction func unwindToResourceLibrary(_ segue: UIStoryboardSegue) {}
}


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


