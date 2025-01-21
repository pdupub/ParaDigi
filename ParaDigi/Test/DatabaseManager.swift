import Foundation
import SQLite

class DatabaseManager {
    static let shared = DatabaseManager()
    private let db: Connection?

    // 这里直接写 "id", "name", "age" 这类列名即可
    private let usersTable = Table("users")
    private let id = SQLite.Expression<Int64>("id")
    private let name = SQLite.Expression<String>("name")
    private let age = SQLite.Expression<Int>("age")

    private init() {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            .first!
            .appendingPathComponent("app.sqlite3")
            .path

        do {
            db = try Connection(path)
            createTable()
        } catch {
            db = nil
            print("Unable to open database: \(error)")
        }
    }

    private func createTable() {
        do {
            try db?.run(usersTable.create(ifNotExists: true) { table in
                table.column(id, primaryKey: .autoincrement)
                table.column(name)
                table.column(age)
            })
        } catch {
            print("Failed to create table: \(error)")
        }
    }

    func insertUser(name: String, age: Int) {
        do {
            // 这儿和上边定义的 name/age 类型对应
            let insert = usersTable.insert(self.name <- name, self.age <- age)
            try db?.run(insert)
            print("Insert user success: \(name), \(age)")
        } catch {
            print("Failed to insert user: \(error)")
        }
    }

    func fetchUsers() -> [(Int64, String, Int)] {
        var users: [(Int64, String, Int)] = []
        do {
            for user in try db!.prepare(usersTable) {
                let userData = (user[id], user[name], user[age])
                users.append(userData)
            }
        } catch {
            print("Failed to fetch users: \(error)")
        }
        return users
    }
}

