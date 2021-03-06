# This file is part of SEQUENCESCAPE; it is distributed under the terms of
# GNU General Public License version 1 or later;
# Please refer to the LICENSE and README files for information on licensing and
# authorship of this file.
# Copyright (C) 2011,2012,2013,2014,2015,2016 Genome Research Ltd.

# Every request "moving" an asset from somewhere to somewhere else without really transforming it
# (chemically) as, cherrypicking, pooling, spreading on the floor etc
class TransferRequest < SystemRequest
  include DefaultAttributes

  has_many :transfer_request_collection_transfer_requests
  has_many :transfer_request_collections, through: :transfer_request_collection_transfer_requests

  # Ensure that the source and the target assets are not the same, otherwise bad things will happen!
  validate :source_and_target_assets_are_different

  set_defaults request_type: ->(_transfer_request) { RequestType.transfer },
               request_purpose: ->(transfer_request) { transfer_request.request_type.request_purpose }

  after_create(:perform_transfer_of_contents)

  # States which are still considered to be processable (ie. not failed or cancelled)
  ACTIVE_STATES = %w(pending started passed qc_complete).freeze

  # state machine
  redefine_aasm column: :state, whiny_persistence: true do
    # The statemachine for transfer requests is more promiscuous than normal requests, as well
    # as being more concise as it has fewer states.
    state :pending, initial: true
    state :started
    state :failed, enter: :on_failed
    state :passed
    state :qc_complete
    state :cancelled, enter: :on_cancelled

    # State Machine events
    event :start do
      transitions to: :started, from: [:pending], after: :on_started
    end

    event :pass do
      # Jumping straight to passed moves through an implied started state.
      transitions to: :passed, from: :pending, after: :on_started
      transitions to: :passed, from: [:started, :failed]
    end

    event :fail do
      transitions to: :failed, from: [:pending, :started, :passed]
    end

    event :cancel do
      transitions to: :cancelled, from: [:started, :passed, :qc_complete]
    end

    event :cancel_before_started do
      transitions to: :cancelled, from: [:pending]
    end

    event :detach do
      transitions to: :pending, from: [:pending]
    end

    # Not all transfer quests will make this transition, but this way we push the
    # decision back up to the pipeline
    event :qc     do
      transitions to: :qc_complete, from: [:passed]
    end
  end

  # validation method
  def source_and_target_assets_are_different
    return true unless asset_id.present? && asset_id == target_asset_id
    errors.add(:asset, 'cannot be the same as the target')
    errors.add(:target_asset, 'cannot be the same as the source')
    false
  end

  def remove_unused_assets
    # Don't remove assets for transfer requests as they are made on creation
  end

  def outer_request
    asset.outer_request(submission_id)
  end

  private

  # after_create callback method
  def perform_transfer_of_contents
    begin
      target_asset.aliquots << asset.aliquots.map(&:dup) unless asset.failed? or asset.cancelled?
    rescue ActiveRecord::RecordNotUnique => exception
      # We'll specifically handle tag clashes here so that we can produce more informative messages
      raise exception unless /aliquot_tags_and_tag2s_are_unique_within_receptacle/.match?(exception.message)
      errors.add(:asset, "contains aliquots which can't be transferred due to tag clash")
      raise Aliquot::TagClash, self
    end
  end

  # Run on start, or if start is bypassed
  def on_started
    nil # Do nothing
  end

  def on_failed
    target_asset.remove_downstream_aliquots if target_asset
  end
  alias_method :on_cancelled, :on_failed
end
