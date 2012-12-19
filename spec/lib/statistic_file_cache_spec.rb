require 'temporal_coupling/statistic_file_cache'
require 'tmpdir'

describe StatisticFileCache do
  let(:directory) { Dir.mktmpdir }
  let(:generator) { double('generator') }
  subject { StatisticFileCache.new(directory, generator) }

  after { FileUtils.remove_entry_secure(directory) }

  it "calls the statistic source when nothing has been cached" do
    generator.stub(:files_in_modified_order).and_return :something
    subject.files_in_modified_order.should be :something
  end

  it "does not call the statistic source a second time" do
    generator.should_receive(:files_in_modified_order).once
    subject.files_in_modified_order
    subject.files_in_modified_order
  end

  [:files_in_modified_order, :pairs_in_modified_order].each do |method|
    it "responds to #{method}" do
      subject.should respond_to(method)
    end
  end
end
