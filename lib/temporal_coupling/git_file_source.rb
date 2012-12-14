class GitFileSource < Struct.new(:repo, :start_date, :branch)
  def files_by_commit
    commits.map do |commit_hash|
      files = %x{ git --git-dir=#{repo} diff-tree --no-commit-id --name-only -r #{commit_hash} }
      files.split("\n")
    end.reject(&:empty?)
  end

  private

  def commits
    commits = %x{ git --git-dir=#{repo} rev-list --since=#{start_date} #{branch} }
    commits.split("\n")
  end
end
