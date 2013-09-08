class Sample < ActiveRecord::Base
  
  belongs_to :organism
  belongs_to :locality_type
  belongs_to :shippingmaterial
  belongs_to :organization
  belongs_to :extraction_method
  belongs_to :storage_medium
  belongs_to :user
  belongs_to :organization
  
  has_many :y_chromosome_seqs
  has_many :y_chromosomes
  has_many :microsatellite_horizontals
  has_many :microsatellites
  has_many :mt_dnas
  has_many :mt_dna_seqs
  has_many :mhcs
  has_many :mhc_seqs
  has_many :genders
  has_many :dna_results
  
  accepts_nested_attributes_for :genders
  accepts_nested_attributes_for :dna_results
  accepts_nested_attributes_for :mt_dnas
  
  before_save :assign_collected_YMD
#  after_create :send_sample_mail

#----- done in controller now
#  def send_sample_mail
#    Emailer.deliver_submission(EMAIL_SAMPLES, "New Sample Submitted", self.submitted_by, self.project_id, self.field_code,self.date_submitted,self.shipping_date, self.batch_number ) 
#  end

  def assign_collected_YMD
    if self.collected_on_day.blank? or self.collected_on_month.blank? or self.collected_on_year.blank?
      self.date_collected = nil
    else
      self.date_collected = DateTime.strptime(self.collected_on_year + "/" + self.collected_on_month + "/" + self.collected_on_day, "%Y/%m/%d" )
    end
  end
  
def self.import(file)
  spreadsheet = open_spreadsheet(file)
  header = spreadsheet.row(1)
  (2..spreadsheet.last_row).each do |i|
    row = Hash[[header, spreadsheet.row(i)].transpose]
    product = find_by_id(row["id"]) || new
    product.attributes = row.to_hash.slice(*accessible_attributes)
    product.save!
  end
end

def self.open_spreadsheet(file)
  case File.extname(file.original_filename)
  when ".csv" then Csv.new(file.path, nil, :ignore)
  when ".xls" then Excel.new(file.path, nil, :ignore)
  when ".xlsx" then Excelx.new(file.path, nil, :ignore)
  else raise "Unknown file type: #{file.original_filename}"
  end
end
  
end
