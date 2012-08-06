# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

require "current_project_helpers"

# require 'digest/sha1'
# require "thread"

MM = ["1","2","3","4","5","6","7","8","9","10","11","12"]
# MM = ["Jan","Feb","Mar","Apr","May","June","July","Aug","Sept","Oct","Nov","Dec"]
TT = [ "Skin", "Muscle", "Bone", "Brain", "Kidney", "Heart", "Other" ]
DD = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31"]
YY = ["2007","2008","2009","2010","2011","2012","2013","2014","2015"]

class TrueClass
  def yesno
    "Yes"
  end
end

class FalseClass
  def yesno
    "No"
  end
end
class NilClass
  def yesno
    " "
  end
end

class ActiveRecord::Base
  def self.find_all_by_example(record, *attributes)
    conditions = Array.new
    query = Array.new
    for attribute in attributes.flatten.uniq
      query << "#{self.connection.quote_column_name(attribute.to_s)} = ?"
      conditions << record.send(attribute)
#      conditions << record[attribute]
    end
    self.find(:all, :conditions => [query.join(' AND ')] + conditions)
  end
end

class ApplicationController < ActionController::Base
   helper :all # include all helpers, all the time

#  # Pick a unique cookie name to distinguish our session data from others'
#  session :session_key => '_nrdpfc_session_id'
  include AuthenticatedSystem
#  include CurrentProjectHelper
#  include InPlaceEditing

  prepend_before_filter :login_required  
  
#  ActiveScaffold.set_defaults do |config|
#    config.security.current_user_method = :current_user
#    config.security.default_permission = false
#    config.actions.exclude :live_search
#    config.actions.add :search
#  end
  
  # This isn't working, I'm not quite sure why...
  # something isn't scoped right...

  def self.is_project_manager
    user = current_user
    return false if ! user
    return false if ! session[:project_id]
    project = Project.find_by_id(session[:project_id])
    return false if ! project
    @project_manager = (project.user_id == user.id)
  end

  def download_table
    # Horizontals use magic to define their tables so we have to use
    # reverse magic to figure it out
    table_name = self.class.respond_to?(:target_table_name) ?
                   self.class.target_table_name.to_s :
                   active_scaffold_config.model.table_name

    table = table_name.intern
    q = QueryBuilder.new(:parent => table, :tables => [ table ], :fields => { table => "*" })
    q.filter_by_project(current_project_id) unless (table == :projects)

    csv_string = FasterCSV.generate do |csv|
      csv << q.column_headers
      q.results.each {|result| csv << result }
    end

    send_data csv_string, :filename => "#{table_name}.csv"
  end

end
