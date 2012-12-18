class GitFileSource < Struct.new(:repo, :start_date, :options)
  DEFAULT_BRANCH = 'master'

  def files_by_commit
    commits.map do |commit_hash|
      files = git %W{ diff-tree --no-commit-id --name-only -r #{commit_hash} }
      files.split("\n")
    end.reject(&:empty?)
  end

  private

  def commits
    if start_date
      commits = git %W{ rev-list --since=#{start_date} #{end_date} #{branch} }
    else
      commits = git %W{ rev-list #{end_date} #{branch} }
    end
    commits.split("\n")
  end

  def branch
    options.fetch(:branch, DEFAULT_BRANCH)
  end

  def end_date
    if options[:end_date]
      "--until=#{options[:end_date]}"
    end
  end

  def git(*args)
    %x{ git --git-dir=#{repo_path} #{args.join(' ')} }
  end

  def repo_path
    return repo if repo.end_with? '.git'
    Dir.glob("#{repo}/**/.git").first
  end
end
