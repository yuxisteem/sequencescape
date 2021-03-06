# This file is part of SEQUENCESCAPE; it is distributed under the terms of
# GNU General Public License version 1 or later;
# Please refer to the LICENSE and README files for information on licensing and
# authorship of this file.
# Copyright (C) 2007-2011,2012,2015 Genome Research Ltd.

class Descriptor < ApplicationRecord
  belongs_to :task
  serialize :selection

  def is_required?
    required
  end

  def matches?(search)
    search.descriptors.each do |descriptor|
      if descriptor.name == name && descriptor.value == value
        return true
      end
    end
    false
  end
end
