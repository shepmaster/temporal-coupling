class StatisticGenerator < Struct.new(:file_source)
  class Frequency < Struct.new(:items)
    def by_frequency
      counts = Hash.new(0)

      items.each do |item|
        counts[item] += 1
      end

      counts.to_a.sort_by(&:last).reverse
    end
  end

  def files_in_modified_order
    Frequency.new(files_by_commit.flatten).by_frequency
  end

  def pairs_in_modified_order
    all_pairs = files_by_commit.flat_map do |files|
      files.combination(2).to_a
    end

    Frequency.new(all_pairs).by_frequency
  end

  private

  def files_by_commit
    @files_by_commit ||= file_source.files_by_commit
  end
end
