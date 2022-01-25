import UIKit

final class NotesTableViewController: UITableViewController {

    @IBOutlet weak var plus: UIBarButtonItem!
    private var notes: [NoteEntity] = []
    weak var notificationCenter = NotificationCenter.default
    weak var appDelegate = UIApplication.shared.delegate as? AppDelegate
    weak var sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCoreData()
        notificationCenter?.addObserver(self, selector: #selector(noteUpdated(_:)), name: nil, object: nil)
        
         self.clearsSelectionOnViewWillAppear = true
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    @IBAction func addMemo(_ sender: Any) {
        let noteView: NoteViewController = storyboard?.instantiateViewController(withIdentifier: "NoteVC") as? NoteViewController ?? NoteViewController()
        if UITraitCollection.current.horizontalSizeClass == .compact {
            navigationController?.pushViewController(noteView, animated: true)
        } else {
            guard let secondNavigationController: UINavigationController = splitViewController?.viewControllers[1] as? UINavigationController else { return }
            secondNavigationController.popViewController(animated: false)
            secondNavigationController.pushViewController(noteView, animated: true)
        }
    }
    
    public func loadCoreData() {
        guard let context = appDelegate?.persistentContainer.viewContext else {return}
        let fetchRequest = NoteEntity.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            notes = try context.fetch(fetchRequest)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print(error)
        }
    }

    @objc
    func noteUpdated(_ notification: Notification) {
        loadCoreData()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NoteTableViewCell.reuseIdentifier,
                                                 for: indexPath) as? NoteTableViewCell ?? NoteTableViewCell()
        cell.configureCell(data: notes[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let noteView: NoteViewController = storyboard?.instantiateViewController(withIdentifier: "NoteVC") as? NoteViewController ?? NoteViewController()
        noteView.configureView(data: notes[indexPath.row])
        
        if UITraitCollection.current.horizontalSizeClass == .compact {
            navigationController?.pushViewController(noteView, animated: true)
            tableView.deselectRow(at: indexPath, animated: true)
        } else {
            guard let secondNavigationController: UINavigationController = splitViewController?.viewControllers[1] as? UINavigationController else { return }
            secondNavigationController.popViewController(animated: false)
            secondNavigationController.pushViewController(noteView, animated: true)
        }
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }

    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
}
