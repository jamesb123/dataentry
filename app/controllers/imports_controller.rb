class ImportsController < ApplicationController

def index
      @messages =[]
      flash[:notice] = ''
      @mssg='test mssg'
      respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @sample }
    end
end


#########
def import
    @mssg=''
    @indx = 0
    @err_flag = ''
    flash[:notice] = ""
    batch_no = DateTime.now.strftime("%Y-%m-%d-%H-%M-%S")

  if request.post? && !params[:import_file].blank? 
    orig_fname = params[:import_file].original_filename
    ext_name = File.extname(orig_fname)
    
    if ext_name != ".csv"
      @err_flag = 'ERROR not csv '
      @mssg = 'File Extension not .csv ' + ext_name
      # flash[:notice] = "file extension not .csv"
      render 'error'
      return
    end

    csv = FasterCSV.new(params[:import_file],{:col_sep => ',',:headers => true,:return_headers => false, :skip_blanks => true})
    row = true
    while row
      begin
        row = csv.shift
      break unless row
      
      rescue FasterCSV::MalformedCSVError => e
        @err_flag = 'ERROR bad data '
        @mssg = 'Badly Formated Data. Error = ' + e.message
        # flash[:notice] = e.message
        render 'error'
        return
      end
    end
    csv.rewind
    # check size size and contents
    csv.each do |row|
        @indx = @indx + 1
    end
    if @indx == 0 
      @err_flag = 'ERROR 0 rows '
      # flash[:notice] = "File is empty, Number Rows = " + @indx.to_s
      @mssg = "File is empty, # Rows = " + @indx.to_s
      render 'error'
      return
    end
    if @indx > 50 
      @err_flag = 'ERROR > 50 rows '
      # flash[:notice] = "File too large Rows = " + @indx.to_s
      @mssg = "File too large Rows = " + @indx.to_s
      render 'error'
      return
    end
    # start import
    csv.rewind
    @indx = 0
    csv.each do |row|
      @indx = @indx + 1
      if @indx > 50        
        @err_flag = 'ERROR > 50 rows '
        # flash[:notice] = "> Maximum 50 samples imported"
        @mssg = "More than the Maximum 50 samples imported"
        render 'error'
        return
      end
      @sample = Sample.new(
      :submitted_by => row[0],
      :shipping_date => row[1],
      :date_submitted => row[2],
      :field_code => row[3],
      :organism_index => row[4],
      :sample_bc => row[5], 
      :photo_id => row[6],
      :field_ident => row[7], 
      :collected_on_day => row[8], 
      :collected_on_month => row[9], 
      :collected_on_year => row[10], 
      :collected_by => row[11],
      :text_tissue_type => row[12], 
      :export_permit => row[13], 
      :import_permit => row[14], 
      :current_location => row[15], 
      :comments => row[16]
      )
      # @sample.submitted_by =  current_user.name
      @sample.user_id = current_user.id
      # @sample.date_submitted = Date.today
      @sample.project_id = 1
      @sample.approved = false
      @sample.remote_data_entry = true
      # @sample.import_permit = "CA027"
      @sample.batch_number = batch_no
      @sample.save 
    end
    
    if csv.lineno - 1 != @indx
      @err_flag = 'ERROR rows missing '
      # flash[:notice] = "not all rows imported " + @indx.to_s
      @mssg = "not all rows imported " + @indx.to_s
      render 'error'
      return
    end
    csv.close

    email_subject = @err_flag + @indx.to_s + " Batch Samples Submitted - Batch Number " + batch_no + ' by ' + current_user.name
    params[:import_file].open
    file_contents = params[:import_file].read
    Emailer.deliver_email_with_attachment(EMAIL_SAMPLES, email_subject, current_user.name, orig_fname, file_contents ) 
    params[:import_file].close
    
    @mssg = @err_flag + "Import successful. " + @indx.to_s + ' samples imported'
    render 'show'
    return

    # flash[:notice] = ""
  end
end


#def fastercsv_options
#    {
#      :col_sep => ',',
#      :headers => true,
#      :return_headers => false
#    }
#  end


def mapimport
  @messages = []
  @indx = 0
      results = CsvMapper.import(params[:import_file], :type => :io) do
      map_to Sample # Map to the Sample ActiveRecord class instead of the default Struct.
      after_row lambda{|row, sample| sample.save}  # Call this lambda and save each record after it's parsed.
      start_at_row 1
      [submitted_by, shipping_date, date_submitted, field_code, organism_index, sample_bc, photo_id, field_ident, collected_on_day, collected_on_month, collected_on_year, collected_by, text_tissue_type, export_permit, import_permit, current_location, comments]
    end
  flash[:notice] = 'successfully imported'
end



end #class  