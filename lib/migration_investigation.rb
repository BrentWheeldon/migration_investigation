require "migration_investigation/version"

module MigrationInvestigation
  class << self
    def pending_migrations?(stage, new_sha, options={})
      old_sha = latest_stage_sha stage
      return true if old_sha.nil?

      change_count(old_sha, new_sha, build_interesting_paths(options.fetch(:additional_paths, [])), options[:skip_filepath_pattern]) != 0
    end

    private

    def latest_stage_sha(stage)
      latest_tag = AutoTagger::Base.new({}).refs_for_stage(stage).last
      latest_tag.sha if latest_tag
    end

    def change_count(old_sha, new_sha, interesting_paths, skip_filepath_pattern)
      cmd = "git diff --name-only #{old_sha} #{new_sha} #{interesting_paths.join(" ")}"
      changes = `#{cmd}`
      changes.split("\n").reject { |l| l.length == 0 }.reject { |l| skip_filepath_pattern && l =~ skip_filepath_pattern }.length
    end

    def build_interesting_paths(additional_paths)
      interesting_paths = ["db/migrate/"]
      interesting_paths << additional_paths
      interesting_paths.flatten
    end
  end
end
