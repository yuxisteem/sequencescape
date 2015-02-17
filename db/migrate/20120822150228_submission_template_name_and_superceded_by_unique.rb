#This file is part of SEQUENCESCAPE is distributed under the terms of GNU General Public License version 1 or later;
#Please refer to the LICENSE and README files for information on licensing and authorship of this file.
#Copyright (C) 2012 Genome Research Ltd.
class SubmissionTemplateNameAndSupercededByUnique < ActiveRecord::Migration
  def self.up
    alter_table(:submission_templates) do
      remove_index(:name => 'index_submission_templates_on_name')
      add_index([:name, :superceded_by_id], :name => 'name_and_superceded_by_unique_idx', :unique => true)
    end
  end

  def self.down
    alter_table(:submission_templates) do
      add_index(:name, :unique => true)
      remove_index(:name => 'name_and_superceded_by_unique_idx')
    end
  end
end
