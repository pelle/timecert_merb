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

class Statistic 
  include DataMapper::Resource
  property :date,Date, :key=>true
  [:digests,:requests,:referrers,:sites].each do |field|
    property field,Integer,:default=>0
  end

  def ratio
    return '' if digests==0||requests==0
    "%01.4f" % (digests.to_f/requests.to_f)
  end
  
  def self.update_stats
    repository.adapter.execute("insert into statistics (date,digests) select date(created_at) as date,count(digest) as digests from stamps where date(created_at)<date(now()) and date(created_at) not in (select date from statistics) group by date(created_at)")
    repository.adapter.execute("insert into statistics (date,requests,referrers,sites) select date(created_at) as date , count(url) as requests, count(distinct url) as referrers,count(distinct site_url) as sites from referrers where created_at<date(now()) group by date ON DUPLICATE KEY UPDATE requests=VALUES(requests),referrers=VALUES(referrers),sites=VALUES(sites)")
  end
  
end