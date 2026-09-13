class Collaboration
  include DataMapper::Resource
  
  property :id, Serial
  property :responsible, String
  property :comment, Text
  property :priority, Boolean
  property :contacted, Boolean
  property :letter, Boolean
  property :meeting, Boolean
  property :successful, Boolean
 # property :created_at, DateTime
 # property :updated_at, DateTime
  property :amount, Float
  property :contact_in_future, Boolean
  property :type, String

  property :company_id, Integer
  property :project_id, Integer
  property :person_id, Integer

  belongs_to :company
  belongs_to :project
  belongs_to :person, :required => false
  
  before :save, :nulify_blank
  
  def unsuccessful?
    successful == false
  end
  
  def pending?
    successful.nil?
  end
  
  protected
  
  def nulify_blank
    self.person_id = nil if person_id == ''
    self.successful = nil if successful == ''
    self.amount = nil if amount.to_s() == ''
    self.type = nil if type.to_s() == ''
  end
end
