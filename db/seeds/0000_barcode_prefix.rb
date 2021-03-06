# This file is part of SEQUENCESCAPE; it is distributed under the terms of
# GNU General Public License version 1 or later;
# Please refer to the LICENSE and README files for information on licensing and
# authorship of this file.
# Copyright (C) 2012,2014,2015 Genome Research Ltd.

barcode_prefixes = %w(NT DN WD PD PA PB GD FA FC FE FG FI FK FM FO FQ FS LS)
barcode_prefixes.each do |prefix|
  BarcodePrefix.create!(prefix: prefix)
end
