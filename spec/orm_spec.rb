require 'spec_helper'

describe "ORM" do

  RSpec::Mocks::setup(self)

  before(:all) do
     TM.orm.instance_variable_set(:@__orm_instance, PG.connect({host: 'localhost', dbname: 'task-manager-test'}))
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


  let(:employee) { TM.orm.employee_create("Bob") }
  before(:each) do
    @name = "Bob"
  end

  describe "employees" do
    describe "#employee_create(employee_name)" do
      it "creates an employee in the db and returns a EMPLOYEE entity" do
        expect(employee).to be_a(TM::Employee)
        expect(employee.name).to eql(@name)
      end
    end

    describe "#employee_get(eid)" do
      it "returns a EMPLOYEE entity from the database" do
        emp = TM.orm.employee_get(employee.eid)
        expect(emp).to be_a(TM::Employee)
        expect(emp.name).to eql(employee.name)
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
      it "returns an ARRAY of PROJECT entities from the database" do
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

    before(:each) do
      @proj1 = TM.orm.project_create("project 1")
      @tasks1_should = 6.times.map {|idx| TM.orm.task_create(@proj1.pid, rand(10), "task #{idx}")}
    end

    describe "list project tasks" do

      describe "#projects_show(pid)" do
        it "returns a array of task ENTITIES all with proj_id=pid and complete=false" do
          results = TM::orm.project_show(@proj1.pid)
          expect(results.count).to eql(@tasks1_should.count)
          results.each_with_index do |tsk, idx|
            expect(are_tasks_equal(tsk, @tasks1_should[idx])).to eql(true)
          end
        end
      end

      describe "#project_history" do
        it "returns an array of task ENTITIES all with proj_id=pid and complete=true" do
          # REQUIRES mark_completed to work
          3.times { |i| TM::orm.task_mark(i+1) }
          results = TM::orm.project_history(@proj1.pid)
          expect(results.count).to eql(3)
          expect(results.all? {|tsk| tsk.complete == true}).to eql(true)
          expect(results.all? {|tsk| tsk.pid == @proj1.pid}).to eql(true)
        end
      end

    end # end project list sub tests

    describe "#project_recruit(pid, eid)" do
      it "returns the row that was just added" do
        employee = TM::orm.employee_create("DJ")
        proj2 = TM::orm.project_create("Boom Town")
        results = TM::orm.project_recruit(proj2.pid,1)
        expect(results["proj_id"].to_i).to eql(proj2.pid)
        expect(results["employee_id"].to_i).to eql(employee.eid)
      end
    end

    describe "#project_employees" do
      it "returns an array of EMPLOYEE entities who are involved in a project" do
        10.times { |i| TM::orm.employee_create("Employee Name #{i+1}")}
        2.times { |i| TM::orm.project_create("Project Name #{i+1}")}

        # proj 1 should have 3 employees
        3.times { |i| TM::orm.project_recruit(1, i+1)}
        # proj 2 should have 8 employees
        8.times { |i| TM::orm.project_recruit(2, i+1)}
        # pending "still being implemented"
        results3 = TM::orm.project_employees(1)
        results8 = TM::orm.project_employees(2)

        expect(results3.count).to eql(3)
        expect(results8.count).to eql(8)

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
