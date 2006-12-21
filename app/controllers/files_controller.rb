class FilesController < ApplicationController
  def index
    find
    render :action => 'find'
  end

  def find
    if request.post?
      @find_value = params[:find_value]
      @files = Earth::File.find(:all, :conditions => ["NAME LIKE ?", @find_value.tr('*','%')])
      render :action => 'results'
    end
  end
end