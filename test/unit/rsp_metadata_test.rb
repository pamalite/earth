
require File.join(File.dirname(__FILE__), '..', '..', 'lib', 'earth_plugin_interface', 'earth_plugin.rb')
require File.join(File.dirname(__FILE__), '..', '..', 'lib', 'earth_plugins', 'rsp_metadata.rb')
require File.join(File.dirname(__FILE__), '..', '..', 'lib', 'earth_plugins', 'file_monitor.rb')

class RspMetadataTest < Test::Unit::TestCase
  
  def setup
    # Put some test files in a directory named test_data
    
    #root directory
    @relative_dir = 'test_data'
    @dir = File.expand_path(@relative_dir)
    
    #jobs directories
    @dir_job1 = File.join(@dir, 'joblor')
    @dir_job2 = File.join(@dir, 'jobhunter')
    
    #sequence directories
    @dir_seq1 = File.join(@dir_job1, 'sequence1')
    @dir_seq2 = File.join(@dir_job1, 'sequence2')
    
    @dir_seq3 = File.join(@dir_job2, 'sequence3')
    @dir_seq4 = File.join(@dir_job2, 'sequence4')
    
    #shot directories
    @dir_shot1 = File.join(@dir_seq1, 'shot1')
    
    @dir_shot2 = File.join(@dir_seq2, 'shot2')
    
    @dir_shot3 = File.join(@dir_seq3, 'shot3')
    
    @dir_shot4 = File.join(@dir_seq4, 'shot4')
    
    #files
    @file1 = File.join(@dir_shot1, 'file_j1_seq1_sh1')
    @file2 = File.join(@dir_shot2, 'file_j1_seq2_sh2')
    @file3 = File.join(@dir_shot3, 'file_j2_seq3_sh3')
    @file4 = File.join(@dir_shot4, 'file_j2_seq4_sh4')

    #create the directory tree
    FileUtils.rm_rf @dir
    FileUtils.mkdir_p @dir
    
    FileUtils.mkdir_p @dir_job1
    FileUtils.mkdir_p @dir_job2
    
    FileUtils.mkdir_p @dir_seq1
    FileUtils.mkdir_p @dir_seq2
    FileUtils.mkdir_p @dir_seq3
    FileUtils.mkdir_p @dir_seq4
    
    FileUtils.mkdir_p @dir_shot1
    FileUtils.mkdir_p @dir_shot2
    FileUtils.mkdir_p @dir_shot3
    FileUtils.mkdir_p @dir_shot4
    
    #create the files
    FileUtils.touch @file1
    FileUtils.touch @file2
    FileUtils.touch @file3
    FileUtils.touch @file4
    
    server = Earth::Server.this_server
    @directory = server.directories.create(:name => @dir, :path => @dir)

    @fileMonitor = FileMonitor.new
    @fileMonitor.update([@directory])
    
    @rsp = RspMetadata.new
  end
  
  def teardown
    # Tidy up
    FileUtils.rm_rf @dir
  end
  
  def test_file_metadata1
    tokens = @file1.split('/')
    file1_name = tokens[tokens.size-1]
    file1 = Earth::File.find(:first, :conditions => ["name = ?",file1_name])
    assert_equal({"job"=>"lor", "sequence"=>"1","shot"=>"1"}, @rsp.file_metadata(file1))
  end
  
  def test_file_metadata2
    tokens = @file2.split('/')
    file2_name = tokens[tokens.size-1]
    file2 = Earth::File.find(:first, :conditions => ["name = ?",file2_name])
    assert_equal({"job"=>"lor", "sequence"=>"2","shot"=>"2"}, @rsp.file_metadata(file2))
  end
  
  def test_file_metadata3
    tokens = @file3.split('/')
    file3_name = tokens[tokens.size-1]
    file3 = Earth::File.find(:first, :conditions => ["name = ?",file3_name])
    assert_equal({"job"=>"hunter", "sequence"=>"3","shot"=>"3"}, @rsp.file_metadata(file3))
  end
  
  def test_file_metadata4
    tokens = @file4.split('/')
    file4_name = tokens[tokens.size-1]
    file4 = Earth::File.find(:first, :conditions => ["name = ?",file4_name])
    assert_equal({"job"=>"hunter", "sequence"=>"4","shot"=>"4"}, @rsp.file_metadata(file4))
  end
  
end
