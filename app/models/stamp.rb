class Stamp 
  include DataMapper::Resource
  property :digest, String,:size => 40, :key => true
  property :created_at, Time
  validates_length :digest,:is=>40
  validates_format :digest,:as=>/[\dabcdef]{40}/
  has n,:referrers
  
  @@cache=FifoCache.new(1000) do |digest|
    Merb.logger.debug "Loading into Cache"
    Stamp.first_or_create(:digest=>digest)
  end
  
  def self.by_digest(digest)
    @@cache[digest]
  end
    
  def timestamp
    self.created_at
  end
  
  def utc
    self.timestamp.utc
  end
  
  def referrer
    @referrer||=referrers.first
  end
  
  def to_text
    utc.to_s
  end
  
  def to_yaml
    to_hash.to_yaml
  end
    
  def to_json
    to_hash.to_json
  end
  
  def to_ini
    "# Go to http://timecert.org for more info\ndigest=#{self.digest}\ntimestamp=#{self.utc}"
  end
  
  def record_referrer(referrer)
    referrers.create(:url=>referrer) if referrer&&referrer!=''&&referrer!='/'
  end
  
  protected
  
  def to_hash
    @to_hash||={:timestamp=>utc.to_s,:digest=>digest}
  end
  
end
