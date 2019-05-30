//
//  RxCocoa+Ext.swift
//  StoryView
//
//  Created by Daniel Asher on 16/07/2018.
//  Copyright © 2018 LEXI LABS. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit
import Rswift

extension Reactive where Base : UICollectionView {
    public func items<S, Cell, O>(cellSpec: ReuseIdentifier<Cell>)
        -> (O) -> (@escaping (Int, S.Iterator.Element, Cell) -> Void)
        -> Disposable where S : Sequence, S == O.Element, Cell : UICollectionViewCell, O : ObservableType {
            return items(cellIdentifier: cellSpec.identifier, cellType: type(of: cellSpec).ReusableType.self)
    }
}
