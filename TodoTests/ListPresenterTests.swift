//
//  ListPresenterTests.swift
//  TodoTests
//
//  Created by Masahiko Sato on 2017/10/26.
//  Copyright © 2017年 Masahiko Sato. All rights reserved.
//

import XCTest
import RealmSwift
@testable import Todo

class ListViewMock: ListView {
    var presenter: ListPresenter!
    var didCallReloadData: (() -> Void)?
    var didCallShowDetail: ((Todo) -> Void)?
    func reloadData() {
        didCallReloadData?()
    }
    
    func showDetailView(todo: Todo) {
        didCallShowDetail?(todo)
    }
}

class ListPresenterTests: XCTestCase {
    var listView: ListViewMock!
    var listPresenter: ListPresenter!
    lazy var foo: String = {
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
        return "foo"
    }()
    
    override func setUp() {
        super.setUp()
        
        print(foo)
//        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
        var config = Realm.Configuration()
        config.inMemoryIdentifier = self.name
        let realm = try! Realm(configuration: config)
        try! realm.write {
            realm.deleteAll()
        }
        
        listView = ListViewMock()
        listPresenter = ListViewPresenter(
            view: listView,
            realm: realm
        )
        listView.presenter = listPresenter
    }
    
    func testReload() {
        let expectation = self.expectation(description: "testReloadData expectation")
        
        listView.didCallReloadData = {
            expectation.fulfill()
        }
        
        listPresenter.add(title: "foo")
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testShowDetail() {
        let expectation = self.expectation(description: "testSwhoDetail expectation")
        
        let index = listPresenter.numberOfTodos - 1
        let todo = listPresenter.todo(at: index)
        
        listView.didCallShowDetail = { t in
            expectation.fulfill()
            XCTAssertEqual(t.id, todo.id)
        }
        
        listPresenter.showDetail(at: index)
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testAdd() {
        let firstTitle = "first todo"
        let secondTitle = "second todo"
        
        listPresenter.add(title: firstTitle)
        listPresenter.add(title: secondTitle)
        
        let firstTodo = listPresenter.todo(at: 0)
        XCTAssertEqual(firstTodo.title, firstTitle)
        
//        let secondTodo = listPresenter.todo(at: 1)
//        XCTAssertEqual(secondTodo.title, secondTitle)
    }
    
//    func testNumberOfTodos() {
//        let range = (0...3)
//        for i in range {
//            listPresenter.add(title: "\(i) todo")
//        }
//                
//        XCTAssertEqual(listPresenter.numberOfTodos, range.count)
//    }
    
}
