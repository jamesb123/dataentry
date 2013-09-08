# Find
# http://en.wikibooks.org/wiki/Ruby_on_Rails/Examples
#The find method of ActiveRecord is documented in the Rails API manual


class SamplesController < ApplicationController
  # GET /samples
  # GET /samples.xml
  @batch_import = false
  def index
    @batch_import = false
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
        Emailer.deliver_submission(EMAIL_SAMPLES, "New Sample Submitted by "+ @sample.submitted_by, @sample.submitted_by, @sample.project_id, @sample.field_code,@sample.date_submitted,@sample.shipping_date, @sample.batch_number ) 
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
