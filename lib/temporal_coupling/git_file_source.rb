class GitFileSource < Struct.new(:repo, :start_date, :branch)
  def files_by_commit
    commits.map do |commit_hash|
      files = git %W{ diff-tree --no-commit-id --name-only -r #{commit_hash} }
      files.split("\n")
    end.reject(&:empty?)
  end

  private

  def commits
    commits = git %W{ rev-list --since=#{start_date} #{branch} }
    commits.split("\n")
  end

  def git(*args)
    %x{ git --git-dir=#{repo_path} #{args.join(' ')} }
  end

  def repo_path
    return repo if repo.end_with? '.git'
    Dir.glob("#{repo}/**/.git").first
  end
end
