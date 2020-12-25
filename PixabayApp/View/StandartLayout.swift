//
//  StandartLayout.swift
//  PixabayApp
//
//  Created by Клим on 23.12.2020.
//

import UIKit

class StandartLayout: UICollectionViewFlowLayout {
    
    init(itemSize: CGSize, insetForSection: UIEdgeInsets, lineSpacing: CGFloat, interItemSpacing: CGFloat){
        super.init()
        self.itemSize = itemSize
        sectionInset = insetForSection
        minimumLineSpacing = lineSpacing
        minimumInteritemSpacing = interItemSpacing
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

}
