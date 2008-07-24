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

class FifoCache
  def initialize(size=1000,&block)
    Merb.logger.info "Initializing Cache with max size=#{size}"
    @max_size=size
    @keys=[]
    @lookup={}
    @factory=block
  end
  
  def size
    @keys.size
  end
  
  def to_a
    @keys.clone
  end
  
  def empty?
    @keys.empty?
  end
  
  def [](key)
    @lookup[key]||self[key]=@factory.call(key)
  end
  
  def has_key?(key)
    @lookup.has_key?(key)
  end
  
  def clear
    @keys=[]
    @lookup={}
  end
  
  protected
  
  def []=(key,value)
    Merb.logger.info "Storing new value key=#{key},size=#{self.size}"
    @lookup[key]=value
    self<<key
  end
  
  def <<(key)
    @keys<<key
    @lookup.delete(@keys.shift) if @keys.size>@max_size
  end
end