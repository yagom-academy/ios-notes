import UIKit

final class NotesTableViewController: UITableViewController {

    @IBOutlet weak var plus: UIBarButtonItem!
    private var noteCoreDatas: [NoteEntity] = []
    private var noteDataObservation: NSKeyValueObservation?
    weak var appDelegate = UIApplication.shared.delegate as? AppDelegate
    weak var sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let notes = Decoder.decodeJSONData(type: [Note].self, from: "sample") ?? []
//        guard let context = appDelegate?.persistentContainer.viewContext else {return}
//        let fetchRequest = NoteEntity.fetchRequest()
        loadCoreData()
        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = true
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadCoreData()
        tableView.reloadData()
    }

    @IBAction func addMemo(_ sender: Any) {
        let noteView: NoteViewController = storyboard?.instantiateViewController(withIdentifier: "NoteVC") as? NoteViewController ?? NoteViewController()
//        noteView.configureView(data: noteEntity)
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
        do {
            noteCoreDatas = try context.fetch(fetchRequest)
            noteCoreDatas.reverse() // 시간 역순으로 정렬하기.. 추후 수정
            tableView.reloadData()
        } catch {
            print(error)
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteCoreDatas.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NoteTableViewCell.reuseIdentifier,
                                                 for: indexPath) as? NoteTableViewCell ?? NoteTableViewCell()
        cell.configureCell(data: noteCoreDatas[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let noteView: NoteViewController = storyboard?.instantiateViewController(withIdentifier: "NoteVC") as? NoteViewController ?? NoteViewController()
        noteView.configureView(data: noteCoreDatas[indexPath.row])
        
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
