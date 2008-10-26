class ReCreateFileMetadataStrings < ActiveRecord::Migration
  def self.up
    #drop the table
    drop_table :file_metadata_strings
    #TODO delete all records from metadata_strings
    
    #re-create the table with a different name
    create_table :files_metadata_strings, :id => false, :force => true do |t|
      t.column :file_id, :integer
      t.column :metadata_string_id, :integer
    end
    add_foreign_key :files_metadata_strings, :file_id, :files, :id, { :name => "file_id_fk" }
    add_foreign_key :files_metadata_strings, :metadata_string_id, :metadata_strings, :id, { :name => "metadata_string_id_fk" }
  end

  def self.down
    #drop the table
    drop_table :files_metadata_strings
    #TODO delete all records from metadata_strings
    
    #re-create the table with the old name
    create_table :file_metadata_strings, :id => false, :force => true do |t|
      t.column :file_id, :integer, :null => false
      t.column :metadata_string_id, :integer
    end
    add_foreign_key :file_metadata_strings, :file_id, :files, :id, { :name => "file_id_fk" }
    add_foreign_key :file_metadata_strings, :metadata_string_id, :metadata_strings, :id, { :name => "metadata_string_id_fk" }
  end
end