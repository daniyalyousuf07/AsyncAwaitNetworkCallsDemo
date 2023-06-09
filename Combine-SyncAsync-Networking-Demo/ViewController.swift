//
//  ViewController.swift
//  Combine-SyncAsync-Networking-Demo
//
//  Created by Daniyal Yousuf on 2023-05-13.
//

import UIKit
import Combine

final class ViewController: UIViewController {
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .init(x: 0, y: 0, width: view.frame.width,
                                             height: view.frame.height))
        table.dataSource = self
        table.delegate = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.backgroundColor = .red
        return table
    }()
    
    private var input: PassthroughSubject<CatListViewModel.Input, Never> = .init()
    private var cancellable = Set<AnyCancellable>()
    
    var viewModel: CatListViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = CatListViewModel()
        view.addSubview(tableView)
        bindData()
        input.send(.viewDidAppear)
        title = viewModel?.screenTitle
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        input.send(.cancelTask) //Task can be cancelled based on any condition
    }
}

//MARK: - HELPER METHODS
extension ViewController {
    private func bindData() {
        let output = viewModel?.transform(input: input.eraseToAnyPublisher())
        output?.sink(receiveValue: { [weak self] result in
            if case .fetchCats(result: .success(_)) = result {
                self?.input.send(.refreshView)
            } else if case .fetchCats(result: .failure(let error)) = result {
                print(error)
            } else  if case .refreshView = result {
                self?.tableView.reloadData()
            }
        }).store(in: &cancellable)
    }
}

//MARK: - TABLEVIEW METHODS
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.catList.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = viewModel?.catList[indexPath.row].name
        return cell
    }
}
