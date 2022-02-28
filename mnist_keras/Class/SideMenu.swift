//
//  SideMenu.swift
//  mnist_keras
//
//  Created by t032fj on 2021/12/12.
//

import Foundation
import UIKit

//let viewController = ViewController()
//let drawViewController = DrawViewController()
//let caluculateViewController = CaluculateViewController()

//class MenuListController: UITableViewController {
//
//    var items = ["Camera", "Draw", "Caluculate"]
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
//        tableView.backgroundColor = .rgb(red: 200, green: 200, blue: 200)
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return items.count
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        cell.backgroundColor = .rgb(red: 200, green: 200, blue: 200)
//        cell.textLabel?.text = items[indexPath.row]
//        return cell
//    }
//
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 75
//    }
//
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        tableView.deselectRow(at: indexPath, animated: true)
////        print(items[indexPath.row])
//
//        var v_count = viewController.pageCount
//        var d_count = drawViewController.pageCount
//        var c_count = caluculateViewController.pageCount
//
//        var page_numbar: Int = 0
//
//        if ( v_count == 1 && c_count == 0 && c_count == 0) {
//
//            page_numbar = 0
//        }
//        else if ( v_count == 0 && c_count == 1 && c_count == 0) {
//
//            page_numbar = 1
//        }
//        else if ( v_count == 0 && c_count == 0 && c_count == 1) {
//
//            page_numbar = 2
//        }
//        else if ( v_count == 0 && c_count == 0 && c_count == 2) {
//
//            page_numbar = 3
//        }
//
//        print("pagecount\(page_numbar)")
//        print("v_count\(v_count)")
//        print("d_count\(d_count)")
//        print("c_count\(c_count)")
//
//        switch page_numbar {
//
//            case 0:
//
//            if (items[indexPath.row] == "Draw") {
//
//                print("Draw")
//                let storyboard = UIStoryboard(name: "DrawView", bundle: nil)
//                let drawingViewController = storyboard.instantiateViewController(withIdentifier: "DrawViewController") as! DrawViewController
//                v_count = 0
//                d_count = 1
//                drawingViewController.modalPresentationStyle = .fullScreen
//                self.present(drawingViewController, animated: true, completion: nil)
//            }
//
//            if (items[indexPath.row] == "Caluculate") {
//
//                print("Caluculate")
//                let storyboard = UIStoryboard(name: "Caluculator", bundle: nil)
//                let caluculatingViewController = storyboard.instantiateViewController(withIdentifier: "CaluculateViewController") as! CaluculateViewController
//                v_count = 0
//                c_count = 1
//                caluculatingViewController.modalPresentationStyle = .fullScreen
//                self.present(caluculatingViewController, animated: true, completion: nil)
//            }
//
//        case 1:
//
//            if (items[indexPath.row] == "Camera") {
//
//                v_count = 1
//                d_count = 0
//                dismiss(animated: true, completion: nil)
//            }
//
//            if (items[indexPath.row] == "Caluculate") {
//
//                print("Caluculate")
//                let storyboard = UIStoryboard(name: "Caluculator", bundle: nil)
//                let caluculatingViewController = storyboard.instantiateViewController(withIdentifier: "CaluculateViewController") as! CaluculateViewController
//                d_count = 0
//                c_count = 2
//                caluculatingViewController.modalPresentationStyle = .fullScreen
//                self.present(caluculatingViewController, animated: true, completion: nil)
//            }
//
//        case 2:
//
//            if (items[indexPath.row] == "Camera") {
//
//                v_count = 1
//                d_count = 0
//                dismiss(animated: true, completion: nil)
//            }
//
//            if (items[indexPath.row] == "Draw") {
//
//                dismiss(animated: true, completion: nil)
//                print("Draw")
//                let storyboard = UIStoryboard(name: "DrawView", bundle: nil)
//                let drawingViewController = storyboard.instantiateViewController(withIdentifier: "DrawViewController") as! DrawViewController
//                v_count = 0
//                d_count = 1
//                drawingViewController.modalPresentationStyle = .fullScreen
//                self.present(drawingViewController, animated: true, completion: nil)
//            }
//
//        case 3:
//
//            if (items[indexPath.row] == "Camera") {
//
//                v_count = 1
//                c_count = 0
//                self.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
//            }
//
//            if (items[indexPath.row] == "Draw") {
//
//                d_count = 1
//                c_count = 0
//                dismiss(animated: true, completion: nil)
//            }
//
//        default:
//            print("error")
//        }
//    }
//}


