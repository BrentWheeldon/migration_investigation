require "migration_investigation/version"

module MigrationInvestigation
  class << self
    def pending_migrations?(stage, new_sha, options={})
      old_sha = latest_stage_sha stage
      return true if old_sha.nil?

      change_count(old_sha, new_sha, build_interesting_paths(options)) != 0
    end

    private

    def latest_stage_sha(stage)
      latest_tag = AutoTagger::Base.new({}).refs_for_stage(stage).last
      latest_tag.sha if latest_tag
    end

    def change_count(old_sha, new_sha, interesting_paths)
      changes = `git diff --name-only #{old_sha} #{new_sha} #{interesting_paths.join(" ")} | wc -l`
      changes.to_i
    end

    def build_interesting_paths(options)
      interesting_paths = ["db/migrate/"]
      interesting_paths << options.fetch(:additional_paths, [])
      interesting_paths.flatten
    end
  end
end
