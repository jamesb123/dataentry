class CreateSamples < ActiveRecord::Migration
  def self.up
  create_table "samples" do |t|
    t.integer  "project_id"
    t.integer  "organism_id"
    t.integer  "organism_index"
    t.string   "sample_bc"
    t.string   "platebc"
    t.string   "plateposition"
    t.string   "field_code"
    t.string   "batch_number"
    t.string   "original_tissue_type"
    t.string   "storage_medium_text"
    t.string   "country"
    t.string   "province"
    t.datetime "date_collected"
    t.string   "collected_on_day"
    t.string   "collected_on_month"
    t.string   "collected_on_year"
    t.string   "collected_by"
    t.datetime "date_received"
    t.string   "received_by"
    t.text     "receiver_comments"
    t.datetime "date_submitted"
    t.string   "submitted_by"
    t.text     "submitter_comments"
    t.string   "latitude"
    t.string   "longitude"
    t.string   "coordinate_system"
    t.string   "locality"
    t.string   "locality_type_text"
    t.string   "locality_comments"
    t.string   "location_accuracy"
    t.string   "storage_building"
    t.string   "storage_room"
    t.string   "storage_fridge"
    t.string   "storage_box"
    t.string   "xy_position"
    t.boolean  "tissue_remaining"
    t.string   "type_lat_long"
    t.integer  "locality_type_id"
    t.integer  "shippingmaterial_id"
    t.integer  "tissue_type_id"
    t.integer  "province_id"
    t.integer  "storage_medium_id"
    t.integer  "country_id"
    t.integer  "extraction_method_id"
    t.decimal  "true_latitude",               :precision => 18, :scale => 9
    t.decimal  "true_longitude",              :precision => 18, :scale => 9
    t.string   "sample_bc_prv"
    t.string   "shipping_material_txt_prv"
    t.string   "location_measurement_method"
    t.boolean  "approved",                                                   :default => false
    t.integer  "sighting_id"
    t.integer  "survey_id"
    t.string   "location_1"
    t.string   "location_2"
    t.string   "location_3"
    t.string   "location_4"
    t.text     "collector_comments"
    t.string   "tissue_type"
  end

  add_index "samples", ["organism_id"], :name => "index_samples_on_organism_id"
  add_index "samples", ["project_id"], :name => "index_samples_on_project_id"
  add_index "samples", ["approved"], :name => "index_samples_on_approved"
  end
 
  def self.down
    drop_table :samples
  end
end
