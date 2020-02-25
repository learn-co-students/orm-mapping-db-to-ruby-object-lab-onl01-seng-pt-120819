class Student
  attr_accessor :name, :grade, :id


  def self.new_from_db(row)
    student = self.new
    student.id = row[0]
    student.name =  row[1]
    student.grade = row[2]
    student
  end

  def self.all
    sql = <<-SQL
    SELECT * FROM students
    SQL

    # selects all rows from the database

    DB[:conn].execute(sql).collect do |row|
      self.new_from_db(row)
    end
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
  end

  def self.find_by_name(name)
    sql = <<-SQL
    SELECT * FROM students
    WHERE name = ?
    LIMIT 1
    SQL

    DB[:conn].execute(sql,name).collect do |row|
      self.new_from_db(row)
    end.first
    # find the student in the database given a name .first picks this
    # return a new instance of the Student class
  end

  def self.all_students_in_grade_9
    sql = <<-SQL
    SELECT * FROM students
    WHERE grade = 9
    SQL

    DB[:conn].execute(sql).collect do |row|
      self.new_from_db(row)
    end
  end

  def self.students_below_12th_grade
    sql = <<-SQL
    SELECT * FROM students
    WHERE grade < 12
    SQL

    DB[:conn].execute(sql).collect do |row|
      self.new_from_db(row)
    end
  end

  def self.first_X_students_in_grade_10(number_of_results)
    sql = <<-SQL
    SELECT * FROM students
    WHERE grade = 10
    LIMIT ?
    SQL

    DB[:conn].execute(sql,number_of_results).collect do |row|
      self.new_from_db(row)
    end
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = 10
    SQL
 
    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end.first
  end

  def self.all_students_in_grade_X(grade)
    sql = <<-SQL
    SELECT * FROM students
    WHERE grade = ?
    SQL

    DB[:conn].execute(sql,grade).collect do |row|
      self.new_from_db(row)
    end
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
