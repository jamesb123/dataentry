# Find
# http://en.wikibooks.org/wiki/Ruby_on_Rails/Examples
#The find method of ActiveRecord is documented in the Rails API manual
#pet = Pet.find(pet_id) Find record by id (an integer). Note: Returns one object.
#pets = Pet.find(:first, :conditions => ["owner_id = ?", owner_id]) - returns the first matching record. [Note: Returns one object.]
#pets = Pet.find(:all, :conditions => ["owner_id = ?", owner_id]) - find all records with a given field value. [Notes: 1. Returns an array of objects. Check for no records found with: pets.empty?. 2.:conditions => supplies an SQL fragment used with WHERE *]
#pets = Pet.find(:all, :conditions => ["owner_id = ? AND name = ?", owner_id, name]) - find all records matching multiple field values. [Note: OR also works.]
#pets = Pet.find(:all, :conditions => ["name LIKE ?", "Fido%"]) - find all records matching a pattern. Wild cards are % for zero or more of any character, and _ for any single character. To escape a wild card use \% or \_. The reference from MySQL for LIKE will help. On the MySQL Regex website you will find examples for using REGEX.
#pets = Pet.find(:all, :order => 'name') - find everything and sort result by name.
#pets = Pet.find(:all, :limit => 10, :conditions => ["owner_id = ?", owner_id]) - returns no more than the number of rows specified by :limit.
#pets = Pet.find(:all, :offset => 50, :limit => 10) - uses offset to skip the first 50 rows.

class SamplesController < ApplicationController
  # GET /samples
  # GET /samples.xml
  def index
    if current_user.login == "admin"
      @sample = Sample.find(:all, :order => 'date_submitted' , :include => [:genders, :dna_results, :mt_dnas], :conditions => "project_id = 1 and remote_data_entry = true")
    else
      @sample = Sample.find(:all, :order => 'date_submitted' , :include => [:genders, :dna_results, :mt_dnas], :conditions => "project_id = 1 and remote_data_entry = true and user_id = '#{current_user.id}'")
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @sample }
    end
  end

  # GET /samples/1
  # GET /samples/1.xml
  # show for current user only
  def show
    @sample = Sample.find(params[:id],:include => [:genders, :dna_results, :mt_dnas])
    @sfw = 100
    @org = Organization.find_by_id(@sample.organization_id)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @sample }
    end
  end
  
  # GET /samples/1
  # GET /samples/1.xml
#  def tracker
#    @sample = Sample.find(:all, :include => [:genders, :dna_results, :mt_dnas ], :conditions => "project_id = 1 and approved = false and user_id = '#{current_user.id}'")
#    @samples = Sample.find(:all, :conditions => "project_id = 1 and approved = false and user_id = '#{current_user.id}' " )
#    respond_to do |format|
#      format.html # index.html.erb
#      format.xml  { render :xml => @sample }
#    end
#  end


  # GET /samples/new
  # GET /samples/new.xml
  def new
    @sample = Sample.new
    @sample.submitted_by =  current_user.name
    @sample.user_id = current_user.id
    @sample.date_submitted = Date.today
    @sample.project_id = 1
    @sample.approved = false
    @sample.remote_data_entry = true
    @sample.import_permit = "CA027"
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @sample }
    end
  end

  # GET /samples/1/edit
  def edit
    @sample = Sample.find(params[:id])
  end

  # POST /samples
  # POST /samples.xml
  def create
    @sample = Sample.new(params[:sample])
    respond_to do |format|
      if @sample.save
        flash[:notice] = 'Sample was successfully created.'
        format.html { redirect_to(@sample) }
        format.xml  { render :xml => @sample, :status => :created, :location => @sample }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @sample.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /samples/1
  # PUT /samples/1.xml
  def update
    @sample = Sample.find(params[:id])
    respond_to do |format|
      if @sample.update_attributes(params[:sample])
        flash[:notice] = 'Sample was successfully updated.'
        format.html { redirect_to(@sample, :notice => 'Newsample was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @sample.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /samples/1
  # DELETE /samples/1.xml
  def destroy
    @sample = Sample.find(params[:id])
    @sample.destroy

    respond_to do |format|
      format.html { redirect_to(samples_url) }
      format.xml  { head :ok }
    end
  end
end
