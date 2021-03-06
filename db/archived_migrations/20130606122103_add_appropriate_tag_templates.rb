#This file is part of SEQUENCESCAPE is distributed under the terms of GNU General Public License version 1 or later;
# Please refer to the LICENSE and README files for information on licensing and
# authorship of this file.
# Copyright (C) 2013 Genome Research Ltd.
class AddAppropriateTagTemplates < ActiveRecord::Migration
  def self.up
    ActiveRecord::Base.transaction do
      each_tag_group do |name|
        next if TagGroup.find_by_name(name).nil?
        TagLayoutTemplate.create!(
          :name => "Illumina C - #{name}",
          :walking_algorithm => 'TagLayout::WalkWellsOfPlate',
          :tag_group => TagGroup.find_by_name(name),
          :direction_algorithm => 'TagLayout::InColumns'
        )
      end
    end
  end

  def self.down
    ActiveRecord::Base.transaction do
      each_tag_group do |name|
        TagLayoutTemplate.find_by_name("Illumina C - #{name}").destroy
      end
    end
  end

  def self.each_tag_group
     ['Sanger_168tags - 10 mer tags', 'TruSeq small RNA index tags - 6 mer tags','TruSeq mRNA Adapter Index Sequences'].each do |name|
      yield(name)
    end
  end
end
