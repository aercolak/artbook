//
//  detailsVC.swift
//  ArtBook
//
//  Created by ANILCAN ERÇOLAK on 3.04.2019.
//  Copyright © 2019 ANILCAN ERÇOLAK. All rights reserved.
//

import UIKit
import CoreData

class detailsVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var artistText: UITextField!
    @IBOutlet weak var yearText: UITextField!
    
    var gelenName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if gelenName != "" {
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Paintings")
            
            fetchRequest.predicate = NSPredicate(format: "name = %@", self.gelenName)
            
            fetchRequest.returnsObjectsAsFaults = false
            
            do {
                let results = try context.fetch(fetchRequest)
                
                if results.count > 0 {
                    for result in results as! [NSManagedObject]{
                        if let name = result.value(forKey: "name") as? String {
                            nameText.text = name
                        }
                        
                        if let artist = result.value(forKey: "artist") as? String {
                            artistText.text = artist
                        }
                        
                        if let year = result.value(forKey: "year") as? Int {
                            yearText.text = String(year)
                        }
                        
                        if let imageData = result.value(forKey: "image") as? Data {
                            imageView.image = UIImage(data: imageData)
                        }
                        
                    }
                }
            } catch {
                print("hata")
            }
            
        }
        
        
        imageView.isUserInteractionEnabled = true
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(detailsVC.resimSec))
        imageView.addGestureRecognizer(gestureRecognizer)
        
        print(gelenName)
    }
    
    @objc func resimSec(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
         
    }
    
    @IBAction func saveButton(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newItem = NSEntityDescription.insertNewObject(forEntityName: "Paintings", into: context)
        
        newItem.setValue(artistText.text, forKey: "artist")
        newItem.setValue(nameText.text, forKey: "name")
        if let year = Int(yearText.text!){
            newItem.setValue(year, forKey: "year")
        }
        let data = imageView.image?.jpegData(compressionQuality: 0.5)
        
        newItem.setValue(data, forKey: "image")
        
        do {
            try context.save()
            print("hata yok")
        } catch {
            print("hata var")
        }
        
        NotificationCenter.default.post(name: NSNotification.Name("newPainting"), object: nil)
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
 
}
