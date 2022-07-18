//
//  Array+SectionModel.swift
//  CodeCohesion
//
//  Created by ios on 2022/07/18.
//


import RxDataSources

extension Array where Element: SectionModelType {
    
    /*
     let task = self.currentState.sections[indexPath.section].items[indexPath.item].currentState
     원래는 이건데 아래 subscript 때문에
     let task = self.currentState.sections[indexPath].currentState
     이게 된다. 잘 봐볼 것.
     */
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
    
    
    /*
     SectionModelType 에 대해서 CRUD하는 연산들인데, 잘 봐두자.
     userdefault 작업은 없고 그냥 보통 insert(at: Int)인데 그걸 확장해서 섹션에서 바로 IndexPath로 작업할 수 있게 한 것들이다. 
     */
    
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
    
    public mutating func insert(_ newElement: Element.Item, at indexPath: IndexPath) {
      self.update(section: indexPath.section) { items in
        items.insert(newElement, at: indexPath.item)
      }
    }
}
