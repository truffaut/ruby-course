require 'spec_helper'

describe "ORM" do

  RSpec::Mocks::setup(self)

  before(:all) do
     TM.orm.instance_variable_set(:@__orm_instance, PG.connect(host: 'localhost', dbname: 'task-manager-test'))
  end
  before(:each) do
    # IO.any_instance.stub(:puts)
    TM.orm.reint_database
  end

  it "is an ORM" do
    expect(TM.orm).to be_a(TM::ORM)
  end
  it "is created with a db adapter" do
    expect(TM.orm.db_adapter).not_to be_nil
  end

  describe "#employee_create(employee_name)" do
    it "creates an employee in the db and returns a EMPLOYEE entity" do
      name = "Bob"
      employee = TM.orm.employee_create(name)
      expect(employee).to be_a(TM::Employee)
      expect(employee.name).to eql(name)
    end
  end
  describe "#project_create(name)" do
    it "creates a project in the database and returns a PROJECT entity" do
      name = "Cooking"
      project = TM.orm.project_create(name)
      expect(project).to be_a(TM::Project)
      expect(project.name).to eql(name)
    end
  end
  describe "#task_create(pid, priority, description)" do
    it "creates a task in the database and returns a TASK entity" do
      proj_id = TM.orm.project_create("somthin!").pid
      task = TM.orm.task_create(proj_id, 5, "AWESOME TASK SO AWESOME!")
      expect(task).to be_a(TM::Task)
      expect(task.priority).to eql(5)
      expect(task.pid).to eql(proj_id)
      expect(task.creation_time).to be_a(Time)
      expect(task.complete).to eql(false)
      expect(task.desc).to eql("AWESOME TASK SO AWESOME!")
      expect(task.tid).to eql(1)
    end
  end

  describe "#employees_list" do
    it "returns an ARRAY of EMPLOYEE entities from the database" do
      names = ["DJ","Awesome Dog", "Panda",
              "Fruit Butt", "Jason Bourne"]
      names.each { |name| TM.orm.employee_create(name)}
      employees = TM.orm.employees_list
      expect(employees).to be_a(Array)
      employees.each_with_index do |employee, i|
        expect(employee.name).to eql(names[i])
      end
    end
  end
  describe "#projects_list" do
    it "returns an ARRAY of PROJECTS entities from the database" do
      names = ["Cooking","Eating", "Panda",
              "Fruit Sculpture", "World Domination"]
      names.each { |name| TM.orm.project_create(name)}
      projects = TM.orm.employees_list
      expect(projects).to be_a(Array)
      projects.each_with_index do |project, i|
        expect(project.name).to eql(names[i])
      end
    end
  end


end # FINAL END
