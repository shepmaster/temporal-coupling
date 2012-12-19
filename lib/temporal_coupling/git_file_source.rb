class GitFileSource < Struct.new(:repo, :start_date, :branch)
  def files_by_commit
    commits.map do |commit_hash|
      files = %x{ git --git-dir=#{repo_path} diff-tree --no-commit-id --name-only -r #{commit_hash} }
      files.split("\n")
    end.reject(&:empty?)
  end

  private

  def commits
    commits = %x{ git --git-dir=#{repo_path} rev-list --since=#{start_date} #{branch} }
    commits.split("\n")
  end

  def repo_path
    return repo if repo.end_with? '.git'
    Dir.glob("#{repo}/**/.git").first
  end
end
