require_relative "../config/environment.rb"

class Student

  attr_accessor :id, :name, :grade

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

  def initialize(name, grade, id = nil)
    @id = id
    @name = name
    @grade = grade
  end

  def self.create_table
    sql = <<-SQL
    create table if not exists students (
      id integer primary key,
      name text,
      grade integer
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
    drop table students
    SQL

    DB[:conn].execute(sql)
  end

  def save(student)
    sql = <<-SQL
    insert into students (name, grade) values(?, ?)
    SQL

    DB[:conn].execute(sql, student.name, student.grade)

    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end

  def self.create(name:, grade:)
    student = Student.new(name, grade)
    student.save
    student
  end
end
