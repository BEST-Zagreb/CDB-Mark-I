class Company
  include DataMapper::Resource
  
  property :id,   Serial
  property :name, String
  property :url, String
  property :phone, String
  property :address, String
  property :city, String
  property :zip, String
  property :country, String
  property :budgeting_month, String
  property :comment, String
  
  has n, :people
  has n, :collaborations
  #has n, :projects

  before :save, :fix_url
  before :save, :nulify_blank
  
  def address?
    not (address.blank? and city.blank? and zip.blank? and country.blank?)
  end
  
  def address_components
    [address, city_with_zip, country].reject {|c| c.blank? }
  end
  
  def city_with_zip
    [zip, city].join(' ')
  end
  
  def to_s
    name
  end

  protected

  def fix_url
    url.slice!(0..6) if url.starts_with? 'http://'
  end

  def nulify_blank
    self.budgeting_month = nil if budgeting_month == ''
  end

end
