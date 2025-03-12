class TaskTemplate < ApplicationRecord
  validates :name, presence: true
  validates :description, presence: true
  
  has_many :task_template_fields
  
  def create_work_package(project_id, author_id)
    WorkPackage.new(
      project_id: project_id,
      author_id: author_id,
      subject: name,
      description: description
      # Add other attributes from template fields
    )
  end
end
