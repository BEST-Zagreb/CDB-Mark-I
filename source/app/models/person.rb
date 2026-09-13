class Person
  include DataMapper::Resource
  
  property :id,    Serial
  property :name,  String
  property :email, String
  property :phone, String
  property :function, String
 # property :created_at, DateTime
  
  belongs_to :company
  
  def to_s
    name
  end
end
