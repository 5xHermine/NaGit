class DiffPullRequest
  def initialize(repo_path, opts = {})
    @repo = repo_path
    set_base_branch(opts[:base_branch]) if opts[:base_branch]
    set_compare_branch(opts[:compare_branch]) if opts[:compare_branch]
    changed_file_name
  end

  def set_base_branch(br)
    @base_branch = br
  end

  def set_compare_branch(br)
    @compare_branch = br
  end

  def repo
    @repo
  end

  def base_branch
    @base_branch
  end

  def compare_branch
    @compare_branch
  end

  def all_branch
    %x`git -C #{@repo} branch --list`.split("\n")
  end

  def changed_file_name
    @changed_file_name = %x`git -C #{@repo} diff --name-only #{@compare_branch} #{@base_branch}`.split("\n")
  end

  def diff_in_file(file_name)
    #compare branch first, base branch after
    arr = []
    files = %x`git -C #{@repo} diff #{@base_branch}..#{@compare_branch} -- #{file_name}`.split("\n")
    files.each do |s|
      if s.match(/^diff/)
        arr << "file name"
      elsif s.match(/^index/)
        arr << "index"
      elsif s.match(/^\-\-\- /) || s.match(/^\+\+\+ /)
        arr << "add_or_delete"
      elsif s.match(/^@@ /)
        arr << "line"
      elsif s.match(/^\s/)
        arr << "origin code"
      elsif s.match(/^\+ /)
        arr << "addition"
      elsif s.match(/^\- /) 
        arr << "deletion"
      else
        arr << "unknown"
      end
    end
    diff = arr.zip(files)
  end

  def diff_in_files
    diffs = []
    @changed_file_name.each do |file|
      diffs << diff_in_file(file)
    end
    diffs
  end
end
