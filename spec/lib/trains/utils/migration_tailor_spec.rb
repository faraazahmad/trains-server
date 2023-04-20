# frozen_string_literal: true

describe Trains::Utils::MigrationTailor do
  context 'when migrations create_table, add_column' do
    let(:create_add_migs) do
      [
        Trains::DTO::Migration.new(
          table_name: 'Post',
          modifier: :create_table,
          fields: [
            Trains::DTO::Field.new(:title, :string),
            Trains::DTO::Field.new(:more, :text)
          ],
          version: 5.2
        ),
        Trains::DTO::Migration.new(
          table_name: 'Post',
          modifier: :add_column,
          fields: [
            Trains::DTO::Field.new(:user_name, :string)
          ],
          version: 7.1
        )
      ]
    end

    it 'creates a model and adds a column to it' do
      models = Trains::Utils::MigrationTailor.stitch(create_add_migs)
      expect(models).to eq(
        {
          'Post' =>
        Trains::DTO::Model.new(
          name: 'Post',
          fields: [
            Trains::DTO::Field.new(:title, :string),
            Trains::DTO::Field.new(:more, :text),
            Trains::DTO::Field.new(:user_name, :string)
          ],
          version: 5.2
        )
        }
      )
    end
  end

  context 'when migrations create_table, remove_column' do
    let(:create_remove_migs) do
      [
        Trains::DTO::Migration.new(
          table_name: 'Post',
          modifier: :create_table,
          fields: [
            Trains::DTO::Field.new(:title, :string),
            Trains::DTO::Field.new(:more, :text)
          ],
          version: 5.2
        ),
        Trains::DTO::Migration.new(
          table_name: 'Post',
          modifier: :remove_column,
          fields: [
            Trains::DTO::Field.new(:title, nil)
          ],
          version: 7.1
        )
      ]
    end

    it 'creates a model and removes title column from it' do
      models = Trains::Utils::MigrationTailor.stitch(create_remove_migs)
      expect(models).to eq(
        {
          'Post' =>
        Trains::DTO::Model.new(
          name: 'Post',
          fields: [
            Trains::DTO::Field.new(:more, :text),
          ],
          version: 5.2
        )
        }
      )
    end
  end
end