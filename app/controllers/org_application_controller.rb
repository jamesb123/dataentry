# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
MM = ["1","2","3","4","5","6","7","8","9","10","11","12"]
# MM = ["Jan","Feb","Mar","Apr","May","June","July","Aug","Sept","Oct","Nov","Dec"]
TT = [ "Skin", "Muscle", "Bone", "Brain", "Kidney", "Heart", "Other" ]
DD = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31"]
YY = ["2007","2008","2009","2010","2011","2012","2013","2014","2015"]
end
