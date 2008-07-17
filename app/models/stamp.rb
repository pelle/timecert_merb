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
