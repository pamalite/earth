# Copyright (C) 2006 Rising Sun Pictures and Matthew Landauer.
# All Rights Reserved.
#  
# This program is free software; you can redistribute it and/or modify it
# under the terms of version 2 of the GNU General Public License as
# published by the Free Software Foundation.
#
# $Id$

class Snapshot
  attr_reader :directory, :filenames, :snapshots

  def deep_copy
    a = Snapshot.new(directory, filenames, snapshots.clone)
  end
  
  def Snapshot.added_files(snap1, snap2)
    added_files = snap2.filenames - snap1.filenames
    added_directories = snap2.subdirectories - snap1.subdirectories
    # Directories that have not been either added or removed
    directories = snap2.subdirectories - added_directories
    
    changes = added_files
    added_directories.each do |directory|
      changes += Snapshot.added_files(Snapshot.new(directory), snap2.snapshots[directory])
    end
    
    directories.each do |d|
      changes += Snapshot.added_files(snap1.snapshots[d], snap2.snapshots[d])
    end

    changes
  end
  
  def Snapshot.removed_files(snap1, snap2)
    Snapshot.added_files(snap2, snap1)
  end
  
  def initialize(directory, filenames = [], snapshots = Hash.new)
    # Internally store everything as absolute path
    @directory = File.expand_path(directory)
    @filenames = filenames
    @snapshots = snapshots
  end
  
  def subdirectories
    @snapshots.keys
  end

  def exist?(path)
    if @filenames.include?(path)
      true
    else
      @snapshots.each_value do |snapshot|
        if snapshot.exist?(path)
          return true
        end
      end
      false
    end
  end
  
  def update
    entries = Dir.entries(@directory)
    entries.delete(".")
    entries.delete("..")

    # Make absolute paths
    entries.map!{|x| File.join(@directory, x)}
    
    @filenames, subdirectories = entries.partition{|f| File.file?(f)}
    @snapshots.clear
    subdirectories.each do |d|
      snapshot = Snapshot.new(d)
      snapshot.update
      @snapshots[d] = snapshot
    end
  end
end