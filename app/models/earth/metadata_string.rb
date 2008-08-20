# Copyright (C) 2007 Rising Sun Pictures and Matthew Landauer
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

module Earth
  class MetadataString < ActiveRecord::Base
    belongs_to :metadata_attribute
    has_and_belongs_to_many :files
   
    # override the create method to avoid redundancy
    # if the new record values are already in the database, 
    #     do not create an equivelant record
    def create
      #look for equivelant to avoid redundancy
      old = MetadataString.find(:first, :conditions => attributes)
      
      if old.nil?
        #no equivelant records
        #creat new one
        super
      else
        #there is an equivelant record
        #do not create
        #just the association will be created  
        self.id = old.id
      end
    end
  
  end
end
