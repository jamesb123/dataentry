# == Schema Information
#
# Table name: genders
#
#  id          :integer(11)   not null, primary key
#  sample_id   :integer(11)   
#  project_id  :integer(11)   
#  gender      :string(255)   
#  gelNum      :string(255)   
#  wellNum     :string(255)   
#  finalResult :boolean(1)    
#  locus       :string(255)   
#

class Gender < ActiveRecord::Base
  belongs_to :locu
  belongs_to :sample
#  extend Exportables::ExportableModel
#  extend GoToOrganismCode::Model
#  include SecuritySets::ProjectBased
#  include ProjectRelations
#  include ApprovalModelHelpers
  
  validates_presence_of :locus

  def to_label 
    "#{id}" 
  end
end
