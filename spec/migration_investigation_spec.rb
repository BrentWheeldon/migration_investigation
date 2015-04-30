require 'spec_helper'

describe MigrationInvestigation do
  describe ".pending_migrations?" do
    subject { MigrationInvestigation.pending_migrations? stage, new_sha }

    let(:stage) { "stage" }
    let(:new_sha) { "abc123" }

    let(:refs) { [ref1, ref2] }
    let(:ref1) { double(:ref1) }
    let(:ref2) { double(:ref2, sha: old_sha) }
    let(:old_sha) { "cba321" }

    before do
      auto_tagger = double(:auto_tagger)
      allow(AutoTagger::Base).to receive(:new).with({}).and_return(auto_tagger)
      allow(auto_tagger).to receive(:refs_for_stage).with(stage).and_return(refs)
      allow(MigrationInvestigation).to receive(:`).with("git diff --name-only #{old_sha} #{new_sha} db/migrate/ | wc -l").and_return(git_diff)
    end

    context "when there are migrations changed between the last tag for the given change, and the new SHA" do
      let(:git_diff) { "       3\n" }

      it { is_expected.to be_truthy }
    end

    context "when there are no migrations changes between the last tag for the given change, and the new SHA" do
      let(:git_diff) { "       0\n" }

      it { is_expected.to be_falsy }
    end
  end
end
