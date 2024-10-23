# frozen_string_literal: true

require "spec_helper"

describe Album do
  let(:album) { described_class.new }

  describe "model that included record list" do
    it "have record list" do
      expect(album).to have_record_list(:tracks).class_name("Track")
    end

    it "have record_list method" do
      expect(album).to respond_to(:record_list).with(1).arguments
    end

    it "have info of everyone record lists" do
      record_list = album.record_list(:tracks)
      expect(record_list).to be_an_instance_of(RecordList::Association::HasList)
    end

    it "have getter" do
      expect(album).to respond_to(:tracks).with(0).arguments
    end

    it "have setter" do
      expect(album).to respond_to("tracks=").with(1).arguments
    end

    it "have getter ids" do
      expect(album).to respond_to("tracks_ids").with(0).arguments
    end

    it "have setter ids" do
      expect(album).to respond_to("tracks_ids=").with(1).arguments
    end
  end

  describe "record list" do
    let(:record_list) { album.record_list(:tracks) }
    let(:records) do
      [Track.create(track_number: 1, title: "Track №1"),
       Track.create(track_number: 2, title: "Track №2")]
    end

    it "returns is a relation" do
      expect(album.tracks).to be_a(ActiveRecord::Relation)
    end

    it "not accept values different of record class" do
      expect { album.tracks = 1 }.to raise_error(ActiveRecord::AssociationTypeMismatch)
    end

    it "not accept values if don`t saved" do
      expect { album.tracks = record_list.klass.new }.to raise_error(ActiveRecord::RecordNotSaved)
    end

    it "accept one value" do
      album.tracks = records.first
      expect(album.tracks).to match_array(records.first)
    end

    it "accept array" do
      album.tracks = records
      expect(album.tracks).to match_array(records)
    end

    it "add one value" do
      album.tracks << records.first
      expect(album.tracks).to match_array(records.first)
    end

    it "add array" do
      album.tracks << records
      expect(album.tracks).to match_array(records)
    end
  end

  describe "record list ids" do
    let(:record_ids) do
      [Track.create(track_number: 1, title: "Track №1").id,
       Track.create(track_number: 2, title: "Track №2").id]
    end

    it "returns is array" do
      expect(album.tracks_ids).to be_a(Array)
    end

    it "not found records in storage" do
      expect { album.tracks_ids = ["qwe", 1] }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "accept one value" do
      album.tracks_ids = record_ids.first
      expect(album.tracks_ids).to match_array(record_ids.first)
    end

    it "accept array" do
      album.tracks_ids = record_ids
      expect(album.tracks_ids).to match_array(record_ids)
    end
  end
end
