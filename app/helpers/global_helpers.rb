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

module Merb
  module GlobalHelpers
    def source_code_select(content,options={})
      "<textarea #{ {:cols=>70,:rows=>2,:onclick=>'this.select()'}.merge(options).collect{|k,v| "#{k}=\"#{v}\""}.join(' ') }>#{content}</textarea>"
    end
  end
end
