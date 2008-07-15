class Stamp 
  include DataMapper::Resource
  property :digest, String,:size => 40, :key => true
  property :created_at, DateTime
  validates_length :digest,:is=>40
  has n,:referrers
  
  def timestamp
    created_at
  end
  
  def utc
    self.created_at#.gmtime
  end
  
  def to_text
    utc
  end
  
  def to_ini
    "# Go to http://timecert.org for more info\ndigest=#{self.digest}\ntimestamp=#{self.utc}"
  end
  
  def record_referrer(referrer)
    referrers.create(:url=>referrer) if referrer&&referrer!=''&&referrer!='/'
  end
end
