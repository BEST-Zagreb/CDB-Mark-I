class Project
  include DataMapper::Resource
  
  property :id,   Serial
  property :name, String
  #property :date, Date
 # property :created_at, DateTime
 # property :updated_at, DateTime
  property :fr_goal, Float
  
  #belongs_to :company
  has n, :collaborations

  before :save, :nulify_blank
  
  def filter_collaborations(filters)
    if filters.empty?
      self.collaborations
    else
      # ['contacted', 'meeting', ...]
      filters.inject(nil) { |all, prop|
        scope = self.collaborations(prop => true)
        all ? (all | scope) : scope
      }
    end
  end
  
  def to_s
    name
  end
  
  def nulify_blank
    self.fr_goal = nil if fr_goal.to_s() == ''
  end
  
end
