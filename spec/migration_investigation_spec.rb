require 'spec_helper'

describe MigrationInvestigation do
  describe ".pending_migrations?" do
    subject { MigrationInvestigation.pending_migrations? stage, new_sha }

    let(:stage) { "stage" }
    let(:new_sha) { "abc123" }

    let(:refs) { [ref1, ref2] }
    let(:ref1) { stub(:ref1) }
    let(:ref2) { stub(:ref2, sha: old_sha) }
    let(:old_sha) { "cba321" }

    before do
      auto_tagger = stub(:auto_tagger)
      AutoTagger::Base.stub(:new).with({}) { auto_tagger }
      auto_tagger.stub(:refs_for_stage).with(stage) { refs }
      MigrationInvestigation.stub(:`).with("git diff --name-only #{old_sha} #{new_sha} db/migrate/ | wc -l") { git_diff }
    end

    context "when there are migrations changed between the last tag for the given change, and the new SHA" do
      let(:git_diff) { "       3\n" }

      it { should be_true }
    end

    context "when there are no migrations changes between the last tag for the given change, and the new SHA" do
      let(:git_diff) { "       0\n" }

      it { should be_false }
    end
  end
end
