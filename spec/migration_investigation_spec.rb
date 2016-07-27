require "spec_helper"

describe MigrationInvestigation do
  describe ".pending_migrations?" do
    let(:stage) { "stage" }
    let(:new_sha) { "abc123" }

    before do
      auto_tagger = double(:auto_tagger)
      allow(AutoTagger::Base).to receive(:new).with({}).and_return(auto_tagger)
      allow(auto_tagger).to receive(:refs_for_stage).with(stage).and_return(refs)
    end

    context "when there are refs for the given stage" do
      let(:refs) { [ref1, ref2] }
      let(:ref1) { double(:ref1) }
      let(:ref2) { double(:ref2, sha: old_sha) }
      let(:old_sha) { "cba321" }

      context "when no additional paths are passed in" do
        subject { MigrationInvestigation.pending_migrations? stage, new_sha }

        before do
          allow(MigrationInvestigation).to receive(:`).with("git diff --name-only #{old_sha} #{new_sha} db/migrate/").and_return(git_diff)
        end

        context "when there are migrations changed between the last tag for the given change, and the new SHA" do
          let(:git_diff) do
            <<~GITDIFF
            db/migrate/121345_foo_migration.rb
            db/migrate/121345_bar_migration.rb
            db/migrate/121345_baz_migration.rb
            GITDIFF
          end

          it { is_expected.to be_truthy }
        end

        context "when there are no migrations changes between the last tag for the given change, and the new SHA" do
          let(:git_diff) { "\n" }

          it { is_expected.to be_falsy }
        end
      end

      context "when an uptime pattern is provided" do
        subject { MigrationInvestigation.pending_migrations? stage, new_sha, skip_filepath_pattern: /\d_online_/}

        before do
          allow(MigrationInvestigation).to receive(:`).with("git diff --name-only #{old_sha} #{new_sha} db/migrate/").and_return(git_diff)
        end

        context "when only online migrations exist" do
          let(:git_diff) do
            <<~GITDIFF
            db/migrate/121345_online_bar_migration.rb
            db/migrate/121345_online_baz_migration.rb
            GITDIFF
          end

          it { is_expected.to be_falsy }
        end

        context "when there are some offline migrations" do
          let(:git_diff) do
            <<~GITDIFF
            db/migrate/121345_foo_migration.rb
            db/migrate/121345_bar_migration.rb
            db/migrate/121345_online_baz_migration.rb
            GITDIFF
          end

          it { is_expected.to be_truthy }
        end
      end

      context "when additional paths are passed in" do
        subject { MigrationInvestigation.pending_migrations? stage, new_sha, additional_paths: ["app/foo.rb"] }

        before do
          allow(MigrationInvestigation).to receive(:`).with("git diff --name-only #{old_sha} #{new_sha} db/migrate/ app/foo.rb").and_return(git_diff)
        end

        context "when there are changes between the last tag for the given change, and the new SHA" do
          let(:git_diff) do
            <<~GITDIFF
            app/foo.rb
            GITDIFF
          end

          it { is_expected.to be_truthy }
        end

        context "when there are no changes between the last tag for the given change, and the new SHA" do
          let(:git_diff) { "\n" }

          it { is_expected.to be_falsy }
        end
      end
    end

    context "when there are no refs for the given stage" do
      subject { MigrationInvestigation.pending_migrations? stage, new_sha }

      let(:refs) { [] }

      it { is_expected.to be_truthy }
    end
  end
end
