module ContentStoreHelpers
  def stub_content_store
    content_store = double(:content_store, content_item: nil)

    allow(content_store).to receive(:content_item).with("/oil-and-gas/offshore").and_return({
      "base_path" => "/oil-and-gas/offshore",
      "title" => "Offshore",
      "description" => "Important information about offshore drilling",
      "format" => "specialist_sector",
      "need_ids" => [],
      "public_updated_at"=> "2014-03-04T13:58:11+00:00",
      "updated_at" => "2014-03-04T14:15:17+00:00",
      "details" => {
        "groups" => [
          {
            "name" => "Oil rigs",
            "contents" => [
              "http://example.com/api/oil-rig-safety-requirements.json",
              "http://example.com/api/oil-rig-staffing.json"
            ]
          },
          {
            "name" => "Piping",
            "contents" => [
              "http://example.com/api/undersea-piping-restrictions.json"
            ]
          },
          {
            "name" => "Other",
            "contents" => [
              "http://example.com/api/north-sea-shipping-lanes.json"
            ]
          }
        ]
      }
    })

    CollectionsAPI.services(:content_store, content_store)
  end
end
