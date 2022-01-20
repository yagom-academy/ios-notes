//
//  NewNoteViewController.swift
//  Notes
//
//  Created by kakao on 2022/01/20.
//

import UIKit
import CoreData

class NewNoteViewController: UIViewController {
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("close", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        button.addTarget(self, action: #selector(touchUpCloseButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("save", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        button.addTarget(self, action: #selector(touchUpSaveButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let noteTextView: UITextView = {
        let textView = UITextView()
        textView.text = ""
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.layer.borderWidth = 1
        textView.layer.borderWidth = 1
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubview(closeButton)
        view.addSubview(noteTextView)
        view.addSubview(saveButton)
        
        setObjectsContraints()
    }
    
    func setObjectsContraints() {
        closeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        
        saveButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        
        noteTextView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        noteTextView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 10).isActive = true
        noteTextView.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -10).isActive = true
        noteTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        noteTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
    }
    
    @objc func touchUpCloseButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @objc func touchUpSaveButton(_ sender: Any) {
        guard let container: NSPersistentContainer = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer else { return }
        let context = container.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "UserNotes", in: context)
        guard let entity = entity else { return }

        let noteEntity = UserNotes(entity: entity, insertInto: context)
        
        noteEntity.setValue(UUID(), forKey: "id")
        
        var stringComponents = noteTextView.text.split(separator: "\n")
        if stringComponents.count > 0 {
            noteEntity.setValue(stringComponents[0], forKey: "title")
            stringComponents.remove(at: 0)
            noteEntity.setValue(stringComponents.joined(separator:"\n"), forKey: "noteBody")
        } else {
            noteEntity.setValue("", forKey: "title")
            noteEntity.setValue("", forKey: "noteBody")
        }
        
        
        let time = Double(Date().timeIntervalSince1970)
        noteEntity.setValue(time, forKey: "lastModifiedDate")
        
        do {
            try context.save()
            print("note saved")
        } catch {
            print("note save fail")
        }
        dismiss(animated: true, completion: nil)
        
    }
}
