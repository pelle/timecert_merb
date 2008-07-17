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

class Digests < Application
  def generate
    @body=request.raw_post
    render
  end
  
  def digest
    @data=params[:body]||request.raw_post
    if @data && @data!=""
      redirect "/#{Digest::SHA1.hexdigest @data}"
    else
      throw :halt, [ 500, "No data to digest"]
    end
  end
  
  def show
    provides :html,:text,:yml,:yaml,:json,:xml,:csv,:ini,:time,:iframe
    @stamp=Stamp.first_or_create(:digest=>params[:digest])
    @stamp.record_referrer(request.referer)
    if content_type==:iframe
      headers["Content-Type"]="text/html"
    end
    display @stamp
    
  end
end
