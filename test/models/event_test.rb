# frozen_string_literal: true

require 'test_helper'

class EventTest < ActiveSupport::TestCase
  fixtures :companies

  def setup
    @company = companies(:one)
    @event = Event.load_from_xml(@company, XmlFixtures::NFs.event_cancel)
  end

  test 'load xml returns an event' do
    assert_kind_of Event, @event
  end

  test 'load xml must return saved object' do
    assert_equal true, @event.persisted?
  end

  test 'populated data' do
    assert_equal @company, @event.company
    assert_equal 'ID1101115023030882147600010365001000113301101139651801', @event.event_id
    assert_equal '50', @event.cOrgao
    assert_equal '50230308821476000103650010001133011011396518', @event.chNFe
    assert_equal '2023-03-01T10:07:25-04:00'.to_time, @event.dhEvento
    assert_equal '110111', @event.tpEvento
    assert_equal 1, @event.nSeqEvento
    assert_equal 'Cancelamento', @event.descEvento
    assert_equal '150230067328801', @event.nProt
    assert_equal 'CANCELAMENTO DE VENDA', @event.xJust
  end
end
