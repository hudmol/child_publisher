require 'spec_helper'

describe 'Child Publisher mixin' do

  let!(:resource) {
    create(:json_resource, :publish => true)
  }

  let!(:series_1) {
    create(:json_archival_object, :resource => {:ref => resource.uri}, :publish => true, :title => "Series 1")
  }

  let!(:series_2) {
    create(:json_archival_object, :resource => {:ref => resource.uri}, :publish => true, :title => "Series 2")

  }

  let!(:series_1_child_1) {
    create(:json_archival_object,
           :resource => {:ref => resource.uri},
           :parent => {:ref => series_1.uri},
           :publish => true,
           :title => "Series 1 Child 1")
  }

  let!(:series_1_child_2) {
    create(:json_archival_object,
           :resource => {:ref => resource.uri},
           :parent => {:ref => series_1.uri},
           :publish => true,
           :title => "Series 1 Child 2")
  }

  let!(:series_2_child_1) {
    create(:json_archival_object,
           :resource => {:ref => resource.uri},
           :parent => {:ref => series_2.uri},
           :publish => true,
           :title => "Series 2 Child 1")
  }

  let!(:series_2_child_2) {
    create(:json_archival_object,
           :resource => {:ref => resource.uri},
           :parent => {:ref => series_2.uri},
           :publish => true,
           :ref_id => 'EXCLUDE',
           :title => "Series 2 Child 2")
  }


  # derby does like the way sequel is sending likes, so override default Note filter, sigh
  ChildPublishing.add_filter(Note)
  # and add our own for testing
  ChildPublishing.add_filter(ArchivalObject.exclude(:ref_id => 'EXCLUDE'))


  def should_be_published(*jaos)
    jaos.each {|jao| ArchivalObject[jao.id].publish.should eq(1)}
  end


  def should_be_unpublished(*jaos)
    jaos.each {|jao| ArchivalObject[jao.id].publish.should eq(0)}
  end


  it "Unpublishes children" do
    ArchivalObject[series_1.id].unpublish_children!


#    json = ArchivalObject.sequel_to_jsonmodel([ArchivalObject[series_1.id]])[0]
#    json['publish'].should be(true)

    should_be_published(series_1, series_2, series_2_child_1, series_2_child_2)
    should_be_unpublished(series_1_child_1, series_1_child_2)
  end


  it "Respects filters" do
    ArchivalObject[series_2.id].unpublish_children!

    puts "S2C2  #{ArchivalObject[series_2_child_2.id].inspect}"

    should_be_published(series_2, series_2_child_2)
    should_be_unpublished(series_2_child_1)
  end
end
