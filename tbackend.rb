require 'sqlite3'
require 'colorize'



class TaskDatabase
  attr_accessor :table, :task, :desc, :date


  def initialize(table)
    @table = table
    @task = task
    @desc = desc
    @date = date
    unless File.exist?("/home/span/bin/tasks.db")
      @db = SQLite3::Database.new("tasks.db")
      @db.execute("CREATE TABLE IF NOT EXISTS #{@table}(Id INTEGER PRIMARY KEY, Task TEXT, Desc TEXT, Date TEXT)")
    else
      @db = SQLite3::Database.open("/home/span/bin/tasks.db")
    end
  end


  def get_id
    id = @db.last_insert_row_id
    if id == 0
      return 1
    else
      return id
    end
  end
      

  def add_task(task,desc,date)
    id = get_id 
    @db.execute("INSERT INTO #{@table}(Task,Desc,Date) VALUES ('#{task}', '#{desc}', '#{date}')")
  end


  def get_task(id)
    @st = @db.prepare("SELECT * FROM #{@table} WHERE Id=#{id}")
    rs = @st.execute
    print_result(rs)
  end
  

  def list_tasks
    @st = @db.prepare("SELECT * FROM #{@table}")
    rs = @st.execute
    print_result(rs)
  end


  def print_result(result)
    system('clear')
    result.each do |row|
      puts row.join "||".colorize(:white)
    end
    pause = gets.chomp
  end


  def close_db
    @st.close if @st
    @db.close if @db
  end


  private :get_id, :print_result


end
