
class Employee
  attr_accessor :name, :title, :salary, :boss

  def initialize(name,title,salary,boss)
    @name = name
    @title = title
    @salary = salary
    @boss = boss
  end

  def bonus(mult)
    salary * mult
  end


end

class Manager < Employee

  attr_accessor :employees

  def initialize(name, title, salary, boss)
    # super(name, title, salary,boss)
    super
    @employees = []

  end

  def add_employee(employee)
    @employees << employee
  end

  def bonus(mult)
    sum = 0
    @employees.each do |employee|
      if employee.is_a?(Manager)
        sum += employee.bonus(mult)
      else
        sum += employee.salary * mult
      end
    end
    sum
  end
end

