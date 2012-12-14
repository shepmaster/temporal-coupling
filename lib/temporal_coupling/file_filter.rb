class FileFilter < Struct.new(:pattern, :file_source)
  def files_by_commit
    file_source.files_by_commit.map do |files|
      files.reject {|f| pattern.match(f)}
    end.reject(&:empty?)
  end
end
