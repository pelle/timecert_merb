class Site 
  include DataMapper::Resource
  property :url,String,:size=>255,:key=>true
  property :description,Text
  property :created_at,DateTime
  has n,  :referrers
end