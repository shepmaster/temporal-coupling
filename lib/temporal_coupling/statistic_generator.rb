class StatisticGenerator < Struct.new(:file_source)
  def files_in_modified_order
    counts = Hash.new(0)

    files_by_commit.flatten.each do |file|
      counts[file] += 1
    end

    counts.to_a.sort_by(&:last).reverse
  end

  def pairs_in_modified_order
    all_pairs = files_by_commit.flat_map do |files|
      files.combination(2).to_a
    end

    pair_counts = Hash.new(0)
    all_pairs.each do |pair|
      pair_counts[pair] += 1
    end

    pair_counts.to_a.sort_by(&:last).reverse
  end

  private

  def files_by_commit
    @files_by_commit ||= file_source.files_by_commit
  end
end
