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

class Referrer
  include DataMapper::Resource
  property :id, Integer,  :serial => true
  property :created_at, DateTime
  property :url, String,:size=>255
  property :stamp_digest, String,:size => 40
  property :site_url, String,:size => 255
  validates_present :url,:stamp_digest
  
  belongs_to :stamp
  belongs_to :site
  before :create, :extract_site_url

  def extract_site_url
    self.url=~/((\w+:\/*)((\w+\-+)|(\w+\.))*\w{1,63}\.[0-9a-zA-Z]{1,6})/i
    self.site_url=$1.downcase if $1
  end
  
  after :create do
    Site.create :url=>self.site_url if self.site_url&&self.site_url!='' and !Site.first(:url=>self.site_url)
  end
end