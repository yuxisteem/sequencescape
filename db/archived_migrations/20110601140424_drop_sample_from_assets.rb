#This file is part of SEQUENCESCAPE is distributed under the terms of GNU General Public License version 1 or later;
# Please refer to the LICENSE and README files for information on licensing and
# authorship of this file.
# Copyright (C) 2011 Genome Research Ltd.
class DropSampleFromAssets < ActiveRecord::Migration
  def self.up
    rename_column :assets, :sample_id, :legacy_sample_id
  end

  def self.down
    rename_column :assets, :legacy_sample_id, :sample_id
  end
end
