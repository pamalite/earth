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
  class MetadataAttribute < ActiveRecord::Base
    has_many :metadata_strings
    
    def self.metadata_attribute_names
      all = MetadataAttribute.find(:all)
      names_list = []
      for m in all do
        names_list << m.name
      end
      names_list
    end
    
    # This method to find metadata attributes by plugin_descriptor name
    # It returns Array (unlike the usual Rails find_by which returns the first record matching the condition)
    def self.find_by_plugin_descriptor_name(name)
      plugin = PluginDescriptor.find_by_name(name)
      MetadataAttribute.find(:all, :conditions => {:plugin_descriptor_id => plugin.id}) unless plugin.nil?
    end
    
  end
end
