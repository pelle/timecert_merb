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

class Stats < Application
  provides :csv,:json,:yaml,:xml
  def index
    @stats=Statistic.all(:order=>[:date.desc],:limit=>90)
    display @stats
  end
  
end
