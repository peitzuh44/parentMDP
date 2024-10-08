//
//  TaskViewModel.swift
//  parentMDP
//
//  Created by Pei-Tzu Huang on 2024/2/23.
//
import FirebaseAuth
import FirebaseFirestore

//MARK: Task Fetching Configurations

struct FetchTaskConfig {
    let userID: String
    let status: String
    let selectedKidID: String
    let criteria: [Criteria]
    let sortOptions: [SortOption]
    
    enum Criteria {
        case createdBy(String)
        case assignTo(String)
        case privateOrPublic(String)
        case dueDate(Date)
    }
    
    enum SortOption {
        case timeCreated(ascending: Bool)
        case dueDate(ascending: Bool)
        
    }
    
}
class TaskViewModel: ObservableObject {
    @Published var tasks: [TaskInstancesModel] = []
    @Published var completedTasksCountByKid: [String: Int] = [:]
    private let db = Firestore.firestore()
        @Published var totalReviewTasksCount: Int = 0
        @Published var privateReviewTasksCount: Int = 0
        @Published var publicReviewTasksCount: Int = 0
        @Published var reviewTasksCountPerKid: [String: Int] = [:]

    func fetchCompletedPublicTasksForCurrentWeek() {
        let startOfWeek = Date().startOfCurrentWeek()
        let endOfWeek = Date().endOfCurrentWeek()

        db.collection("taskInstances")
            .whereField("status", isEqualTo: "complete")
            .whereField("privateOrPublic", isEqualTo: "public")
            .whereField("due", isGreaterThanOrEqualTo: startOfWeek)
            .whereField("due", isLessThan: endOfWeek)
            .addSnapshotListener { [weak self] (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                    return
                }
                
                // Make sure we're on the main thread since we're updating the UI
                DispatchQueue.main.async {
                    // Reset the counts for a fresh start
                    self?.completedTasksCountByKid = [:]
                    // Process documents
                    querySnapshot?.documents.forEach { document in
                        let task = try? document.data(as: TaskInstancesModel.self)
                        if let completedBy = task?.completedBy {
                            // Initialize if the key doesn't exist, increment if it does
                            self?.completedTasksCountByKid[completedBy, default: 0] += 1
                        }
                    }
                    // Notify the UI to update
                    self?.objectWillChange.send()
                }
            }
    }

    
        // MARK: Task Fetching Count For Status
        // Fetch and update counts for review tasks
        func updateReviewTasksCounts(userID: String, kids: [KidModel]) {
            fetchReviewTasksCount(userID: userID, privateOrPublic: nil, kidID: nil) { count in
                self.totalReviewTasksCount = count
            }
            fetchReviewTasksCount(userID: userID, privateOrPublic: "private", kidID: nil) { count in
                self.privateReviewTasksCount = count
            }
            fetchReviewTasksCount(userID: userID, privateOrPublic: "public", kidID: nil) { count in
                self.publicReviewTasksCount = count
            }

            for kid in kids {
                fetchReviewTasksCount(userID: userID, privateOrPublic: "private", kidID: kid.id) { count in
                    self.reviewTasksCountPerKid[kid.id] = count
                }
            }
        }

        private func fetchReviewTasksCount(userID: String, privateOrPublic: String?, kidID: String?, completion: @escaping (Int) -> Void) {
            var query: Query = db.collection("taskInstances")
                .whereField("createdBy", isEqualTo: userID)
                .whereField("status", isEqualTo: "reviewing")
            
            if let privateOrPublic = privateOrPublic {
                query = query.whereField("privateOrPublic", isEqualTo: privateOrPublic)
            }

            if let kidID = kidID {
                query = query.whereField("assignTo", isEqualTo: kidID)
            }

            query.getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error fetching review tasks count: \(error.localizedDescription)")
                    completion(0)
                } else {
                    let count = querySnapshot?.documents.count ?? 0
                    completion(count)
                }
            }
        }
    
    func tasks(forRoutine routine: String, withStatus status: String) -> [TaskInstancesModel] {
        return tasks.filter { $0.routine!.lowercased() == routine.lowercased() && $0.status == status }
        }
    
    func tasks(forStatus status: String) -> [TaskInstancesModel] {
           print("Filtering tasks for routine: \(status)")
        return tasks.filter { $0.status.lowercased() == status.lowercased() }
       }
    // MARK: Fetch Tasks
    
    func fetchTasks(withConfig config: FetchTaskConfig, privateOrPublic: String) {
        var query: Query = db.collection("taskInstances")
        let calendar = Calendar.current
        var orderByDueDateApplied = false


        print("Debug: Fetching tasks with configuration:")
                config.criteria.forEach { criterion in
                    print("Debug: - Criterion: \(criterion)")
                }
                config.sortOptions.forEach { sortOption in
                    print("Debug: - SortOption: \(sortOption)")
                }

        for criterion in config.criteria {
            switch criterion {
            case .createdBy(let userID):
                query = query.whereField("createdBy", isEqualTo: userID)
                print("Debug: Applying 'createdBy' filter for userID: \(userID)")
                
            case .assignTo(let kidID):
                // Apply the assignTo filter conditionally based on isPublicTask flag
                if privateOrPublic == "private" {
                    print("Debug: Applying 'assignTo' filter for kidID: \(kidID)")
                    query = query.whereField("assignTo", isEqualTo: kidID)
                }


            case .privateOrPublic(let value):
                print("Debug: Applying 'privateOrPublic' filter for value: \(value)")
                query = query.whereField("privateOrPublic", isEqualTo: value)
                print("Debug: Applying 'privateOrPublic' filter for value: \(value)")
            case .dueDate(let dueDate):
                let startOfDay = calendar.startOfDay(for: dueDate)
                let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) ?? dueDate
                query = query.whereField("due", isGreaterThanOrEqualTo: startOfDay)
                             .whereField("due", isLessThan: endOfDay)
                             .order(by: "due")
                orderByDueDateApplied = true
                print("Debug: Applying 'dueDate' filter from \(startOfDay) to \(endOfDay), ordering by 'due'")
            }
        }

            // Apply sorting, ensuring dueDate's order is respected
        for sortOption in config.sortOptions {
               switch sortOption {
               case .timeCreated(let ascending):
                   if !orderByDueDateApplied {
                       query = query.order(by: "timeCreated", descending: !ascending)
                       print("Debug: Applying 'timeCreated' sort, ascending: \(ascending)")
                   } else {
                       print("Debug: Skipping 'timeCreated' sort due to prior 'dueDate' ordering")
                   }
               case .dueDate(let ascending):
                   if !orderByDueDateApplied {
                       query = query.order(by: "due", descending: !ascending)
                       print("Debug: Applying secondary 'dueDate' sort, ascending: \(ascending)")
                   } else {
                       print("Debug: Skipping duplicate 'dueDate' sort")
                   }
               }
           }
        
        // Execute query
        query.addSnapshotListener { [weak self] querySnapshot, error in
            if let error = error {
                print("Debug: Error fetching documents: \(error.localizedDescription)")
                return
            }
            guard let documents = querySnapshot?.documents else {
                print("Debug: No documents found with the given criteria.")
                return
            }

            print("Debug: Fetched \(documents.count) documents.")
            self?.tasks = documents.compactMap { doc -> TaskInstancesModel? in
                try? doc.data(as: TaskInstancesModel.self)
            }
        }
    }

    
    
    // MARK: Fetch Review Task
//    func fetchReviewTask(forUserID userID: String) {
//        db.collection("taskInstances")
//            .whereField("createdBy", isEqualTo: userID)
//            .whereField("status", isEqualTo: "reviewing")
//            .order(by: "due", descending: false)
//            .order(by: "timeCreated", descending: false)
//            .addSnapshotListener { [weak self] querySnapshot, error in
//                guard let documents = querySnapshot?.documents else {
//                    print("Error fetching documents: \(String(describing: error?.localizedDescription))")
//                    return
//                }
//
//                self?.tasks = documents.compactMap { doc -> TaskInstancesModel? in
//                    try? doc.data(as: TaskInstancesModel.self)
//                }
//            }
//        
//    }
    
    // MARK: Fetch Tasks
//    func fetchTasks(forUserID userID: String, dateToFetch: Date, selectedKidID: String, privateOrPublic: String){
//        
//        if privateOrPublic == "private"  {
//            fetchPrivateTasks(forUserID: userID, dateToFetch: dateToFetch, selectedKidID: selectedKidID)
//            print("Fetching private tasks...")
//        }
//        if privateOrPublic == "public" {
//            fetchPublicTasks(forUserID: userID, dateToFetch: dateToFetch)
//            print("Fetching public tasks...")
//        }
//
//        
//        
//    }
    
    // MARK: Fetch Private Task
    func fetchPrivateTasks(forUserID userID: String, dateToFetch: Date, selectedKidID: String){
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: dateToFetch)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) ?? dateToFetch

        db.collection("taskInstances")
            .whereField("createdBy", isEqualTo: userID)
            .whereField("due", isGreaterThanOrEqualTo: startOfDay)
            .whereField("due", isLessThan: endOfDay)
            .whereField("assignTo", isEqualTo: selectedKidID)
            .whereField("privateOrPublic", isEqualTo: "private")
            .order(by: "due", descending: false)
            .order(by: "timeCreated", descending: false)
            .addSnapshotListener { [weak self] querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(String(describing: error?.localizedDescription))")
                    return
                }

                self?.tasks = documents.compactMap { doc -> TaskInstancesModel? in
                    try? doc.data(as: TaskInstancesModel.self)
                }
            }
    }

    // Fetch Public Task
    func fetchPublicTasks(forUserID userID: String, dateToFetch: Date) {
        let startOfDay = Calendar.current.startOfDay(for: dateToFetch)
        let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay) ?? dateToFetch

        db.collection("taskInstances")
            .whereField("due", isGreaterThanOrEqualTo: startOfDay)
            .whereField("due", isLessThan: endOfDay)
            .whereField("privateOrPublic", isEqualTo: "public") // Ensure this matches your data model
            .order(by: "due", descending: false)
            .addSnapshotListener { [weak self] querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error?.localizedDescription ?? "")")
                    return
                }

                self?.tasks = documents.compactMap { doc -> TaskInstancesModel? in
                    try? doc.data(as: TaskInstancesModel.self)
                }
                print("Public tasks fetched: \(self?.tasks.count ?? 0)")
            }
    }
    
    //MARK: Delete Tasks
    func deleteTask(taskID: String, taskOriginalID: String?, selectedTaskDueDate: Date) {
        if let taskOriginalID = taskOriginalID, !taskOriginalID.isEmpty {
            // The task is part of a repeating series; delete the task original and future instances.
            deleteRepeatingTask(taskOriginalID: taskOriginalID, selectedTaskDueDate: selectedTaskDueDate)
        } else {
            // The task is a one-off task; delete only this task instance.
            db.collection("taskInstances").document(taskID).delete { error in
                if let error = error {
                    print("Error removing one-off task document: \(error)")
                } else {
                    print("One-off task document successfully removed!")
                }
            }
        }
    }
    
    
    // MARK: Delete Rpeating Task
    private func deleteRepeatingTask(taskOriginalID: String, selectedTaskDueDate: Date) {
        // Delete future task instances
        db.collection("taskInstances")
            .whereField("taskOriginalID", isEqualTo: taskOriginalID)
            .whereField("due", isGreaterThanOrEqualTo: Timestamp(date: selectedTaskDueDate))
            .getDocuments { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents for deletion: \(err)")
                    return
                }
                let group = DispatchGroup()
                for document in querySnapshot!.documents {
                    group.enter()
                    document.reference.delete() { error in
                        if let error = error {
                            print("Error removing future instance document: \(error)")
                        }
                        group.leave()
                    }
                }

                // Once all future instances are deleted, delete the taskOriginal
                group.notify(queue: .main) {
                    self.db.collection("taskOriginal").document(taskOriginalID).delete() { error in
                        if let error = error {
                            print("Error deleting taskOriginal: \(error)")
                        } else {
                            print("TaskOriginal and all future instances successfully deleted.")
                        }
                    }
                }
            }
    }
    
    //MARK: Update Task
    func updateTask(_ task: TaskInstancesModel, name: String, timeCreated: Date, createdBy: String, assignTo: String, difficulty: String, routine: String, dueOrStartDate: Date, repeatingPattern: String, selectedDays: [Int]?, privateOrPublic: String) {
        let taskID = task.id
        let taskOriginalID = task.taskOriginalID
        let selectedTaskDueDate = task.due
        
        if !taskOriginalID.isEmpty {
            deleteRepeatingTask(taskOriginalID: taskOriginalID, selectedTaskDueDate: selectedTaskDueDate)
            createPrivateTask(name: name, timeCreated: timeCreated, createdBy: createdBy, assignTo: assignTo, difficulty: difficulty, routine: routine, dueOrStartDate: dueOrStartDate, repeatingPattern: repeatingPattern, selectedDays: selectedDays)
        } else{
            db.collection("taskInstances").document(taskID).delete { error in
                if let error = error {
                    print("Error removing one-off task document: \(error)")
                } else {
                    print("One-off task document successfully removed!")
                }
            }
            createPrivateTask(name: name, timeCreated: timeCreated, createdBy: createdBy, assignTo: assignTo, difficulty: difficulty, routine: routine, dueOrStartDate: dueOrStartDate, repeatingPattern: repeatingPattern, selectedDays: selectedDays)
            // run create new task function now
            
            
        }

        
        
        
    }
}


extension TaskViewModel {
    
    // MARK: Create Tasks
    func createTask(name: String, timeCreated: Date, createdBy: String, assignTo: String, difficulty: String, routine: String, dueOrStartDate: Date, repeatingPattern: String, selectedDays: [Int]?, privateOrPublic: String){
        if privateOrPublic == "private" {
            createPrivateTask(name: name, timeCreated: timeCreated, createdBy: createdBy, assignTo: assignTo, difficulty: difficulty, routine: routine, dueOrStartDate: dueOrStartDate, repeatingPattern: repeatingPattern, selectedDays: selectedDays)
        }
        if privateOrPublic == "public" {
            createPublicTask(name: name, timeCreated: timeCreated, createdBy: createdBy, difficulty: difficulty, dueOrStartDate: dueOrStartDate, repeatingPattern: repeatingPattern, selectedDays: selectedDays, completedBy: "")
            
        }
    }
    
    
    //MARK: Create Private Task
    func createPrivateTask(name: String, timeCreated: Date, createdBy: String, assignTo: String, difficulty: String, routine: String, dueOrStartDate: Date, repeatingPattern: String, selectedDays: [Int]?) {
        
        if repeatingPattern.lowercased() == "does not repeat" {
            createOneOffPrivateTask(name: name, timeCreated: timeCreated, createdBy: createdBy, assignTo: assignTo, difficulty: difficulty, routine: routine, repeatingPattern: repeatingPattern, due: dueOrStartDate)
        } else {
            createRepeatingPrivateTask(name: name, timeCreated: timeCreated, createdBy: createdBy, difficulty: difficulty, routine: routine, repeatingPattern: repeatingPattern, selectedDays: selectedDays, startDate: dueOrStartDate, assignTo: assignTo)
            
        }
        
        // MARK: Create One-off Private Task
        func createOneOffPrivateTask(name: String, timeCreated: Date, createdBy: String, assignTo: String, difficulty: String, routine: String, repeatingPattern: String, due: Date){
            let db = Firestore.firestore()
            let newTaskInstancesRef = db.collection("taskInstances").document()
            let taskInstancesID = newTaskInstancesRef.documentID
            let taskInstances =
            TaskInstancesModel(id: taskInstancesID, name: name, timeCreated: timeCreated, createdBy: createdBy, difficulty: difficulty, due: due, repeatingPattern: repeatingPattern, taskOriginalID: "", status: "todo", routine: routine, assignTo: assignTo, completedBy: "", privateOrPublic: "private")
            do {
                try db.collection("taskInstances").document(taskInstancesID).setData(from: taskInstances)
            } catch let error {
                print("Error: \(error)")
            }
        }
        
        // MARK: Create repeating private task
        func createRepeatingPrivateTask(name: String, timeCreated: Date, createdBy: String, difficulty: String, routine: String, repeatingPattern: String, selectedDays: [Int]?, startDate: Date, assignTo: String){
            let db = Firestore.firestore()
            let newTaskOriginalRef = db.collection("taskOriginal").document()
            let taskOriginalID = newTaskOriginalRef.documentID
            let taskOriginal = TaskOriginalModel(id: taskOriginalID, name: name, timeCreated: timeCreated, createdBy: createdBy, difficulty: difficulty, repeatingPattern: repeatingPattern, selectedDays: selectedDays, startDate: startDate, routine: routine, assignTo: assignTo, privateOrPublic: "private")
            
            do {
                try newTaskOriginalRef.setData(from: taskOriginal)
                generatePrivateTaskInstances(privateTaskOriginal: taskOriginal, selectedDays: selectedDays)
            } catch let error {
                print("Error creating task original: \(error)")
            }
        }
    }
    
    // MARK: Create Public Task
    func createPublicTask(name: String, timeCreated: Date, createdBy: String, difficulty: String, dueOrStartDate: Date, repeatingPattern: String, selectedDays: [Int]?, completedBy: String) {
        
        if repeatingPattern.lowercased() == "does not repeat" {
            createOneOffPublicTask(name: name, timeCreated: timeCreated, createdBy: createdBy, difficulty: difficulty, repeatingPattern: repeatingPattern, due: dueOrStartDate)
        } else {
            createRepeatingPublicTask(name: name, timeCreated: timeCreated, createdBy: createdBy, difficulty: difficulty, repeatingPattern: repeatingPattern, selectedDays: selectedDays, startDate: dueOrStartDate)
            
        }
        
        // MARK: Create Oneoff Public Task
        func createOneOffPublicTask(name: String, timeCreated: Date, createdBy: String, difficulty: String, repeatingPattern: String, due: Date){
            let db = Firestore.firestore()
            let newTaskInstancesRef = db.collection("taskInstances").document()
            let taskInstancesID = newTaskInstancesRef.documentID
            let taskInstances =
            TaskInstancesModel(
                id: taskInstancesID,
                name: name,
                timeCreated: timeCreated,
                createdBy: createdBy,
                difficulty: difficulty,
                due: due,
                repeatingPattern: repeatingPattern,
                taskOriginalID: "",
                status: "todo",
                routine: "no routine",
                assignTo: "",
                completedBy: "",
                privateOrPublic: "public")
            do {
                try db.collection("taskInstances").document(taskInstancesID).setData(from: taskInstances)
            } catch let error {
                print("Error: \(error)")
            }
        }
        
        // MARK: Create repeating public task
        func createRepeatingPublicTask(name: String, timeCreated: Date, createdBy: String, difficulty: String, repeatingPattern: String, selectedDays: [Int]?, startDate: Date){
            let db = Firestore.firestore()
            let newTaskOriginalRef = db.collection("taskOriginal").document()
            let taskOriginalID = newTaskOriginalRef.documentID
            let taskOriginal = TaskOriginalModel(id: taskOriginalID, name: name, timeCreated: timeCreated, createdBy: createdBy, difficulty: difficulty, repeatingPattern: repeatingPattern, selectedDays: selectedDays, startDate: startDate, routine: "", assignTo: "", privateOrPublic: "public")
            
            do {
                try newTaskOriginalRef.setData(from: taskOriginal)
                generatePublicTaskInstances(publicTaskOriginal: taskOriginal, selectedDays: selectedDays)
            } catch let error {
                print("Error creating task original: \(error)")
            }
        }
    }
    
    
    // MARK: Generate private task instances
    func generatePrivateTaskInstances(privateTaskOriginal: TaskOriginalModel, selectedDays: [Int]?) {
        let db = Firestore.firestore()
        var nextDueDate = privateTaskOriginal.startDate
        
        while shouldContinueGeneratingTaskInstances(startingFrom: nextDueDate) {
            let newTaskInstancesRef = db.collection("taskInstances").document()
            let taskInstances =
            TaskInstancesModel(
                id: newTaskInstancesRef.documentID,
                name:privateTaskOriginal.name,
                timeCreated: privateTaskOriginal.timeCreated,
                createdBy: privateTaskOriginal.createdBy,
                difficulty: privateTaskOriginal.difficulty,
                due: nextDueDate,
                repeatingPattern: privateTaskOriginal.repeatingPattern,
                taskOriginalID: privateTaskOriginal.id,
                status: "todo",
                routine: privateTaskOriginal.routine,
                assignTo: privateTaskOriginal.assignTo,
                completedBy: "",
                privateOrPublic: "private"
            )
            
            do {
                try newTaskInstancesRef.setData(from: taskInstances)
            } catch let error {
                print("Error creating task instance: \(error)")
            }
            
            nextDueDate = getNextDueDate(currentDueDate: nextDueDate, repeatingPattern: privateTaskOriginal.repeatingPattern, selectedDays: selectedDays)
        }
    }
    
    // MARK: Generate Public Task Instances
    func generatePublicTaskInstances(publicTaskOriginal: TaskOriginalModel, selectedDays: [Int]?) {
        let db = Firestore.firestore()
        var nextDueDate = publicTaskOriginal.startDate
        
        while shouldContinueGeneratingTaskInstances(startingFrom: nextDueDate) {
            let newTaskInstancesRef = db.collection("taskInstances").document()
            let taskInstances =
            TaskInstancesModel(
                id: newTaskInstancesRef.documentID,
                name:publicTaskOriginal.name,
                timeCreated: publicTaskOriginal.timeCreated,
                createdBy: publicTaskOriginal.createdBy,
                difficulty: publicTaskOriginal.difficulty,
                due: nextDueDate,
                repeatingPattern: publicTaskOriginal.repeatingPattern,
                taskOriginalID: publicTaskOriginal.id,
                status: "todo",
                routine: "",
                assignTo: "",
                completedBy: "",
                privateOrPublic: "public"
            )
            
            do {
                try newTaskInstancesRef.setData(from: taskInstances)
            } catch let error {
                print("Error creating task instance: \(error)")
            }
            
            nextDueDate = getNextDueDate(currentDueDate: nextDueDate, repeatingPattern: publicTaskOriginal.repeatingPattern, selectedDays: selectedDays)
        }
    }
    
    
}


// MARK: Generate next due date
func getNextDueDate(currentDueDate: Date, repeatingPattern: String, selectedDays: [Int]?) -> Date {
    let calendar = Calendar.current

    switch repeatingPattern {
    case "Everyday":
        return calendar.date(byAdding: .day, value: 1, to: currentDueDate)!

    case "Every week":
        return calendar.date(byAdding: .weekOfYear, value: 1, to: currentDueDate)!

    case "Every weekday":
        // Get the next weekday date
        var nextDate = currentDueDate
        repeat {
            nextDate = calendar.date(byAdding: .day, value: 1, to: nextDate)!
            let selectedDays = calendar.component(.weekday, from: nextDate)
            if calendar.isDateInWeekend(nextDate) == false {
                return nextDate
            }
        } while true

    case "Every weekend":
        // Get the next weekend date
        var nextDate = currentDueDate
        repeat {
            nextDate = calendar.date(byAdding: .day, value: 1, to: nextDate)!
            if calendar.isDateInWeekend(nextDate) {
                return nextDate
            }
        } while true

    case "Custom repeat":
        // Custom repeat logic based on selectedDays
        guard let selectedDays = selectedDays, !selectedDays.isEmpty else {
            return currentDueDate // If no days are selected, return the current due date
        }
        var nextDate = currentDueDate
        repeat {
            nextDate = calendar.date(byAdding: .day, value: 1, to: nextDate)!
            let weekday = calendar.component(.weekday, from: nextDate)
            if selectedDays.contains(weekday) {
                return nextDate
            }
        } while true

    default:
        return currentDueDate
    }
}

func shouldContinueGeneratingTaskInstances(startingFrom date: Date) -> Bool {
    let calendar = Calendar.current
    guard let twoMonthsLater = calendar.date(byAdding: .month, value: 2, to: Date()) else {
        return false
    }
    return date <= twoMonthsLater
}



extension TaskViewModel {
    
    // MARK: Reward Calculation
    func coinAmount(difficulty: String) -> Int {
        // Example difficulty mapping, adjust as necessary
        switch difficulty {
        case "Easy": return 10
        case "Medium": return 20
        case "Hard": return 30
        default: return 0
        }
    }
    
    func completeTaskAndUpdateKidCoin(task: TaskInstancesModel, completedBy: String?) {
        // First, mark the challenge as complete.
        
        if task.privateOrPublic == "private" {
            markPrivateTaskAsComplete(taskID: task.id) { [self] in
                self.updateKidCoinBalance(kidID: task.assignTo!, coinToAdd: coinAmount(difficulty: task.difficulty))
            }
        }
        if task.privateOrPublic == "public" {
            markPublicTaskAsComplete(taskID: task.id, selectedKidID: completedBy!) { [self] in
                self.updateKidCoinBalance(kidID: completedBy!, coinToAdd: coinAmount(difficulty: task.difficulty))
            }
        }

    }

// MARK: Mark private task as complete
func markPrivateTaskAsComplete(taskID: String, completion: @escaping () -> Void) {
        let taskRef = db.collection("taskInstances").document(taskID)
        taskRef.updateData(["status": "complete"]) { error in
            if let error = error {
                print("Error updating challenge status: \(error)")
            } else {
                print("Challenge marked as complete")
                completion()
            }
        }
    }
    
// MARK: Mark public task as complete
func markPublicTaskAsComplete(taskID: String, selectedKidID: String, completion: @escaping () -> Void) {
    
    let taskRef = db.collection("taskInstances").document(taskID)
    taskRef.updateData(
        ["status": "complete",
         "completedBy": selectedKidID
        ]
    ) { error in
        if let error = error {
            print("Error updating challenge status: \(error)")
        } else {
            print("Challenge marked as complete")
            completion()
        }
    }
}

// MARK: Update kid coinBalance
private func updateKidCoinBalance(kidID: String, coinToAdd: Int) {
        let kidRef = db.collection("kids").document(kidID)
        db.runTransaction({ (transaction, errorPointer) -> Any? in
            let kidDocument: DocumentSnapshot
            do {
                try kidDocument = transaction.getDocument(kidRef)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }
            guard let oldCoinBalance = kidDocument.data()?["coinBalance"] as? Int else {
                let error = NSError(domain: "AppErrorDomain", code: -1, userInfo: [
                    NSLocalizedDescriptionKey: "Unable to retrieve coin balance from snapshot \(kidDocument)"
                ])
                errorPointer?.pointee = error
                return nil
            }
            transaction.updateData(["coinBalance": oldCoinBalance + coinToAdd], forDocument: kidRef)
            return nil
        }) { (object, error) in
            if let error = error {
                print("Transaction failed: \(error)")
            } else {
                print("Transaction successfully committed!")
            }
        }
    }
}





// MARK: Mark complete by kid



extension TaskViewModel {
    
    func markAsCompleteByKids(updatedTask: TaskInstancesModel) {
        let docRef = db.collection("taskInstancesModel").document(updatedTask.id)
        
        let updateData: [String: Any] = [
            "status": "reviewing"
        ]
        
        docRef.updateData(updateData) { error in
            if let error = error {
                print("Error updating reward: \(error)")
            } else {
                print("Reward successfully updated")
                // You could perform additional tasks here, like notifying the user of the success
            }
        }
    }
    
}

