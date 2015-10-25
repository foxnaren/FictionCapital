json.array!(@examples) do |example|
  json.extract! example, :id, :name, :integer, :desc, :string
  json.url example_url(example, format: :json)
end
