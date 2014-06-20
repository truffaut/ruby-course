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

  describe "basic init" do
    it "is an ORM" do
      expect(TM.orm).to be_a(TM::ORM)
    end
    it "is created with a db adapter" do
      expect(TM.orm.db_adapter).not_to be_nil
    end
  end # END SINGLETON INIT

  describe "employees" do

    describe "#employee_create(employee_name)" do
      it "creates an employee in the db and returns a EMPLOYEE entity" do
        name = "Bob"
        employee = TM.orm.employee_create(name)
        expect(employee).to be_a(TM::Employee)
        expect(employee.name).to eql(name)
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

  end # END EMPLOYEES

  describe "projects" do

    describe "#project_create(name)" do
      it "creates a project in the database and returns a PROJECT entity" do
        name = "Cooking"
        project = TM.orm.project_create(name)
        expect(project).to be_a(TM::Project)
        expect(project.name).to eql(name)
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

    describe "#projects_show(pid)" do
      it "returns a array of task ENTITIES all with proj_id=pid and complete=false" do
        proj1 = TM.orm.project_create("project 1")
        proj2 = TM.orm.project_create("project 2")
        proj1_tasks = 6.times.map {|idx| TM.orm.task_create(proj1.pid, rand(10), "task #{idx}")}
        proj2_tasks = 12.times.map {|idx| TM.orm.task_create(proj2.pid, rand(10), "task #{idx}")}
        expect(proj1_tasks.all?{|tsk| tsk.is_a? TM::Task}).to eql(true)
        expect(proj1_tasks.count).to eql(6)
        expect(proj1_tasks.all?{|tsk| tsk.pid==proj1.pid}).to eql(true)
        expect(proj2_tasks.all?{|tsk| tsk.is_a? TM::Task}).to eql(true)
        expect(proj2_tasks.all?{|tsk| tsk.pid==proj2.pid}).to eql(true)
        expect(proj2_tasks.count).to eql(12)
      end
    end

    describe "#project_history" do
      it "returns an array of task ENTITIES all with proj_id=pid and complete=true" do
        # REQUIRES mark_completed to work
      end
    end

  end # END PROJECTS

  describe "tasks" do

    describe "#task_create(pid, priority, description)" do
      it "creates a task in the database and returns a TASK entity" do
        proj_id = TM.orm.project_create("somthin!").pid
        task = TM.orm.task_create(proj_id, 5, "AWESOME TASK SO AWESOME!")
        expect(task).to be_a(TM::Task)
        expect(task.creation_time).to be_a(Time)
        expect(task.complete).to eql(false)
        expect(task.desc).to eql("AWESOME TASK SO AWESOME!")
        expect(task.priority).to eql(5)
        expect(task.pid).to eql(proj_id)
        expect(task.tid).to eql(1)
      end
    end

    let(:proj_id) {TM.orm.project_create("somthin!").pid}
    let(:task) {TM.orm.task_create(proj_id, 5, "AWESOME TASK SO AWESOME!")}

    describe "#task_get" do
      it "returns a task ENTITY that's been created in the database" do
        result = TM.orm.task_get(task.tid)
        expect(are_tasks_equal(task, result)).to eq(true)
      end

      it "returned TASK is the correct task" do
        task2 = TM.orm.task_create(proj_id, 6, "AWESOME TASK SO AWESOME!")
        result = TM.orm.task_get(task.tid)
        # binding.pry
        expect(are_tasks_equal(task, result)).to eq(true)
        expect(are_tasks_equal(task2, result)).to eq(false)
      end
    end

    describe "#task_mark(tid)" do
      it "returns a TASK entity that is marked true" do
        result = TM.orm.task_mark(task.tid)
        expect(result).to be_a(TM::Task)
        expect(result.complete).to eql(true)
      end
    end

  end # END TASK BLOCK


end # FINAL END
