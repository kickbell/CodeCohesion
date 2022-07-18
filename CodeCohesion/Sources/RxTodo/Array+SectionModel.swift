//
//  Array+SectionModel.swift
//  CodeCohesion
//
//  Created by ios on 2022/07/18.
//


import RxDataSources

extension Array where Element: SectionModelType {
    
    public subscript(indexPath: IndexPath) -> Element.Item {
        get {
            return self[indexPath.section].items[indexPath.item]
        }
        mutating set {
            self.update(section: indexPath.section) { items in
                items[indexPath.item] = newValue
            }
        }
    }
    
    private mutating func update<T>(section: Int, mutate: (inout [Element.Item]) -> T) -> T {
        var items = self[section].items
        let value = mutate(&items)
        self[section] = Element.init(original: self[section], items: items)
        return value
    }
    
    @discardableResult
    public mutating func remove(at indexPath: IndexPath) -> Element.Item {
      return self.update(section: indexPath.section) { items in
        return items.remove(at: indexPath.item)
      }
    }
}
