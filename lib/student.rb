
# Remember, you can access your database connection anywhere in this class with DB[:conn]

class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    new_student = self.new #self.new is the same as running Student.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student #return the newly created instance
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = <<-SQL
        SELECT *
        FROM students
    SQL
    
    DB[:conn].execute(sql).collect do |row| #return all student instances from the db
      self.new_from_db(row)
    end
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE name = ?
      LIMIT 1
    SQL

    DB[:conn].execute(sql, name).map do |row|
      self.new_from_db(row)
    end.first
  end
  
  def save #saves an instance of the Student class to the database
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table #creates the students table in the database
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table  #drops the students table from the database
    sql = "DROP TABLE IF EXISTS students" #you can write it as a direct string or heredoc
    DB[:conn].execute(sql)
  end

##########

  def self.all_students_in_grade_9
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE students.grade = 9
    SQL

    DB[:conn].execute(sql)
  end

    def self.students_below_12th_grade
      sql = <<-SQL
        SELECT *
        FROM students
        WHERE students.grade < 12
      SQL

      DB[:conn].execute(sql).collect do |row| #iterate over each row and use the self.new_from_db method to create a new Ruby object for each row
        self.new_from_db(row)
      end
    end

    def self.first_X_students_in_grade_10(x)  #returns an array of the first X students in grade 10.
                                              #you need an argument to input for LIMIT '?' and don't forget to add it to the execute method
      sql = <<-SQL
        SELECT *
        FROM students
        WHERE students.grade = 10
        LIMIT ?
      SQL

      DB[:conn].execute(sql, x).collect do |row| #iterate over each row and use the self.new_from_db method to create a new Ruby object for each row
        self.new_from_db(row)
      end
    end

    def self.first_student_in_grade_10 #returns the first student in grade 10
      sql = <<-SQL
        SELECT *
        FROM students
        WHERE students.grade = 10
      SQL

      DB[:conn].execute(sql).collect do |row|
        self.new_from_db(row)
      end.first #chain .first to end of the DB[:conn].execute(sql).collect or .map block
                #the return value of .collect or .map is an array and we are simply grabbing the .first element from the returned array
    end

    def self.all_students_in_grade_X(x)
      sql = <<-SQL
        SELECT *
        FROM students
        WHERE students.grade = ?
      SQL

      DB[:conn].execute(sql, x).collect do |row|
        self.new_from_db(row)
      end
      
    end

end