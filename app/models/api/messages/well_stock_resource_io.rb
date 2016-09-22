# Used to broadcast stock wells to the UWH.
# Tubes have a separate template, as the information
# is mapped slightly differently.
class Api::Messages::WellStockResourceIO < Api::Base

  renders_model(::Well)

  map_attribute_to_json_attribute(:uuid,'stock_resource_uuid')
  map_attribute_to_json_attribute(:id,'stock_resource_id')
  map_attribute_to_json_attribute(:created_at)
  map_attribute_to_json_attribute(:updated_at)
  map_attribute_to_json_attribute(:subject_type,'labware_type')

  with_association(:plate) do
    map_attribute_to_json_attribute(:ean13_barcode,'machine_barcode')
    map_attribute_to_json_attribute(:sanger_human_barcode,'human_barcode')
  end

  map_attribute_to_json_attribute(:map_description,'labware_coordinate')

  with_association(:well_attribute) do
    map_attribute_to_json_attribute(:concentration)
    map_attribute_to_json_attribute(:initial_volume)
    map_attribute_to_json_attribute(:current_volume)
    map_attribute_to_json_attribute(:sequenom_count,'snp_count')
    map_attribute_to_json_attribute(:pico_pass)
    map_attribute_to_json_attribute(:gel_pass)
  end


  # Note: Assumes one aliquot per tube. Might need to change ASAP
  with_association(:primary_aliquot) do
    with_association(:sample){ map_attribute_to_json_attribute(:uuid,'sample_uuid') }
    with_association(:study){ map_attribute_to_json_attribute(:uuid,'study_uuid') }
  end
end
