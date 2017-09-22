# This file is part of SEQUENCESCAPE; it is distributed under the terms of
# GNU General Public License version 1 or later;
# Please refer to the LICENSE and README files for information on licensing and
# authorship of this file.
# Copyright (C) 2017 Genome Research Ltd.

class BroadcastEvent::LabwareReceived < BroadcastEvent
  set_event_type 'labware.received'

  # Properties takes :order_id

  seed_class Asset

  seed_subject :labware
  has_subjects(:study, :studies)
  has_subjects(:labware, :labware)
  has_subjects(:sample, :contained_samples)

  has_metadata(:location, :location_name)
end
