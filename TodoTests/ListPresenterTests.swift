//
//  ListPresenterTests.swift
//  TodoTests
//
//  Created by Masahiko Sato on 2017/10/26.
//  Copyright © 2017年 Masahiko Sato. All rights reserved.
//

import XCTest
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
    
    override func setUp() {
        super.setUp()
        
        listView = ListViewMock()
        listPresenter = ListViewPresenter(view: listView)
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
    
}
