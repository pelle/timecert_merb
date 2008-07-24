# TimeCert - Thirdparty Digest Timestamping Service
# Copyright (C) 2008 Pelle Braendgaard, Stake Ventures Inc.
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
# 
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

class Site 
  include DataMapper::Resource
  property :url,String,:size=>255,:key=>true
  property :title, String
  property :description,Text
  property :created_at,DateTime
  property :referrer_count,Integer
  property :digest_count,Integer
  has n,  :referrers
  
  def to_s
    self.title||self.url
  end
  
  def self.update_stats
    repository(:default).adapter.execute("insert into sites (url,created_at,referrer_count,digest_count) select site_url,min(created_at) as created_at,count(distinct url) as referrer_count,count(distinct stamp_digest) as digest_count from referrers where site_url is not null and site_url!='' group by site_url ON DUPLICATE KEY UPDATE created_at=VALUES(created_at), referrer_count =VALUES(referrer_count), digest_count =VALUES(digest_count)")
  end
end