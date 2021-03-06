#This file is part of SEQUENCESCAPE is distributed under the terms of GNU General Public License version 1 or later;
# Please refer to the LICENSE and README files for information on licensing and
# authorship of this file.
# Copyright (C) 2011 Genome Research Ltd.
class CarrierWaveCleanup < ActiveRecord::Migration
  def self.up
    # Delete old file columns
    remove_column :study_reports, :report_file
    remove_column :sample_manifests, :uploaded_file
    remove_column :sample_manifests, :generated_file
    remove_column :plate_volumes, :uploaded_file
  end

  def self.down
    # Replace file columns:
    add_column :study_reports, :report_file, :binary, :limit => 16.megabytes
    add_column :sample_manifests, :uploaded_file, :binary, :limit => 16.megabytes
    add_column :sample_manifests, :generated_file, :binary, :limit => 16.megabytes
    add_column :plate_volumes, :uploaded_file, :binary, :limit => 16.megabytes
  end
end
