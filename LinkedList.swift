//
//  LinkedList.swift
//  
//
//  Created by 김민성 on 2022/08/19.
//

import Foundation

class Node<Value> {
    var data: Value
    var next: Node?
    
    init(data: Value, next: Node? = nil) {
        self.data = data
        self.next = next
    }
    
}

extension Node: CustomStringConvertible {
    
    var description: String {
        guard let next = next else {
            // 마지막 노드일 경우
            return "\(data)"
        }
        // 마지막 노드가 아닐 때
        return "\(data) -> " + String(describing: next) + " "
    }
}

public struct LinkedList<Value> {
    var head: Node<Value>?
    var tail: Node<Value>?
    
    init(){}
    var isEmpty: Bool {
        head == nil
    }
    // 링크드리스트 맨앞에 추가
    mutating func push(_ data: Value) {
        // head에 노드를 저장하고 원래 head가 가리키는 노드를 next에 연결한다.
        head = Node(data: data, next: head)
        // tail이 nil이면 노드가 없다는 뜻이므로 head와 tail모두 같은 곳을 가리킨다.
        if tail == nil {
            tail = head
        }
    }
    // 링크드리스트 맨뒤에 추가
    mutating func append(_ data: Value) {
        // 리스트가 비어있으면 그냥 앞에다 추가하는 것과 같으므로 push한다.
        guard !isEmpty else {
            push(data)
            return
        }
        // tail의 next에 새로운 노드를 연결한다. 새로운 노드의 next는 없으므로 nil이다.
        tail!.next = Node(data: data)
        // tail을 새로운 노드로 갱신한다. (새로운 노드 => tail.next)
        tail = tail!.next
    }
    
    // 노드를 찾는다.
    func node(at index: Int) -> Node<Value>? {
        var currentNode = head
        var currentIndex = 0
        // 현재 노드가 nil일 때 까지 and 현재 인덱스가 주어진 인덱스 전 까지 계속 반복한다.
        // 파라미터로 넘어온 index가 리스트에 노드 개수보다 많을 경우를 대비해 currentNode != nil이 필요하다.
        while currentNode != nil && currentIndex < index {
            // 현재 노드에 다음노드를 넣는다.
            currentNode = currentNode?.next
            // 인덱스를 추가한다.
            currentIndex += 1
        }
        return currentNode
    }
    // 파라미터로 넘어온 노드 뒤에 노드를 삽입한다.
    @discardableResult
    mutating func insert(_ data: Value, after node: Node<Value>) -> Node<Value> {
        // 파라미터로 전달된 노드가 이미 마지막에 연결되어 있다면
        guard tail !== node else {
            //그냥 맨뒤에 노드를 추가한다.
            append(data)
            return tail!
        }
        // 그게 아니라면 넘어온 노드뒤에 새로운 노드를 만든다.
        // 새로운 노드의 next는 넘어온 노드가 이전에 가리키던 노드를 가리킨다.
        node.next = Node(data: data, next: node.next)
        // 새로운 노드를 리턴함으로서 insert를 반복가능하도록 만든다.
        return node.next!
    }
    
    @discardableResult
    // 맨 앞의 노드를 삭제한다.
    mutating func pop() -> Value? {
        // 리턴한 후 마무리 작업을 해준다.
        defer {
            // 해드를 뒤 노드로 이동시킨다.
            head = head?.next
            // 해드가 nil이라면
            if isEmpty {
                tail = nil
            }
        }
        // head의 data를 리턴한다.
        return head?.data
    }
    
    // 맨 뒤의 노드를 삭제한다.
    mutating func removeLast() -> Value? {
        // head가 nil이면 삭제할 것이 없으므로 nil을 반환
        guard let head = head else {
            return nil
        }
        // head뒤에 아무것도 없으면 그냥 pop하면 됨 => head삭제
        guard head.next != nil else {
            return pop()
        }
        //마지막 노드와 마지막 전 노드를 계속 추적해야함. why? 마지막 노드를 삭제할 때 전 노드의 연결을 끊어야 하므로
        var prev = head
        var current = head
        // 다음 노드가 nil일 때 까지 반복.
        while let next = current.next {
            // 이전 노드에 현재 노드를 넣음. => 계속 앞으로 나아감
            prev = current
            // 현재 노드에 다음 노드를 넣음. => 계속 앞으로 나아감
            current = next
        }
        // 마지막 노드까지 왔다면 이전 노드가 가리키는 포인터 연결을 끊음
        prev.next = nil
        // tail도 이전을 가리킴
        tail = prev
        // 연결이 끊긴 마지막 노드를 리턴함
        return current.data

    }
    
    // 특정 노드 뒤의 노드를 삭제한다.
    mutating func remove(after node: Node<Value>) -> Value? {
        defer {
            if node.next === tail {
                tail = node
            }
            node.next = node.next?.next
        }
        return node.next?.data
    }
}

extension LinkedList: CustomStringConvertible {

  public var description: String {
    guard let head = head else {
      return "Empty list"
    }
    return String(describing: head)
  }
}

func main() {
    var linkedList = LinkedList<Int>()
    //4-> 3 -> 1 -> 2
    linkedList.append(1)
    linkedList.append(2)
    linkedList.push(3)
    linkedList.push(4)
    print(linkedList)

    print("Before inserting: \(linkedList)")
    var middleNode = linkedList.node(at: 1)!
    for _ in 1...4 {
        middleNode = linkedList.insert(-1, after: middleNode)
    }
    print(linkedList)

    print("Before popping list: \(linkedList)")
    let poppedValue = linkedList.pop()
    print("After popping list: \(linkedList)")
    print("Popped value: " + String(describing: poppedValue))

    print("Before removing last node: \(linkedList)")
    var removedValue = linkedList.removeLast()

    print("After removing last node: \(linkedList)")
    print("Removed value: " + String(describing: removedValue))


    print("Before removing at particular index: \(linkedList)")
    let index = 1
    let node = linkedList.node(at: index - 1)!
    removedValue = linkedList.remove(after: node)

    print("After removing at index \(index): \(linkedList)")
    print("Removed value: " + String(describing: removedValue))

}
