class Referrer
  include DataMapper::Resource
  property :id, Integer,  :serial => true
  property :created_at, DateTime
  property :url, String,:size=>255
  property :stamp_digest, String,:size => 40
  validates_present :url
  
#  belongs_to :site
  belongs_to :stamp
  
#  before :save do |referrer|
#    if referrer.url
#      referrer.url=~/https?:\/\/([\w.]+)/
#      referrer.site=Site.find_or_create(:url=>"http://#{$1}")
#    end
#  end
#  
end