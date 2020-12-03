//
//  PairsController.swift
//  Pair
//
//  Created by Jason Koceja on 12/3/20.
//

import Foundation


class PairsController {
    
    // MARK: - Properties
    
    static var shared = PairsController()
    
    var groups: [[String]] = []
    var lonelys: [Int] {
        var indexesOfGroupsOfLonelys: [Int] = []
        for (index,group) in groups.enumerated() {
            if group.count < 2 {
                indexesOfGroupsOfLonelys.append(index)
            }
        }
        return indexesOfGroupsOfLonelys
    }
    
    // MARK: - Initializer
    
    init() {
        loadGroups()
    }
    
    // MARK: - Helpers
    
    func populateGroups(){
        var names: [String] = []
        for group in groups {
            for person in group {
                names.append(person)
            }
        }
        populateGroups(names)
    }
    
    func populateGroups(_ names: [String]) {
        var newGroup: [[String]] = []
        var pair: [String] = []
        for (index,name) in names.enumerated() {
            let oddOrEven = (index + 2) % 2
            switch (oddOrEven) {
                case 0:
                    pair = []
                    pair.append(name)
                    if index == names.count - 1 {
                        newGroup.append(pair)
                    }
                case 1:
                    pair.append(name)
                    newGroup.append(pair)
                default:
                    break
            }
        }
        groups = newGroup
        saveGroups()
    }
    
    func groupOfOne() -> Int? {
        for (index, group) in groups.enumerated() {
            if group.count < 2 {
                return index
            }
        }
        return nil
    }
    
    func groupsOfOne() -> [Int] {
        var indexesOfGroupsOfLonelys: [Int] = []
        for (index, group) in groups.enumerated() {
            if group.count < 2 {
                indexesOfGroupsOfLonelys.append(index)
            }
        }
        return indexesOfGroupsOfLonelys
    }
    
    // CRUD
    //  create
    func addPersonWithName(_ name: String) {
        if let indexLonelyGroup = groupOfOne() {
            var group = groups[indexLonelyGroup]
            group.append(name)
            groups[indexLonelyGroup] = group
        } else {
            groups.append([name])
        }
        saveGroups()
    }
    
    //  update
    func randomizePairs() {
        var peopleToRandomize: [String] = []
        for group in groups {
            for person in group {
                peopleToRandomize.append(person)
            }
        }
        let shuffled = peopleToRandomize.shuffled()
        populateGroups(shuffled)
    }
    
    func pairLonelys() -> Bool {
        let indexes = groupsOfOne()
        if indexes.count > 1 && groups.count > 1 {
            let indexA = indexes[0]
            let indexB = indexes[1]
            var groupA = groups[indexA]
            let groupB = groups[indexB]
            let lonelyToPair = groupB[0]
            groupA.append(lonelyToPair)
            groups.remove(at: indexB)
            groups[indexA] = groupA
            saveGroups()
            return true
        } else {
            return false
        }
    }
    
    //  delete
    func removePersonAtIndexPath(_ indexPath: IndexPath) {
        let groupIndex = indexPath.section
        let personIndex = indexPath.row
        var group = groups[groupIndex]
        group.remove(at: personIndex)
        groups[groupIndex] = group
        saveGroups()
    }
    
    // MARK: - Persistence
    
    func loadGroups() {
        if let loadedGroups = UserDefaults.standard.array(forKey: "Groups") as? [[String]] {
            groups = loadedGroups
        } else {
            print("[\(#fileID):\(#function): \(#line)] -- ERROR: Failed to load groups")
        }
        populateGroups()
    }
    
    func saveGroups() {
        UserDefaults.standard.setValue(groups, forKey: "Groups")
    }
}
