# frozen_string_literal: true

require "spec_helper"

describe Track do
  let(:reflection) { described_class.record_lists_reflections[:albums] }

  describe "model that included has and belongs to record lists" do
    let(:track) { described_class.new }

    it "have record list" do
      expect(track).to have_and_belongs_to_record_lists(:albums).class_name("Album").inverse_of(:tracks)
    end

    it "have record_list method" do
      expect(track).to respond_to(:record_list).with(1).arguments
    end

    it "have info of everyone record lists" do
      record_list = track.record_list(:albums)
      expect(record_list).to be_an_instance_of(RecordList::Association::BelongsToList)
    end

    it "have getter" do
      expect(track).to respond_to(:albums).with(0).arguments
    end

    it "have setter" do
      expect(track).to respond_to("albums=").with(1).arguments
    end

    it "have getter ids" do
      expect(track).to respond_to("albums_ids").with(0).arguments
    end

    it "have setter ids" do
      expect(track).to respond_to("albums_ids=").with(1).arguments
    end
  end

  describe "has and belongs to record lists" do
    context "when subject all state" do
      let(:track) { described_class.new }

      it "returns is a relation" do
        expect(track.albums).to be_a(ActiveRecord::Relation)
      end
    end

    context "when subject not persisted" do
      let(:track) { described_class.new }

      it "don`t permit action" do
        expect { track.albums = "qew" }.to raise_error(ActiveRecord::RecordNotSaved)
      end
    end

    context "when subject is persisted" do
      let(:track) { described_class.create(track_number: 1, title: "Track №1") }

      let(:records) do
        [Album.create(title: "Album №1"),
         Album.create(title: "Album №2")]
      end

      it "not accept values other class" do
        expect { track.albums = 1 }.to raise_error(ActiveRecord::AssociationTypeMismatch)
      end

      it "not accept values unless saved" do
        expect { track.albums = reflection.klass.new }.to raise_error(ActiveRecord::RecordNotSaved)
      end

      it "accept one value" do
        track.albums = records.first
        expect(track.albums).to match_array(records.first)
      end

      it "accept array" do
        track.albums = records
        expect(track.albums).to match_array(records)
      end

      it "add one value" do
        track.albums << records.first
        expect(track.albums).to match_array(records.first)
      end

      it "add array" do
        track.albums << records
        expect(track.albums).to match_array(records)
      end
    end
  end

  describe "has and belongs to record lists ids" do
    let(:track) { described_class.create(track_number: 1, title: "Track №1") }

    let(:record_ids) do
      [Album.create(title: "Album №1").id, Album.create(title: "Album №2").id]
    end

    it "returns is array" do
      expect(track.albums_ids).to be_a(Array)
    end

    it "not found records in storage" do
      expect { track.albums_ids = ["qwe", 1] }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "accept one value" do
      track.albums_ids = record_ids.first
      expect(track.albums_ids).to match_array(record_ids.first)
    end

    it "accept array" do
      track.albums_ids = record_ids
      expect(track.albums_ids).to match_array(record_ids)
    end
  end
end
