require "migration_investigation/version"

module MigrationInvestigation
  class << self
    def pending_migrations? stage, new_sha
      old_sha = get_latest_sha stage
      change_count = get_change_count old_sha, new_sha
      change_count != 0
    end

    private

    def get_latest_sha stage
      AutoTagger::Base.new({}).refs_for_stage(stage).last.sha
    end

    def get_change_count old_sha, new_sha
      changes = `git diff --name-only #{old_sha} #{new_sha} db/migrate/ | wc -l`
      changes.to_i
    end
  end
end
