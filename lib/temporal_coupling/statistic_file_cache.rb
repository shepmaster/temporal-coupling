require 'pathname'

class StatisticFileCache < Struct.new(:directory, :generator)
  def files_in_modified_order
    cache("file_cache", :files_in_modified_order)
  end

  def pairs_in_modified_order
    cache("pair_cache", :pairs_in_modified_order)
  end

  private

  def cache(name, method)
    filename = full_path(name)

    if File.exist? filename
      File.open(filename) do |f|
        Marshal.load(f)
      end
    else
      File.open(filename, "w") do |f|
        generator.send(method).tap do |files|
          Marshal.dump(files, f)
        end
      end
    end
  end

  def full_path(path)
    dir_path = Pathname.new(directory)
    Dir.mkdir(dir_path) unless dir_path.exist?
    dir_path + path
  end
end
