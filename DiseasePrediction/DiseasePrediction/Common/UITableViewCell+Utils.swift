//
//  UITableViewCell+Utils.swift
//  DiseasePrediction
//
//  Created by Partenhauser Andreas on 07.10.17.
//  Copyright © 2017 BurdaHackday. All rights reserved.
//

import UIKit

public protocol AddableNib: class {
    static var Identifer: String { get }
}

public extension AddableNib {
    public static var Identifer: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}

extension UITableView {
    func addTableViewCell(for addable: AddableNib.Type) {
        self.register(UINib(nibName: addable.Identifer, bundle: nil), forCellReuseIdentifier: addable.Identifer)
    }
}
