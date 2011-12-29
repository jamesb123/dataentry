class Sample < ActiveRecord::Base
  belongs_to :organism
  belongs_to :locality_type
  belongs_to :shippingmaterial
  belongs_to :organization
  belongs_to :extraction_method
  belongs_to :storage_medium
  belongs_to :user
  
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
  
end
