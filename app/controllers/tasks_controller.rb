# frozen_string_literal: true

class TasksController < ApplicationController
  def index
    tasks = user.tasks

    serialized_tasks = tasks.map do |task|
      {
        'id' => task.id,
        'userId' => user.id,
        'status' => task.status,
        'name' => task.name,
        'createdAt' => task.created_at,
        'completedAt' => task.completed_at
      }
    end

    render(json: serialized_tasks)
  end

  def show
    task = user.tasks.find(params[:id])

    serialized_task = {
      'id' => task.id,
      'userId' => user.id,
      'status' => task.status,
      'name' => task.name,
      'createdAt' => task.created_at,
      'completedAt' => task.completed_at
    }

    render(json: serialized_task)
  end

  def create
    task = user.tasks.new(create_task_params.merge(status: :pending))

    if task.save
      serialized_task = {
        'id' => task.id,
        'userId' => user.id,
        'status' => task.status,
        'name' => task.name,
        'createdAt' => task.created_at,
        'completedAt' => task.completed_at
      }

      render(status: :created, json: serialized_task)
    else
      serialized_error = {
        'error' => {
          'message' => 'Validation error',
          'details' => task.errors.full_messages
        }
      }

      render(status: :unprocessable_entity, json: serialized_error)
    end
  end

  def complete
    task = user.tasks.find(params[:id])

    task.update!(status: :completed, completed_at: Time.current)

    IssueNotification.call(task:)

    render(json: TaskSerializer.new(task, user).as_json)
  end

  private

  def user
    @user ||= User.find(params[:user_id])
  end

  def create_task_params
    params.require(:task).permit(:name)
  end
end
