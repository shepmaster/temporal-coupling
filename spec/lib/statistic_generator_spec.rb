require 'temporal_coupling/statistic_generator'

describe StatisticGenerator do
  let(:file_source) { double("file source") }
  subject { StatisticGenerator.new(file_source) }

  context "computing the frequency of input files" do
    it "handles a single file" do
      file_source.stub(:files_by_commit) { [['a']] }
      subject.files_in_modified_order.should have_a_frequency_of(1).for('a')
    end

    it "handles multiple files in the same commit" do
      file_source.stub(:files_by_commit) { [['a', 'b']] }
      subject.files_in_modified_order.should have_a_frequency_of(1).for('a')
      subject.files_in_modified_order.should have_a_frequency_of(1).for('b')
    end

    it "handles the same file in different commits" do
      file_source.stub(:files_by_commit) { [['a'], ['a']] }
      subject.files_in_modified_order.should have_a_frequency_of(2).for('a')
    end

    it "returns highest frequency files first" do
      file_source.stub(:files_by_commit) { [['a', 'b'], ['b']] }
      subject.files_in_modified_order[0].first.should eql 'b'
    end
  end

  context "computing the frequency of input pairs" do
    it "ignores commits with one file" do
      file_source.stub(:files_by_commit) { [['a']] }
      subject.pairs_in_modified_order.should be_empty
    end

    it "handles a single pair" do
      file_source.stub(:files_by_commit) { [['a', 'b']] }
      subject.pairs_in_modified_order.should have_a_frequency_of(1).for(['a', 'b'])
    end

    it "handles three pairs" do
      file_source.stub(:files_by_commit) { [['a', 'b', 'c']] }
      subject.pairs_in_modified_order.should have_a_frequency_of(1).for(['a', 'b'])
      subject.pairs_in_modified_order.should have_a_frequency_of(1).for(['a', 'c'])
      subject.pairs_in_modified_order.should have_a_frequency_of(1).for(['b', 'c'])
    end

    it "handles the same pair in different commits" do
      file_source.stub(:files_by_commit) { [['a', 'b'], ['a', 'b']] }
      subject.pairs_in_modified_order.should have_a_frequency_of(2).for(['a', 'b'])
    end

    it "returns highest frequency pairs first" do
      file_source.stub(:files_by_commit) { [['a', 'b', 'c'], ['b', 'c']] }
      subject.pairs_in_modified_order[0].first.should eql ['b', 'c']
    end
  end

  RSpec::Matchers.define :have_a_frequency_of do |freq|
    match do |actual|
      actual.include? [@item, freq]
    end

    chain :for do |item|
      @item = item
    end

    failure_message_for_should do |actual|
      "expected #{@item} to have a frequency of #{freq}, but had #{actual}"
    end
  end
end
